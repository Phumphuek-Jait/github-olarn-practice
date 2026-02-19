#!/bin/sh
# ==========================================
# INT142 - test.sh (Contributor Submission Checker)
# - Does NOT check "Required files"
# - Checks content, commit keywords, reflog evidence
# - Checks commit author name + email (strict)
# Total: 100 points
# ==========================================

# ---------------- CONFIG ----------------
# Expected commit author name format:
#   Firstname Lastname (Github-Practice)
# Example:
#   EXPECTED_NAME="John Smith (Github-Practice)"
EXPECTED_NAME="FIRSTNAME LASTNAME (Github-Practice)"

# Expected GitHub private email (exact match).
# Example:
#   EXPECTED_EMAIL="12345678+username@users.noreply.github.com"
EXPECTED_EMAIL="YOUR_PRIVATE_GITHUB_EMAIL@users.noreply.github.com"

# How many latest commits to validate author identity (excluding bots).
# Set 0 to check ALL commits (may be slow on large repos).
CHECK_LAST_N_COMMITS=50

# Commit message keywords required
KW_FEATURE="Feature: Update index.html content"
KW_CONFLICT="Conflict: Modify same line in index.html"
KW_MERGE="Merge: Resolve conflict on index.html"
KW_RECOVERY="Recovery: Restore previous state"
KW_HISTORY="History: Reorganize commits"
KW_EVIDENCE="Evidence: Add reflog records"

# Minimal content checks
INDEX_MUST_HAVE_1="Feature Section"
INDEX_MUST_HAVE_2="Conflict Simulation"
INDEX_MUST_HAVE_3="Automated Update Section"

COLLAB_MUST_HAVE_1="## Owner"
COLLAB_MUST_HAVE_2="## Collaborator"
COLLAB_OWNER_BULLET_MIN=1

# Require reflog evidence from contributor
REQUIRE_REFLOG=1
# ----------------------------------------

TOTAL=0
FAILED=0

sep(){ printf "\n--------------------------------------------\n"; }
pass(){ echo "✅ $1"; }
fail(){ echo "❌ $1"; FAILED=1; }

add(){ TOTAL=$((TOTAL + $1)); }

have_file(){ [ -f "$1" ]; }
have_dir(){ [ -d "$1" ]; }

has_text(){ grep -Fq "$2" "$1" 2>/dev/null; }

has_commit_subject(){ git log --format='%s' 2>/dev/null | grep -Fq "$1"; }

require_repo_root(){
  if [ ! -d ".git" ]; then
    fail "Not a git repository (missing .git). Run at repo root."
    exit 1
  fi
}

validate_expected_config(){
  sep
  echo "0) Config validation (0 pts)"
  if [ "$EXPECTED_NAME" = "FIRSTNAME LASTNAME (Github-Practice)" ]; then
    fail "EXPECTED_NAME is not set. Edit test.sh and set EXPECTED_NAME."
  else
    pass "EXPECTED_NAME is set"
  fi

  if [ "$EXPECTED_EMAIL" = "YOUR_PRIVATE_GITHUB_EMAIL@users.noreply.github.com" ]; then
    fail "EXPECTED_EMAIL is not set. Edit test.sh and set EXPECTED_EMAIL."
  else
    pass "EXPECTED_EMAIL is set"
  fi
}

# ----------------------------
# 1) index.html content (25)
# ----------------------------
score_index_content(){
  sep
  echo "1) index.html content structure (25 pts)"
  P=0

  if ! have_file "index.html"; then
    fail "index.html missing; cannot check"
    add 0
    return
  fi

  if has_text "index.html" "$INDEX_MUST_HAVE_1"; then pass "Found: $INDEX_MUST_HAVE_1"; P=$((P+9)); else fail "Missing: $INDEX_MUST_HAVE_1"; fi
  if has_text "index.html" "$INDEX_MUST_HAVE_2"; then pass "Found: $INDEX_MUST_HAVE_2"; P=$((P+9)); else fail "Missing: $INDEX_MUST_HAVE_2"; fi
  if has_text "index.html" "$INDEX_MUST_HAVE_3"; then pass "Found: $INDEX_MUST_HAVE_3"; P=$((P+7)); else fail "Missing: $INDEX_MUST_HAVE_3"; fi

  add "$P"
  echo "Score: $P/25"
}

# ---------------------------------
# 2) COLLABORATORS.md format (20)
# ---------------------------------
score_collab_content(){
  sep
  echo "2) COLLABORATORS.md format (20 pts)"
  P=0

  if ! have_file "COLLABORATORS.md"; then
    fail "COLLABORATORS.md missing; cannot check"
    add 0
    return
  fi

  if has_text "COLLABORATORS.md" "$COLLAB_MUST_HAVE_1"; then pass "Found: $COLLAB_MUST_HAVE_1"; P=$((P+8)); else fail "Missing heading: $COLLAB_MUST_HAVE_1"; fi
  if has_text "COLLABORATORS.md" "$COLLAB_MUST_HAVE_2"; then pass "Found: $COLLAB_MUST_HAVE_2"; P=$((P+8)); else fail "Missing heading: $COLLAB_MUST_HAVE_2"; fi

  # Heuristic: count bullets within 3 lines after "## Owner"
  OWNER_BULLETS=$(grep -n "## Owner" -A 5 "COLLABORATORS.md" 2>/dev/null | grep -E "^-|^\*|^•" | wc -l | tr -d ' ')
  if [ "$OWNER_BULLETS" -ge "$COLLAB_OWNER_BULLET_MIN" ]; then
    pass "Owner section has entries ($OWNER_BULLETS)"
    P=$((P+4))
  else
    fail "Owner section looks empty (add at least one bullet under Owner)"
  fi

  add "$P"
  echo "Score: $P/20"
}

# -----------------------------------------
# 3) Commit message keywords present (25)
# -----------------------------------------
score_commit_keywords(){
  sep
  echo "3) Commit message keywords (25 pts)"
  P=0

  if has_commit_subject "$KW_FEATURE"; then pass "Found commit: $KW_FEATURE"; P=$((P+5)); else fail "Missing commit: $KW_FEATURE"; fi
  if has_commit_subject "$KW_CONFLICT"; then pass "Found commit: $KW_CONFLICT"; P=$((P+5)); else fail "Missing commit: $KW_CONFLICT"; fi
  if has_commit_subject "$KW_MERGE"; then pass "Found commit: $KW_MERGE"; P=$((P+5)); else fail "Missing commit: $KW_MERGE"; fi
  if has_commit_subject "$KW_RECOVERY"; then pass "Found commit: $KW_RECOVERY"; P=$((P+4)); else fail "Missing commit: $KW_RECOVERY"; fi
  if has_commit_subject "$KW_HISTORY"; then pass "Found commit: $KW_HISTORY"; P=$((P+4)); else fail "Missing commit: $KW_HISTORY"; fi

  if [ "$REQUIRE_REFLOG" -eq 1 ]; then
    if has_commit_subject "$KW_EVIDENCE"; then pass "Found commit: $KW_EVIDENCE"; P=$((P+2)); else fail "Missing commit: $KW_EVIDENCE"; fi
  else
    pass "Evidence commit not required"
    P=$((P+2))
  fi

  add "$P"
  echo "Score: $P/25"
}

# -----------------------------------------
# 4) Reflog evidence files (10)
# -----------------------------------------
score_reflog_evidence(){
  sep
  echo "4) Reflog evidence (10 pts)"
  P=0

  if [ "$REQUIRE_REFLOG" -ne 1 ]; then
    pass "Reflog not required"
    add 10
    echo "Score: 10/10"
    return
  fi

  if ! have_dir "reflog"; then
    fail "reflog/ missing (required)"
    add 0
    return
  fi

  if have_file "reflog/reflog_HEAD.txt"; then pass "reflog/reflog_HEAD.txt exists"; P=$((P+6)); else fail "Missing reflog/reflog_HEAD.txt"; fi

  BRCOUNT=$(ls reflog 2>/dev/null | grep -E "^reflog_.*\.txt$" | grep -v "reflog_HEAD\.txt" | wc -l | tr -d ' ')
  if [ "$BRCOUNT" -ge 1 ]; then pass "Found branch reflog files: $BRCOUNT"; P=$((P+2)); else fail "No branch reflog files found"; fi

  if have_file "reflog/README.md"; then pass "reflog/README.md exists"; P=$((P+2)); else fail "Missing reflog/README.md"; fi

  add "$P"
  echo "Score: $P/10"
}

# -----------------------------------------
# 5) Commit author name + email check (20)
# -----------------------------------------
score_commit_identity(){
  sep
  echo "5) Commit author identity (20 pts)"
  P=0

  # Validate name format (must contain real first+last + suffix)
  # Strictly enforce the expected name string to avoid ambiguity.
  # Also enforce that it ends with " (Github-Practice)".
  echo "$EXPECTED_NAME" | grep -Eq "^[^()]+ [^()]+ \(Github-Practice\)$"
  if [ $? -ne 0 ]; then
    fail "EXPECTED_NAME format invalid. Must be: Firstname Lastname (Github-Practice)"
    add 0
    return
  fi

  # Get commits to check (exclude bots)
  if [ "$CHECK_LAST_N_COMMITS" -gt 0 ]; then
    COMMITS=$(git log -n "$CHECK_LAST_N_COMMITS" --format='%H|%an|%ae' 2>/dev/null | grep -v "github-actions\[bot\]" | grep -v "github-classroom\[bot\]")
  else
    COMMITS=$(git log --format='%H|%an|%ae' 2>/dev/null | grep -v "github-actions\[bot\]" | grep -v "github-classroom\[bot\]")
  fi

  if [ -z "$COMMITS" ]; then
    fail "No commits found to validate (after excluding bots)."
    add 0
    return
  fi

  BAD=0
  COUNT=0

  echo "$COMMITS" | while IFS='|' read -r H AN AE
  do
    COUNT=$((COUNT + 1))
    if [ "$AN" != "$EXPECTED_NAME" ] || [ "$AE" != "$EXPECTED_EMAIL" ]; then
      echo "❌ Commit $H has wrong author:"
      echo "   Author Name : $AN"
      echo "   Author Email: $AE"
      BAD=$((BAD + 1))
    fi
  done

  # The while loop above runs in subshell in many sh implementations.
  # So we re-check with grep-based approach for scoring.

  # Check: any non-bot commit with mismatching name?
  if [ "$CHECK_LAST_N_COMMITS" -gt 0 ]; then
    MISMATCH_NAME=$(git log -n "$CHECK_LAST_N_COMMITS" --format='%an|%ae' 2>/dev/null \
      | grep -v "github-actions\[bot\]" \
      | grep -v "github-classroom\[bot\]" \
      | grep -Fv "$EXPECTED_NAME|$EXPECTED_EMAIL" | wc -l | tr -d ' ')
  else
    MISMATCH_NAME=$(git log --format='%an|%ae' 2>/dev/null \
      | grep -v "github-actions\[bot\]" \
      | grep -v "github-classroom\[bot\]" \
      | grep -Fv "$EXPECTED_NAME|$EXPECTED_EMAIL" | wc -l | tr -d ' ')
  fi

  if [ "$MISMATCH_NAME" -eq 0 ]; then
    pass "All checked (non-bot) commits match author name + private email"
    P=$((P+20))
  else
    fail "Found $MISMATCH_NAME commit(s) with wrong author name/email (must match exactly)"
  fi

  add "$P"
  echo "Score: $P/20"
}

# ---------------- MAIN ----------------
require_repo_root
echo "INT142 Submission Checker (Contributor-side)"
echo "This script checks the contributor's work and identity settings."

validate_expected_config

score_index_content
score_collab_content
score_commit_keywords
score_reflog_evidence
score_commit_identity

sep
echo "Final Score: $TOTAL/100"

if [ "$FAILED" -eq 1 ]; then
  echo "Result: ❌ NEEDS FIXES"
  exit 1
else
  echo "Result: ✅ PASS"
  exit 0
fi
