#!/bin/bash

# ==========================
# Repository Sync Script
# ==========================

set -euo pipefail

REPO_FILE="./repos.list"
BASE_DIR="$HOME/projects"

# Emojis
CLONE="⬇️"
CLONE_SUCCESS="⬇️✅"
CLONE_FAILURE="⬇️❌"
PULL="🔄"
PULL_SUCCESS="🔄✅"
PULL_FAILURE="🔄❌"
DOWNLOAD="📦"
DOWNLOAD_SUCCESS="📦✅"
DOWNLOAD_FAILURE="📦❌"

mkdir -p "$BASE_DIR"

# --------------------------
# Sync Git Repo
# --------------------------
sync_git_repo() {
  local repo_url="$1"
  local target_path="$2"
  local repo_name="$3"
  local repo_dir="$target_path/$repo_name"

  if [ -d "$repo_dir/.git" ]; then
    echo "$PULL Pulling '$repo_name'"
    (cd "$repo_dir" && git pull --rebase --autostash) \
      && echo "$PULL_SUCCESS Updated '$repo_name'" \
      || echo "$PULL_FAILURE Failed to update '$repo_name'"
  else
    echo "$CLONE Cloning '$repo_name'"
    mkdir -p "$target_path"
    git clone "$repo_url" "$repo_dir" \
      && echo "$CLONE_SUCCESS Cloned '$repo_name'" \
      || echo "$CLONE_FAILURE Failed to clone '$repo_name'"
  fi
}

# --------------------------
# Download File
# --------------------------
download_file() {
  local file_url="$1"
  local target_path="$2"
  local folder_name="$3"
  local folder_dir="$target_path/$folder_name"
  local filename

  filename="$(basename "$file_url")"

  mkdir -p "$folder_dir"
  echo "$DOWNLOAD Downloading '$filename'"

  curl -L --fail -o "$folder_dir/$filename" "$file_url" \
    && echo "$DOWNLOAD_SUCCESS Downloaded '$filename'" \
    || echo "$DOWNLOAD_FAILURE Failed to download '$filename'"
}

# --------------------------
# Main Loop
# --------------------------
if [ ! -f "$REPO_FILE" ]; then
  echo "❌ Repository list file not found: $REPO_FILE"
  exit 1
fi

while IFS="|" read -r url target_subdir folder; do
  # Trim whitespace
  url="$(echo "${url:-}" | xargs)"
  target_subdir="$(echo "${target_subdir:-}" | xargs)"
  folder="$(echo "${folder:-}" | xargs)"

  # Skip empty or comment lines
  [ -z "$url" ] && continue
  [[ "$url" == \#* ]] && continue

  # Default folder name
  [ -z "$folder" ] && folder="$(basename "$url" .git)"

  # Target directory
  local_target_dir="$BASE_DIR"
  [ -n "$target_subdir" ] && local_target_dir="$BASE_DIR/$target_subdir"

  echo -e "\n=============================="
  echo "📂 Processing: $folder"
  echo "📁 Target path: $local_target_dir"
  echo "=============================="

  if [[ "$url" == *.git ]]; then
    sync_git_repo "$url" "$local_target_dir" "$folder"
  else
    download_file "$url" "$local_target_dir" "$folder"
  fi
done < "$REPO_FILE"

echo -e "\n✅ All sync operations complete."
