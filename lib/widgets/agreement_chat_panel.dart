import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../services/api_service.dart';

class AgreementChatPanel extends StatefulWidget {
  final AnalysisResult result;

  const AgreementChatPanel({super.key, required this.result});

  @override
  State<AgreementChatPanel> createState() => _AgreementChatPanelState();
}

class _ChatMessage {
  final String role; // "user" or "assistant"
  final String content;
  _ChatMessage({required this.role, required this.content});
}

class _AgreementChatPanelState extends State<AgreementChatPanel> {
  bool _expanded = false;
  bool _sending = false;
  bool _hovering = false;
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  static const _suggestions = [
    'What is the interest rate?',
    'What happens if I miss a payment?',
    'What are the biggest risks?',
  ];

  Map<String, dynamic> _buildAgreementContext() {
    final c = widget.result.extractedClauses;
    return {
      'agreement_type': widget.result.agreementType,
      'extracted_clauses': {
        'interest_rate': c.interestRate,
        'late_fee': c.lateFee,
        'early_settlement_penalty': c.earlySettlementPenalty,
        'liability_type': c.liabilityType,
        'repossession_clause': c.repossessionClause,
        'loan_amount': c.loanAmount ?? 'Not specified',
        'loan_tenure': c.loanTenure ?? 'Not specified',
        'interest_model': c.interestModel ?? 'Not specified',
        'compounding_frequency': c.compoundingFrequency ?? 'Not applicable',
        'guarantor_liability': c.guarantorLiability ?? 'Not applicable',
        'insurance_requirement': c.insuranceRequirement ?? 'Not applicable',
        'balloon_payment': c.balloonPayment ?? 'Not applicable',
      },
      'plain_language_summary': widget.result.plainLanguageSummary,
      'detected_risks': widget.result.detectedRisks,
      'defender_analysis': widget.result.defenderAnalysis,
      'protector_analysis': widget.result.protectorAnalysis,
      'narrative_simulation': {
        'one_missed_payment':
            widget.result.narrativeSimulation.oneMissedPayment,
        'three_missed_payments':
            widget.result.narrativeSimulation.threeMissedPayments,
        'full_default': widget.result.narrativeSimulation.fullDefault,
      },
      'risk_scores': {
        'legal_risk_score': widget.result.riskScores.legalRiskScore,
        'financial_burden_score':
            widget.result.riskScores.financialBurdenScore,
        'poverty_vulnerability_score':
            widget.result.riskScores.povertyVulnerabilityScore,
        'overall_risk_score': widget.result.riskScores.overallRiskScore,
        'risk_level': widget.result.riskScores.riskLevel,
      },
    };
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _sending) return;

    setState(() {
      _messages.add(_ChatMessage(role: 'user', content: text.trim()));
      _sending = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final history = _messages
          .sublist(0, _messages.length - 1)
          .map((m) => {'role': m.role, 'content': m.content})
          .toList();

      final reply = await _apiService.chatWithAgreement(
        userMessage: text.trim(),
        conversationHistory: history,
        agreementContext: _buildAgreementContext(),
      );

      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(role: 'assistant', content: reply));
          _sending = false;
        });
        _scrollToBottom();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            role: 'assistant',
            content: 'Sorry, something went wrong. Please try again.',
          ));
          _sending = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF16102A), Color(0xFF0F0D18)],
          ),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.28)
                : const Color(0xFF8B5CF6).withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6)
                  .withValues(alpha: _hovering ? 0.12 : 0.05),
              blurRadius: _hovering ? 28 : 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Purple accent bar
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8B5CF6),
                    const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
            _buildHeader(),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _expanded ? _buildChatBody() : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(14),
          bottom: Radius.circular(14),
        ),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // AI icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.06),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.question_answer_rounded,
                    color: Color(0xFF8B5CF6), size: 15),
              ),
              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ask About This Agreement',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(
                      _messages.isEmpty
                          ? 'AI-powered agreement clarification'
                          : '${_messages.length} messages',
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 10),
                    ),
                  ],
                ),
              ),

              // AI badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.10),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                  ),
                ),
                child: const Text('AI',
                    style: TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontSize: 9,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),

              // Chevron
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(Icons.expand_more_rounded,
                    color: Color(0xFF64748B), size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBody() {
    return Column(
      children: [
        // Divider
        Container(
          height: 1,
          color: const Color(0xFF1E1E2E),
        ),

        // Suggestion chips (only when no messages yet)
        if (_messages.isEmpty) _buildSuggestions(),

        // Message list
        if (_messages.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 360),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              shrinkWrap: true,
              itemCount: _messages.length + (_sending ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

        // Input row
        _buildInputRow(),
      ],
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Try asking:',
              style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _suggestions.map((s) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _sendMessage(s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.06),
                      border: Border.all(
                        color:
                            const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(s,
                        style: const TextStyle(
                            color: Color(0xFFA78BFA),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    final isUser = msg.role == 'user';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            // AI avatar
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                ),
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Color(0xFF8B5CF6), size: 12),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isUser
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.15)
                    : const Color(0xFF1A1A2E),
                border: Border.all(
                  color: isUser
                      ? const Color(0xFF8B5CF6).withValues(alpha: 0.20)
                      : const Color(0xFF1E1E2E),
                ),
              ),
              child: SelectableText(
                msg.content,
                style: TextStyle(
                  color: isUser
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFFCBD5E1),
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
              ),
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: Color(0xFF8B5CF6), size: 12),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF1A1A2E),
              border: Border.all(color: const Color(0xFF1E1E2E)),
            ),
            child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF0D0B16),
          border: Border.all(color: const Color(0xFF1E1E2E)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(
                    color: Color(0xFFE2E8F0), fontSize: 12),
                decoration: const InputDecoration(
                  hintText: 'Ask about this agreement...',
                  hintStyle:
                      TextStyle(color: Color(0xFF475569), fontSize: 12),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  isDense: true,
                ),
                onSubmitted: (text) => _sendMessage(text),
                enabled: !_sending,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _sending
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF8B5CF6)),
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () => _sendMessage(_controller.text),
                      icon: const Icon(Icons.send_rounded,
                          color: Color(0xFF8B5CF6), size: 18),
                      splashRadius: 18,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
