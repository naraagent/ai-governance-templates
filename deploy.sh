#!/bin/bash
# AI Governance Templates — Deployment Script
# Usage: ./deploy.sh --profile <profile> --repo <path>
# Deploys AGENTS.md + .kiro/ configuration to target repository

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE=""
REPO_PATH=""
FORCE=false

usage() {
    echo "Usage: $0 --profile <profile> --repo <path> [--force]"
    echo ""
    echo "Profiles: generic, eks-nodejs, frontend-react, terraform-module, lambda-python"
    echo ""
    echo "Options:"
    echo "  --profile    Profile to deploy"
    echo "  --repo       Target repository path"
    echo "  --force      Overwrite existing files"
    echo ""
    echo "Example:"
    echo "  $0 --profile eks-nodejs --repo /path/to/my-service"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --profile) PROFILE="$2"; shift 2 ;;
        --repo) REPO_PATH="$2"; shift 2 ;;
        --force) FORCE=true; shift ;;
        *) usage ;;
    esac
done

if [[ -z "$PROFILE" || -z "$REPO_PATH" ]]; then
    usage
fi

PROFILE_DIR="${SCRIPT_DIR}/profiles/${PROFILE}"

if [[ ! -d "$PROFILE_DIR" ]]; then
    echo "ERROR: Profile '${PROFILE}' not found at ${PROFILE_DIR}"
    echo "Available profiles:"
    ls -1 "${SCRIPT_DIR}/profiles/"
    exit 1
fi

if [[ ! -d "$REPO_PATH" ]]; then
    echo "ERROR: Repository path '${REPO_PATH}' does not exist"
    exit 1
fi

echo "╔══════════════════════════════════════════╗"
echo "║  AI Governance Templates — Deploy        ║"
echo "╠══════════════════════════════════════════╣"
echo "║  Profile: ${PROFILE}"
echo "║  Target:  ${REPO_PATH}"
echo "╚══════════════════════════════════════════╝"
echo ""

# Deploy AGENTS.md
AGENTS_SRC="${PROFILE_DIR}/AGENTS.md"
AGENTS_DST="${REPO_PATH}/AGENTS.md"

if [[ -f "$AGENTS_SRC" ]]; then
    if [[ -f "$AGENTS_DST" && "$FORCE" != true ]]; then
        echo "⚠️  AGENTS.md already exists (use --force to overwrite)"
    else
        cp "$AGENTS_SRC" "$AGENTS_DST"
        echo "✅ Deployed AGENTS.md"
    fi
fi

# Deploy .kiro/ directory
KIRO_SRC="${PROFILE_DIR}/.kiro"
KIRO_DST="${REPO_PATH}/.kiro"

if [[ -d "$KIRO_SRC" ]]; then
    if [[ -d "$KIRO_DST" && "$FORCE" != true ]]; then
        echo "⚠️  .kiro/ directory already exists — merging new files only"
        # Copy only files that don't exist
        find "$KIRO_SRC" -type f | while read -r src_file; do
            rel_path="${src_file#$KIRO_SRC/}"
            dst_file="${KIRO_DST}/${rel_path}"
            if [[ ! -f "$dst_file" ]]; then
                mkdir -p "$(dirname "$dst_file")"
                cp "$src_file" "$dst_file"
                echo "  ✅ Added .kiro/${rel_path}"
            else
                echo "  ⏭️  Skipped .kiro/${rel_path} (exists)"
            fi
        done
    else
        mkdir -p "$KIRO_DST"
        cp -r "$KIRO_SRC/"* "$KIRO_DST/"
        echo "✅ Deployed .kiro/ directory"
    fi
fi

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "Next steps:"
echo "  1. Review deployed files in ${REPO_PATH}"
echo "  2. Customize AGENTS.md with service-specific details"
echo "  3. Commit: git add AGENTS.md .kiro/ && git commit -m 'chore: add AI governance templates'"
echo "  4. Push to develop branch"
