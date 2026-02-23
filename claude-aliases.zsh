# Claude Code CLI shortcuts
# Usage:
#   --yolo  => --dangerously-skip-permissions
#   -y      => --dangerously-skip-permissions
#   -t      => --teammate-mode tmux
#   -a      => --agent master
#   cc      => claude (short alias)

# 인자 변환 헬퍼
_claude_expand_args() {
  local args=()
  for arg in "$@"; do
    case "$arg" in
      # Skip permissions (yolo mode)
      --yolo|-y) args+=("--dangerously-skip-permissions") ;;
      # Short alias for --teammate-mode tmux
      -t)        args+=("--teammate-mode" "tmux") ;;
      # Short alias for --agent master
      -a)        args+=("--agent" "master") ;;
      *)         args+=("$arg") ;;
    esac
  done
  echo "${args[@]}"
}

# claude 래퍼
claude() {
  local expanded=($(_claude_expand_args "$@"))
  command claude "${expanded[@]}"
}

# cc = claude 단축
cc() {
  local expanded=($(_claude_expand_args "$@"))
  command claude "${expanded[@]}"
}
