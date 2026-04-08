#!/usr/bin/env bash
# Claude Code status line script
# Displays: model, context window usage (progressbar), session info, vim mode, git branch

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
used_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')
total_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
session=$(echo "$input" | jq -r '.session_name // empty')
version=$(echo "$input" | jq -r '.version // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# ANSI colors (will be dimmed by terminal)
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BLUE='\033[0;34m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

parts=()

# Model name
parts+=("$(printf "${CYAN}${BOLD}%s${RESET}" "$model")")

# Version
if [ -n "$version" ]; then
  parts+=("$(printf "${DIM}v%s${RESET}" "$version")")
fi

# Context window progress bar
if [ -n "$used_pct" ]; then
  bar_width=20
  filled=$(echo "$used_pct $bar_width" | awk '{printf "%d", ($1/100)*$2}')
  empty=$((bar_width - filled))

  if (( $(echo "$used_pct > 80" | bc -l) )); then
    bar_color=$RED
  elif (( $(echo "$used_pct > 50" | bc -l) )); then
    bar_color=$YELLOW
  else
    bar_color=$GREEN
  fi

  bar=""
  for ((i=0; i<filled; i++)); do bar="${bar}█"; done
  for ((i=0; i<empty; i++)); do bar="${bar}░"; done

  pct_str=$(printf "%.0f%%" "$used_pct")
  parts+=("$(printf "ctx: ${bar_color}%s${RESET} ${DIM}%s${RESET}" "$bar" "$pct_str")")
fi

# Token count
if [ -n "$used_tokens" ] && [ -n "$total_tokens" ]; then
  used_k=$(echo "$used_tokens" | awk '{printf "%.0fk", $1/1000}')
  total_k=$(echo "$total_tokens" | awk '{printf "%.0fk", $1/1000}')
  parts+=("$(printf "${DIM}%s/%s${RESET}" "$used_k" "$total_k")")
fi

# Rate limit 5h
if [ -n "$five_hour" ]; then
  five_str=$(printf "%.0f%%" "$five_hour")
  if (( $(echo "$five_hour > 80" | bc -l) )); then
    rl_color=$RED
  elif (( $(echo "$five_hour > 50" | bc -l) )); then
    rl_color=$YELLOW
  else
    rl_color=$GREEN
  fi
  parts+=("$(printf "5h: ${rl_color}%s${RESET}" "$five_str")")
fi

# Rate limit 7d
if [ -n "$seven_day" ]; then
  seven_str=$(printf "%.0f%%" "$seven_day")
  if (( $(echo "$seven_day > 80" | bc -l) )); then
    rl7_color=$RED
  elif (( $(echo "$seven_day > 50" | bc -l) )); then
    rl7_color=$YELLOW
  else
    rl7_color=$GREEN
  fi
  parts+=("$(printf "7d: ${rl7_color}%s${RESET}" "$seven_str")")
fi

# Vim mode
if [ -n "$vim_mode" ]; then
  if [ "$vim_mode" = "INSERT" ]; then
    parts+=("$(printf "${GREEN}[INSERT]${RESET}")")
  else
    parts+=("$(printf "${MAGENTA}[NORMAL]${RESET}")")
  fi
fi

# Git branch (fast, skip locks)
if [ -n "$cwd" ] && command -v git &>/dev/null; then
  branch=$(GIT_DIR="$cwd/.git" GIT_WORK_TREE="$cwd" git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || GIT_DIR="$cwd/.git" GIT_WORK_TREE="$cwd" git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    parts+=("$(printf "${BLUE} %s${RESET}" "$branch")")
  fi
fi

# Session name
if [ -n "$session" ]; then
  parts+=("$(printf "${DIM}\"%s\"${RESET}" "$session")")
fi

# Join with separator
result=""
for part in "${parts[@]}"; do
  if [ -z "$result" ]; then
    result="$part"
  else
    result="$result $(printf "${DIM}|${RESET}") $part"
  fi
done

printf "%b" "$result"
