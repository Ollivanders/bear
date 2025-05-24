terraform_plan_with_unlock() {
  echo "Running terraform plan..."
  lock_id=$(terraform plan 2>&1 | grep -oE "Lock info: .+ID: ([a-zA-Z0-9-]+)" | grep -oE "([a-zA-Z0-9-]+)$")
  
  if [ -n "$lock_id" ]; then
    echo "Lock detected. Lock ID: $lock_id"
    echo "Forcing unlock..."
    terraform force-unlock -force "$lock_id"
    echo "Unlocked"
  else
    echo "No lock ID found. Aborting."
    return 1
  fi
}
