#!/usr/bin/env bash
#
# Check the SITE_DEPLOY_HOOK used by .github/workflows/gitbook.yml.
#
# That workflow ends by POSTing to a Cloudflare Pages deploy hook so
# swe.springlee.dev rebuilds. The hook is an unguessable URL that carries no
# auth header: possession of the URL *is* the authorisation. That means there is
# nothing to scope, approve or renew -- but it also means the URL is a secret and
# must never be pasted into a shared log.
#
# The URL is read from the SITE_DEPLOY_HOOK environment variable, or prompted
# for. It is deliberately NOT taken as an argument, so it stays out of shell
# history and out of `ps` output.
#
#   ./tools/check-deploy-hook.sh             # shape checks only, no deploy
#   ./tools/check-deploy-hook.sh --fire      # actually trigger a rebuild
#
set -uo pipefail

cd "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

FIRE=0
case "${1:-}" in
  --fire) FIRE=1 ;;
  -h|--help) sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  "") ;;
  *) echo "unknown argument: $1" >&2; exit 2 ;;
esac

if [ -z "${SITE_DEPLOY_HOOK:-}" ]; then
  printf 'SITE_DEPLOY_HOOK (input hidden): ' >&2
  read -rs SITE_DEPLOY_HOOK
  printf '\n' >&2
fi
if [ -z "${SITE_DEPLOY_HOOK:-}" ]; then
  echo "No URL given." >&2
  exit 2
fi

hr() { printf '\n%s\n' "$1"; }
verdict=0

hr "1. Does the URL look like a Pages deploy hook?"
case "$SITE_DEPLOY_HOOK" in
  https://api.cloudflare.com/client/v4/pages/webhooks/deploy_hooks/*)
    echo "   Yes — matches the Cloudflare Pages deploy hook form." ;;
  http://*)
    echo "   The URL is http, not https. Deploy hooks are always https."
    verdict=1 ;;
  https://*)
    echo "   Reachable URL, but not the usual Pages deploy hook form."
    echo "   Expected https://api.cloudflare.com/client/v4/pages/webhooks/deploy_hooks/<id>"
    echo "   Continuing anyway in case Cloudflare changed the shape." ;;
  *)
    echo "   This does not look like a URL at all. Copy the whole hook URL,"
    echo "   including the https:// prefix."
    verdict=1 ;;
esac

# A truncated paste is the most common way this breaks, and it is easy to spot
# without revealing the secret.
len=${#SITE_DEPLOY_HOOK}
echo "   Length: $len characters"
if [ "$len" -lt 60 ]; then
  echo "   -> Suspiciously short; the value was probably truncated when pasted."
  verdict=1
fi
case "$SITE_DEPLOY_HOOK" in
  *[[:space:]]*)
    echo "   -> The value contains whitespace, which usually means a stray newline"
    echo "      was included when the secret was saved."
    verdict=1 ;;
esac

hr "2. Firing the hook"
if [ "$FIRE" -eq 1 ]; then
  tmp="$(mktemp)"
  trap 'rm -f "$tmp"' EXIT
  code="$(curl -sS -X POST -o "$tmp" -w '%{http_code}' "$SITE_DEPLOY_HOOK")"
  echo "   HTTP $code"
  if [ "$code" = "200" ] && grep -q '"success":[[:space:]]*true' "$tmp"; then
    echo "   SUCCESS — swe-site is rebuilding."
  else
    sed 's/^/     /' "$tmp"; echo
    echo "   A 404 means the hook was deleted or regenerated in the Cloudflare"
    echo "   dashboard; create a new one and update the secret."
    verdict=1
  fi
else
  echo "   Skipped — this triggers a real deployment."
  echo "   Re-run with --fire to test it for real."
fi

hr "Verdict"
if [ "$verdict" -eq 0 ] && [ "$FIRE" -eq 1 ]; then
  echo "Deploy hook works. Store this exact value as the SITE_DEPLOY_HOOK secret"
  echo "in the repository that runs the GitBook workflow."
elif [ "$verdict" -eq 0 ]; then
  echo "URL shape looks right. Only --fire can confirm Cloudflare accepts it."
else
  echo "Fix the problems above, then re-run."
fi
exit "$verdict"
