import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class ClauseCard extends StatefulWidget {
  final ExtractedClauses clauses;

  const ClauseCard({super.key, required this.clauses});

  @override
  State<ClauseCard> createState() => _ClauseCardState();
}

class _ClauseCardState extends State<ClauseCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final items = _buildClauseItems();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(_hovering ? 1.012 : 1.0, _hovering ? 1.012 : 1.0),
        transformAlignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF101020), Color(0xFF0D0D18)],
          ),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF06B6D4).withValues(alpha: 0.25)
                : const Color(0xFF1E1E2E),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF06B6D4)
                  .withValues(alpha: _hovering ? 0.10 : 0.02),
              blurRadius: _hovering ? 28 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top accent bar
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF06B6D4),
                    const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
            // Clause rows
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final item = entry.value;
                  final isLast = entry.key == items.length - 1;
                  final isEven = entry.key % 2 == 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: isEven
                          ? const Color(0xFF151524).withValues(alpha: 0.5)
                          : Colors.transparent,
                      border: isLast
                          ? null
                          : const Border(
                              bottom: BorderSide(
                                  color: Color(0xFF1A1A28), width: 0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 7, right: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF06B6D4),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF06B6D4)
                                    .withValues(alpha: 0.4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(item.label,
                              style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: Text(item.value,
                              style: const TextStyle(
                                  color: Color(0xFFE2E8F0),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  height: 1.4)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_ClauseItem> _buildClauseItems() {
    final c = widget.clauses;
    final items = <_ClauseItem>[
      _ClauseItem('Interest Rate', c.interestRate),
      _ClauseItem('Late Fee', c.lateFee),
      _ClauseItem('Early Settlement', c.earlySettlementPenalty),
      _ClauseItem('Liability Type', c.liabilityType),
      _ClauseItem('Repossession', c.repossessionClause),
    ];

    if (_isPresent(c.loanAmount)) {
      items.add(_ClauseItem('Loan Amount', c.loanAmount!));
    }
    if (_isPresent(c.loanTenure)) {
      items.add(_ClauseItem('Loan Tenure', c.loanTenure!));
    }
    if (_isPresent(c.interestModel)) {
      items.add(_ClauseItem('Interest Model', c.interestModel!));
    }
    if (_isPresent(c.compoundingFrequency)) {
      items.add(_ClauseItem('Compounding', c.compoundingFrequency!));
    }
    if (_isPresent(c.guarantorLiability)) {
      items.add(_ClauseItem('Guarantor Liability', c.guarantorLiability!));
    }
    if (_isPresent(c.insuranceRequirement)) {
      items.add(_ClauseItem('Insurance', c.insuranceRequirement!));
    }
    if (_isPresent(c.balloonPayment)) {
      items.add(_ClauseItem('Balloon Payment', c.balloonPayment!));
    }

    return items;
  }

  bool _isPresent(String? value) {
    if (value == null || value.isEmpty) return false;
    final lower = value.toLowerCase();
    return lower != 'not applicable' &&
        lower != 'not specified' &&
        lower != 'n/a' &&
        lower != 'none';
  }
}

class _ClauseItem {
  final String label;
  final String value;
  const _ClauseItem(this.label, this.value);
}
