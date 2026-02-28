import {ExtractedClauses, RiskScores} from "../types/analysis";

interface RiskFlag {
  rule: string;
  severity: "high" | "medium";
  points: number;
  category: "legal" | "financial" | "poverty";
}

function parsePercentage(value: string): number | null {
  const match = value.match(/([\d.]+)\s*%/);
  return match ? parseFloat(match[1]) : null;
}

function detectRiskFlags(
  clauses: ExtractedClauses,
  agreementType: string,
): RiskFlag[] {
  const flags: RiskFlag[] = [];
  const type = agreementType.toLowerCase();

  // ===== PERSONAL LOAN RULES (from CLAUDE.md) =====
  if (type.includes("personal") || type.includes("loan")) {
    const interestRate = parsePercentage(clauses.interest_rate || "");
    if (interestRate !== null && interestRate > 15) {
      flags.push({
        rule: "Interest rate > 15%",
        severity: "high",
        points: 25,
        category: "financial",
      });
    }

    if (clauses.interest_model?.toLowerCase().includes("flat")) {
      flags.push({
        rule: "Flat interest model",
        severity: "medium",
        points: 15,
        category: "financial",
      });
    }

    const lateFee = parsePercentage(clauses.late_fee || "");
    if (lateFee !== null && lateFee > 5) {
      flags.push({
        rule: "Late fee > 5% of installment",
        severity: "high",
        points: 25,
        category: "legal",
      });
    }

    const earlyPenalty = parsePercentage(
      clauses.early_settlement_penalty || "",
    );
    if (earlyPenalty !== null && earlyPenalty > 3) {
      flags.push({
        rule: "Early settlement penalty > 3%",
        severity: "medium",
        points: 15,
        category: "financial",
      });
    }

    if (clauses.compounding_frequency?.toLowerCase().includes("month")) {
      flags.push({
        rule: "Monthly compounding interest",
        severity: "medium",
        points: 15,
        category: "financial",
      });
    }
  }

  // ===== GUARANTOR RULES (from CLAUDE.md) =====
  if (type.includes("guarantor")) {
    const liability = (clauses.liability_type || "").toLowerCase();

    if (liability.includes("joint") && liability.includes("several")) {
      flags.push({
        rule: "Joint & Several Liability",
        severity: "high",
        points: 25,
        category: "legal",
      });
    }

    if (liability.includes("unlimited")) {
      flags.push({
        rule: "Unlimited liability",
        severity: "high",
        points: 25,
        category: "legal",
      });
    }

    const guarantorLiability = (
      clauses.guarantor_liability || ""
    ).toLowerCase();
    if (
      !guarantorLiability.includes("release") &&
      !liability.includes("release")
    ) {
      flags.push({
        rule: "No release clause",
        severity: "medium",
        points: 15,
        category: "legal",
      });
    }

    if (
      guarantorLiability.includes("direct") ||
      guarantorLiability.includes("recovery") ||
      liability.includes("direct recovery")
    ) {
      flags.push({
        rule: "Direct legal recovery clause",
        severity: "high",
        points: 25,
        category: "legal",
      });
    }
  }

  // ===== HIRE PURCHASE RULES (from CLAUDE.md) =====
  if (type.includes("hire") || type.includes("purchase")) {
    const repo = (clauses.repossession_clause || "").toLowerCase();
    if (repo.includes("immediate")) {
      flags.push({
        rule: "Immediate repossession clause",
        severity: "high",
        points: 25,
        category: "legal",
      });
    }

    const interestRate = parsePercentage(clauses.interest_rate || "");
    if (interestRate !== null && interestRate > 12) {
      flags.push({
        rule: "Hire purchase interest > 12%",
        severity: "medium",
        points: 15,
        category: "financial",
      });
    }

    const balloon = (clauses.balloon_payment || "").toLowerCase();
    if (
      balloon &&
      !balloon.includes("not applicable") &&
      !balloon.includes("none")
    ) {
      flags.push({
        rule: "Balloon payment clause",
        severity: "high",
        points: 25,
        category: "financial",
      });
    }

    const insurance = (clauses.insurance_requirement || "").toLowerCase();
    if (insurance.includes("mandatory") || insurance.includes("required")) {
      flags.push({
        rule: "Mandatory expensive insurance",
        severity: "medium",
        points: 15,
        category: "financial",
      });
    }
  }

  return flags;
}

export function calculateRiskScores(
  clauses: ExtractedClauses,
  agreementType: string,
): RiskScores {
  const flags = detectRiskFlags(clauses, agreementType);

  let legalScore = 0;
  let financialScore = 0;
  let povertyScore = 0;

  for (const flag of flags) {
    if (flag.category === "legal") {
      legalScore += flag.points;
    } else if (flag.category === "financial") {
      financialScore += flag.points;
    }
    // Poverty vulnerability increases with both legal and financial risk
    povertyScore += Math.round(flag.points * 0.8);
  }

  // Cap scores at 100
  legalScore = Math.min(legalScore, 100);
  financialScore = Math.min(financialScore, 100);
  povertyScore = Math.min(povertyScore, 100);

  const overallScore = Math.round(
    (legalScore + financialScore + povertyScore) / 3,
  );

  const riskLevel =
    overallScore <= 30 ? "Low" : overallScore <= 60 ? "Medium" : "High";

  return {
    legal_risk_score: legalScore,
    financial_burden_score: financialScore,
    poverty_vulnerability_score: povertyScore,
    overall_risk_score: overallScore,
    risk_level: riskLevel,
  };
}
