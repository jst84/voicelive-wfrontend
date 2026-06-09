# Voice Interaction Guidelines

A practical guide for designing spoken content that is clear, effective, and user-centered.

---

## 1. Design for listening, not reading

Responses should be short, natural, and easy to remember. Avoid visual elements or structures built for screens.

Avoid:

- tables
- long lists
- Markdown blocks or emoji
- long paragraphs

Prefer:

- at most 2–3 sentences
- a single main idea per turn
- conversational language

---

## 2. One thing at a time

Never list too many items in a row (e.g., 8 items). Provide a summary and let the user ask for details.

Always:

- communicate totals (e.g., "You have eight pending payments")
- highlight priorities (e.g., "Two are urgent")
- ask where to drill down (e.g., "Do you want to start with those?")

**Example**

❌
"You have eight payments: Techlab, SAP, Oracle, Revenue Agency..."

✅
"You have eight pending payments. Two are urgent. Do you want to start with those?"

---

## 3. Progressive disclosure

Do not give all details upfront: provide a summary first, then the details only if requested. This reduces cognitive load and frustration.

---

## 4. Offload details to another channel

Voice is not the right channel for long or sensitive data (IBANs, tax codes, long references, long lists, reports).

Recommended pattern:

Voice → summary

Teams / Email → full details

**Example:** "If you want, I can send the full details on Teams."

---

## 5. Make content "speakable"

- Numbers: avoid complex numeric formats. E.g. ❌ "€1.250.000" → ✅ "one million two hundred fifty thousand euros".
- Dates: use relative references. E.g. ❌ "15/06/2026" → ✅ "next Monday".
- Codes: read them only when necessary and pronounce them clearly (e.g., "zero zero one" instead of "001").

---

## 6. Keep conversational turns short

Avoid monologues. After each response, propose the next step and end with a question.

Pattern:

Information + Suggestion + Question

**Example:** "There are two urgent orders. Do you want to see them?"

---

## 7. Controlled proactivity

Notify users about urgencies, deadlines, large amounts, and anomalies without being intrusive. Avoid long explanations or endless lists.

---

## 8. Highlight only what matters

Provide concise summaries for critical items:

- large amounts: "Over two hundred thousand euros"
- deadlines: "Deadline to not miss"
- anomalies: "Warning: this payment is outside the normal range"

The user should immediately understand whether action is required.

---

## 9. Guided conversation

The assistant should propose the next step: approve, drill down, send details, or move to the next item.

---

## 10. Security by dialogue

For critical operations, follow a step flow:

1. Show only essential data
2. Verify identity
3. Ask for confirmation
4. Execute
5. Communicate the outcome

This replaces traditional GUI popups.

---

## 11. Reduce cognitive load

Limit information to 2–3 items at a time; avoid complex numbers and technical explanations.

---

## 12. Tone: trusted colleague

Use simple, natural language: e.g., "There are two urgent orders." rather than formal, bureaucratic phrasing.

---

## 13. Do not reveal internal workings

Do not expose technical or implementation details (e.g., "I'm querying the database" or "I ran a query"). The user should perceive an assistant, not a middleware.

---

## 14. Load context at the start

When a conversation starts, automatically fetch context and present a relevant finding: e.g., "I checked the situation: there are two urgent orders."

---

## 15. Invisible tools

The system decides which function to use without exposing implementation to the user.

Desired pattern:

User → Tool → Spoken summary

Never: User → "I'm running get_pending_orders"

---

## 16. Graceful fallback

If the request is out of scope, respond simply without technical explanations. Example: "This is outside what I can do. You should contact the Treasury team."

---

## 17. Action-oriented design

Every response should lead to an action: drill down, approve, reject, send details, or move to the next item. Avoid answers that end the conversation with no options.

---

## 18. Concise confirmations

For completed actions, use short, clear confirmations.

❌ "The payment identified by code X has been processed successfully."

✅ "Done, payment approved."

---

## 19. Voice-first, not screen-first

Don't turn a web app into a spoken monologue. Design for voice: summarize, prioritize, guide, and converse.

---

## 20. Design for time, not space

Voice delivers information over time: order information by priority and put important items at the beginning of the sentence.
