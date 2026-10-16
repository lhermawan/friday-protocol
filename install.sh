#!/usr/bin/env bash
# FRIDAY-PROTOCOL Multi-Platform Interactive Installer (Linux / macOS)
# Author: Lucky Hermawan & FRIDAY

set -e

echo ""
echo -e "\033[0;36m==========================================================================\033[0m"
echo -e "\033[0;32m  🛡️  FRIDAY-PROTOCOL: Spec-Driven DevSecOps Governance for AI Agents\033[0m"
echo -e "\033[1;33m  Version 1.0.0 | Open-Source Edition by Lucky Hermawan & FRIDAY\033[0m"
echo -e "\033[0;36m==========================================================================\033[0m"
echo ""

# 1. Target Environment
echo -e "\033[1m[1/3] Select Target Agent Environment:\033[0m"
echo "  1) Antigravity / Gemini CLI"
echo "  2) Claude Code"
echo "  3) Cursor / Windsurf"
echo "  4) Universal (All Platforms)"
read -rp "Enter choice [1-4] (default: 4): " envChoice
envChoice=${envChoice:-4}

# 2. Scope
echo -e "\n\033[1m[2/3] Select Installation Scope:\033[0m"
echo "  1) Global (Applies to all projects on this machine)"
echo "  2) Workspace (Current directory only)"
read -rp "Enter choice [1-2] (default: 1): " scopeChoice
scopeChoice=${scopeChoice:-1}

# 3. Cognitive Second Brain Mode
echo -e "\n\033[1m[3/3] Cognitive Second Brain Integration:\033[0m"
echo "  Do you have a Cognitive Second Brain (e.g. MemoriaGraph / MCP Memory Graph)?"
read -rp "Enable Cognitive Mode? [y/N] (default: N): " hasBrain
hasBrain=${hasBrain:-N}

isCognitive=false
if [[ "$hasBrain" =~ ^[Yy]$ ]]; then
    isCognitive=true
fi

echo -e "\n\033[0;36m>>> Configuring FRIDAY-PROTOCOL ($( [ "$isCognitive" = true ] && echo "Cognitive Mode" || echo "Standalone DevSecOps Mode" ))...\033[0m"

RULE_SNIPPET=$(cat << 'EOF'

<!-- BEGIN FRIDAY-PROTOCOL (AUTO-INJECTED) -->
# 🛡️ FRIDAY-PROTOCOL: PRIMARY GOVERNANCE LAW
All engineering tasks, feature additions, coding, refactors, and system modifications MUST 100% strictly adhere to this protocol:

## 1. THE 5 IRON LAWS
1. **Law of Deliberation:** The AI is strictly FORBIDDEN from generating or modifying any code before an Implementation Plan is explicitly approved by the User.
2. **Law of 6D Lifecycle Matrix:** Must map the entire feature journey across all 6 dimensions (*Source -> Runtime State -> Persistence -> Downstream Consumers -> Security/RBAC -> Failure Modes*).
3. **Law of Security-First:** SAST and multi-role access control checks must pass BEFORE functional UAT to eliminate regression loops.
4. **Law of Empirical Proof:** Never declare completion without objective proof (exit code 0, HTTP 200 OK, terminal logs).
5. **Law of Deliberate Execution:** Audit all architectural decisions and verified solutions before declaring sign-off.

## 2. HARD ANTI-BYPASS LOCK (ALWAYS-PROCEED PROOF)
Even if 'Always Proceed', auto-approval, or YOLO mode is enabled:
- **Zero-Tool Turn Termination:** Once the Implementation Plan is drafted, the agent MUST CALL ZERO TOOLS and immediately terminate its turn.
- **Semantic Approval Token:** Code editing tools are programmatically locked until the User explicitly submits an approval token: `['OKE', 'Proceed', 'Lanjut', 'Approve', 'Yes']`.
- Any code generation prior to receiving this token is an existential protocol violation.

## 3. THE 8-PHASE EXECUTION PIPELINE
- **Fast-Path (Q&A / Info / Status):** Answer directly, concisely, without plan bureaucracy.
- **Execution-Path (Feature / Coding / Config / Fix):**
  1. *Phase 1 (Intent Analysis):* Analyze scope and requirements.
  2. *Phase 2 (6D Lifecycle Planning):* Create Implementation Plan detailing all 6 dimensions.
  3. *Phase 3 (The Iron Gate):* ZERO TOOLS. Halt turn. Await User approval token.
  4. *Phase 4 (Blueprint Recap):* Summarize confirmed files and execution scope.
  5. *Phase 5 (Clean Implementation):* Write minimal, secure, surgical code.
  6. *Phase 6 (SAST & Security Gate):* Audit OWASP Top 10, BFLA, channel isolation, and least privilege. Patch vulnerabilities immediately.
  7. *Phase 7 (Empirical UAT):* Verify full chain (Preview -> Save -> Downstream Export) + anti-regression + multi-role check. Gather terminal proof.
  8. *Phase 8 (Completion & Sign-off):* Present evidence-backed summary with exit codes and execution logs.
<!-- END FRIDAY-PROTOCOL -->
EOF
)

inject_rule() {
    local target="$1"
    local dir
    dir="$(dirname "$target")"
    mkdir -p "$dir"
    
    if [ -f "$target" ]; then
        if grep -q "<!-- BEGIN FRIDAY-PROTOCOL" "$target"; then
            # Replace existing block
            sed -i '/<!-- BEGIN FRIDAY-PROTOCOL/,/<!-- END FRIDAY-PROTOCOL -->/d' "$target"
            echo "$RULE_SNIPPET" >> "$target"
            echo -e "  \033[0;32m[UPDATED]\033[0m $target"
        else
            # Prepend
            local tmp
            tmp=$(mktemp)
            echo "$RULE_SNIPPET" > "$tmp"
            cat "$target" >> "$tmp"
            mv "$tmp" "$target"
            echo -e "  \033[0;32m[INJECTED]\033[0m $target"
        fi
    else
        echo "$RULE_SNIPPET" > "$target"
        echo -e "  \033[0;32m[CREATED]\033[0m $target"
    fi
}

# Apply targets
if [ "$envChoice" -eq 1 ] || [ "$envChoice" -eq 4 ]; then
    [ "$scopeChoice" -eq 1 ] && target="$HOME/.gemini/config/rules/GEMINI.md" || target="./.agents/rules/GEMINI.md"
    inject_rule "$target"
fi

if [ "$envChoice" -eq 2 ] || [ "$envChoice" -eq 4 ]; then
    [ "$scopeChoice" -eq 1 ] && target="$HOME/.claude/CLAUDE.md" || target="./CLAUDE.md"
    inject_rule "$target"
fi

if [ "$envChoice" -eq 3 ] || [ "$envChoice" -eq 4 ]; then
    [ "$scopeChoice" -eq 1 ] && target="$HOME/.cursorrules" || target="./.cursorrules"
    inject_rule "$target"
fi

echo ""
echo -e "\033[0;32m==========================================================================\033[0m"
echo -e "\033[0;32m  🎉 FRIDAY-PROTOCOL Successfully Installed!\033[0m"
echo -e "\033[1;33m  Your AI agent is now governed by the 5 Iron Laws & The Iron Gate.\033[0m"
echo -e "\033[0;36m  Next time your agent runs, it will pause for your plan approval!\033[0m"
echo -e "\033[0;32m==========================================================================\033[0m"
echo ""
