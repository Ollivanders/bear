alias tf="terraform"
alias twl="terraform workspace list"
alias tfa="terraform apply"
alias tfp="terraform plan"
alias tfi="terraform init"
alias tfo="terraform output"
alias tss='terraform state list | fzf --multi --bind "tab:toggle+down" | while IFS= read -r addr; do terraform state show "$addr"; done'
alias tsf='terraform state list | fzf --multi --bind "tab:toggle+down"'

function tws() {
  if [ "$#" -eq 0 ]; then
    local ws
    ws=$(terraform workspace list 2>/dev/null | sed 's/^[* ]*//' | fzf --prompt="Terraform workspace > ")
    if [ -z "$ws" ]; then
      return 0
    fi
    set -- "$ws"
  fi

  terraform workspace select "$@" || return $?

  local workspace_name="${@: -1}"
  if typeset -f set_aws_profile_for_env >/dev/null; then
    set_aws_profile_for_env "$workspace_name"
  fi
}

tfUnlock() {
  echo "Running terraform plan..."
  lock_id=$(terraform plan -no-color 2>&1 | awk '/ID:/ { gsub(/[^0-9]/, "", $0); print $0 }')
  echo "LockID: $lock_id"

  if [ -n "$lock_id" ]; then
    echo "Lock detected. Lock ID: $lock_id"
    echo "Unlocking..."
    terraform force-unlock -force "$lock_id"
    echo "Unlocked"
  else
    echo "No lock ID found. Aborting."
    return 1
  fi
}

function applyAllRegions() {
  for file in regional_config/*.yaml; do
    filename=$(basename "$file" .yaml)
    tws $filename
    tfa
  done
}

function applyAllWorkspaces() {
  workspaces=($(terraform workspace list | sed 's/*//g' | tr -d ' '))
  for workspace in "${workspaces[@]}"; do
    if [[ $workspace == "default" && ${#workspaces[@]} -gt 1 ]]; then
      continue
    fi
    terraform workspace select $workspace
    terraform apply
  done
}

function planAllWorkspaces() {
  workspaces=($(terraform workspace list | sed 's/*//g' | tr -d ' '))
  for workspace in "${workspaces[@]}"; do
    if [[ $workspace == "default" && ${#workspaces[@]} -gt 1 ]]; then
      continue
    fi
    terraform workspace select $workspace
    terraform plan
  done
}

function checkWorkspaceLocks() {
  workspaces=($(terraform workspace list | sed 's/*//g' | tr -d ' '))
  for workspace in "${workspaces[@]}"; do
    if [[ $workspace == "default" && ${#workspaces[@]} -gt 1 ]]; then
      continue
    fi
    terraform workspace select $workspace
    lock_id=$(terraform state pull | jq -r '.lock_id // empty')
    if [[ -n $lock_id ]]; then
      echo "Workspace $workspace is locked with Lock ID: $lock_id."
    else
      echo "Workspace $workspace is not locked."
    fi
  done
}


tf_targets() {
  local input
  input=$(pbpaste)

  local targets
  targets=$(echo "$input" \
    | grep -E '^\s+#\s+(module\.|[a-z])' \
    | grep -E '(will be|must be)' \
    | sed 's/.*# //' \
    | sed -E 's/ (will be|must be).*//' \
    | sort -u \
    | sed "s/.*/-target='&'/" \
    | tr '\n' ' ')

  if [ -z "$targets" ]; then
    echo "No Terraform resources found in clipboard."
    return 1
  fi

  echo "$targets" | pbcopy
  echo "Copied to clipboard"
}
