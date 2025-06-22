terraform_plan_with_unlock() {
  echo "Running terraform plan..."
  lock_id=$(terraform plan 2>&1 | grep -P 'ID:\s+\d+' | awk -F: '{gsub(/^[ \t]+/, "", $2); print $2}')
  echo $lock_id

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
