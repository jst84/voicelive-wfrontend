# VoiceLive - Conversational Voice Assistant

A full-stack application for conversational voice interactions, integrating a backend for voice management, a SQL database exposed as services, and a responsive web interface.

## General Architecture

The application consists of three main components:

```
┌─────────────────────────────────────┐
│         Frontend (Browser)          │
│     Responsive Web Interface        │
└──────────────┬──────────────────────┘
               │
               │ (WebSocket/HTTP)
               │
┌──────────────▼──────────────────────┐
│    VoiceLive Server (Backend)       │
│    Voice Interaction Engine         │
│    Foundry Hosted Agent Service     │
└──────────────┬──────────────────────┘
               │
               │ (REST/MCP/GraphQL)
               │
┌──────────────▼──────────────────────┐
│      SQL Server Database            │
│     (DAB - Data API Builder)        │
└─────────────────────────────────────┘
```

---

## 🎤 VoiceLive Server

**Path:** `voicelive-server/`

Backend engine responsible for managing voice interaction between the browser and VoiceLive APIs.

This backend uses a Foundry Agent Hosted Service. You need to create an agent on the Foundry platform and then invoke it via the VoiceLive APIs.

### Key Features

- **Voice Processing**: Manages audio stream from the browser
- **Conversation**: Orchestrates bidirectional voice communication
- **VoiceLive API Integration**: Communicates with external APIs for voice processing
- **Foundry Agent Hosted Service**: Uses a hosted agent configured on the Foundry platform
- **Session Management**: Maintains conversation state

### Structure

```
voicelive-server/
├── server.py          # Main application Flask/FastAPI
└── models/
    ├── __init__.py
    └── chat_dto.py    # Data Transfer Objects for communication
```

### Technologies

- **Framework**: Python (Flask/FastAPI)
- **Protocols**: WebSocket, HTTP REST
- **Audio**: Real-time audio stream processing

### Usage

```bash
# Activate virtual environment
source venv/Scripts/activate  # Windows PowerShell

# Start the server
python voicelive-server/server.py
```

---

## 🗄️ SQL Source

**Path:** `sql-source/`

Configuration system and DAB (Data API Builder) commands to expose SQL Server database as REST, MCP, and GraphQL services.

### Key Features

- **Data API Builder**: Automatic API generation from SQL Server database
- **Multi-Protocol Exposure**: REST, MCP (Model Context Protocol), GraphQL
- **Schema Configuration**: Table, relationship, and field definitions
- **Command Management**: SQL scripts and DAB configurations

### Structure

```
sql-source/
├── dab-config.json    # Main DAB configuration
├── commands.txt       # SQL commands and configurations
└── start.cmd          # Startup script
```

### Configuration

The `dab-config.json` file defines:
- SQL Server database connection
- Table exposure
- Permissions and authentication
- REST/MCP/GraphQL endpoints

### Usage

```bash
# Start the DAB service
cmd start.cmd

# Or directly with DAB CLI
dab start

# Update schema
dab update <table> --fields.name <field> --fields.description "..." 
```

### Available APIs

- **REST**: `http://localhost:5000/api/<table>`
- **GraphQL**: `http://localhost:5000/graphql`
- **MCP**: Direct integration with MCP clients

---

## 🌐 Frontend

**Path:** `frontend/`

Minimalist and responsive web interface for voice conversation with the backend.

### Key Features

- **Conversational Interface**: Clean and intuitive chat interface
- **Voice Capture**: Browser microphone access
- **Responsive Design**: Optimized for desktop and mobile
- **Real-time Display**: Live conversation updates

### Structure

```
frontend/
├── index.html         # Main HTML page
├── css/
│   └── newsite.css    # Updated styles/theme
└── js/
    ├── engine.js      # Main UI engine
    └── audio-processor.js  # Audio processing
```

### Technologies

- **HTML5**: Web Audio API
- **CSS3**: Grid/Flexbox responsive
- **JavaScript**: Vanilla JS (no framework)
- **WebSocket**: Real-time backend communication

### Usage

Simply open `frontend/index.html` in your browser, or serve with a web server:

```bash
# Python
python -m http.server 8000

# Node.js
npx serve frontend
```

Access at: `http://localhost:8000/frontend/`

---

## 🚀 Installation and Setup

### Prerequisites

- Python 3.8+
- SQL Server (or compatible)
- Modern browser with Web Audio API support
- DAB CLI (Data API Builder)

### Initial Setup

1. **Python Environment**
   ```bash
   python -m venv venv
   # Windows
   venv\Scripts\Activate.ps1
   # Linux/Mac
   source venv/bin/activate
   ```

2. **Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Environment Configuration**
   ```bash
   cp sample.env.txt .env
   # Edit .env with SQL Server credentials
   ```

4. **Start Services**
   ```bash
   # Terminal 1: VoiceLive Backend
   python voicelive-server/server.py
   
   # Terminal 2: SQL Server + DAB
   cd sql-source && start.cmd
   
   # Terminal 3: Frontend Server
   cd frontend && python -m http.server 8000
   ```

---

## 🔧 Configuration

### Environment Variables

See `sample.env.txt` for required configuration:

```
DATABASE_URL=...
VOICELIVE_API_KEY=...
API_PORT=...
AGENT_VOICE_IT=...
AGENT_VOICE_EN=...
```

The backend supports a `lang` parameter with values `it` or `en`. When `lang` is provided, the agent uses the corresponding voice value from environment variables `AGENT_VOICE_IT` or `AGENT_VOICE_EN`. If `lang` is not specified, the default language is `it`.

### DAB Configuration

The `sql-source/dab-config.json` file configures:

```json
{
  "data_source": "SQL_SERVER",
  "connection": "Server=...;Database=...;",
  "rest": {
    "enabled": true,
    "path": "/api"
  },
  "graphql": {
    "enabled": true,
    "path": "/graphql"
  },
  "mcp": {
    "enabled": true
  }
}
```

---

## 📝 Conversational Flow

1. **User** speaks in the browser (Frontend)
2. **Audio Processor** captures and sends to backend
3. **VoiceLive Server** processes the voice command
4. **SQL Source** (via DAB) executes database queries
5. **Response** returns to frontend and is played back

---

## 📚 Logs and Debug

Logs are saved in the `logs/` folder:

- Backend errors and warnings
- Database queries
- VoiceLive API interactions

```bash
tail -f logs/voicelive-server.log
```

---

## 📖 Further Information

- [DAB Documentation](https://learn.microsoft.com/en-us/azure/data-api-builder/)
- [Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API)
- [SQL Server Connection Strings](https://learn.microsoft.com/en-us/dotnet/framework/data/adonet/connection-strings)

---

**Project:** VoiceLive Conversational Assistant  
**Version:** 1.0  
**Date:** June 2026
