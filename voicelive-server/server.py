#!/usr/bin/env python
# pylint: disable=line-too-long,useless-suppression

from __future__ import annotations

import asyncio
import base64
import logging
import os
import pathlib
import queue
import signal
import sys
from datetime import datetime
from typing import Optional, Union, cast, List, Literal
from urllib import response
from pydantic import BaseModel

# FastAPI and WebSocket imports
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import uuid
from datetime import datetime
from dataclasses import asdict
import uvicorn
import models.chat_dto as chat_dto
from fastapi.middleware.cors import CORSMiddleware

# Environment variable loading
try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError:
    print("Note: python-dotenv not installed. Using existing environment variables.")

# Azure VoiceLive SDK imports
from azure.ai.voicelive.aio import VoiceLiveConnection, connect, AgentSessionConfig
from azure.ai.voicelive.models import (
    AudioEchoCancellation,
    AudioNoiseReduction,
    AzureStandardVoice,
    InputAudioFormat,
    Modality,
    OutputAudioFormat,
    RequestSession,
    ServerEventType,
    AzureSemanticVad,
    LlmInterimResponseConfig,
    AudioInputTranscriptionOptions,
)
from azure.core.credentials_async import AsyncTokenCredential

# from azure.identity.aio import DefaultAzureCredential
from azure.identity import DefaultAzureCredential
import json
from azure.ai.projects import AIProjectClient


# Set up logging
logging.basicConfig(
    level=logging.DEBUG, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


def _get_required_env(name: str, optional: bool = False) -> str:
    """Get a required environment variable or exit with error."""
    value = os.environ.get(name)
    if not value and not optional:
        print(f"❌ Error: No {name} provided")
        print(f"Please set the {name} environment variable.")
        sys.exit(1)
    return value


# Configuration from environment variables
endpoint = _get_required_env("AZURE_VOICELIVE_ENDPOINT")
agent_name = _get_required_env("AGENT_NAME")
agent_project_name = _get_required_env("AGENT_PROJECT_NAME")
agent_voicelive_model = _get_required_env("AZURE_VOICELIVE_MODEL")
agent_voicelive_transcription_model = _get_required_env("AZURE_VOICELIVE_TRANSCRIPTION_MODEL")

# Optional configuration
agent_version = _get_required_env("AGENT_VERSION",True)  # Optional
agent_voice_it = _get_required_env("AGENT_VOICE_IT", True)
agent_voice_en = _get_required_env("AGENT_VOICE_EN", True)
foundry_resource_override = _get_required_env("FOUNDRY_RESOURCE_OVERRIDE",True)  # Optional
agent_auth_identity_client_id =_get_required_env(
    "AGENT_AUTH_IDENTITY_CLIENT_ID",True
)  # Optional


def get_voice_for_language(lang: Optional[str]) -> str:
    """Return the voice setting for the requested language."""
    normalized = (lang or "it").strip().lower()

    if normalized == "en" and agent_voice_en:
        return agent_voice_en
    if normalized == "it" and agent_voice_it:
        return agent_voice_it

    if normalized not in {"it", "en"}:
        normalized = "it"

    return agent_voice

# Set up logging directory
pathlib.Path("logs").mkdir(exist_ok=True)
timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
logfilename = f"{timestamp}_agent_v2_conversation.log"

## chat endpoint
azure_agent_endpoint = f"{endpoint}api/projects/{agent_project_name}"
project_client = AIProjectClient(
    endpoint=azure_agent_endpoint,
    credential=DefaultAzureCredential(),
)

openai_client = project_client.get_openai_client()

# Create FastAPI app
app = FastAPI(title="Data Agent Assistant")
origins = _get_required_env("CORS_ALLOWED_ORIGINS", "")
allowed_origins = [o.strip() for o in origins.split(",") if o.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class AudioProcessor:
    """
    Handles real-time audio playback for the voice assistant.

    Implements sequence number based audio packet system for proper interrupt handling.
    """

    class AudioPlaybackPacket:
        """Represents a packet that can be sent to the audio playback queue."""

        def __init__(self, seq_num: int, data: Optional[bytes]):
            self.seq_num = seq_num
            self.data = data

    def __init__(self, connection: VoiceLiveConnection):
        self.connection = connection

        # Playback with sequence numbers for interrupt handling
        self.playback_queue: queue.Queue[AudioProcessor.AudioPlaybackPacket] = (
            queue.Queue()
        )
        self.playback_base = 0
        self.next_seq_num = 0

        logger.info("AudioProcessor initialized")

    def _get_and_increase_seq_num(self):
        seq = self.next_seq_num
        self.next_seq_num += 1
        return seq

    def queue_audio(self, audio_data: Optional[bytes]) -> None:
        """Queue audio data for playback."""
        self.playback_queue.put(
            AudioProcessor.AudioPlaybackPacket(
                seq_num=self._get_and_increase_seq_num(), data=audio_data
            )
        )

    def skip_pending_audio(self):
        """Skip current audio in playback queue (used during interrupts)."""
        self.playback_base = self._get_and_increase_seq_num()

    def get_next_audio(self) -> Optional[bytes]:
        """Get next audio packet from queue (non-blocking)."""
        try:
            packet = self.playback_queue.get_nowait()
            if packet and packet.data:
                return packet.data
        except queue.Empty:
            pass
        return None

    def shutdown(self):
        """Clean up audio resources."""
        logger.info("Audio processor cleaned up")


class AgentV2VoiceAssistant:
    """
    Voice assistant using Azure AI Foundry agent with AgentSessionConfig.
    Communicates with clients via WebSocket.
    """

    def __init__(
        self,
        endpoint: str,
        credential: AsyncTokenCredential,
        agent_config: AgentSessionConfig,
        voice: str,
    ) -> None:
        self.endpoint = endpoint
        self.credential = credential
        self.agent_config = agent_config
        self.voice = voice
        self.connection: Optional[VoiceLiveConnection] = None
        self.audio_processor: Optional[AudioProcessor] = None
        self.session_ready = False
        self.websocket: Optional[WebSocket] = None

    async def set_websocket(self, websocket: WebSocket) -> None:
        """Set the WebSocket for communication with client."""
        self.websocket = websocket

    async def start(self):
        """Start the voice assistant session."""
        try:
            logger.info(
                "Connecting to VoiceLive API with agent %s for project %s",
                self.agent_config.get("agent_name"),
                self.agent_config.get("project_name"),
            )

            # Connect using AgentSessionConfig
            async with connect(
                endpoint=self.endpoint,
                credential=self.credential,
                agent_config=self.agent_config,
            ) as connection:
                conn = connection
                self.connection = conn

                # Initialize audio processor
                ap = AudioProcessor(conn)
                self.audio_processor = ap

                # Configure session for voice conversation
                await self._setup_session()

                logger.info("Voice assistant ready!")

                # Notify client that session is ready
                if self.websocket:
                    await self.websocket.send_json(
                        {"type": "session_ready", "message": "Voice assistant ready"}
                    )

                # Process events
                await self._process_events()
        except Exception:
            logger.exception("Voice assistant encountered an error")
            raise
        finally:
            if self.audio_processor:
                self.audio_processor.shutdown()

    async def _setup_session(self):
        """Configure the VoiceLive session for audio conversation."""
        logger.info("Setting up voice conversation session...")

        voice_config = AzureStandardVoice(name=self.voice)

        # Create turn detection configuration
        turn_detection_config = AzureSemanticVad(
            threshold=0.5,
            prefix_padding_ms=300,
            silence_duration_ms=500,
            interrupt_response=True,
            auto_truncate=True,
        )

        # Create session configuration+
        input_audio_transcription = AudioInputTranscriptionOptions(
            model=agent_voicelive_transcription_model
        )
        session_config = RequestSession(
            model=agent_voicelive_model,
            modalities=[Modality.TEXT, Modality.AUDIO],
            voice=voice_config,
            input_audio_transcription=input_audio_transcription,
            input_audio_format=InputAudioFormat.PCM16,
            output_audio_format=OutputAudioFormat.PCM16,
            turn_detection=turn_detection_config,
            input_audio_echo_cancellation=AudioEchoCancellation(),
            input_audio_noise_reduction=AudioNoiseReduction(
                type="azure_deep_noise_suppression"
            ),
            interim_response=LlmInterimResponseConfig(latency_threshold_ms=1000),
        )

        conn = self.connection
        assert (
            conn is not None
        ), "Connection must be established before setting up session"
        await conn.session.update(session=session_config)

        logger.info("Session configuration sent")

    async def send_audio_input(self, audio_base64: str) -> None:
        """Send audio input to the agent."""
        if self.connection:
            await self.connection.input_audio_buffer.append(audio=audio_base64)

    async def _process_events(self):
        """Process events from the VoiceLive connection and forward to WebSocket client."""
        try:
            conn = self.connection
            assert (
                conn is not None
            ), "Connection must be established before processing events"
            async for event in conn:
                await self._handle_event(event)
        except asyncio.CancelledError:
            logger.info("Event processing cancelled")
        except Exception:
            logger.exception("Error processing events")
            raise

    async def _handle_event(self, event):
        """Handle different types of events from VoiceLive."""
        logger.info("Received event: %s", event.type)
        ap = self.audio_processor
        assert ap is not None, "AudioProcessor must be initialized"

        if event.type == ServerEventType.SESSION_UPDATED:
            logger.info("Session ready: %s", event.session.id)
            await write_conversation_log(f"SessionID: {event.session.id}")
            await write_conversation_log(f"Model: {event.session.model}")
            await write_conversation_log(f"Voice: {event.session.voice}")
            await write_conversation_log("")
            self.session_ready = True

        elif (
            event.type
            == ServerEventType.CONVERSATION_ITEM_INPUT_AUDIO_TRANSCRIPTION_COMPLETED
        ):
            user_transcript = f'User Input:\t{event.get("transcript", "")}'
            logger.info(user_transcript)
            await write_conversation_log(user_transcript)
            if self.websocket:
                await self.websocket.send_json(
                    {"type": "user_transcript", "text": event.get("transcript", "")}
                )

        elif event.type == ServerEventType.RESPONSE_CONTENT_PART_ADDED:
            # agent_text = f'Agent Text Response:\t{event.get("text", "")}'
            # logger.info(agent_text)
            # await write_conversation_log(agent_text)
            print(f"###")
            print(event)
            print(f"Received delta2: {event.get('text', '')}")
            if self.websocket:
                await self.websocket.send_json(
                    {"type": "agent_delta_text2", "text": event.get("text", "")}
                )

        elif event.type == ServerEventType.RESPONSE_TEXT_DELTA:
            # agent_text = f'Agent Text Response:\t{event.get("text", "")}'
            # logger.info(agent_text)
            # await write_conversation_log(agent_text)
            print(f"###")
            print(f"Received delta: {event.get('delta', '')}")
            if self.websocket:
                await self.websocket.send_json(
                    {"type": "agent_delta_text", "text": event.get("delta", "")}
                )

        elif event.type == ServerEventType.RESPONSE_TEXT_DONE:
            agent_text = f'Agent Text Response:\t{event.get("text", "")}'
            logger.info(agent_text)
            await write_conversation_log(agent_text)
            if self.websocket:
                await self.websocket.send_json(
                    {"type": "agent_text", "text": event.get("text", "")}
                )

        elif event.type == ServerEventType.RESPONSE_AUDIO_TRANSCRIPT_DONE:
            agent_audio = f'Agent Audio Response:\t{event.get("transcript", "")}'
            logger.info(agent_audio)
            await write_conversation_log(agent_audio)
            if self.websocket:
                await self.websocket.send_json(
                    {"type": "agent_transcript", "text": event.get("transcript", "")}
                )

        elif event.type == ServerEventType.RESPONSE_AUDIO_TRANSCRIPT_DELTA:
            print("## audio delta")
            print(event)
            if self.websocket:
                await self.websocket.send_json(
                    {
                        "type": "agent_transcript_delta",
                        "text": event.get("delta", ""),
                        "response_id": event.get("response_id", ""),
                    }
                )

        elif event.type == ServerEventType.INPUT_AUDIO_BUFFER_SPEECH_STARTED:
            logger.info("User started speaking - stopping playback")
            ap.skip_pending_audio()
            if self.websocket:
                await self.websocket.send_json({"type": "speech_started"})

        elif event.type == ServerEventType.INPUT_AUDIO_BUFFER_SPEECH_STOPPED:
            logger.info("User stopped speaking")
            if self.websocket:
                await self.websocket.send_json({"type": "speech_stopped"})

        elif event.type == ServerEventType.RESPONSE_CREATED:
            logger.info("Assistant response created")
            if self.websocket:
                await self.websocket.send_json({"type": "response_started"})

        elif event.type == ServerEventType.RESPONSE_AUDIO_DELTA:
            logger.debug("Received audio delta")
            ap.queue_audio(event.delta)
            if self.websocket and event.delta:
                audio_base64 = base64.b64encode(event.delta).decode("utf-8")
                await self.websocket.send_json(
                    {"type": "audio_delta", "audio": audio_base64}
                )

        elif event.type == ServerEventType.RESPONSE_AUDIO_DONE:
            logger.info("Assistant finished speaking")
            if self.websocket:
                await self.websocket.send_json({"type": "audio_done"})

        elif event.type == ServerEventType.RESPONSE_DONE:
            logger.info("Response complete")
            if self.websocket:
                await self.websocket.send_json({"type": "response_done"})

        elif event.type == ServerEventType.ERROR:
            logger.error("VoiceLive error: %s", event.error.message)
            if self.websocket:
                await self.websocket.send_json(
                    {"type": "error", "message": str(event.error.message)}
                )

        elif event.type == ServerEventType.WARNING:
            logger.warning("VoiceLive warning: %s", event.warning.message)
            if self.websocket:
                await self.websocket.send_json(
                    {"type": "warning", "message": str(event.warning.message)}
                )
        elif event.type == ServerEventType.CONVERSATION_ITEM_TRUNCATED:
            logger.info("VoiceLive barge-in detected")
            if self.websocket:
                await self.websocket.send_json({"type": "barge_in", "text": "User barge-in detected, response truncated"})

        elif event.type == ServerEventType.CONVERSATION_ITEM_CREATED:
            logger.debug("Conversation item created: %s", event.item.id)

        else:
            logger.debug("Unhandled event type: %s", event.type)


async def write_conversation_log(message: str) -> None:
    """Write a message to the conversation log."""

    def _write_to_file():
        with open(f"logs/{logfilename}", "a", encoding="utf-8") as conversation_log:
            conversation_log.write(message + "\n")

    await asyncio.to_thread(_write_to_file)


class TokenRequest(BaseModel):
    scope: str
    additionally_allowed_tenants: Optional[List[str]] = None

# class ChatRequest(BaseModel):
#     query: str
#     history: List[Message] = []
#     response_id: Optional[str] = None

# Global assistant instance
current_assistant: Optional[AgentV2VoiceAssistant] = None
event_task: Optional[asyncio.Task] = None


def new_uuid() -> str:
    return str(uuid.uuid4())


def iso(ts=None) -> str:
    return ts if ts else datetime.utcnow().isoformat() + "Z"


# Monta la cartella "frontend" come statica
app.mount("/static", StaticFiles(directory="../frontend"), name="static")


@app.get("/")
async def get_root():
    """Serve the frontend HTML."""
    return FileResponse("../frontend/index.html")


@app.post("/get_token")
async def get_token(request: TokenRequest):
    """HTTP endpoint for getting a token for a given scope."""

    if request.additionally_allowed_tenants:
        logger.info(
            "Getting token for scope '%s' with additional tenants: %s",
            request.scope,
            request.additionally_allowed_tenants,
        )
        credential = DefaultAzureCredential(
                additionally_allowed_tenants=request.additionally_allowed_tenants
        )
    else:  
        logger.info("Getting token for scope '%s'", request.scope)
        credential = DefaultAzureCredential()

    
    token = credential.get_token(request.scope)
    return {"token": token}


@app.post("/chat")
async def chat_endpoint(request: chat_dto.Message):
    """HTTP endpoint for sending user input"""

    print("Received chat request: ", request)

    conv = chat_dto.Conversation(
        id=request.id if request.id else new_uuid(),
        createdat=request.createdat if request.createdat else iso(),
        updatedat=iso(),
    )

    response = openai_client.responses.create(
        previous_response_id=request.qa_id,
        input=request.content,
        extra_body={
            "agent": {
                "name": agent_name if request.agent_name is None else request.agent_name,
                "version": agent_version if request.agent_version is None else request.agent_version,
                "type": "agent_reference",
            }
        },
    )

    user_message = chat_dto.Message(
        id=new_uuid(),
        qa_id=response.id,
        conversation_id=conv.id,
        role="user",
        createdat=iso(),
        content=request.content,
    )

    assistant_message = chat_dto.Message(
        id=new_uuid(),
        qa_id=response.id,
        conversation_id=conv.id,
        role="assistant",
        createdat=iso(),
        content=response.output_text,
    )
    payload = chat_dto.ConversationPayload(conversation=conv, messages=[user_message, assistant_message])

    return payload
    # print(f"Response output: {response.output_text}")
    # print(f"Response output: {response.id}")
    # return {"response": response.output_text, "response_id": response.id}


@app.websocket("/ws")
async def websocket_endpoint(
    websocket: WebSocket,
    agent_name_param: str = None,
    agent_version_param: str = None,
    lang: str = "it",
):
    """WebSocket endpoint for audio stream and event communication."""
    global current_assistant, event_task

    await websocket.accept()
    logger.info("WebSocket client connected")

    try:
        # Use agent_name from query parameter if provided, otherwise use environment variable
        used_agent_name = agent_name_param if agent_name_param else agent_name
        used_agent_version = agent_version_param if agent_version_param else agent_version
        normalized_lang = (lang or "it").strip().lower()
        if normalized_lang not in {"it", "en"}:
            normalized_lang = "it"

        used_voice = get_voice_for_language(normalized_lang)

        logger.info("Using agent_name: %s", used_agent_name)
        logger.info("Using agent_version: %s", used_agent_version)
        logger.info("Using language: %s", normalized_lang)
        logger.info("Using voice: %s", used_voice)

        # Create and start the voice assistant
        agent_config: AgentSessionConfig = {
            "agent_name": used_agent_name,
            "project_name": agent_project_name,
        }
  
        agent_config["agent_version"] = used_agent_version
        
        if foundry_resource_override:
            agent_config["foundry_resource_override"] = foundry_resource_override
        if agent_auth_identity_client_id:
            agent_config["authentication_identity_client_id"] = (
                agent_auth_identity_client_id
            )

        credential: AsyncTokenCredential = DefaultAzureCredential()

        assistant = AgentV2VoiceAssistant(
            endpoint=endpoint,
            credential=credential,
            agent_config=agent_config,
            voice=used_voice,
        )

        await assistant.set_websocket(websocket)
        current_assistant = assistant

        # Start the event processing task
        event_task = asyncio.create_task(assistant.start())

        # Handle incoming messages from client
        while True:
            data = await websocket.receive_json()

            if data["type"] == "audio_chunk":
                # Receive audio from client and send to agent
                audio_base64 = data["audio"]
                await assistant.send_audio_input(audio_base64)
            elif data["type"] == "stop":
                logger.info("Client requested stop")
                break

    except WebSocketDisconnect:
        logger.info("WebSocket client disconnected")
    except Exception as e:
        logger.exception("WebSocket error: %s", e)
        try:
            await websocket.send_json({"type": "error", "message": str(e)})
        except Exception:
            pass
    finally:
        if event_task:
            event_task.cancel()
            try:
                await event_task
            except asyncio.CancelledError:
                pass
        current_assistant = None
        logger.info("WebSocket connection closed")


if __name__ == "__main__":
    print("🎙️  Talk with your data")
    print("=" * 50)
    print(f"Agent: {agent_name}")
    print(f"Project: {agent_project_name}")
    if agent_version:
        print(f"Version: {agent_version}")
    print("Using AgentSessionConfig for agent configuration")
    print("=" * 50)
    print("\n🚀 Starting server on http://localhost:8001")
    print("Open http://localhost:8001 in your browser to use the voice assistant\n")

    uvicorn.run(app, host="0.0.0.0", port=8001, log_level="info")
