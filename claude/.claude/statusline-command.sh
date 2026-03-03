#!/usr/bin/env bash

input=$(cat)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

cd "$current_dir" 2>/dev/null

# ---------------------------------------------------------------------------
# Cache setup
# One cache file per project directory, keyed by an md5 of the path.
# TTL: 5 seconds. Expensive operations (git branch, git diff, docker ps) are
# read from cache when fresh, and refreshed in the background when stale so
# the status line never blocks waiting for slow commands.
# ---------------------------------------------------------------------------
cache_dir="/tmp/claude-statusline-cache"
mkdir -p "$cache_dir"
dir_key=$(echo "$current_dir" | md5 2>/dev/null || echo "$current_dir" | md5sum 2>/dev/null | cut -d' ' -f1)
cache_file="${cache_dir}/${dir_key}.cache"
cache_ttl=5  # seconds

cache_fresh=0
if [ -f "$cache_file" ]; then
  # find returns the file if it was modified within the last $cache_ttl seconds
  if [ -n "$(find "$cache_file" -mtime -${cache_ttl}s 2>/dev/null)" ]; then
    cache_fresh=1
  fi
fi

cache_get() {
  # Usage: cache_get KEY
  # Reads a value from KEY=VALUE lines in the cache file
  grep -m1 "^${1}=" "$cache_file" 2>/dev/null | cut -d'=' -f2-
}

cache_set() {
  # Usage: cache_set KEY VALUE
  # Atomically writes/updates a key in the cache file
  local key="$1" value="$2" tmp
  tmp="${cache_file}.tmp"
  # Remove existing key line, append updated value
  { grep -v "^${key}=" "$cache_file" 2>/dev/null; printf '%s=%s\n' "$key" "$value"; } > "$tmp"
  mv -f "$tmp" "$cache_file"
}

# ---------------------------------------------------------------------------
# Git branch (cached)
# ---------------------------------------------------------------------------
if [ "$cache_fresh" = "1" ]; then
  branch=$(cache_get branch)
  [ -z "$branch" ] && branch="no-git"
else
  branch=$(git branch --show-current 2>/dev/null || echo 'no-git')
  (cache_set branch "$branch") &
fi

# ---------------------------------------------------------------------------
# AWS profile (cheap env var read, no caching needed)
# ---------------------------------------------------------------------------
aws_profile=""
[ -n "$AWS_PROFILE" ] && aws_profile=$(printf " \033[33maws:%s\033[0m" "$AWS_PROFILE")

# ---------------------------------------------------------------------------
# Context usage block (comes from stdin JSON, no caching needed)
# A single vertical block character scaled to usage, with color coding.
# ---------------------------------------------------------------------------
ctx_bar=""
if [ -n "$used_pct" ]; then
  block=$(echo "$used_pct" | awk '{
    p = int($1)
    if      (p <= 12) print "▁"
    else if (p <= 25) print "▂"
    else if (p <= 37) print "▃"
    else if (p <= 50) print "▄"
    else if (p <= 62) print "▅"
    else if (p <= 75) print "▆"
    else if (p <= 87) print "▇"
    else              print "█"
  }')
  if [ "$(echo "$used_pct" | awk '{print ($1 >= 80)}')" = "1" ]; then
    fg="\033[31m"           # bright red foreground
    bg="\033[48;5;52m"      # dark red background
  elif [ "$(echo "$used_pct" | awk '{print ($1 >= 60)}')" = "1" ]; then
    fg="\033[33m"           # bright yellow foreground
    bg="\033[48;5;58m"      # dark yellow/olive background
  else
    fg="\033[32m"           # bright green foreground
    bg="\033[48;5;22m"      # dark green background
  fi
  ctx_bar=$(printf "${bg}${fg}%s\033[0m ${fg}%d%%\033[0m" "$block" "$used_pct")
fi

# ---------------------------------------------------------------------------
# Git diff stat (cached)
# ---------------------------------------------------------------------------
git_changes=""
if [ "$branch" != "no-git" ]; then
  if [ "$cache_fresh" = "1" ]; then
    git_changes=$(cache_get git_changes)
  else
    shortstat=$(git diff --shortstat HEAD 2>/dev/null)
    if [ -n "$shortstat" ]; then
      insertions=$(echo "$shortstat" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+')
      deletions=$(echo "$shortstat" | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+')
      [ -z "$insertions" ] && insertions=0
      [ -z "$deletions" ] && deletions=0
      if [ "$insertions" -gt 0 ] || [ "$deletions" -gt 0 ]; then
        git_changes=$(printf " \033[32m+%s\033[0m \033[31m-%s\033[0m" "$insertions" "$deletions")
      fi
    fi
    (cache_set git_changes "$git_changes") &
  fi
fi

# ---------------------------------------------------------------------------
# Line 1: directory, git branch, aws, model, context bar, git changes
# ---------------------------------------------------------------------------
line1=$(printf "\033[36m%s\033[0m" "$(basename "$current_dir")")
[ "$branch" != "no-git" ] && line1="${line1} \033[32m(${branch})\033[0m"
[ -n "$aws_profile" ] && line1="${line1}${aws_profile}"
line1="${line1} \033[35m${model}\033[0m"
[ -n "$ctx_bar" ] && line1="${line1} ${ctx_bar}"
[ -n "$git_changes" ] && line1="${line1}${git_changes}"
printf '%b' "${line1}\n"

# ---------------------------------------------------------------------------
# Line 2: docker container URLs (cached)
# Matches containers by docker compose project label OR container name.
# Shows service name alongside each port as a clickable OSC 8 link.
# ---------------------------------------------------------------------------
if command -v docker &>/dev/null; then
  project_name=$(basename "$current_dir" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/-*$//')

  if [ "$cache_fresh" = "1" ]; then
    docker_entries=$(cache_get docker_entries)
  else
    docker_entries=""
    if docker info &>/dev/null 2>&1; then
      declare -A seen_ports
      while IFS= read -r line; do
        [ -z "$line" ] && continue
        compose_project=$(echo "$line" | jq -r '.Labels // "" | split(",") | map(select(startswith("com.docker.compose.project="))) | .[0] // "" | split("=")[1] // ""' 2>/dev/null)
        service_name=$(echo "$line" | jq -r '.Labels // "" | split(",") | map(select(startswith("com.docker.compose.service="))) | .[0] // "" | split("=")[1] // ""' 2>/dev/null)
        container_name=$(echo "$line" | jq -r '.Names // ""' 2>/dev/null)
        [ -z "$service_name" ] && service_name="$container_name"
        match=0
        [ "$compose_project" = "$project_name" ] && match=1
        echo "$container_name" | grep -qi "$project_name" && match=1
        if [ "$match" = "1" ]; then
          ports=$(echo "$line" | jq -r '.Ports // ""' 2>/dev/null)
          while IFS= read -r port_entry; do
            host_port=$(echo "$port_entry" | grep -oE '(0\.0\.0\.0|127\.0\.0\.1):[0-9]+' | grep -oE '[0-9]+$')
            if [ -n "$host_port" ] && [ -z "${seen_ports[$host_port]}" ]; then
              seen_ports[$host_port]=1
              url="http://localhost:${host_port}"
              docker_entries="${docker_entries} \e]8;;${url}\a\033[36m${service_name}\033[34m:${host_port}\e]8;;\a"
            fi
          done <<< "$(echo "$ports" | tr ',' '\n')"
        fi
      done < <(docker ps --format '{{json .}}' 2>/dev/null)
    fi
    (cache_set docker_entries "$docker_entries") &
  fi

  if [ -n "$docker_entries" ]; then
    printf '%b' "${docker_entries}\033[0m\n"
  fi
fi
