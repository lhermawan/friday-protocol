#!/usr/bin/env node

/**
 * FRIDAY-PROTOCOL v2.2.0: Zero-Dependency Security Findings Validator
 * Validates findings.json against the report-schema standards.
 */

const fs = require('node:fs');
const path = require('node:path');

function validateFindings(filePath) {
  if (!fs.existsSync(filePath)) {
    console.error(`❌ Error: Findings file not found at: ${filePath}`);
    process.exit(1);
  }

  let data;
  try {
    const raw = fs.readFileSync(filePath, 'utf-8');
    data = JSON.parse(raw);
  } catch (err) {
    console.error(`❌ Error parsing JSON: ${err.message}`);
    process.exit(1);
  }

  const errors = [];

  // Top-level checks
  const requiredTop = ['protocol_version', 'generated_at', 'audit_target', 'summary', 'findings'];
  for (const field of requiredTop) {
    if (!data[field]) {
      errors.push(`Missing top-level required field: '${field}'`);
    }
  }

  if (!Array.isArray(data.findings)) {
    errors.push(`Field 'findings' must be an Array.`);
    data.findings = [];
  }

  let countConfirmed = 0;
  let countNeedsValidation = 0;
  let countRejected = 0;

  data.findings.forEach((finding, index) => {
    const prefix = `findings[${index}] (ID: ${finding.id || 'UNKNOWN'})`;

    if (!finding.id || !/^FIND-[0-9]{3,}$/.test(finding.id)) {
      errors.push(`${prefix}: 'id' must follow pattern ^FIND-[0-9]{3,}$ (e.g. FIND-001)`);
    }
    if (!finding.fingerprint) {
      errors.push(`${prefix}: Missing 'fingerprint'`);
    }
    if (!finding.title) {
      errors.push(`${prefix}: Missing 'title'`);
    }
    if (!['confirmed', 'needs_validation', 'rejected'].includes(finding.verdict)) {
      errors.push(`${prefix}: Invalid verdict '${finding.verdict}'. Must be confirmed, needs_validation, or rejected.`);
    }
    if (!finding.attack_class) {
      errors.push(`${prefix}: Missing 'attack_class'`);
    }
    if (!Array.isArray(finding.source_trace) || finding.source_trace.length === 0) {
      errors.push(`${prefix}: 'source_trace' must be a non-empty array`);
    }

    if (finding.verdict === 'confirmed') {
      countConfirmed++;
      if (!finding.severity) {
        errors.push(`${prefix}: Confirmed findings must declare 'severity' (CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL)`);
      }
      if (!finding.observed_impact) {
        errors.push(`${prefix}: Confirmed findings must describe 'observed_impact'`);
      }
      if (!finding.remediation) {
        errors.push(`${prefix}: Confirmed findings must provide a 'remediation' recommendation`);
      }
    } else if (finding.verdict === 'needs_validation') {
      countNeedsValidation++;
      if (!finding.missing_fact) {
        errors.push(`${prefix}: Needs_validation findings must specify the exact 'missing_fact'`);
      }
      if (!finding.validation_plan) {
        errors.push(`${prefix}: Needs_validation findings must provide a safe 'validation_plan'`);
      }
    } else if (finding.verdict === 'rejected') {
      countRejected++;
      if (!finding.rejection_reason) {
        errors.push(`${prefix}: Rejected findings must specify 'rejection_reason' (proof of disprover)`);
      }
      if (!finding.mitigating_control) {
        errors.push(`${prefix}: Rejected findings must state the existing 'mitigating_control'`);
      }
    }
  });

  // Summary reconciliation
  if (data.summary) {
    if (data.summary.confirmed !== countConfirmed) {
      errors.push(`Summary mismatch: confirmed count (${data.summary.confirmed}) does not match findings (${countConfirmed})`);
    }
    if (data.summary.needs_validation !== countNeedsValidation) {
      errors.push(`Summary mismatch: needs_validation count (${data.summary.needs_validation}) does not match findings (${countNeedsValidation})`);
    }
    if (data.summary.rejected !== countRejected) {
      errors.push(`Summary mismatch: rejected count (${data.summary.rejected}) does not match findings (${countRejected})`);
    }
  }

  if (errors.length > 0) {
    console.error(`\n❌ Validation Failed with ${errors.length} error(s):`);
    errors.forEach(e => console.error(`  - ${e}`));
    process.exit(1);
  }

  console.log(`\n✅ Findings Validation Passed!`);
  console.log(`  📊 Target: ${data.audit_target}`);
  console.log(`  🛡️ Protocol: FRIDAY-PROTOCOL v${data.protocol_version}`);
  console.log(`  🎯 Summary: ${countConfirmed} confirmed | ${countNeedsValidation} needs_validation | ${countRejected} rejected`);
}

const targetFile = process.argv[2] || path.join(process.cwd(), '.friday', 'audit', 'findings.json');
validateFindings(targetFile);
