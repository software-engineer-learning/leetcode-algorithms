#!/usr/bin/env bash
#
# Diagnose the SITE_DISPATCH_TOKEN used by .github/workflows/gitbook.yml.
#
# That workflow ends by POSTing a repository_dispatch to the swe-site repo so
# swe.springlee.dev rebuilds. When the token is scoped wrong GitHub answers
#
#   403 {"message": "Resource not accessible by personal access token"}
#
# which says nothing about *which* of the two possible mistakes was made. This
# script separates them: whether the repo is missing from the token's
# "Repository access" list, or whether Contents is set to Read instead of
# Read and write.
#
# The token is read from the SITE_DISPATCH_TOKEN environment variable, or
# prompted for silently. It is deliberately NOT taken as an argument, so it
# stays out of shell history and out of `ps` output.
#
#   ./tools/check-dispatch-token.sh                      # read-only checks
#   ./tools/check-dispatch-token.sh --dispatch           # also fire a real deploy
#   ./tools/check-dispatch-token.sh --repo owner/name    # override the target
#
set -uo pipefail

cd "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

WORKFLOW=".github/workflows/gitbook.yml"
REPO=""
DO_DISPATCH=0

while [ $# -gt 0 ]; do
  case "$1" in
    --dispatch) DO_DISPATCH=1; shift ;;
    --repo)     REPO="${2:?--repo needs owner/name}"; shift 2 ;;
    -h|--help)  sed -n '2,25p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)          echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

# Default the target to whatever the workflow actually dispatches to, so the
# two never drift apart.
if [ -z "$REPO" ] && [ -f "$WORKFLOW" ]; then
  REPO="$(sed -n 's|.*api\.github\.com/repos/\([^/]*/[^/]*\)/dispatches.*|\1|p' "$WORKFLOW" | head -1)"
fi
REPO="${REPO:-software-engineer-learning/swe-site}"

if [ -z "${SITE_DISPATCH_TOKEN:-}" ]; then
  printf 'SITE_DISPATCH_TOKEN (input hidden): ' >&2
  read -rs SITE_DISPATCH_TOKEN
  printf '\n' >&2
fi
if [ -z "${SITE_DISPATCH_TOKEN:-}" ]; then
  echo "No token given." >&2
  exit 2
fi

API="https://api.github.com"
auth=(
  -H "Authorization: Bearer ${SITE_DISPATCH_TOKEN}"
  -H "Accept: application/vnd.github+json"
  -H "X-GitHub-Api-Version: 2022-11-28"
)

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

hr() { printf '\n%s\n' "$1"; }
verdict=0

# --- 1. token validity ----------------------------------------------------
hr "1. Is the token valid?"
code="$(curl -sS -o "$tmp/user.json" -D "$tmp/user.h" -w '%{http_code}' "${auth[@]}" "$API/user")"
if [ "$code" != "200" ]; then
  echo "   HTTP $code — the token is invalid, expired, or was saved with stray"
  echo "   whitespace. Re-create it; nothing below will be meaningful."
  sed -n 's/.*"message": *"\([^"]*\)".*/   \1/p' "$tmp/user.json" | head -1
  exit 1
fi
echo "   HTTP 200 — authenticates as: $(sed -n 's/.*"login": *"\([^"]*\)".*/\1/p' "$tmp/user.json" | head -1)"
exp="$(tr -d '\r' < "$tmp/user.h" | sed -n 's/^[Gg]ithub-[Aa]uthentication-[Tt]oken-[Ee]xpiration: *//p')"
[ -n "$exp" ] && echo "   Expires: $exp"

# --- 2. repository access and write permission ----------------------------
hr "2. Can the token reach $REPO, and can it write?"
code="$(curl -sS -o "$tmp/repo.json" -w '%{http_code}' "${auth[@]}" "$API/repos/$REPO")"
case "$code" in
  200)
    private="$(sed -n 's/.*"private": *\(true\|false\).*/\1/p' "$tmp/repo.json" | head -1)"
    echo "   HTTP 200 — repo is in the token's Repository access list ($([ "$private" = true ] && echo private || echo public))."
    perms="$(tr -d ' \n' < "$tmp/repo.json" | sed -n 's/.*"permissions":{\([^}]*\)}.*/\1/p')"
    echo "   Effective permissions: ${perms:-unknown}"
    # CAUTION: this "permissions" object is the ACCOUNT's role on the repo, not
    # the fine-grained token's granted permissions. The repo owner always reads
    # back admin/push=true even when the token only carries Contents: Read.
    # So push:true rules nothing in; push:false rules the token out.
    case "$perms" in
      *'"push":true'*)
        echo "   -> The account can write to the repo."
        echo "      NOTE: this reflects your role on the repo, NOT the token's grants."
        echo "      A token with Contents: Read shows this too, so it does not"
        echo "      confirm the token itself may dispatch. Only step 3 can." ;;
      *)
        echo "   -> The account has no write access to this repo at all."
        verdict=1 ;;
    esac
    ;;
  404)
    echo "   HTTP 404 — the token cannot see this repo at all."
    echo "      Either $REPO is missing from Repository access, or the token's"
    echo "      resource owner is wrong. An organization-owned fine-grained token"
    echo "      can never reach a personal repository, whatever its permissions."
    verdict=1 ;;
  *)
    echo "   HTTP $code"
    head -5 "$tmp/repo.json" | sed 's/^/     /'
    verdict=1 ;;
esac

# --- 3. the dispatch itself -----------------------------------------------
hr "3. The dispatch call"
if [ "$DO_DISPATCH" -eq 1 ]; then
  code="$(curl -sS -X POST -o "$tmp/d.json" -D "$tmp/d.h" -w '%{http_code}' \
    "${auth[@]}" "$API/repos/$REPO/dispatches" -d '{"event_type":"content-updated"}')"
  echo "   HTTP $code"
  if [ "$code" = "204" ]; then
    echo "   SUCCESS — swe-site is rebuilding."
  else
    sed 's/^/     /' "$tmp/d.json"
    verdict=1
  fi
  wanted="$(tr -d '\r' < "$tmp/d.h" | sed -n 's/^[Xx]-[Aa]ccepted-[Gg]ithub-[Pp]ermissions: *//p')"
  [ -n "$wanted" ] && echo "   GitHub says this endpoint requires: $wanted"
else
  echo "   Skipped — this fires a real swe-site deploy."
  echo "   Re-run with --dispatch to test it end to end."
fi

# --- verdict --------------------------------------------------------------
hr "Verdict"
if [ "$verdict" -eq 0 ] && [ "$DO_DISPATCH" -eq 1 ]; then
  echo "Token is correctly scoped for POST /repos/$REPO/dispatches."
elif [ "$verdict" -eq 0 ]; then
  echo "Read-only checks passed, but they CANNOT confirm Contents: Read and write."
  echo "GitHub exposes no read-only view of a fine-grained token's grants, so the"
  echo "dispatch itself is the only conclusive test:"
  echo
  echo "    ./tools/check-dispatch-token.sh --dispatch"
  echo
  echo "  204 -> the token is fine; the 403 in CI means the stored"
  echo "         SITE_DISPATCH_TOKEN secret is a different or stale token."
  echo "  403 -> this token lacks Contents: Read and write. Fix it in the token"
  echo "         settings; the repo-role output above is not evidence otherwise."
else
  echo "A fine-grained PAT needs BOTH of these for POST /repos/$REPO/dispatches:"
  echo "  * Repository access -> $REPO explicitly selected"
  echo "  * Permissions -> Contents: Read and write"
  echo "Step 2 above shows which one is missing."
fi
exit "$verdict"
