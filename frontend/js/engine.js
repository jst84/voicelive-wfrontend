class VoiceAssistantClient {


    constructor() {
        this.ws = null;
        this.mediaStream = null;
        this.processor = null;
        this.isRecording = false;
        this.analyser = null;
        this.animationId = null;
        this.sampleRate = 24000; // 24kHz to match backend
        this.agentName = null;
        this.elements = {
            startBtn: document.getElementById('startBtn'),
            stopBtn: document.getElementById('stopBtn'),
            muteBtn: document.getElementById('muteBtn'),
            connectionStatus: document.getElementById('connectionStatus'),
            recordingStatus: document.getElementById('recordingStatus'),
            connectionText: document.getElementById('connectionText'),
            recordingText: document.getElementById('recordingText'),
            conversationLog: document.getElementById('conversationLog'),
            canvas: document.getElementById('audioVisualizer')
        };

        this.readquerystring();
        this.setupEventListeners();
        this.connectWebSocket();
        this.initializeAudioVisualizer();
    }

    readquerystring() {
        const params = new URLSearchParams(window.location.search);
        const agentName = params.get('agent_name');
        if (agentName && agentName.trim() !== '') {
            this.agentName = agentName;
        }

        const agentVersion = params.get('agent_version');
        if (agentVersion && agentVersion.trim() !== '') {
            this.agentVersion = agentVersion;
        }

        const lang = params.get('lang');
        if (lang && lang.trim() !== '') {
            this.lang = lang;
        }
    }

    setupEventListeners() {
        this.elements.startBtn.addEventListener('click', (e) => this.startRecording(e));
        this.elements.stopBtn.addEventListener('click', (e) => this.stopRecording(e));
        this.elements.muteBtn.addEventListener('click', () => {
            if (!this.mediaStream) return;
            const audioTrack = this.mediaStream.getAudioTracks()[0];
            audioTrack.enabled = !audioTrack.enabled;
            this.elements.muteBtn.textContent = audioTrack.enabled ? 'Mute' : 'Unmute';
        });
    }

    connectWebSocket() {

        if (this.ws && this.ws.readyState === WebSocket.OPEN) {
            console.log('WebSocket already connected');
            return;

        }
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        var wsUrl = `${protocol}//${window.location.host}/ws`; //set wss url
        if (this.agentName) {
            console.log(`Connecting to agent: ${this.agentName}`);
            wsUrl += `?agent_name_param=${encodeURIComponent(this.agentName)}`;
        }
        if (this.agentVersion) {
            console.log(`Connecting with agent version: ${this.agentVersion}`);
            wsUrl += `&agent_version_param=${encodeURIComponent(this.agentVersion)}`;
        }
        if (this.lang) {
            console.log(`Connecting with language: ${this.lang}`);
            wsUrl += `&lang=${encodeURIComponent(this.lang)}`;
        }

        this.ws = new WebSocket(wsUrl);

        this.ws.onopen = () => {
            console.log('WebSocket connected');
            this.updateConnectionStatus(true);
            this.addLogMessage('Connected to voice assistant', 'system');
        };

        this.ws.onmessage = (event) => {
            const data = JSON.parse(event.data);
            this.handleMessage(data);
        };

        this.ws.onerror = (error) => {
            console.error('WebSocket error:', error);
            this.addLogMessage('Connection error', 'error');
        };

        this.ws.onclose = () => {
            console.log('WebSocket closed');
            this.updateConnectionStatus(false);
            this.addLogMessage('Disconnected from voice assistant', 'system');
            this.stopRecording();
        };
    }

    async startRecording(e) {


        if (this.isRecording) return;

        if (e) {
            const buttonRef = e.currentTarget;
            buttonRef.classList.add("hide");
            document.getElementById('stopBtn').classList.remove("hide");
            document.getElementById('muteBtn').classList.remove("hide");
        } else {
            document.getElementById('startBtn').classList.add("hide");
            document.getElementById('stopBtn').classList.remove("hide");
            document.getElementById('muteBtn').classList.remove("hide");
        }

        this.connectWebSocket();
        try {
            // Request microphone access
            this.mediaStream = await navigator.mediaDevices.getUserMedia({
                audio: {
                    echoCancellation: true,
                    noiseSuppression: true,
                    autoGainControl: false,
                    sampleRate: this.sampleRate
                }
            });

            // Use global audio context
            if (audioContext.state === 'suspended') {
                await audioContext.resume();
            }

            // Create analyser for visualizer
            this.analyser = audioContext.createAnalyser();
            this.analyser.fftSize = 256;

            // Create source
            const source = audioContext.createMediaStreamSource(this.mediaStream);

            // Create script processor for audio capture
            this.processor = audioContext.createScriptProcessor(4096, 1, 1);

            source.connect(this.analyser);
            this.analyser.connect(this.processor);
            this.processor.connect(audioContext.destination);

            // Handle audio data
            this.processor.onaudioprocess = (event) => {
                const inputData = event.inputBuffer.getChannelData(0);
                this.sendAudioChunk(inputData);
            };

            this.isRecording = true;
            this.updateRecordingStatus(true);
            this.addLogMessage('Started recording', 'system');
            this.startVisualization();

        } catch (error) {
            console.error('Error accessing microphone:', error);
            this.addLogMessage(`Microphone error: ${error.message}`, 'error');
        }
    }

    stopRecording(e) {
        if (!this.isRecording) return;

        if (e) {
            const buttonRef = e.currentTarget;
            buttonRef.classList.add("hide");
            document.getElementById('startBtn').classList.remove("hide");
            document.getElementById('muteBtn').classList.add("hide");
        } else {
            document.getElementById('stopBtn').classList.add("hide");
            document.getElementById('startBtn').classList.remove("hide");
            document.getElementById('muteBtn').classList.add("hide");
        }

        this.isRecording = false;
        this.updateRecordingStatus(false);

        // Stop streams
        if (this.mediaStream) {
            this.mediaStream.getTracks().forEach(track => track.stop());
            this.mediaStream = null;
        }

        if (this.processor) {
            this.processor.disconnect();
            this.processor = null;
        }

        // Don't close global audioContext; it's reused across sessions

        if (this.animationId) {
            cancelAnimationFrame(this.animationId);
            this.animationId = null;
        }

        // Notify server
        if (this.ws && this.ws.readyState === WebSocket.OPEN) {
            this.ws.send(JSON.stringify({ type: 'stop' }));
        }

        this.addLogMessage('Stopped recording', 'system');
    }

    sendAudioChunk(inputData) {
        if (!this.ws || this.ws.readyState !== WebSocket.OPEN) return;

        // Convert float32 to PCM16
        const pcmData = this.floatTo16BitPCM(inputData);

        // Convert to base64
        const base64Audio = this.arrayBufferToBase64(pcmData);

        // Send to server
        this.ws.send(JSON.stringify({
            type: 'audio_chunk',
            audio: base64Audio
        }));
    }

    floatTo16BitPCM(floatData) {
        const buffer = new DataView(new ArrayBuffer(floatData.length * 2));
        let offset = 0;
        for (let i = 0; i < floatData.length; i++, offset += 2) {
            let s = Math.max(-1, Math.min(1, floatData[i]));
            buffer.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7fff, true);
        }
        return buffer.buffer;
    }

    arrayBufferToBase64(buffer) {
        let binary = '';
        const bytes = new Uint8Array(buffer);
        for (let i = 0; i < bytes.byteLength; i++) {
            binary += String.fromCharCode(bytes[i]);
        }
        return window.btoa(binary);
    }

    handleMessage(data) {
        console.log('Message received:', data.type);

        switch (data.type) {
            case 'session_ready':
                this.addLogMessage('Voice assistant initialized', 'system');
                break;
            case 'barge_in':
                this.addLogMessage('User barge-in detected, response truncated', 'system');
                workletNode.port.postMessage({ type: "stop" });
                break;
            case 'user_transcript':
                this.addLogMessage(`You: ${data.text}`, 'user');
                break;
            case 'agent_transcript_delta':
                console.log('Delta text received:', data);
                this.addDeltaLogMessage(data.response_id, `${data.text}`, 'agent');
                break;
            case 'speech_started':
                this.addLogMessage('Listening...', 'system');
                break;
            case 'speech_stopped':
                this.addLogMessage('Processing...', 'system');
                break;
            case 'response_started':
                this.addLogMessage('Agent is composing response...', 'system');
                //reset audio buffer in case of barge-in during response generation
                workletNode.port.postMessage({ type: "clear" });
                workletNode.port.postMessage({ type: "start" });
                break;
            case 'audio_delta':
                // Handle audio streaming from agent (expects base64-encoded PCM16)
                if (data.audio) {
                    try {
                        const audioBuf = base64ToArrayBuffer(data.audio);
                        playAudio(audioBuf);
                    } catch (e) {
                        console.error('Error decoding/playing audio_delta:', e);
                    }
                }
                break;
            case 'audio_done':
                this.addLogMessage('Ready for next input', 'system');
                break;
            case 'response_done':
                this.addLogMessage('Response complete', 'system');
                break;
            case 'error':
                this.addLogMessage(`Error: ${data.message}`, 'error');
                break;
            case 'warning':
                this.addLogMessage(`Warning: ${data.message}`, 'system');
                break;
        }
    }

    updateConnectionStatus(connected) {
        const statusEl = this.elements.connectionStatus;
        const textEl = this.elements.connectionText;
        if (connected) {
            statusEl.className = 'status-icon connected';
            textEl.textContent = 'Connected';
        } else {
            statusEl.className = 'status-icon disconnected';
            textEl.textContent = 'Disconnected';
        }
    }

    updateRecordingStatus(recording) {
        const statusEl = this.elements.recordingStatus;
        const textEl = this.elements.recordingText;
        this.elements.startBtn.disabled = recording;
        this.elements.stopBtn.disabled = !recording;

        if (recording) {
            statusEl.className = 'status-icon processing';
            textEl.textContent = 'Recording';
            this.elements.startBtn.parentElement.classList.add('recording');
        } else {
            statusEl.className = 'status-icon disconnected';
            textEl.textContent = 'Stopped';
            this.elements.startBtn.parentElement.classList.remove('recording');
        }
    }

    addLogMessage(message, type = 'system') {
        const log = this.elements.conversationLog;
        const messageEl = document.createElement('div');
        messageEl.className = `message ${type}`;

        const timestamp = new Date().toLocaleTimeString();
        messageEl.textContent = `[${timestamp}] ${message}`;

        log.appendChild(messageEl);
        log.scrollTop = log.scrollHeight;
    }
    addDeltaLogMessage(response_id, message, type = 'system') {
        const log = this.elements.conversationLog;
        let container = document.getElementById(response_id);
        if (!container) {
            container = document.createElement('div');
            container.id = response_id;
            container.className = 'message agent';
            log.appendChild(container);
        }
        const messageEl = document.createElement('span');
        messageEl.className = type;
        messageEl.textContent = message;  // Set, don't concatenate
        container.appendChild(messageEl);
        log.scrollTop = log.scrollHeight;
    }
    initializeAudioVisualizer() {
        const canvas = this.elements.canvas;
        const ctx = canvas.getContext('2d');

        canvas.width = canvas.offsetWidth;
        canvas.height = canvas.offsetHeight;

        // Initial draw
        ctx.fillStyle = '#e0e0e0';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
    }
    startVisualization() {
        const canvas = this.elements.canvas;
        const ctx = canvas.getContext('2d');
        const dataArray = new Uint8Array(this.analyser.frequencyBinCount);

        const draw = () => {
            this.animationId = requestAnimationFrame(draw);

            this.analyser.getByteFrequencyData(dataArray);

            // Clear canvas
            ctx.fillStyle = '#f5f5f5';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Draw bars
            const barWidth = canvas.width / dataArray.length;
            const midY = canvas.height / 2;

            for (let i = 0; i < dataArray.length; i++) {
                const barHeight = (dataArray[i] / 255) * (canvas.height / 2);
                const hue = (i / dataArray.length) * 360;

                ctx.fillStyle = `hsl(${hue}, 80%, 50%)`;
                ctx.fillRect(i * barWidth, midY - barHeight, barWidth - 1, barHeight);
                ctx.fillRect(i * barWidth, midY, barWidth - 1, barHeight);
            }
        };

        draw();
    }
}

let mediaStream, source, processor, socket;
let audioContext = new AudioContext({ sampleRate: 24000 });
let workletNode;

// Decode base64 (received from server) into an ArrayBuffer
function base64ToArrayBuffer(base64) {
    const binary = window.atob(base64);
    const len = binary.length;
    const bytes = new Uint8Array(len);
    for (let i = 0; i < len; i++) {
        bytes[i] = binary.charCodeAt(i);
    }
    return bytes.buffer;
}
// Load the AudioWorkletProcessor from the same directory as this script
async function loadAudioProcessor() {
    // Load the worklet from the same directory as this script
    await audioContext.audioWorklet.addModule('/static/js/audio-processor.js');
    workletNode = new AudioWorkletNode(audioContext, 'audio-processor');
    workletNode.connect(audioContext.destination);

}

async function playAudio(arrayBuffer) {
    if (!workletNode) {
        console.warn('Audio worklet not initialized, skipping playback');
        return;
    }
    if (audioContext.state === 'suspended') await audioContext.resume();
    const int16 = new Int16Array(arrayBuffer);
    const float32 = new Float32Array(int16.length);
    for (let i = 0; i < int16.length; i++) {
        float32[i] = int16[i] / (int16[i] < 0 ? 0x8000 : 0x7FFF);
    }
    workletNode.port.postMessage({ pcm: float32 });
}

// Initialize client when DOM is ready; ensure worklet is loaded first
document.addEventListener('DOMContentLoaded', async () => {
    try {
        await loadAudioProcessor();
        console.log('Audio system initialized');
    } catch (e) {
        console.warn('Audio playback may not work:', e);
    }
    // Initialize client even if worklet fails to load
    new VoiceAssistantClient();
});