#!/usr/bin/env bash

input=$(cat)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

cd "$current_dir" 2>/dev/null

branch=$(git branch --show-current 2>/dev/null || echo 'no-git')

# AWS profile
aws_profile=""
[ -n "$AWS_PROFILE" ] && aws_profile=$(printf " \033[33maws:%s\033[0m" "$AWS_PROFILE")

# Context usage bar
ctx_bar=""
if [ -n "$used_pct" ]; then
  filled=$(echo "$used_pct" | awk '{printf "%d", $1 / 10}')
  empty=$((10 - filled))
  bar=""
  for i in $(seq 1 $filled); do bar="${bar}█"; done
  for i in $(seq 1 $empty); do bar="${bar}░"; done
  if [ "$filled" -ge 8 ]; then bar_color="\033[31m"
  elif [ "$filled" -ge 6 ]; then bar_color="\033[33m"
  else bar_color="\033[32m"
  fi
  ctx_bar=$(printf " ${bar_color}%s %d%%\033[0m" "$bar" "$used_pct")
fi

# Line 1
printf "\033[36m%s\033[0m \033[32m(%s)\033[0m%s \033[35m%s\033[0m%s\n" \
  "$(basename "$current_dir")" \
  "$branch" \
  "$aws_profile" \
  "$model" \
  "$ctx_bar"

# Line 2: git diff stat (staged + unstaged), only if there are changes
if [ "$branch" != "no-git" ]; then
  shortstat=$(git diff --shortstat HEAD 2>/dev/null)
  if [ -n "$shortstat" ]; then
    insertions=$(echo "$shortstat" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' || echo 0)
    deletions=$(echo "$shortstat" | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+' || echo 0)
    [ -z "$insertions" ] && insertions=0
    [ -z "$deletions" ] && deletions=0
    if [ "$insertions" -gt 0 ] || [ "$deletions" -gt 0 ]; then
      printf "\033[32m+%s\033[0m \033[31m-%s\033[0m\n" "$insertions" "$deletions"
    fi
  fi
fi

# Line 3: docker container URLs for the current project
# Matches containers by docker compose project label OR container name containing the project basename
if command -v docker &>/dev/null && docker info &>/dev/null 2>&1; then
  project_name=$(basename "$current_dir" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/-*$//')
  docker_urls=""
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    # Extract compose project label and container name
    compose_project=$(echo "$line" | jq -r '.Labels // "" | split(",") | map(select(startswith("com.docker.compose.project="))) | .[0] // "" | split("=")[1] // ""' 2>/dev/null)
    container_name=$(echo "$line" | jq -r '.Names // ""' 2>/dev/null)
    # Check if this container belongs to the current project
    match=0
    [ "$compose_project" = "$project_name" ] && match=1
    echo "$container_name" | grep -qi "$project_name" && match=1
    if [ "$match" = "1" ]; then
      # Extract host ports bound to 0.0.0.0 or 127.0.0.1 (i.e. published to localhost)
      ports=$(echo "$line" | jq -r '.Ports // ""' 2>/dev/null)
      while IFS= read -r port_entry; do
        host_port=$(echo "$port_entry" | grep -oE '(0\.0\.0\.0|127\.0\.0\.1):[0-9]+' | grep -oE '[0-9]+$')
        if [ -n "$host_port" ]; then
          url="http://localhost:${host_port}"
          # Avoid duplicates
          echo "$docker_urls" | grep -qF "$url" || docker_urls="${docker_urls} ${url}"
        fi
      done <<< "$(echo "$ports" | tr ',' '\n')"
    fi
  done < <(docker ps --format '{{json .}}' 2>/dev/null)

  if [ -n "$docker_urls" ]; then
    printf "\033[34m"
    for url in $docker_urls; do
      printf "%s " "$url"
    done
    printf "\033[0m\n"
  fi
fi
