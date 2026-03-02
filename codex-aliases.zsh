# Codex CLI shortcuts
# Usage:
#   --yolo, -y   => --dangerously-bypass-approvals-and-sandbox
#   -a           => keep main TUI on codex, enforce hook runtime for sub-task delegation
#   -r           => resume --last (if session id is provided: resume <id>)
#   cdx          => codex short alias

typeset -gi _CODEX_SUBTASK_HOOK_ENFORCED=0

_codex_expand_args() {
  local option_args=()
  local positional_args=()
  local args=()
  local do_resume=0
  local resume_target=""
  local enforce_subtask_hooks=0

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --yolo|-y)
        option_args+=("--dangerously-bypass-approvals-and-sandbox")
        ;;
      -a)
        enforce_subtask_hooks=1
        ;;
      -r|--resume)
        do_resume=1
        if [ -n "${2:-}" ] && [[ "${2:-}" != -* ]]; then
          resume_target="$2"
          shift
        fi
        ;;
      *)
        positional_args+=("$1")
        ;;
    esac
    shift
  done

  if [ "$do_resume" -eq 1 ]; then
    args+=("${option_args[@]}")
    args+=("resume")
    if [ -n "$resume_target" ]; then
      args+=("$resume_target")
    else
      args+=("--last")
    fi
    args+=("${positional_args[@]}")
  else
    args+=("${option_args[@]}")
    args+=("${positional_args[@]}")
  fi

  _CODEX_SUBTASK_HOOK_ENFORCED=$enforce_subtask_hooks
  reply=("${args[@]}")
}

_codex_has_profile_arg() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -p|--profile)
        return 0
        ;;
      --profile=*)
        return 0
        ;;
    esac
    shift
  done
  return 1
}

cdx() {
  _codex_expand_args "$@"
  local expanded=("${reply[@]}")
  local default_profile="${CODEX_DEFAULT_PROFILE:-master}"
  local runner="codex"

  if [ "${_CODEX_SUBTASK_HOOK_ENFORCED:-0}" -eq 1 ]; then
    local task_runner="${AI_FORGE_CODEX_TASK_RUNNER:-$HOME/.codex/bin/codex-exec-with-hooks}"
    if ! command -v "$task_runner" >/dev/null 2>&1 && [ ! -x "$task_runner" ]; then
      echo "[cdx] error: codex-exec-with-hooks not found for sub-task hook enforcement." >&2
      echo "[cdx] install/refresh:" >&2
      echo "  cd /Users/sangjunserver3/Desktop/project/ai-forge" >&2
      echo "  ./scripts/build.sh && ./scripts/install-codex.sh --quiet" >&2
      return 1
    fi

    if [ -n "$default_profile" ] && ! _codex_has_profile_arg "${expanded[@]}"; then
      AI_FORGE_SUBTASK_HOOK_ENFORCED=1 \
      AI_FORGE_CODEX_TASK_HOOK_MODE=require \
      AI_FORGE_CODEX_TASK_RUNNER="$task_runner" \
      command "$runner" -p "$default_profile" "${expanded[@]}"
    else
      AI_FORGE_SUBTASK_HOOK_ENFORCED=1 \
      AI_FORGE_CODEX_TASK_HOOK_MODE=require \
      AI_FORGE_CODEX_TASK_RUNNER="$task_runner" \
      command "$runner" "${expanded[@]}"
    fi
    return $?
  fi

  if [ -n "$default_profile" ] && ! _codex_has_profile_arg "${expanded[@]}"; then
    command "$runner" -p "$default_profile" "${expanded[@]}"
  else
    command "$runner" "${expanded[@]}"
  fi
}
