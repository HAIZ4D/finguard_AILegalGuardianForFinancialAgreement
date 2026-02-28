<div align="center">

<img src="https://img.shields.io/badge/KitaHack-2026-8B5CF6?style=for-the-badge&logo=google&logoColor=white" />
<img src="https://img.shields.io/badge/Flutter-Web-06B6D4?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Vertex_AI-Gemini_2.0_Flash-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white" />
<img src="https://img.shields.io/badge/Firebase-Deployed-F59E0B?style=for-the-badge&logo=firebase&logoColor=white" />
<img src="https://img.shields.io/badge/SDG_1-No_Poverty-E5243B?style=for-the-badge" />
<img src="https://img.shields.io/badge/SDG_16-Peace_%26_Justice-00689D?style=for-the-badge" />

<br/><br/>

# FinGuard
### AI Legal Guardian for Financial Agreements

**Live App: [https://finguard-4dacc.web.app](https://finguard-4dacc.web.app)**

</div>

---

## Section 1 : Project Overview

**FinGuard: AI Legal Guardian for Financial Agreements**

**Team Name:** Sigma Coders
**GDGoC Chapter:** Google Developer Group on Campus : Universiti Putra Malaysia (UPM)
**University:** Universiti Putra Malaysia (UPM)
**Members:**
- Muhammad Haizad bin Murad *(Team Leader)* : Universiti Putra Malaysia
- Hafiy Azfar bin Mohd Masri : Universiti Putra Malaysia
- Hazriq Haykal Norrol Farhan : Universiti Putra Malaysia
- Muhammad Naim bin Mazni : Universiti Putra Malaysia

### Executive Summary

FinGuard is an AI-powered legal risk analysis tool that helps ordinary Malaysians understand financial agreements before they sign them. Users upload a personal loan, guarantor contract, or hire-purchase agreement as a PDF, and within seconds the app extracts every key clause, explains the risks in plain language, simulates what happens if they miss payments, and calculates a deterministic risk score they can trust. The entire system is built on Google Vertex AI (Gemini 2.0 Flash) and Firebase, fully deployed, and accessible to anyone without a legal background or a lawyer. FinGuard directly addresses SDG 1 (No Poverty) and SDG 16 (Peace, Justice & Strong Institutions) by putting the knowledge of a legal analyst into the hands of every borrower.

---

### AI Is Core to This Solution

FinGuard would not function at all without AI. The entire value of the product : reading a dense legal document, identifying hidden risks, explaining consequences in plain language, and debating both sides of an agreement : requires natural language understanding that no rule-based or keyword system can replicate. Google Vertex AI (Gemini 2.0 Flash) is used in every primary workflow: contract analysis, scenario simulation, debate transcript generation, and the contextual chatbot. Without AI, FinGuard is just a file upload form. With it, it becomes a legal guardian in your pocket.

---

## Section 2 : Problem Statement

### The Scale of the Problem

A UiTM study published in the *Journal of Administrative Science* found that **over 95% of non-law university students cannot identify their basic rights in a contract or recognise red-flag clauses.** This is not a B40 problem : it affects engineers, IT professionals, and business owners equally.

The language barrier makes it worse. Malaysian legal contracts use archaic English and technical Bahasa Baku that even educated readers struggle to decode. In October 2025, senior lawyers publicly warned that even official legal translations carry the risk of "erroneous meaning" that leads to miscarriages of justice *([Free Malaysia Today, Oct 2025](https://www.freemalaysiatoday.com/category/nation/2025/10/25/difficult-to-make-malay-authoritative-text-for-national-laws-say-lawyers))* : a problem that is orders of magnitude worse for an ordinary borrower reading a loan contract alone.

### The Consequences

The downstream impact of legal illiteracy is measurable and severe:

- **46.4% of all Malaysian bankruptcies** are caused by personal loans and guarantor obligations *([Insolvency Dept / SYOK, 2025](https://en.syok.my/news/young-malaysians-declared-bankrupt-until-2025))*
- **60% of those declared bankrupt were aged 25–44** : working adults in their productive years *(FINCO Financial Industry Collective Outreach, 2018–2022)*
- The most dangerous group: **accidental bankrupts** : people who signed as a guarantor (penjamin) not realising "joint and several liability" makes them 100% liable for the entire debt
- Bank Negara Malaysia's 2024 survey found financial **behaviour scores declining** even as knowledge improves : people are signing documents they don't fully understand under real-world pressure
- In 2021 alone, the Labour Department received over **2,500 employment contract complaints**, many rooted in misunderstood clauses like unilateral transfer rights *(FINCO)*

A June 2025 Industrial Court ruling (*Jagdeep Kaur v. Halal Development Corp*) confirmed this pattern in employment: employees routinely sign transfer letters that strip their rights, simply because they don't know that any fundamental change to an employment contract requires mutual consent under the Employment Act 1955 *([AJobThing, Sep 2025](https://www.ajobthing.com/resources/blog/8-misconceptions-and-myths-about-employment-contracts-in-malaysia))*.

### Why Existing Solutions Fail

Lawyers cost RM200–500/hour. Generic guides can't read your specific contract. Bank staff work for the lender. There is no tool that takes your actual agreement and tells you, in plain language, exactly what you are agreeing to and what can go wrong. That is the gap FinGuard fills.

### Why AI Is Necessary

Contract language is not uniform : every lender uses different phrasing for the same mechanisms. A keyword filter that looks for "repossession" will miss "forced disposal of collateral asset." Only a large language model can read any contract in any format, reliably identify what matters, explain it in plain language, and simulate both sides of the argument. A rules engine cannot narrate. A keyword filter cannot debate. Only Gemini can.

---

## Section 3 : SDG Alignment

### SDG 1 : No Poverty

SDG 1 targets the elimination of poverty in all its forms, including financial vulnerability caused by predatory lending and debt traps. In Malaysia, the B40 population is disproportionately exposed to high-interest personal loans and hire-purchase agreements with aggressive repossession and penalty clauses. Many fall into poverty not because of a single catastrophic event, but because of a slow accumulation of fees, penalties, and compounding interest on agreements they never fully understood.

FinGuard contributes to SDG 1 directly. Every time a user sees that their proposed loan carries a 24% effective interest rate before signing : not after : they have a chance to negotiate, find an alternative, or simply walk away. Every time a first-time guarantor understands that "joint and several liability" means they are fully responsible for the entire debt, not just a share of it, they can make an informed decision. FinGuard does not give legal advice. It gives legal knowledge : and knowledge is the most effective tool against financial exploitation.

The Poverty Vulnerability Score in FinGuard is directly tied to this SDG. It aggregates 80% of all triggered risk points across both legal and financial categories to produce a single score representing how much this agreement could threaten a borrower's financial stability. A score above 60 on this dimension means the agreement has multiple characteristics commonly associated with debt spiral entry in Malaysian lending data.

### SDG 16 : Peace, Justice & Strong Institutions

SDG 16 calls for access to justice for all : not just for those who can afford legal representation. In the current system, institutional lenders have legal teams who draft contracts. Individual borrowers have nothing. This imbalance is a justice problem. A person who signs a harmful contract they did not understand does not have recourse because ignorance of a contract's terms is not a legal defence.

FinGuard addresses this by democratising legal understanding. It does not replace a lawyer. It gives every borrower the same baseline understanding of their agreement that a lawyer would give them in the first five minutes of a consultation : the risks, the key clauses, the worst-case scenarios, and what questions to ask before signing. This is what access to justice looks like at scale.

### Measurable Impact

FinGuard tracks measurable outcomes through the Decision Tracker feature and Firebase Analytics. After viewing their full analysis, users record their decision: Sign, Negotiate, or Walk Away. This creates a direct record of behaviour changed, not just information delivered. The system also tracks how many contracts with overall risk scores above 60 result in a "Negotiate" or "Walk Away" decision, which is the most direct measure of harm prevented. The goal is for more than half of high-risk analyses to result in something other than an unconsidered sign.

---

## Section 4 : Solution Overview

### What FinGuard Does

FinGuard accepts any personal loan, guarantor agreement, or hire-purchase contract as a PDF upload. It sends the document through Google Vertex AI for multi-role analysis, runs the extracted data through a deterministic risk scoring engine, and returns a complete structured report in under 30 seconds. The report includes plain-language explanations, risk scores with full transparency into how they were calculated, scenario simulations, dual-perspective analysis, and an interactive AI Financial Debate Podcast. After reading the report, users can ask follow-up questions through an AI chatbot that has full context of their specific contract.

### Key Features

**AI Contract Analysis (5 Roles in One Gemini Call)**
A single structured API call to Vertex AI activates five logical roles within the model: Clause Extraction, Defender Analysis, Protector Analysis, Narrative Risk Simulation, and Debate Moderation. Gemini also produces a Detected Risks list and a Plain Language Summary as part of the same response. This is the core of the product : everything else builds on top of this output.

**Deterministic Risk Scoring**
Three independent risk scores are calculated by a rule-based TypeScript engine, not by AI: Legal Risk (0–100), Financial Burden (0–100), and Poverty Vulnerability (0–100). Each score is derived from specific thresholds calibrated to Malaysian lending practices. The Overall Risk Score is the average of the three. A risk level of Low, Medium, or High is assigned based on the overall score.

**Score Transparency Panel**
Every triggered risk rule is shown to the user with its exact contribution to the score : for example, "Interest rate 24% exceeds 15% personal loan threshold → +25 Financial Risk." The full scoring formula is displayed. Users can trace exactly why their score is what it is.

**Narrative Risk Simulation**
Gemini narrates : specifically for the uploaded contract : what happens after 1 missed payment, 3 missed payments, and full default. The simulation covers fee accumulation, legal escalation, guarantor exposure, and repossession where applicable. This is not generic text; it references the actual clauses from the user's agreement.

**Defender vs Protector Analysis**
Two perspectives on the same agreement are presented side by side. The Defender explains each clause from the lender's position : why it exists, what risk it manages. The Protector explains the same clauses from the borrower's position : what could go wrong, what the worst-case exposure looks like. Users can read both and form their own judgement.

**AI Financial Debate Podcast**
Gemini generates an 8-turn structured debate between the Defender and Protector, which is then converted to dual-voice audio using Google Cloud Text-to-Speech. The Protector uses a female voice (en-US-Neural2-C) and the Defender uses a male voice (en-US-Neural2-D). The transcript highlights in sync with audio playback. Users can tap any turn to seek directly to that point in the audio.

**AI Chatbot**
A floating chat panel gives users direct question-and-answer access to Gemini with their full contract context loaded. They can ask "What does the balloon payment clause mean for me?" or "If I miss two payments, what is the total extra I would owe?" and receive accurate, contract-specific answers.

**Recommended Actions**
A rule-based engine generates a prioritised list of specific steps the user should take before signing, based on which risk rules were triggered. If the late fee is above 5%, the action is "Ask the lender to confirm the exact late fee calculation in writing." If joint and several liability is detected, the action is "Consult a lawyer before signing this guarantor agreement." These are deterministic, not AI-generated.

**Financial Calculators**
The result screen includes a Debt-to-Income (DTI) ratio calculator, a full repayment breakdown showing total cost of credit over the loan tenure, a worst-case penalty scenario panel, and an interest model insight that explains the difference between the stated and effective interest rate.

**Agreement Comparison**
Users can select any two past analyses from their history and compare them side by side. All three risk scores, individual clause values, simulation scenarios, and a computed verdict are shown together. No new API call is needed : the comparison is calculated locally from stored data.

**Decision Tracker**
After completing an analysis, users record whether they chose to Sign, Negotiate, or Walk Away. This is stored in a separate `decisions` Firestore collection and linked back to the analysis, enabling tracking of real behavioural impact over time.

**Analysis History**
Every analysis is saved to Firestore and accessible from the History screen. Users can revisit past analyses, view full reports, start a comparison, or open the chatbot for a previous contract at any time.

---

## Section 5 : Technical Architecture

### System Overview

```
┌──────────────────────────────────────────────────────────┐
│                    Flutter Web (Frontend)                  │
│  Provider State Mgmt · file_picker · fl_chart             │
│  Screens: Home · Upload · Result · History · Comparison   │
└────────────────────────┬─────────────────────────────────┘
                         │ HTTPS / JSON
                         ▼
┌──────────────────────────────────────────────────────────┐
│          Firebase Cloud Functions (2nd Gen, Node 20)       │
│                                                            │
│  analyzeContract    chatWithAgreement    getHistory        │
│  generateDebateAudio                    logDecision        │
└──────┬─────────────────────┬────────────────────────────-┘
       │                     │
       ▼                     ▼
┌─────────────┐    ┌──────────────────────────────────────┐
│ Vertex AI   │    │   Deterministic Risk Engine          │
│ Gemini 2.0  │    │   (riskEngine.ts : pure TypeScript)  │
│ Flash       │    │   No AI · Rule-based · Reproducible  │
└──────┬──────┘    └──────────────────────────────────────┘
       │                              │
       └──────────────┬───────────────┘
                      ▼
┌──────────────────────────────────────────────────────────┐
│                  Firebase Services                         │
│                                                            │
│  Firestore            Cloud Storage      Firebase Hosting  │
│  (analyses/decisions) (PDFs / WAV audio) (Flutter Web)    │
│                                                            │
│  Firebase Analytics   Cloud Text-to-Speech (TTS API)      │
└──────────────────────────────────────────────────────────┘
```

### Component Breakdown

**Flutter Web (Frontend)**
The frontend is a compiled Flutter Web single-page application. State is managed with the `provider` package via `AnalysisProvider`, which holds the current analysis result and loading state. All network calls are encapsulated in `ApiService`. The UI is broken into screens (`HomeScreen`, `UploadScreen`, `ResultScreen`, `HistoryScreen`, `ComparisonScreen`) and self-contained widgets (`RiskGauge`, `ClauseCard`, `DebatePodcast`, `SimulationTimeline`, `ScoreTransparency`, `RecommendedActions`, `AgreementChatPanel`, `DtiCalculator`, `RepaymentBreakdown`, `DecisionTracker`).

**Firebase Cloud Functions (Backend)**
All business logic runs server-side inside five Cloud Functions (2nd Gen, Node.js 20, TypeScript). No AI credentials or scoring logic are ever exposed to the frontend. Each function has individually configured timeout and memory limits appropriate to its workload.

**Vertex AI (Gemini 2.0 Flash)**
The AI layer is accessed via the `@google-cloud/vertexai` SDK. Contract analysis uses `responseMimeType: "application/json"` to enforce structured output. The chat endpoint uses `text/plain` with a system instruction built from the contract context. Both use the model ID `gemini-2.0-flash-001` pinned to the `us-central1` region.

**Deterministic Risk Engine**
A pure TypeScript module (`riskEngine.ts`) with no external dependencies. It receives extracted clause data from Gemini and applies hard-coded threshold rules calibrated to Malaysian lending practices. It produces three independent scores and an overall risk level. This component is intentionally isolated from AI to ensure scoring is reproducible and auditable.

**Google Cloud Text-to-Speech**
The TTS service (`ttsService.ts`) synthesises each debate turn in parallel using two Neural2 voices. Raw PCM buffers are concatenated with 700ms silence gaps between turns. A 44-byte WAV header is prepended in memory and the complete audio file is written to Cloud Storage. Timing data is computed from byte offsets to enable transcript synchronisation in the frontend player.

### Data Flow

```
User uploads PDF
        │
        ▼
Flutter reads PDF bytes → base64-encodes → POST /analyzeContract
        │
        ▼
Cloud Function decodes base64 bytes → pdf-parse extracts raw text
        │
        ▼
Gemini 2.0 Flash (single structured call)
  ├─ Role 1: Clause Extraction
  ├─ Role 2: Defender Analysis
  ├─ Role 3: Protector Analysis
  ├─ Role 4: Narrative Risk Simulation
  ├─ Role 5: Debate Moderation
  ├─ Detected Risks list
  └─ Plain Language Summary
        │
        ▼
riskEngine.ts (deterministic, no AI)
  ├─ Legal Risk Score (0–100)
  ├─ Financial Burden Score (0–100)
  └─ Poverty Vulnerability Score (0–100)
        │
        ▼
Combined result saved to Firestore (analyses collection)
        │
        ▼
Structured JSON returned to Flutter
        │
        ▼
UI renders full analysis report
```

### Firestore Database Schema

```
analyses/{documentId}
  ├── agreement_type         : "Personal Loan" | "Guarantor Agreement" | "Hire Purchase"
  ├── extracted_clauses      : {
  │     interest_rate, late_fee, early_settlement_penalty,
  │     liability_type, repossession_clause, loan_amount,
  │     loan_tenure, interest_model, compounding_frequency,
  │     guarantor_liability, insurance_requirement, balloon_payment
  │   }
  ├── defender_analysis      : string (AI : lender perspective)
  ├── protector_analysis     : string (AI : borrower perspective)
  ├── narrative_simulation   : { one_missed_payment, three_missed_payments, full_default }
  ├── debate_transcript      : [{ speaker: "defender"|"protector", message: string }]
  ├── detected_risks         : string[]
  ├── plain_language_summary : string
  ├── risk_scores            : {
  │     legal_risk_score, financial_burden_score,
  │     poverty_vulnerability_score, overall_risk_score,
  │     risk_level: "Low" | "Medium" | "High"
  │   }
  ├── user_decision          : "Sign" | "Negotiate" | "Walk Away" | null
  ├── audioUrl               : string | null (Cloud Storage path)
  ├── audioTimings           : [{ index, speaker, startMs, endMs }]
  ├── audioDurationMs        : number
  ├── input_method           : "text" | "pdf"
  └── timestamp              : Timestamp

decisions/{documentId}
  ├── analysis_id  : string
  ├── decision     : string
  ├── risk_score   : number
  ├── timestamp    : string
  └── created_at   : Timestamp
```

### Cloud Function Endpoints

**POST `/analyzeContract`**
Main analysis endpoint. Accepts `contract_text` (string) or `pdf_bytes_base64` (base64-encoded PDF bytes). Runs Gemini analysis → risk scoring → Firestore save → returns full JSON. Timeout: 120s, Memory: 512MiB.

**POST `/chatWithAgreement`**
AI chatbot endpoint. Accepts `user_message`, `conversation_history` (up to 10 messages), and `agreement_context` (the full analysis data). Returns a plain-text reply from Gemini with full contract awareness. Timeout: 60s, Memory: 256MiB.

**GET `/getHistory`**
Returns the 20 most recent analyses from Firestore ordered by timestamp descending. Accepts optional `?limit=N` query parameter (max 50).

**POST `/logDecision`**
Records a user's sign/negotiate/walk-away decision to the `decisions` collection and updates the corresponding `analyses` document. Used by the Decision Tracker widget.

**POST `/generateDebateAudio`**
Generates dual-voice TTS audio for a debate transcript. Checks Firestore cache first to avoid regeneration. Synthesises turns in parallel, merges PCM buffers, creates WAV, uploads to Cloud Storage, and returns a base64-encoded audio payload with timing data. Timeout: 180s, Memory: 512MiB.

---

## Section 6 : Google Technology Justification

---

### Google AI Technology

---

### Vertex AI : Gemini 2.0 Flash

**Why we chose it:** FinGuard required a model that could read free-form legal text of any length and return a complete, structured JSON response covering eight distinct output fields : all in a single API call. We evaluated this against the alternative of multiple specialised calls (one for extraction, one for analysis, one for simulation) and chose the single-call multi-role approach because it is simpler, cheaper, and faster. Gemini 2.0 Flash was the correct choice because it supports `responseMimeType: "application/json"` at the API level, which enforces structured output without post-processing hacks.

**Cause → Effect:** Because Gemini enforces structured JSON output at the API level, the backend receives machine-parseable responses without post-processing. This reduces pipeline failures, lowers error handling complexity, and ensures reliable contract analysis under real demo conditions.

**Why not another model:** FinGuard is built entirely on Google products, and Vertex AI integrates natively with the Firebase Admin SDK via service account authentication. This means no API keys are stored in environment variables or frontend code : authentication is handled by the Cloud Functions runtime identity, eliminating an entire class of credential management risk.

### Google Cloud Text-to-Speech

**Why we chose it:** The AI Financial Debate Podcast required two distinct, natural-sounding voices : one for the lender advocate (Defender) and one for the borrower advocate (Protector). Google Cloud Text-to-Speech's Neural2 voices are the highest-quality voices available within the Google ecosystem and are consistent with the "only Google products" architecture constraint. The API returns raw PCM audio that can be programmatically merged into a single WAV file with precise timing control.

**Cause → Effect:** Because we use two distinct Neural2 voices (`en-US-Neural2-D` for the Defender, `en-US-Neural2-C` for the Protector), users can distinguish which side is speaking by voice alone without reading the speaker labels : making the podcast experience genuinely conversational. Byte-level timing calculation from raw PCM audio enables transcript highlighting to synchronise within 200ms accuracy, creating a seamless and interactive listening experience.

---

### Google Technology

---

### Flutter Web

**Why we chose it:** Flutter Web compiles a single Dart codebase into a fully interactive browser application with native-quality animations and UI components. For FinGuard, this meant building a rich result report with animated risk gauges, scrollable timelines, and a floating chat panel without writing any JavaScript. Flutter's widget composition model made it straightforward to build the 14 UI sections of the result screen as independent, reusable widgets, each testable in isolation.

**Cause → Effect:** Because Flutter uses a single codebase for both mobile and web, FinGuard can be extended to Android and iOS without rewriting the frontend. This reduces development time and enables rapid scaling to a wider audience with minimal engineering overhead.

### Firebase Cloud Functions (2nd Gen)

**Why we chose it:** All AI calls and business logic must run server-side to protect credentials and prevent tampering with the risk scoring engine. Cloud Functions 2nd Gen (powered by Cloud Run under the hood) gave us per-function configuration of timeout and memory, HTTPS triggers with built-in CORS support, and zero-infrastructure deployment. We can deploy all five endpoints with a single `firebase deploy --only functions` command.

**Cause → Effect:** Because the risk engine runs server-side inside Cloud Functions rather than in the Flutter frontend, users cannot inspect, modify, or tamper with scoring logic. This guarantees that all displayed risk scores are authoritative, reproducible, and secure.

**Scalability:** Cloud Functions scale to zero when idle and spin up new instances automatically under load. For a hackathon with unpredictable traffic spikes (especially during demos), this means no over-provisioning costs and no risk of the backend going down under sudden load.

### Cloud Firestore

**Why we chose it:** Firestore's document-oriented model maps perfectly to the structure of a contract analysis result : a single JSON-like document with nested objects for clauses, scores, simulations, and metadata. No schema migrations are needed when new fields are added (for example, adding `debate_transcript` and audio caching fields to existing documents was transparent to all existing history entries). Firestore also integrates directly with the Firebase Admin SDK inside Cloud Functions with no additional configuration.

**Cause → Effect:** Because all analysis results are persisted immediately to Firestore, the History and Comparison features require no backend processing : the Flutter frontend fetches pre-computed data and renders it locally. This allows History and Comparison features to render instantly without additional AI calls, reducing latency and eliminating redundant API costs.

### Firebase Cloud Storage

**Why we chose it:** Cloud Storage is the persistence layer for two types of binary data: generated debate audio files and any large supplementary assets. When a user plays the AI Financial Debate Podcast for the first time, the synthesised WAV file is uploaded to Cloud Storage by the `generateDebateAudio` Cloud Function after TTS synthesis. On subsequent plays, the function checks Cloud Storage first : if the file exists, it returns it directly without re-calling the Text-to-Speech API. PDF files themselves are transmitted directly to the Cloud Function as base64-encoded bytes in the request body, without an intermediate Cloud Storage upload step.

**Cause → Effect:** Because audio files are cached in Cloud Storage after first generation, subsequent visits to the same analysis result serve audio instantly without re-calling the Text-to-Speech API. This prevents redundant Text-to-Speech API costs and significantly reduces playback latency for returning users.

### Firebase Hosting

**Why we chose it:** Flutter Web produces a static build output (HTML, JS, CSS, assets). Firebase Hosting serves static files via a global CDN with HTTPS by default. Deployment is a single command: `flutter build web --release && firebase deploy --only hosting`. Custom domain support and automatic SSL certificate management are included.

**Cause → Effect:** Because Firebase Hosting serves assets from edge CDN nodes globally, the Flutter Web app loads with low latency regardless of user location. This ensures stable demo performance even if judges access the app from different regions.

### Firebase Analytics

**Why we chose it:** Firebase Analytics is a zero-configuration analytics layer that integrates into Flutter Web via the `firebase_analytics` package. It provides usage tracking without requiring a separate analytics service or additional authentication.

**Cause → Effect:** Because Analytics tracks screen navigation patterns and session engagement across all users, we have measurable evidence of how deeply users explore the result report : not just page views. The confirmed 17.18 events-per-active-user figure directly supports our impact claims by demonstrating genuine multi-screen engagement rather than single-page bounces.

---

## Section 7 : AI Integration

### Multi-Role AI Architecture

FinGuard implements what we call a Multi-Role Prompt Architecture inside a single Vertex AI call. Rather than making five separate API calls for extraction, analysis, simulation, debate, and summary (which would multiply cost and latency by five), a single structured mega-prompt instructs Gemini to perform all five roles sequentially and return their outputs as a single unified JSON object. Each role is defined by a clearly labelled section in the prompt, with explicit instructions about perspective, tone, and output format.

The five roles are:

**Role 1 : Clause Extraction Agent:** Reads the raw contract and outputs structured key-value pairs for all relevant financial and legal terms: interest rate and model, late fees, early settlement penalty, liability type, repossession clause, loan amount, tenure, insurance requirements, and balloon payment.

**Role 2 : Defender Agent:** Analyses the agreement from the lender's perspective. Explains why each clause exists and what business risk it protects against. Tone is professional and balanced, not adversarial.

**Role 3 : Protector Agent:** Analyses the same clauses from the borrower's perspective. Surfaces hidden costs, escalation risks, and worst-case legal exposure. Tone is empathetic and practically focused.

**Role 4 : Narrative Risk Simulator:** Writes three scenario narratives specific to the uploaded contract: what happens at 1 missed payment, 3 missed payments, and full default. Includes guarantor exposure and repossession timelines where applicable.

**Role 5 : Debate Moderator:** Generates an 8-turn structured debate (4 turns per side) between the Defender and Protector. Each turn is 1–3 sentences. The Protector opens with the most significant concern, the Defender responds with business justification, and they alternate through to a final summary from each side.

In addition to the five named roles, the same call produces the Detected Risks list (concise descriptions of every red flag found) and the Plain Language Summary (a 2–3 paragraph plain-English rewrite of the entire agreement).

A separate, independent AI call handles the chatbot. The `chatWithAgreement` Cloud Function uses a different system prompt built from the contract context and conversation history. It is capped at 10 messages of history to stay within token limits and uses a higher temperature (0.3 vs 0.2 for analysis) to allow more natural conversational responses.

### Structured Prompt Design

The contract analysis prompt is carefully engineered to produce consistent, parseable output across any contract type. Key design decisions:

The `responseMimeType: "application/json"` generation config parameter tells Gemini at the API level to return only valid JSON. This eliminates the most common failure mode in LLM pipelines : the model wrapping its JSON in markdown code fences or adding explanatory text before or after the object. We still include a fallback `cleanText` function that strips code fences in case an older model version ignores this parameter.

The prompt includes a complete JSON schema as a concrete example, not just a field list. This dramatically reduces hallucinated field names or structural variations. The schema includes example values (e.g., `"18% per annum (flat rate)"`) so the model understands the expected format of each value.

The debate transcript is given explicit turn count, speaker alternation rules, opening speaker identity, and tone guidance. Without these constraints, Gemini produces variable-length debates that cannot be reliably timed for audio synchronisation. With them, it consistently produces exactly 8 turns in the correct alternating pattern.

The prompt includes a negative instruction: `"Be specific to THIS contract, not generic."` This is the single most impactful instruction for output quality. Without it, Gemini tends to produce generic financial risk descriptions rather than clause-specific narratives.

### How AI Improves Decision-Making

Without FinGuard, a borrower reads a contract and either signs without understanding it (accepting unknown risk) or does not sign (rejecting a potentially acceptable agreement out of confusion). Both are poor outcomes.

FinGuard's AI output enables a third path: the user reads the plain language summary, sees the risk score, understands which specific clauses are problematic, sees what would happen if things go wrong, reads both sides of the debate, and then makes an informed decision. The Decision Tracker captures whether that decision was to sign, negotiate, or walk away : providing evidence that the AI output genuinely changed behaviour, not just provided information.

The Protector analysis and worst-case simulation are particularly important for decision-making. Users consistently report (in our feedback sessions) that seeing the escalation scenario written out in plain language for their specific contract is more impactful than any numerical score.

### How Hallucination Is Reduced

FinGuard uses two architectural mechanisms to reduce the impact of hallucination:

The first is strict output schema enforcement. The `responseMimeType: "application/json"` parameter and the concrete JSON schema in the prompt constrain the model to produce structured outputs in a specific format. Numerical claims (interest rates, fee percentages) are extracted from the source document, not generated by the model, which means they can be cross-validated against what the document actually contains.

The second and more important mechanism is the complete separation of risk scoring from AI. Gemini extracts clause values (e.g., "interest rate: 18%"). The deterministic risk engine applies the rule (e.g., "if > 15%, add 25 points to Financial Risk"). The final risk score cannot be hallucinated because the model never produces it : only the rule engine does. If Gemini misreads the interest rate, the score will be wrong, but it will be wrong in a way that can be corrected by reading the source document. It cannot be wrong in the sense of being invented from nothing.

### Why AI Is Meaningful, Not Decorative

A meaningful AI integration solves a problem that cannot be solved without AI. FinGuard's core function : reading any financial contract in any format and producing clause-specific, personalised risk analysis in natural language : is not achievable through any non-AI approach. No keyword matcher can identify a balloon payment clause that is worded as "residual value payment at termination." No template system can produce a narrative simulation tailored to the specific penalty amounts and tenure of an individual agreement. No rules engine can generate a balanced debate between two positions on the same clause. AI is not an add-on feature in FinGuard. It is the product.

---

## Section 8 : Implementation Details

### Frontend Implementation

The Flutter Web frontend uses the `provider` package for state management. `AnalysisProvider` is the single source of truth, holding the current `AnalysisResult`, loading state (`idle`, `loading`, `success`, `error`), and analysis history. All screens listen to this provider via `Consumer<AnalysisProvider>`.

The upload flow uses `file_picker` with `withData: true` to open a native file dialog for PDF selection and read the file bytes directly into memory as a `Uint8List`. The `analyzeContractPdf` API method base64-encodes those bytes and posts them as `pdf_bytes_base64` in the JSON body to the `analyzeContract` Cloud Function : no intermediate Cloud Storage upload is required. Text input (for testing with sample contracts) uses the `analyzeContract` method directly with `contract_text`.

The result screen is composed of 14 distinct widget sections, each independently built, animated with `animate_do` entrance effects, and organised in a vertical scroll column. `fl_chart` is used for the ring-dial animated gauge and the linear progress bars in the score sections. `shimmer` provides loading skeleton placeholders while the analysis is in progress.

The debate podcast widget (`DebatePodcast`) manages its own audio state with a local `StatefulWidget`. Audio is loaded lazily : the Cloud Function is called only on the first tap of the Play button. The `just_audio` package handles web audio playback via a `StreamBuilder` on the position stream for real-time progress tracking and transcript highlighting.

### Backend Processing Flow

When a contract arrives at the `analyzeContract` function:

1. The function validates the request (either `contract_text` or `pdf_bytes_base64` must be present)
2. If `pdf_bytes_base64` is provided, the base64 string is decoded to a `Buffer` and parsed with `pdf-parse` (dynamic import to reduce cold-start overhead)
3. The extracted text is passed to `analyzeWithGemini()` with the project ID and optional agreement type hint
4. `analyzeWithGemini()` builds the full prompt, calls Vertex AI with `responseMimeType: "application/json"`, strips any markdown fences from the response, parses the JSON, and validates required fields
5. The parsed Gemini response is passed to `calculateRiskScores()` which runs the deterministic rule engine
6. The combined result is assembled and saved to Firestore in the `analyses` collection
7. The full structured response (Gemini outputs + risk scores) is returned as JSON to the frontend

The entire flow from HTTP request to response takes between 15 and 35 seconds depending on contract length and model response time. A 120-second timeout is configured on the function to handle large contracts.

### PDF Parsing Method

PDF text extraction uses the `pdf-parse` npm package, imported dynamically inside the Cloud Function handler to reduce cold-start time. The library is called with a `Buffer` decoded from the base64 `pdf_bytes_base64` field in the request body. It returns a `pdfData.text` string containing the full extracted text with whitespace preserved.

No OCR is performed. The system works with digitally-created PDFs (bank-generated loan documents, e-signed contracts). Scanned image PDFs will produce empty or garbled text and are outside the current scope.

### Risk Scoring Logic

The risk engine (`riskEngine.ts`) operates in two phases.

**Phase 1 : Flag Detection:** The engine examines the extracted clause values from Gemini and checks them against hard-coded rules for each agreement type. Personal loan rules check for interest rate above 15%, flat interest model, late fee above 5%, early settlement penalty above 3%, and monthly compounding. Guarantor rules check for joint and several liability, unlimited liability, absence of a release clause, and direct recovery language. Hire purchase rules check for immediate repossession, interest above 12%, balloon payment presence, and mandatory insurance. Each triggered rule produces a `RiskFlag` object with a severity level, point value, and category.

**Phase 2 : Score Calculation:** Legal Risk accumulates points from all legal-category flags. Financial Burden accumulates points from all financial-category flags. Poverty Vulnerability accumulates 80% of all flag points regardless of category, reflecting that both legal and financial risks threaten financial stability. All three scores are capped at 100. The Overall Risk Score is `Math.round((legal + financial + poverty) / 3)`. Risk levels are: 0–30 Low, 31–60 Medium, 61–100 High.

The complete rule thresholds are:

- Personal Loan: Interest > 15% → High (+25 Financial), Flat rate model → Medium (+15 Financial), Late fee > 5% → High (+25 Legal), Early penalty > 3% → Medium (+15 Financial), Monthly compounding → Medium (+15 Financial)
- Guarantor: Joint & Several liability → High (+25 Legal), Unlimited liability → High (+25 Legal), No release clause → Medium (+15 Legal), Direct recovery clause → High (+25 Legal)
- Hire Purchase: Immediate repossession → High (+25 Legal), Interest > 12% → Medium (+15 Financial), Balloon payment → High (+25 Financial), Mandatory insurance → Medium (+15 Financial)

### Agreement Comparison Logic

The comparison feature requires no API call. When a user selects two analyses from the History screen and taps Compare, the Flutter app passes both `AnalysisResult` objects to `ComparisonScreen` via `Navigator.pushNamed` arguments.

Inside the comparison screen, five sections are computed entirely from the stored data:

**Risk Overview:** The three score values from each result's `riskScores` object are placed side by side. The lower overall score is highlighted as the safer agreement.

**Financial Cost Table:** Numeric values are extracted from clause strings using a regex pattern (`/[\d.]+/`). Cells are colour-coded: green for the lower value, red for the higher. This surfaces at a glance which agreement costs more across all financial dimensions.

**Clause Risk Table:** String clause values are compared. When a numeric extraction is possible, the higher value receives a "Stricter" badge. When not numeric, the comparison is shown as-is for the user to assess.

**Simulation Comparison:** The narrative texts for all three default scenarios are placed in a side-by-side two-column layout for direct reading comparison.

**Verdict:** The agreement with the lower `overallRiskScore` wins. The verdict section lists the specific score dimensions where the winner is better, presents audience-specific guidance cards (suitable for: Salary Earner / Guarantor / Business Owner), and includes a disclaimer that this is not legal advice.

### Key Technical Decisions

**Single Gemini call vs multiple calls:** We chose to combine all five AI roles into one API call. The alternative (five separate calls) would have multiplied cost, latency, and complexity. The single-call architecture works because Gemini 2.0 Flash can handle multi-task structured prompts reliably, and the `responseMimeType: "application/json"` parameter keeps the output clean.

**Deterministic scoring separate from AI:** This was a deliberate architecture decision, not a cost-saving one. Risk scores that users act on must be trustworthy. An AI-generated score could vary between runs, be influenced by prompt phrasing, or be impossible to explain to a sceptical user. A deterministic rule engine produces the same score every time from the same inputs and can display every rule that contributed : this is what makes the Score Transparency feature possible.

**Versioned model ID:** We initially used `gemini-1.5-flash` as the model identifier and received 404 errors from the Vertex AI SDK. After investigation, we found that the correct versioned model ID for the `us-central1` region is `gemini-2.0-flash-001`. We now pin to the full versioned ID rather than a generic alias to avoid this class of breakage in future deployments.

**WAV header construction in memory:** The TTS service constructs the WAV file header manually (44 bytes, RIFF/WAVE format, 16-bit mono PCM at 24kHz) rather than using an audio library. This avoids an additional npm dependency and gives us precise control over the audio format parameters needed for accurate timing calculation.

**Audio timing from byte offsets:** Timing synchronisation for the transcript highlight feature is derived from PCM byte offsets rather than metadata returned by the TTS API. The formula is `ms = bytes / 2 / 24000 * 1000` (16-bit = 2 bytes per sample, 24000 samples per second). This produces reliable sub-second accuracy without any post-processing.

---

## Section 9 : Innovation

### What Makes FinGuard Different

Most financial technology tools in this space do one of two things: they show you your credit score, or they help you apply for a loan faster. Neither of them reads the contract you are about to sign and tells you what is actually in it. FinGuard does something that has not existed before as a free, accessible, web-based tool for Malaysian borrowers: it puts a legal analyst, a financial adviser, and a risk assessor in your browser, activated by a single PDF upload.

**Innovation 1 : Multi-Role Single-Call AI Architecture**

Using a large language model to play multiple distinct analytical roles within a single structured prompt is an architectural pattern that pushes the boundaries of what developers typically do with Gemini. Most implementations make one call and ask one question. FinGuard makes one call and asks the model to simultaneously be a clause extractor, a lender advocate, a borrower protector, a scenario narrator, a debate moderator, and a plain-language translator : all returning their outputs in a single, validated JSON object. This is not prompt chaining. It is a deliberate multi-role system design that reduces cost, reduces latency, and produces coherent cross-role outputs because the model holds the full contract context in working memory across all five roles simultaneously.

**Innovation 2 : Responsible AI Hybrid: AI Reasons, Rules Score**

FinGuard makes an explicit architectural decision that is rare in hackathon projects: it draws a hard line between what AI does and what rules do. AI is used for everything that requires natural language understanding : reading, explaining, narrating, debating. Rules are used for everything that requires trust : scoring, ranking, recommending. The user can see every rule that contributed to their score. The score cannot change between runs because it is not produced by a model. This hybrid is not a limitation; it is a design philosophy. Financial risk scores that inform real-world decisions must be explainable and reproducible. FinGuard is built on that principle.

**Innovation 3 : Dual-Voice AI Financial Debate Podcast**

The AI Financial Debate Podcast is the most technically distinctive feature in FinGuard. Gemini generates a structured 8-turn adversarial debate about the user's specific contract. That debate is then synthesised into audio using two distinct Neural2 voices from Google Cloud Text-to-Speech : one voice for each side. The PCM audio buffers are stitched together server-side with precisely timed silence gaps. Byte-offset timing calculations enable the frontend to synchronise transcript highlighting to within 200ms of the actual audio playback position. Users can tap any turn in the transcript to seek audio to that exact moment. The result is an experience that transforms a legal document into an accessible, listenable financial podcast : a format that has no precedent in the consumer legal tech space.

**Innovation 4 : Poverty Vulnerability Score as an SDG Metric**

Most risk scoring tools in lending produce a single credit risk number. FinGuard produces a dedicated Poverty Vulnerability Score that measures how likely this agreement is to contribute to a financial poverty spiral. It aggregates 80% of all triggered risk points across both legal and financial categories into a single SDG-aligned metric. A borrower might have a moderate Financial Burden score but a high Poverty Vulnerability score because their contract has multiple overlapping penalty mechanisms that individually look modest but compound severely on a missed payment. This score directly operationalises SDG 1 as a measurable output of a software system.

**Innovation 5 : Explainable AI Through Score Transparency**

Most AI-driven risk tools give you a number and expect you to trust it. FinGuard shows its working. The Score Transparency panel lists every rule that was triggered : the rule name, the category it affects, and the exact point contribution : and displays the full scoring formula. A user who disagrees with their score can trace exactly why it is what it is and identify which clause they would need to negotiate to bring it down. This is Explainable AI applied to a real consumer decision-support context.

**Innovation 6 : Behavioural Impact Measurement**

Most information tools measure output (page views, analyses completed). FinGuard measures outcome (decisions changed). The Decision Tracker records whether each user chose to Sign, Negotiate, or Walk Away after seeing their analysis. This data is stored in a separate Firestore collection linked to the analysis and the risk score. It allows us to ask the most important question in impact measurement: did the user receive information, or did the information actually change what they did? This distinction is what separates a tool that is useful from a tool that makes a difference.

---

## Section 10 : User Testing and Iteration

### Our Testing Approach

Before finalising the feature set, we tested FinGuard with four people outside the team: a university student who had recently signed a PTPTN supplement personal loan, a young professional currently comparing car loan offers, a parent who had signed a guarantor agreement for a family member's business loan, and a peer from the engineering faculty with no finance background. Each tester was given a sample personal loan contract, asked to use the app without any guidance from us, and then asked to describe what was confusing, what was helpful, and what was missing. The iterations below came directly from their responses.

---

**Iteration 1 : Repayment Breakdown**

A tester who had recently taken a personal loan said the monthly installment figure in her agreement felt manageable, so she had signed it. She said "I never added it up. I had no idea I was paying almost double the original loan amount by the end." After seeing the risk score in FinGuard, she asked whether the app could show her the total cost of the loan, not just the monthly number.

We implemented the Repayment Breakdown widget in response. It shows the total amount repayable over the full tenure, a visual breakdown of how much goes to principal versus interest, the effective interest rate compared to the stated rate, and a summary of the total interest paid. For flat-rate loans, it also shows the annualised equivalent rate so users can make meaningful comparisons between loan offers. This feature directly addresses the information gap that caused our tester to unknowingly commit to paying far more than she expected.

---

**Iteration 2 : DTI Impact Calculator**

A young professional testing the app said something important: "The risk score tells me about the contract. But I need to know if I can actually afford this loan on my salary." He was right : a contract can be low-risk in terms of its penalty clauses but still unaffordable for a specific individual's income. Our first version had no way to assess affordability at a personal level.

We implemented the DTI (Debt-to-Income) Impact Calculator. Users input their monthly income and existing monthly debt obligations. The calculator computes their current DTI ratio, their DTI after taking this loan, and whether the new ratio crosses the 40% danger threshold commonly used by Malaysian lenders and financial counsellors as the boundary between sustainable and unsustainable debt. If the DTI would exceed 40%, the calculator highlights this as a critical affordability warning : separate from the contract risk score, which assesses the agreement itself rather than the borrower's financial position.

---

**Iteration 3 : Contextual AI Chatbot**

After seeing their full analysis report, multiple testers had follow-up questions that the static report could not answer in real time. One asked "Can I negotiate the early settlement penalty before I sign?" Another asked "If my salary is RM3,500 and I miss one payment, exactly how much more would I owe next month?" These are specific, contextual questions that require understanding of the particular contract : not generic financial advice.

We implemented the AI Chatbot as a floating panel accessible from the result screen. Each user message triggers a separate Gemini call that receives the complete contract analysis as its context : the extracted clauses, the risk scores, the agreement type, and the conversation history for that session. This means Gemini's responses reference the user's actual terms and figures rather than giving generic answers. The chatbot is capped at 10 messages of history per session to maintain token efficiency while preserving conversation continuity.

---

**Iteration 4 : AI Financial Debate Podcast**

One tester looked at the Defender vs Protector analysis section and said "This is still too much text. I feel like I am reading another legal document." She was right : two multi-paragraph analysis sections placed side by side recreated the density of the original contract in a different format. She suggested making it something she could listen to on her phone while doing something else, like a podcast.

We implemented the AI Financial Debate Podcast. Gemini generates an 8-turn adversarial debate between the Defender and Protector, each referencing specific clauses from the user's actual contract. The debate is synthesised into dual-voice audio using Google Cloud Text-to-Speech, with a distinctly different voice for each side. The audio player shows a scrollable transcript that highlights the active speaker in real time as the audio plays. Users can also tap any turn to jump directly to that point in the conversation. The experience transforms a wall of legal analysis text into a 3–4 minute audio discussion that users can follow passively, engage with interactively, or skip through at their own pace.

---

## Section 11 : Success Metrics and Impact

### Measuring What Matters

Standard analytics tools measure reach : how many people visited, how many pages they viewed. For FinGuard, reach is a vanity metric. The only metric that matters is whether someone made a more informed financial decision because of the app. We measure this at three levels: qualitative outcomes from user testing, behavioural tracking via the Decision Tracker, and usage pattern data from Firebase Analytics.

### Findings from User Survey (10 Respondents)

Ten participants completed a structured post-analysis survey. Of the ten, four were also the active iteration testers documented in Section 10 (who additionally provided qualitative suggestions that drove the four usability iterations). The remaining six completed the survey without providing written suggestions. All ten respondents used the live deployed app to analyse a real or representative financial agreement before answering the survey.

#### Behaviour Change : Understanding Scale

Respondents rated their understanding of the contract on a 1–5 scale both before and after using FinGuard.

**Before FinGuard:**
- 20% (2 respondents) rated their understanding at 1 (no understanding)
- 50% (5 respondents) rated their understanding at 2 (low understanding)
- 30% (3 respondents) rated their understanding at 3 (partial understanding)
- 0% rated 4 or 5
- Result : 100% of respondents were below confident before using the tool

**After FinGuard:**
- 30% (3 respondents) rated their understanding at 4 (good understanding)
- 70% (7 respondents) rated their understanding at 5 (full understanding)
- 0% rated 3 or below
- Result : 100% of respondents moved to high confidence after using the tool

Every single respondent shifted from the bottom half of the scale (1–3) to the top half (4–5). This is not a marginal improvement : it is a complete distributional shift. The plain language summary, clause-by-clause breakdown, and scenario simulation together moved all ten respondents from uncertain to confident.

#### Behaviour Change : Decision Change Metric

After seeing the full FinGuard analysis, respondents were asked whether they would change their original signing decision.

| Decision Change | Respondents | Percentage |
|---|---|---|
| Sign → Walk Away | 4 | 40% |
| Sign → Negotiate | 3 | 30% |
| Negotiate → Sign | 1 | 10% |
| No change (kept same decision) | 2 | 20% |

**8 out of 10 respondents (80%) changed their stated decision after seeing the FinGuard analysis.**

Breaking down the 8 who changed:
- **7 out of 10 respondents (70%) became more cautious** : 4 who initially said they would sign outright decided to walk away entirely after seeing a High risk classification, and 3 decided to negotiate specific clauses before signing
- **1 out of 10 respondents (10%) became more confident** : initially uncertain and inclined to negotiate, they decided to sign after FinGuard assigned a Low risk classification and confirmed no dangerous clauses were present

Both outcomes represent informed decision-making. The goal of FinGuard is not to make everyone walk away : it is to ensure no one signs or refuses to sign without understanding what they are agreeing to. A Low risk result that gives a hesitant person confidence to proceed is as valid a success as a High risk result that prevents a harmful signing.

#### Risk Awareness : Correlation Between Risk Score and Decision

The Risk Awareness data confirms that FinGuard's deterministic risk scoring directly influenced respondents' decisions in the expected direction:

- Respondents shown **High Risk** agreements consistently chose **Walk Away** or **Negotiate** as their post-analysis decision
- Respondents shown **Low Risk** agreements consistently chose **Sign** or retained their original signing intent

This correlation is the core validation of the system's design. The risk engine is not assigning arbitrary scores : respondents read the score, understood the clause-level explanations behind it, and made decisions that match the risk level. The AI and the deterministic engine together produced outputs that users found credible and acted on.

#### Feature Engagement : Most Useful Features

Respondents identified which features they found most useful during their analysis session.

| Feature | Respondents Found Useful | Usage Rate |
|---|---|---|
| AI-Generated Agreement Summary | 9 / 10 | 90% |
| Extracted Key Clauses | 9 / 10 | 90% |
| Risk Score Dashboard | 9 / 10 | 90% |
| Defender vs Protector Perspectives | 9 / 10 | 90% |
| Repayment Breakdown | 9 / 10 | 90% |
| FinGuard AI Chatbot | 9 / 10 | 90% |
| Risk Simulation (Scenario Analysis) | 8 / 10 | 80% |
| Agreement Comparison | 8 / 10 | 80% |
| DTI Calculator | 7 / 10 | 70% |
| Effective Interest Rate Insight | 7 / 10 | 70% |
| Recommended Actions | 6 / 10 | 60% |

Six features achieved 90% utility rating. No feature scored below 60%. This distribution confirms that the product has no dead weight : every section of the result report is valued by the majority of users, and the highest-value features (AI Summary, Key Clauses, Risk Score, Defender/Protector, Chatbot) are the exact features built around FinGuard's core AI architecture.

The 80% changed-decision rate is the most meaningful metric we have. It is not a page view or a session length : it is a behaviour change with direct SDG 1 relevance.

### Google Technology for Analytics

**Firebase Analytics** is integrated in the Flutter frontend via `firebase_analytics: ^12.1.2`. The `FirebaseAnalyticsObserver` is attached to the app router, automatically tracking every screen navigation event across the full user journey (Home → Upload → Result → History → Comparison).

### Live Firebase Analytics Data (Feb 2026)

The following confirmed data was recorded from the live deployed application at [https://finguard-4dacc.web.app](https://finguard-4dacc.web.app):

- **33 unique users** visited and interacted with the app
- **567 total events** fired across all sessions
- **17.18 events per active user** — users explore multiple screens per session, not a single-page bounce
- **379 screen_view events** across 33 users — confirmed multi-screen navigation
- **57 session_start events** — users return across multiple separate sessions
- **32 first_visit events** — 32 first-time visitors recorded

The 17.18 events-per-user figure is the most meaningful engagement signal: users are not landing on the home screen and leaving. They are navigating through the upload flow, reading the full result report, and returning to the app. This is the behaviour of a tool people find genuinely useful, not a demo they click once and close.

### Cause-and-Effect Impact Model

Even where raw numbers are limited at hackathon scale, the causal mechanism is clear and direct:

User uploads contract → FinGuard surfaces hidden clause risks the user did not know existed → User understands the financial consequences of clauses they could not previously read → User records a Negotiate or Walk Away decision instead of signing unconsidered → One potentially harmful agreement is not signed at terms disadvantageous to the borrower → That user's financial security is marginally but meaningfully better protected.

At scale, this causal chain compounds. In our survey, 70% of respondents shown a High risk agreement chose to Walk Away or Negotiate rather than sign unconsidered. If FinGuard processes 10,000 analyses per year and a conservative 30% of High-risk analyses result in a Negotiate or Walk Away decision, that is 3,000 instances of a potentially harmful financial commitment being examined rather than accepted blindly. Against the backdrop of AKPK reporting tens of thousands of Malaysians seeking debt counselling annually : many citing unexpected contract terms : even a fraction of that figure represents meaningful SDG 1 impact.

---

## Section 12 : Technical Challenges

### Challenge 1 : Gemini Returning Truncated JSON for Long Contracts

**What went wrong:** During early testing with real bank-issued loan contracts (typically 8–15 pages of dense text), the Gemini API call would return a partial JSON response. The response would begin correctly, proceed through the first several fields, and then cut off mid-string : sometimes in the middle of a paragraph in the `protector_analysis` field, leaving the JSON structurally incomplete and unparseable. The `JSON.parse()` call in the Cloud Function would throw an error, the entire analysis would fail, and the user received a generic error message.

**Why it happened:** Gemini 2.0 Flash has a default output token limit. When the contract text is long and the prompt requests eight separate analysis outputs, the combined response can exceed the default token budget. The model does not wait until it finishes the final field before returning : it returns whatever it has produced up to the token limit, even if that means returning structurally broken JSON.

**Technical solution:** We set `maxOutputTokens: 8192` explicitly in the Vertex AI generation config. This gives the model the maximum room available in the standard Flash context for output. We also added a `finishReason` log check in the Cloud Function: if the model returns `finishReason: "MAX_TOKENS"` instead of `"STOP"`, it is logged as a warning. This lets us detect truncation after the fact and identify contracts that are too large for the current token budget, without crashing the user's request.

**Design decision:** We also restructured the JSON schema in the prompt to place the most critical fields (`extracted_clauses`, `risk_scores`, `agreement_type`) earlier in the response object. If truncation does occur, the backend at minimum has the data it needs for risk scoring even if the narrative fields are incomplete.

---

### Challenge 2 : Audio Playback Blocked by CORS

**What went wrong:** The original design stored generated debate audio as a WAV file in Cloud Storage and returned a signed URL to the Flutter frontend, which would then play it directly via the browser's audio element. In testing, playback failed silently in Chrome. The browser's developer console showed a CORS (Cross-Origin Resource Sharing) error: the audio request from the Firebase Hosting domain was being blocked by the Cloud Storage default CORS policy.

**Why it happened:** Cloud Storage signed URLs do not automatically inherit the CORS headers needed for cross-origin audio playback. Configuring CORS on a Cloud Storage bucket requires `gsutil cors set` with a JSON configuration file : an infrastructure step that is brittle, easy to misconfigure, and needs to be re-applied if the bucket configuration is reset.

**Technical solution:** We eliminated the CORS problem entirely by removing the cross-origin request. Instead of returning a signed URL, the `generateDebateAudio` Cloud Function now downloads the generated WAV file from Cloud Storage, base64-encodes it, and returns it inline in the JSON response body as `data:audio/wav;base64,...`. The Flutter frontend stores this data URI in memory and passes it directly to the `just_audio` player. Because the audio data is embedded in the API response, the browser never makes a separate cross-origin request for the audio file : there is no CORS negotiation at all.

**Design decision:** The trade-off is that the base64 payload adds roughly 1.5× the file size to the HTTP response body. For a 3–4 minute WAV at 24kHz mono, this is approximately 6–8 MB in the response. On modern broadband connections this is acceptable for a one-time load. The audio data is cached in the Firestore document on subsequent requests so re-loading the same analysis does not re-download the full audio again.

---

## Section 13 : Ethics and Responsible AI

### Financial Disclaimer

FinGuard is an information tool, not a legal or financial advisory service. Every screen that presents risk analysis, clause explanations, or recommended actions includes a clear disclaimer: the outputs are intended to help users understand what their contract says, not to constitute legal advice. Users are encouraged to consult a qualified lawyer or financial adviser before making any decision to sign, reject, or modify a financial agreement. This disclaimer is embedded in the app UI, not hidden in a terms of service document.

### Data Privacy and Document Handling

FinGuard does not collect any personally identifiable information. No user accounts exist. No names, identification numbers, email addresses, or demographic data are collected at any point in the user flow. The app is fully functional without authentication by design : this is not only a hackathon scope simplification, it is a deliberate privacy choice that reduces the surface area for data misuse.

When a user uploads a PDF, the file is transmitted to Cloud Storage via an HTTPS POST to the Cloud Function. The file is stored temporarily in a private Cloud Storage bucket (not publicly accessible) under a generated UUID filename that carries no personal information. The file is read once by the `pdf-parse` library during the analysis, and the extracted text is passed to Vertex AI. Vertex AI processes the text for the duration of the API call. We do not configure Vertex AI to retain request data for model training : the default data handling policy for production Vertex AI APIs does not use request data for training purposes.

The Firestore `analyses` collection stores the analysis outputs (clause data, risk scores, AI text). It does not store the original PDF. It does not store any user identifier : all analyses are anonymous documents identified only by a Firestore-generated document ID. A future version with user accounts would require an explicit consent and data retention policy; the current anonymous architecture avoids this requirement entirely.

### Bias Mitigation in Risk Scoring

The most critical anti-bias decision in FinGuard is that risk scores are never produced by AI. Gemini extracts clause values (strings). The deterministic risk engine converts those strings to scores using hard-coded, publicly documented threshold rules. This means the risk score cannot be influenced by any bias in the training data of the language model : whether that bias relates to the type of lender, the demographic of the borrower, or the phrasing style of the contract.

The scoring rules themselves are calibrated to Malaysian lending regulations and practice standards. They are fixed thresholds, not learned weights. Any change to the rules requires a deliberate code change with explicit justification : they cannot drift or shift based on model updates. This makes the system auditable: anyone can read `riskEngine.ts` and verify exactly how every score is calculated.

### Responsible Use of AI Outputs

Gemini's outputs : Defender analysis, Protector analysis, scenario simulations, debate transcript : are clearly labelled as AI-generated throughout the UI. The term "AI-generated" or "Powered by Gemini" is shown on all AI content sections. The distinction between AI outputs and deterministic outputs is maintained in the UI (the Score Transparency panel explicitly labels the scoring as "Deterministic rule-based scoring : no AI bias"). Users are never left uncertain about which parts of the report come from AI reasoning and which come from rules.

### Current Limitations

FinGuard is honest about what it cannot do. Judges and users should be aware of the following known boundaries:

- **No OCR support** : the system works with digitally-created PDFs (bank-issued, e-signed contracts). Scanned image PDFs produce empty or garbled text. Document image parsing is outside the current scope.
- **English language only** : the UI, AI prompts, and risk engine outputs are in English. Bahasa Malaysia support is planned but not yet implemented.
- **Malaysian context only** : the risk scoring thresholds are calibrated specifically to Malaysian lending regulations and AKPK guidelines. The tool is not appropriate for contracts governed by other jurisdictions without recalibrating the rule engine.
- **Numeric extraction via pattern matching** : the comparison feature extracts numeric values from clause strings using a regex pattern. Unusually formatted values (e.g., "eighteen percent" instead of "18%") may not be correctly extracted for comparison.
- **Not legal advice** : FinGuard identifies and explains risks but does not constitute legal advice. Users with complex agreements are explicitly directed to consult a qualified lawyer.
- **No user accounts** : all analyses are anonymous. Users cannot save preferences, receive notifications, or track their history across devices. This is a deliberate privacy decision at hackathon scope.
- **Chat context limited to 10 messages** : the AI chatbot retains up to 10 messages of conversation history per session to manage token costs. Longer conversations reset context.

---

## Section 14 : Scalability and Future Roadmap

### Immediate Next Steps (Post-Hackathon)

**Expand Agreement Types**
FinGuard currently supports three agreement types: Personal Loan, Guarantor Agreement, and Hire Purchase. The next priority is BNPL (Buy Now Pay Later) agreements, which have become a significant source of consumer financial distress in Malaysia among young adults. Islamic financing structures (Murabahah, Tawarruq, Ijarah) are also a priority, as their risk mechanisms : deferred payment markups, profit rates, mandatory takaful : differ significantly from conventional interest-rate instruments and require their own rule thresholds. Tenancy agreements with embedded financing clauses (common in developer-funded property schemes) are a third target.

**Bahasa Malaysia Interface**
The borrowers most exposed to harmful financial agreements are often most comfortable reading and speaking in Bahasa Malaysia rather than English. Gemini 2.0 Flash handles multilingual prompts reliably. Adding Bahasa Malaysia support requires translating the Flutter UI strings and appending a language instruction to the prompt. The risk scoring engine is language-agnostic. This is a high-priority accessibility feature.

**Guided Pre-Signing Checklist**
The current AI chatbot answers questions reactively. A guided pre-signing checklist would proactively walk the user through a structured set of questions : "Do you understand what triggers the late penalty?", "Have you confirmed the balloon payment amount with your lender?", "Do you have at least 3 months of installments in savings?" : and flag gaps in understanding before the user signs. This moves FinGuard from a passive information tool to an active decision-support companion.

**Mobile App (iOS and Android)**
Flutter's cross-platform capabilities mean the entire current frontend codebase can be compiled to iOS and Android with minimal changes. A mobile app would make FinGuard accessible at the moment a contract is presented : at the bank counter, at the car dealership, at the signing table : not only when the user is at a computer. This dramatically increases the real-world utility of the tool.

**Lender-Side Audit Tool**
Financial institutions that want to improve their customer relationships and reduce dispute rates could use a lender-facing version of FinGuard to audit their own contract templates. If a lender's standard personal loan agreement scores 75 on the overall risk scale, they know exactly which clauses are contributing to that score and can consider whether moderating those clauses would reduce borrower default rates and complaints.

### National-Level Scaling Plan

At national scale, FinGuard's value proposition aligns directly with initiatives by Bank Negara Malaysia (BNM) and AKPK to improve financial literacy. A partnership with AKPK could integrate FinGuard's contract analysis into their existing debt counselling workflow, giving counsellors an AI-assisted tool to explain contracts to clients in their sessions. A partnership with BNM's consumer protection division could provide aggregate anonymised data about which clause types are most commonly flagged as high-risk across all analysed contracts : providing a data-driven signal for regulatory review of lending practices.

At scale, Firebase's serverless architecture is a structural advantage. Every component scales automatically with zero infrastructure management:

Cloud Functions scale from zero to thousands of concurrent instances with no configuration changes. Firestore handles millions of document reads and writes per day without any operational overhead. Cloud Storage accepts any volume of uploads without capacity planning. Firebase Hosting serves the Flutter Web frontend from a global CDN regardless of user location or traffic volume.

The only cost-scaling consideration is Vertex AI API call volume, which scales linearly with usage and can be managed through quota increases and rate limiting at the Cloud Function layer.

### Cost and Resource Efficiency

FinGuard is architecturally cost-efficient by design. The following estimates are based on published Google Cloud pricing:

**Contract Analysis (per analysis)**
A typical 5-page loan contract generates approximately 3,000 input tokens and 2,500 output tokens for the Gemini call. At Gemini 2.0 Flash pricing (~$0.10/1M input, $0.40/1M output), this is roughly $0.001 per analysis. At 1,000 analyses per day, the Gemini cost is approximately $1/day.

**Debate Audio Generation (per podcast)**
An 8-turn debate transcript is approximately 1,800–2,200 characters. Google Cloud Text-to-Speech Neural2 pricing is approximately $16/1M characters. One debate audio generation costs approximately $0.035. Audio files are cached in Cloud Storage after first generation : subsequent plays cost nothing from the TTS API.

**Infrastructure (Cloud Functions, Firestore, Hosting)**
Cloud Functions 2nd Gen charges only for actual invocation time : there are no charges when idle. Firestore charges per document read/write : one analysis writes approximately 3 documents (analyses, potential decisions) at negligible cost. Firebase Hosting serves from CDN cache and costs essentially nothing at hackathon traffic levels.

**Estimated Total Cost at Scale**

- 1,000 analyses/day + 400 podcast generations/day : approximately $15–25/month
- 10,000 analyses/day + 4,000 podcast generations/day : approximately $150–250/month
- This is well within the operational budget of a public-sector or NGO deployment, and orders of magnitude cheaper than equivalent legal consulting costs for users.

### Multi-Language Expansion

After Bahasa Malaysia, the roadmap includes Mandarin Chinese (for Malaysian Chinese communities), Tamil (for Malaysian Indian communities), and eventually other ASEAN languages as FinGuard expands regionally. The core AI layer requires only a language instruction change in the prompt. The risk engine is language-independent. The main investment required for each language is UI translation and localisation.

### SME and Business Contract Expansion

Individual borrowers are the current focus, but small business owners face the same information asymmetry problem with commercial loan agreements, supplier credit terms, and equipment leasing contracts. A business-focused module with SME-appropriate risk thresholds and scenario simulations is a natural extension of the same architecture.

---

## Section 15 : Setup and Installation

### Demo

**Live Application:** [https://finguard-4dacc.web.app](https://finguard-4dacc.web.app)

**Demo Video:** *(YouTube link : [Youtube](https://youtu.be/zlv5PPr6w5I))*

**GitHub Repository:** *(Link : [GitHub Repo](https://github.com/HAIZ4D/finguard_AILegalGuardianForFinancialAgreement.git))*

---

### Prerequisites

Before running FinGuard locally, you need the following installed:

- Flutter SDK 3.7 or later : [flutter.dev](https://flutter.dev/docs/get-started/install)
- Node.js 18 or later : [nodejs.org](https://nodejs.org)
- Firebase CLI : `npm install -g firebase-tools`
- A Google Cloud project with the following APIs enabled:
  - Vertex AI API
  - Cloud Text-to-Speech API
  - Firebase (Firestore, Cloud Functions, Cloud Storage, Hosting)

---

### Firebase Project Setup

```bash
# Login to Firebase
firebase login

# Link to the existing project (or create your own)
firebase use finguard-4dacc

# Or initialise a new project
firebase init
# Select: Functions, Firestore, Hosting, Storage
```

---

### Vertex AI and Text-to-Speech Setup

The Cloud Functions use Application Default Credentials via the service account attached to the Firebase project. No manual credential file is needed when running in Cloud Functions. For local emulator testing, enable application default credentials:

```bash
gcloud auth application-default login
gcloud config set project finguard-4dacc

# Enable required APIs (one-time setup)
gcloud services enable aiplatform.googleapis.com
gcloud services enable texttospeech.googleapis.com
```

---

### Environment Variables

No `.env` file is required. The Cloud Functions read these values automatically from the runtime environment:

- `GCLOUD_PROJECT` : Google Cloud project ID (automatically set by Firebase runtime)
- `FIREBASE_CONFIG` : Firebase configuration (automatically set by Firebase runtime)

There are no secrets to manage manually. Vertex AI and Cloud Storage authentication are handled by the Cloud Functions service account identity.

---

### Running the Frontend Locally

```bash
# From the project root
flutter pub get
flutter run -d chrome
```

The app will connect to the deployed Cloud Functions by default. To point to local emulators, update the URL constants in [lib/services/api_service.dart](lib/services/api_service.dart) to use `localhost:5001`.

---

### Running the Backend Locally

```bash
cd functions
npm install
npm run build
firebase emulators:start --only functions,firestore,storage
```

The local emulator runs all five Cloud Functions on `localhost:5001`. Vertex AI calls will still reach the live Vertex AI API (the emulator does not mock external API calls).

---

### Deploying to Firebase

```bash
# Step 1 : Build and deploy Cloud Functions
cd functions
npm install
npm run build
cd ..
firebase deploy --only functions

# Step 2 : Build Flutter Web and deploy to Firebase Hosting
flutter build web --release
firebase deploy --only hosting
```

Both steps together deploy the complete application. The live deployment updates at [https://finguard-4dacc.web.app](https://finguard-4dacc.web.app) within about 60 seconds of the hosting deploy completing.

---

## Section 16 : Repository Structure

```
finguard/
│
├── lib/                              # Flutter frontend (Dart)
│   ├── main.dart                     # App entry point, route definitions
│   │
│   ├── models/
│   │   └── analysis_result.dart      # AnalysisResult, RiskScores, DebateTurn data models
│   │
│   ├── providers/
│   │   └── analysis_provider.dart    # ChangeNotifier : app state (result, loading, history)
│   │
│   ├── screens/
│   │   ├── home_screen.dart          # Landing page with feature overview
│   │   ├── upload_screen.dart        # PDF upload and text input, status indicator
│   │   ├── result_screen.dart        # Full analysis report (14 widget sections)
│   │   ├── history_screen.dart       # Past analyses, comparison selection, pulse animation
│   │   └── comparison_screen.dart    # Side-by-side agreement comparison (5 sections)
│   │
│   ├── services/
│   │   └── api_service.dart          # HTTP client for all 5 Cloud Function endpoints
│   │
│   ├── utils/
│   │   └── financial_calculator.dart # DTI, repayment, score factors, recommendations
│   │
│   └── widgets/
│       ├── animated_gauge.dart        # Animated ring dial for risk score display
│       ├── risk_gauge.dart            # Static risk level indicator
│       ├── clause_card.dart           # Individual extracted clause display card
│       ├── simulation_timeline.dart   # 3-scenario narrative timeline (1/3/full default)
│       ├── debate_podcast.dart        # AI Financial Debate Podcast player + transcript
│       ├── perspective_card.dart      # Legacy Defender/Protector card (fallback)
│       ├── score_transparency.dart    # Expandable scoring formula + rule breakdown
│       ├── recommended_actions.dart   # Rule-based action list from risk flags
│       ├── agreement_chat_panel.dart  # Floating AI chatbot panel
│       ├── dti_calculator.dart        # Debt-to-Income ratio calculator
│       ├── repayment_breakdown.dart   # Total repayment, principal vs interest breakdown
│       ├── interest_insight.dart      # Flat vs reducing rate explanation panel
│       ├── worst_case_panel.dart      # Maximum penalty accumulation scenario
│       ├── decision_tracker.dart      # Sign / Negotiate / Walk Away decision widget
│       ├── decision_badge.dart        # Badge showing recorded decision on history cards
│       ├── sdg_impact_card.dart       # SDG 1 / SDG 16 alignment display
│       └── finguard_logo.dart         # Animated FinGuard logo component
│
├── functions/                        # Firebase Cloud Functions (TypeScript/Node.js 20)
│   ├── src/
│   │   ├── index.ts                  # 5 function exports: analyzeContract, chatWithAgreement,
│   │   │                             #   getHistory, logDecision, generateDebateAudio
│   │   │
│   │   ├── prompts/
│   │   │   ├── contractPrompt.ts     # 5-role mega-prompt for contract analysis
│   │   │   └── chatPrompt.ts         # System prompt builder for AI chatbot
│   │   │
│   │   ├── services/
│   │   │   ├── geminiService.ts      # Vertex AI SDK integration (analyzeWithGemini, chatWithGemini)
│   │   │   ├── riskEngine.ts         # Deterministic risk scoring engine (no AI)
│   │   │   └── ttsService.ts         # Google Cloud TTS, WAV construction, audio timing
│   │   │
│   │   └── types/
│   │       ├── analysis.ts           # ExtractedClauses, GeminiResponse, AnalysisResult, RiskScores
│   │       ├── debate.ts             # DebateTurn, DebateAudioRequest, DebateAudioResponse
│   │       └── chat.ts               # ChatRequest, ConversationMessage
│   │
│   ├── package.json                  # Node.js dependencies (@google-cloud/vertexai, text-to-speech, etc.)
│   └── tsconfig.json                 # TypeScript configuration (target: ES2020)
│
├── samples/                          # Sample contracts for testing and demonstration
│   ├── personal_loan_LOW_RISK.txt    # 7% reducing rate, minimal penalties → Low Risk result
│   ├── personal_loan_HIGH_RISK.txt   # 24% flat rate, 8% late fee → High Risk result
│   ├── guarantor_contract_HIGH_RISK.txt  # Joint & several, unlimited liability → High Risk
│   └── hire_purchase_HIGH_RISK.txt   # 15% flat, immediate repossession, balloon payment
│
├── web/                              # Flutter Web platform configuration
│   └── index.html                    # Firebase SDK initialisation, app entry point
│
├── firebase.json                     # Firebase deployment configuration (functions, hosting, storage)
├── firestore.rules                   # Firestore security rules
├── storage.rules                     # Cloud Storage security rules
├── pubspec.yaml                      # Flutter dependencies
└── README.md                         # This file
```

### Key Architectural Separations

The folder structure reflects the three core architectural separations in FinGuard:

**AI vs Rules:** The `services/geminiService.ts` file handles everything AI-related. The `services/riskEngine.ts` file handles everything scoring-related. They are completely separate files with no shared logic, making the AI/rules boundary visible and auditable in the codebase.

**Prompts as first-class code:** The `prompts/` folder contains the system prompts as TypeScript modules rather than inline strings. This makes prompt engineering changes reviewable in version control and separates the prompt design from the API call mechanics.

**Frontend data isolation:** All API calls go through `services/api_service.dart`. No screen or widget makes HTTP calls directly. All state changes go through `providers/analysis_provider.dart`. No widget modifies state directly. This separation means the entire data flow of the app can be traced through two files.

---

## KitaHack 2026 Judging Criteria Alignment

This section maps FinGuard's features directly to the KitaHack 2026 evaluation rubric to help judges locate evidence for each criterion.

**SDG Impact**
FinGuard addresses SDG 1 (No Poverty) and SDG 16 (Peace, Justice & Strong Institutions) directly and measurably. The Poverty Vulnerability Score is an explicit SDG 1 metric embedded in every analysis. The Decision Tracker records behaviour changes : whether users negotiate or walk away from harmful agreements after using the app. Section 3 details the SDG alignment and Section 11 documents the 80% behaviour change result (8 out of 10 survey respondents) and the confirmed risk-score-to-decision correlation from the post-analysis survey.

**User Feedback and Iteration**
Ten participants completed a structured post-analysis survey; four of those ten were also the active iteration testers who provided qualitative suggestions that drove four documented product iterations: Repayment Breakdown, DTI Calculator, AI Chatbot, and AI Financial Debate Podcast. Each iteration is described in Section 10 with the specific feedback that motivated it. 100% of survey respondents reported improved understanding (all shifted from 1–3 to 4–5 on a 5-point scale); 80% changed their stated signing decision after seeing the FinGuard analysis.

**Success Metrics**
Section 11 documents four layers of evidence: (1) survey outcomes from 10 respondents showing 100% understanding improvement and 80% decision change; (2) feature engagement data with six features rated useful by 90% of respondents and no feature below 60%; (3) live Firebase Analytics data : 33 unique users, 567 total events, 17.18 events per active user confirming deep multi-screen engagement; and (4) a cause-and-effect model linking app usage to measurable harm prevention with a projection to national scale.

**AI Integration**
Gemini 2.0 Flash performs five distinct analytical roles in a single structured API call: clause extraction, defender analysis, protector analysis, narrative risk simulation, and debate moderation. A second independent Gemini call powers the contextual chatbot. AI is used for every natural language task. Risk scoring is deliberately kept deterministic and explainable. Section 7 explains the full architecture.

**Technology Innovation**
Six innovations are described in Section 9: multi-role single-call AI architecture, AI/Rules hybrid for trustworthy scoring, dual-voice AI Financial Debate Podcast with real-time transcript sync, Poverty Vulnerability Score as an operationalised SDG metric, Explainable AI through Score Transparency, and Behavioural Impact Measurement via Decision Tracker.

**Technical Architecture**
The full system architecture is documented in Section 5: Flutter Web frontend, five Firebase Cloud Functions (2nd Gen), Vertex AI Gemini 2.0 Flash, deterministic TypeScript risk engine, Firestore, Cloud Storage, Firebase Hosting, Firebase Analytics, and Google Cloud Text-to-Speech. The architecture diagram, Firestore schema, and all five Cloud Function endpoint specifications are included.

**Scalability**
Section 14 documents the serverless scaling properties of all components, a cost efficiency analysis ($0.001 per analysis, ~$150–250/month at 10,000 analyses/day), and a national-level scaling plan including AKPK and BNM partnership paths.

**Completeness**
FinGuard is fully deployed. All described features are live and functional at [https://finguard-4dacc.web.app](https://finguard-4dacc.web.app). Sample contracts for all three agreement types are included in the `samples/` folder for immediate demonstration.

---

*Built for KitaHack 2026 by Team Sigma Coders : Google Developer Group on Campus, Universiti Putra Malaysia*
