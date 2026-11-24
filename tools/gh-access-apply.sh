#!/bin/bash
# gh-access-apply.sh: apply the access tiers of agent-guidelines policy/access-tiers.md
# to aurora-silicon public product repos. Idempotent. Default is --dry-run; pass --apply to change.
# Needs a gh token with repo + admin:org. Logs every change to $LOG.
set -u
ORG=aurora-silicon
MODE=dry; [ "${1:-}" = "--apply" ] && MODE=apply
ONLY="${2:-}"
LOG=${LOG:-./gh-access-apply-$(date +%Y%m%d-%H%M%S)-$MODE.log}
CORE_ID=20734456; OMARCHY_ID=20734502

# Tiers (verify a repo is live before adding it; see access-tiers.md)
PRODUCT="linux mesa aura m1n1 u-boot aurora-installer aurora-platform aurora-distributions fedora-aurora alarm-aurora nixos-aurora omarchy-aurora speakerguardd alsa-ucm-conf-asahi asahi-audio gpubench agent-guidelines aurora-diag aurora-sep-userspace camera-denoise kbd-light upower xserver pipewire FFmpeg libva-v4l2_request fex macvdmtool tuxvdmtool aurora-bless mil-hwx-compiler splash aurora-steam-native aurora-lily aurora-xart aurora-neo-platform-config avd-fw capture-ns .github aurora-silicon.github.io"
OMARCHY="linux mesa aura m1n1 u-boot aurora-installer alarm-aurora omarchy-aurora aurora-platform speakerguardd alsa-ucm-conf-asahi asahi-audio agent-guidelines gpubench"
# Workflows push to the default branch with GITHUB_TOKEN (cannot bypass rulesets): no branch rulesets yet.
NO_BRANCH_RULES="aurora-distributions fedora-aurora alarm-aurora .github"
# Workflows create release tags with GITHUB_TOKEN: no tag ruleset yet.
NO_TAG_RULES="aurora-installer aurora-distributions fedora-aurora alarm-aurora nixos-aurora omarchy-aurora"
# The 'mergers only' (restrict updates) ruleset makes every merge a bypass click, so it is kept but
# DISABLED (2026-11-24 redesign): the merger gate is code-owner review (CODEOWNERS -> core + omarchy-m).
# Set MERGERS_ENFORCEMENT=active only after the Owners decide to restore it.
MERGERS_ENFORCEMENT=${MERGERS_ENFORCEMENT:-disabled}
# No code-owner review, no last-push/stale rules (Owner decision 2026-11-24, merge train).
NO_CODEOWNER_REVIEW="mesa"
# linux has its own hand-made rulesets (27977956 etc.); only the (disabled) mergers ruleset + core bypass are added.

inlist() { local x=$1; shift; for y in $*; do [ "$x" = "$y" ] && return 0; done; return 1; }
log() { echo "$(date +%H:%M:%S) [$MODE] $*" | tee -a "$LOG"; }
TMP=$(mktemp); trap 'rm -f "$TMP"' EXIT
run() { if [ $MODE = apply ]; then "$@" >"$TMP" 2>&1 || { log "ERROR: $* -> $(head -c 400 "$TMP")"; return 1; }; fi; return 0; }

team_perm() { # repo team perm
  local cur; cur=$(gh api "orgs/$ORG/teams/$2/repos/$ORG/$1" -H 'Accept: application/vnd.github.v3.repository+json' --jq '.role_name' 2>/dev/null) || cur=none
  [ "$cur" = "$3" ] && return
  [ "$3" = "maintain" ] || [ "$3" = "admin" ] || [ "$3" = "push" ] || [ "$3" = "triage" ] || return
  [ "$cur" = "write" ] && [ "$3" = "push" ] && return
  log "$1: team $2 $cur -> $3"
  run gh api -X PUT "orgs/$ORG/teams/$2/repos/$ORG/$1" -f permission="$3"
}

ruleset() { # repo name json
  local id; id=$(gh api "repos/$1/rulesets" --jq ".[]|select(.name==\"$2\")|.id" 2>/dev/null | head -1)
  if [ -z "$id" ]; then log "$1: create ruleset '$2'"; run gh api -X POST "repos/$1/rulesets" --input <(echo "$3")
  else
    local want have; want=$(jq -S '{enforcement,target,conditions,rules,bypass_actors:(.bypass_actors|sort_by(.actor_type,.actor_id))}' <<<"$3")
    # compare only the rule parameters we set (GitHub fills in defaults for the rest)
    have=$(gh api "repos/$1/rulesets/$id" | jq -S --argjson w "$want" '{enforcement,target,conditions,
      rules:[.rules|to_entries[]|.key as $i|.value|(($w.rules[$i].parameters // {})|keys) as $k
        |if ($k|length)==0 then del(.parameters) else .parameters|=with_entries(select(.key as $x|$k|index($x))) end],
      bypass_actors:(.bypass_actors|map({actor_id,actor_type,bypass_mode})|sort_by(.actor_type,.actor_id))}')
    [ "$(jq -cS . <<<"$want")" = "$(jq -cS . <<<"$have")" ] && return
    log "$1: update ruleset $id '$2'"; run gh api -X PUT "repos/$1/rulesets/$id" --input <(echo "$3")
  fi
}

BYPASS_PR_CORE='[{"actor_id":null,"actor_type":"OrganizationAdmin","bypass_mode":"pull_request"},{"actor_id":'$CORE_ID',"actor_type":"Team","bypass_mode":"pull_request"}]'
review_rules() { # $1 = 1: code-owner review + last-push + stale dismiss
  local s=true; [ "${1:-1}" = 0 ] && s=false
  jq -n --argjson b "$BYPASS_PR_CORE" --argjson s $s '{name:"default branch: reviewed PRs",target:"branch",enforcement:"active",
  conditions:{ref_name:{include:["~DEFAULT_BRANCH"],exclude:[]}}, bypass_actors:$b,
  rules:[{type:"deletion"},{type:"non_fast_forward"},{type:"pull_request",parameters:{required_approving_review_count:1,
   dismiss_stale_reviews_on_push:$s,require_code_owner_review:$s,require_last_push_approval:$s,
   required_review_thread_resolution:false}}]}'; }
merger_rules() { # $1 = include omarchy
  local b=$BYPASS_PR_CORE
  [ "$1" = 1 ] && b=$(jq -c --argjson id $OMARCHY_ID '.+[{actor_id:$id,actor_type:"Team",bypass_mode:"pull_request"}]' <<<"$b")
  jq -n --argjson b "$b" --arg en "$MERGERS_ENFORCEMENT" '{name:"default branch: mergers only (Core, Omarchy Mac)",target:"branch",enforcement:$en,
  conditions:{ref_name:{include:["~DEFAULT_BRANCH"],exclude:[]}}, bypass_actors:$b, rules:[{type:"update"}]}'; }
tag_rules() { jq -n '{name:"release tags: v* aurora-* (owners only)",target:"tag",enforcement:"active",
  conditions:{ref_name:{include:["refs/tags/v*","refs/tags/aurora-*"],exclude:[]}},
  bypass_actors:[{actor_id:null,actor_type:"OrganizationAdmin",bypass_mode:"always"}],
  rules:[{type:"creation"},{type:"update"},{type:"deletion"},{type:"non_fast_forward"}]}'; }

log "start (log $LOG)"
for r in $PRODUCT; do
  [ -n "$ONLY" ] && ! inlist $r $ONLY && continue
  vis=$(gh api repos/$ORG/$r --jq '.visibility+" "+(.archived|tostring)')
  [ "$vis" = "public false" ] || { log "$r: SKIP ($vis)"; continue; }
  team_perm $r core admin
  team_perm $r aurora-dev push
  inlist $r $OMARCHY && team_perm $r omarchy-m maintain
  om=0; inlist $r $OMARCHY && om=1
  if [ $r = linux ]; then
    # add Core team (PR-only) to the hand-made trunk ruleset's bypass list
    cur=$(gh api repos/$ORG/linux/rulesets/27977956)
    if ! jq -e ".bypass_actors[]|select(.actor_type==\"Team\" and .actor_id==$CORE_ID)" <<<"$cur" >/dev/null; then
      log "linux: ruleset 27977956 add bypass Team core (pull_request)"
      run gh api -X PUT repos/$ORG/linux/rulesets/27977956 --input <(jq --argjson id $CORE_ID '{bypass_actors:(.bypass_actors|map({actor_id,actor_type,bypass_mode})+[{actor_id:$id,actor_type:"Team",bypass_mode:"pull_request"}])}' <<<"$cur")
    fi
    ruleset $ORG/$r "default branch: mergers only (Core, Omarchy Mac)" "$(merger_rules $om)"
    continue
  fi
  if inlist $r $NO_BRANCH_RULES; then log "$r: branch rulesets DEFERRED (workflow pushes to default branch)"
  else
    co=1; inlist $r $NO_CODEOWNER_REVIEW && co=0
    ruleset $ORG/$r "default branch: reviewed PRs" "$(review_rules $co)"
    ruleset $ORG/$r "default branch: mergers only (Core, Omarchy Mac)" "$(merger_rules $om)"
  fi
  if inlist $r $NO_TAG_RULES; then log "$r: tag ruleset DEFERRED (workflow creates release tags)"
  else ruleset $ORG/$r "release tags: v* aurora-* (owners only)" "$(tag_rules)"; fi
done
log "done"
