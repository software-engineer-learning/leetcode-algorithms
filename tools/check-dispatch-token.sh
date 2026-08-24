#!/usr/bin/env bash
#
# Check the SITE_DISPATCH_TOKEN used by .github/workflows/gitbook.yml.
#
# That workflow ends by POSTing a `content-updated` repository_dispatch to
# software-engineer-learning/swe-site, which is what swe-site's deploy.yml
# listens for. Only that workflow rebuilds swe.springlee.dev: it clones all four
# content repos, runs mkdocs, and uploads the result to Cloudflare Pages.
#
# The token is read from the SITE_DISPATCH_TOKEN environment variable, or
# prompted for. It is deliberately NOT taken as an argument, so it stays out of
# shell history and out of `ps` output.
#
#   ./tools/check-dispatch-token.sh          # permission checks only, no deploy
#   ./tools/check-dispatch-token.sh --fire   # actually trigger a rebuild
#
set -uo pipefail

cd "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

TARGET_REPO="software-engineer-learning/swe-site"
API="https://api.github.com"

FIRE=0
case "${1:-}" in
  --fire) FIRE=1 ;;
  -h|--help) sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  "") ;;
  *) echo "unknown argument: $1" >&2; exit 2 ;;
esac

if [ -z "${SITE_DISPATCH_TOKEN:-}" ]; then
  printf 'SITE_DISPATCH_TOKEN (input hidden): ' >&2
  read -rs SITE_DISPATCH_TOKEN
  printf '\n' >&2
fi
if [ -z "${SITE_DISPATCH_TOKEN:-}" ]; then
  echo "No token given." >&2
  exit 2
fi

gh_api() { # method path [data] -> prints body to $body, returns status in $code
  local method="$1" path="$2" data="${3:-}"
  body="$(mktemp)"
  if [ -n "$data" ]; then
    code="$(curl -sS -X "$method" -o "$body" -w '%{http_code}' \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${SITE_DISPATCH_TOKEN}" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "${API}${path}" -d "$data")"
  else
    code="$(curl -sS -X "$method" -o "$body" -w '%{http_code}' \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${SITE_DISPATCH_TOKEN}" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "${API}${path}")"
  fi
}

hr() { printf '\n%s\n' "$1"; }
verdict=0

hr "1. Does the token look intact?"
len=${#SITE_DISPATCH_TOKEN}
echo "   Length: $len characters"
case "$SITE_DISPATCH_TOKEN" in
  ghp_*) echo "   Classic personal access token (ghp_). Needs the 'repo' scope." ;;
  github_pat_*)
    echo "   Fine-grained personal access token (github_pat_). Needs 'Contents:"
    echo "   read and write' on ${TARGET_REPO}, AND the organisation must allow"
    echo "   fine-grained tokens (Org settings -> Personal access tokens)." ;;
  ghs_*) echo "   GitHub App installation token (ghs_). Fine if the app has Contents: write." ;;
  *)
    echo "   -> Unrecognised prefix. Copy the whole token; it was probably truncated."
    verdict=1 ;;
esac
case "$SITE_DISPATCH_TOKEN" in
  *[[:space:]]*)
    echo "   -> The value contains whitespace, which usually means a stray newline"
    echo "      was included when the secret was saved."
    verdict=1 ;;
esac

hr "2. Does GitHub accept the token at all?"
gh_api GET /user
if [ "$code" = "200" ]; then
  echo "   Authenticated as: $(sed -n 's/.*"login"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$body" | head -1)"
else
  echo "   HTTP $code — GitHub rejected the token."
  sed 's/^/     /' "$body"; echo
  echo "   -> Regenerate it and update the SITE_DISPATCH_TOKEN secret."
  rm -f "$body"
  hr "Verdict"; echo "Fix the problems above, then re-run."
  exit 1
fi
rm -f "$body"

hr "3. Can it write to ${TARGET_REPO}?"
gh_api GET "/repos/${TARGET_REPO}"
case "$code" in
  200)
    if grep -q '"push"[[:space:]]*:[[:space:]]*true' "$body"; then
      echo "   Yes — the token has push (write) access, which is what"
      echo "   repository_dispatch requires."
    else
      echo "   -> The token can read ${TARGET_REPO} but not write to it."
      echo "      Classic PAT: add the 'repo' scope."
      echo "      Fine-grained PAT: grant 'Contents: read and write' on that repo."
      verdict=1
    fi ;;
  404)
    echo "   -> 404. GitHub returns 404 rather than 403 when a token cannot see a"
    echo "      repository at all. Check the token's repository access, and that"
    echo "      the org allows the token type."
    verdict=1 ;;
  *)
    echo "   HTTP $code"
    sed 's/^/     /' "$body"; echo
    verdict=1 ;;
esac
rm -f "$body"

hr "4. Firing the dispatch"
if [ "$FIRE" -eq 1 ]; then
  gh_api POST "/repos/${TARGET_REPO}/dispatches" \
    '{"event_type":"content-updated","client_payload":{"repo":"leetcode-algorithms","source":"check-dispatch-token.sh"}}'
  echo "   HTTP $code"
  if [ "$code" = "204" ]; then
    echo "   SUCCESS — swe-site is rebuilding."
    echo "   Watch it: https://github.com/${TARGET_REPO}/actions"
  else
    sed 's/^/     /' "$body"; echo
    echo "   A 422 means swe-site's deploy.yml no longer listens for the"
    echo "   'content-updated' event type."
    verdict=1
  fi
  rm -f "$body"
else
  echo "   Skipped — this triggers a real deployment."
  echo "   Re-run with --fire to test it for real."
fi

hr "Verdict"
if [ "$verdict" -eq 0 ] && [ "$FIRE" -eq 1 ]; then
  echo "Dispatch works. Store this exact value as the SITE_DISPATCH_TOKEN secret"
  echo "(organisation-level, so every content repo picks it up)."
elif [ "$verdict" -eq 0 ]; then
  echo "Token and permissions look right. Only --fire can confirm the dispatch"
  echo "actually reaches swe-site's deploy.yml."
else
  echo "Fix the problems above, then re-run."
fi
exit "$verdict"
