from dataclasses import dataclass, field
from typing import List, Optional, Any
import uuid
from datetime import datetime

# ---------------------------------------------------------
# Conversation
# ---------------------------------------------------------

@dataclass
class Conversation:
    id: str = "fe3e33a0-5d48-4018-b1e1-0241e8631215"
    title: str = ""
    createdat: str = ""
    updatedat: str = ""
    userid: str = ""
    market_id: int = 1
    market_desc: str = "NA"
    note: str = ""
    filter: Optional[Any] = None
    filter_secondary: Optional[Any] = None
    product_info: Optional[Any] = None
    product_info_secondary: Optional[Any] = None
    is_custom_domain: bool = True
    first_question: Optional[Any] = None
    custom_domain: Optional[Any] = None
    language: Optional[Any] = None
    have_tickets_thd: bool = False
    have_tickets_phd: bool = False
    favorite: bool = False


# ---------------------------------------------------------
# Message
# ---------------------------------------------------------

@dataclass
class Message:
    content: str
    role: str="user"
    agent_name: Optional[str] = None
    agent_version: Optional[str] = None
    id: Optional[str] = None
    conversation_id: Optional[str] = None
    createdat: Optional[str] = None
    qa_id: Optional[str] = None
    edited_at: Optional[Any] = None
    edited_by: Optional[Any] = None
    models: Optional[str] = None


# ---------------------------------------------------------
# Root JSON
# ---------------------------------------------------------

@dataclass
class ConversationPayload:
    conversation: Conversation
    messages: List[Message]
    response: bool = True
    cached: bool = False
    follow_up_questions: List[Any] = field(default_factory=list)
    img_base64: List[Any] = field(default_factory=list)
    disambiguate: bool = False
    tool_called: str = "product-specialist"
    disambiguation_options: List[Any] = field(default_factory=list)
    out_of_scope: bool = False
    status: str = "completed"
    model: str = "Product-Specialist"
    missing_filters: bool = False


# ---------------------------------------------------------
# Utility per generare UUID e timestamp ISO
# ---------------------------------------------------------

def new_uuid() -> str:
    return str(uuid.uuid4())

def now_iso() -> str:
    return datetime.utcnow().isoformat() + "Z"
