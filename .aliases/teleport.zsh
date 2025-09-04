alias white-background='printf %b '\''\e]11;#FFFFFF\a\'\'''
alias black-background='printf %b '\''\e]11;#000000\a\'\'''
alias red-background='printf %b '\''\e]11;#660000\a\'\'''
alias orange-background='printf %b '\''\e]11;#4d2e00\a\'\'
alias tlogin="tsh login --proxy=${TELEPORT_HOST} --auth=okta"
alias ttoken="tctl tokens add --type=node"
alias tshs="tsh ls --search"
alias tkill="export PROCCESSES=\$(ps -ef | grep 'tsh proxy ssh' | grep -v 'grep tsh proxy ssh' | awk '{print \$2}'); kill \$PROCCESSES ; unset PROCCESSES"
alias tshf="tsh ls | fzf > selected | cut -d' ' -f1 | pbcopy"
alias tshd="tsh ls -v | fzf -m"
TELEPORT_HOSTS_PATH="${HOME}/.cache/teleport_hosts.txt"

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
  echo "if unsuccessful, run: tsh ssh $1"
  echo "ssh ${USER}@${1}.${TELEPORT_HOST}  -A"
  ssh -t ${USER}@${1}.${TELEPORT_HOST} #-A 'bash -o vi'
  # wezterm ssh -t ${USER}@${1}.${TELEPORT_HOST} #-A 'bash -o vi'
  if [[ $2 = "c" ]]; then
    echo "tsh ssh ${USER}@$1"
    tsh ssh -A ${USER} 'bash -o vi'
  fi
}

function adb() {
  echo "tsh db connect --db-user=rds-readonly --db-name=${2} $1"
  tsh db connect --db-user=rds-readonly --db-name=$2 $1
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

function pdb() {
  echo "tsh db connect --db-user=rds-readonly --db-name=postgres $1"
  tsh db connect --db-user=rds-readonly --db-name=postgres $1
}

function tshls() {
  tsh ls -v >$TELEPORT_HOSTS_PATH
  echo "Synced TELEPORT_HOSTS ${TELEPORT_HOSTS_PATH}"
}

function tshl() {
  for uuid in $(cat $TELEPORT_HOSTS_PATH | fzf -m | awk '{print $2}'); do
      if tssh "$uuid"; then
          break
          echo $uuid
      else
          echo "Failed to connect to $uuid, trying next..."
      fi
  done
}

function tshr() {
  tshls
  tshl
}

