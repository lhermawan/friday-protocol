#!/usr/bin/env bash
# ==============================================================================
# 🛡️ FRIDAY-PROTOCOL: One-Line OWASP ZAP Baseline DAST Runner
# Standard: BSSN Day 4 Application Security Testing
# ==============================================================================

set -e

TARGET_URL="${1:-http://localhost:8000}"
REPORT_FILE="${2:-zap-baseline-report.html}"
OUTPUT_DIR="$(pwd)/reports/security"

mkdir -p "$OUTPUT_DIR"

echo "===================================================================="
echo "🛡️ FRIDAY-PROTOCOL DAST Scanner (OWASP ZAP Baseline)"
echo "Target  : $TARGET_URL"
echo "Report  : $OUTPUT_DIR/$REPORT_FILE"
echo "===================================================================="

# Translate localhost to host.docker.internal when scanning host machine from Docker
DOCKER_TARGET="$TARGET_URL"
if [[ "$TARGET_URL" == *"localhost"* || "$TARGET_URL" == *"127.0.0.1"* ]]; then
  DOCKER_TARGET=$(echo "$TARGET_URL" | sed 's/localhost/host.docker.internal/g; s/127.0.0.1/host.docker.internal/g')
fi

docker run --rm \
  -v "$OUTPUT_DIR:/zap/wrk/:rw" \
  --add-host=host.docker.internal:host-gateway \
  zaproxy/zap-stable \
  zap-baseline.py -t "$DOCKER_TARGET" -r "$REPORT_FILE" -I

echo "===================================================================="
echo "✅ DAST Scan Completed! Report saved to $OUTPUT_DIR/$REPORT_FILE"
echo "===================================================================="
