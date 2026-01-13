alias white-background='printf %b '\''\e]11;#FFFFFF\a\'\'''
alias black-background='printf %b '\''\e]11;#000000\a\'\'''
alias red-background='printf %b '\''\e]11;#660000\a\'\'''
alias orange-background='printf %b '\''\e]11;#4d2e00\a\'\'
alias tlogin="tsh login --proxy=${TELEPORT_HOST} --auth=okta"
alias ttoken="tctl tokens add --type=node"
alias tshs="tsh ls --search"
alias tkill="export PROCCESSES=\$(ps -ef | grep 'tsh proxy ssh' | grep -v 'grep tsh proxy ssh' | awk '{print \$2}'); kill \$PROCCESSES ; unset PROCCESSES"
# alias tshf="tsh ls | fzf > selected | cut -d' ' -f1 | pbcopy"
alias tshd="tsh ls -v | fzf -m"
TELEPORT_HOSTS_PATH="${HOME}/.cache/teleport_hosts.txt"
TELEPORT_DBS_PATH="${HOME}/.cache/teleport_dbs.txt"

function tsh_ls() {
  CLOUD_PROVIDER=""
  ENV=""

  for ARG in "$@"; do
    if [[ "$ARG" =~ ^(colo|aws|gcp)$ ]]; then
      CLOUD_PROVIDER=$ARG
    elif [[ "$ARG" =~ ^(staging|uat|sandbox|alpha|prod|capture|repeater)$ ]]; then
      ENV=$ARG
    fi
  done

  ARGS=""
  if [[ -n "$CLOUD_PROVIDER" ]]; then
    ARGS="cloud_provider=$CLOUD_PROVIDER"
  fi
  if [[ -n "$ENV" ]]; then
    if [[ -n "$ARGS" ]]; then
      ARGS="$ARGS,"
    fi
    ARGS="${ARGS}env=$ENV"
  fi
  echo "tsh ls ${ARGS}"
  tsh ls "${ARGS}"
}

function tssh() {
  echo "ssh -t ${USER}@${1}.${TELEPORT_HOST}"
  ssh -t ${USER}@${1}.${TELEPORT_HOST} -o ConnectTimeout=5 #-A 'bash -o vi'
}

function filetoscp() {
  echo "tsh scp $2 ${USER}@$1:/home/${USER}/$2"
  tsh scp -r $2 ${USER}@$1:/home/${USER}/
}

function toscp() {
  echo "tsh scp $2 ${USER}@$1:/home/${USER}/$2"
  tsh scp $2 ${USER}@$1:/home/${USER}/$2
}

function frscp() {
  echo "tsh scp ${USER}@$1:/home/${USER}/$2 $2"
  tsh scp ${USER}@$1:/home/${USER}/$2 $2
}

function adb() {
  echo "tsh db connect --db-user=rds-readonly --db-name=${2} $1"
  tsh db connect --db-user=rds-readonly --db-name=$2 $1
}

function pdb() {
  local role=${2:-rds-admin}
  echo "tsh db connect --db-user=${role} --db-name=postgres $1"
  tsh db connect --db-user=${role} --db-name=postgres $1
}

function tshls() {
  tsh ls -v >$TELEPORT_HOSTS_PATH
  echo "Synced TELEPORT_HOSTS ${TELEPORT_HOSTS_PATH}"
}

function tshl() {
  for uuid in $(cat $TELEPORT_HOSTS_PATH | fzf -m | awk '{print $2}'); do
      if tssh "$uuid"; then
          echo $uuid
          return 0
      else
          echo "Failed to connect to $uuid, trying next..."
      fi
  done
  return 1
}

function tshr() {
  tshls
  tshl
}

function tshf() {
  for vm in $(cat $TELEPORT_HOSTS_PATH | fzf -m ); do
    echo $vm
  done
}

function tshls_db() {
  echo "Syncing teleport dbs"
  tsh db ls -v >$TELEPORT_DBS_PATH
  echo "Synced TELEPORT_DBS ${TELEPORT_DBS_PATH}"
}

function tshl_db() {
  local selection dbs
  selection=$(sed '1,2d' $TELEPORT_DBS_PATH | fzf -m) || return 1
  dbs=$(echo "$selection" | awk '{print $1}')

  for db in $dbs; do
      local line type roles role
      line=$(awk -v target="$db" '$1==target {print; exit}' $TELEPORT_DBS_PATH)
      type=$(awk -v target="$db" '$1==target {print $3; exit}' $TELEPORT_DBS_PATH)
      [[ -z "$line" ]] && continue

      roles=$(echo "$line" | sed -n 's/.*\[\(.*\)\].*/\1/p' | tr ' ' '\n' | sed '/^$/d')

      if [[ -n "$roles" ]]; then
          if [[ "$type" == "gcp" ]]; then
              roles=$(echo "$roles" | grep -v '^rds-' || true)
          elif [[ "$type" == "rds" ]]; then
              roles=$(echo "$roles" | grep -v 'cloudsql-' || true)
          fi
          if [[ -n "$TSHDBL_EXCLUDE_ROLES" ]]; then
              local -a exclude_roles_list
              exclude_roles_list=(${=TSHDBL_EXCLUDE_ROLES})
              for exclude_role in $exclude_roles_list; do
                  roles=$(echo "$roles" | grep -v "$exclude_role" || true)
              done
          fi
          roles=$(echo "$roles" | sed '/^$/d')
          if [[ -n "$roles" ]]; then
              role=$(echo "$roles" | fzf --prompt="role ($db)> ")
          fi
      fi
      echo $db

      if pdb "$db" "$role"; then
          echo $db
          return 0
      else
          echo "Failed to connect to $db, trying next..."
      fi
  done
}

function tshr_db() {
  tshls_db
  tshl_db
}

