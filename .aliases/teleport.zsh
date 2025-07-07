alias tlogin="tsh login --proxy=socrates.teleport.sh --auth=okta"
alias ttoken="tctl tokens add --type=node"
alias tshs="tsh ls --search"
alias tkill="export PROCCESSES=\$(ps -ef | grep 'tsh proxy ssh' | grep -v 'grep tsh proxy ssh' | awk '{print \$2}'); kill \$PROCCESSES ; unset PROCCESSES"
alias tshf="tsh ls | fzf > selected | cut -d' ' -f1 | pbcopy"
alias tshd="tsh ls -v | fzf -m"

function tshl() {
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
  #tsh ssh -A oliver.baxandall@$1
  echo "ssh oliver.baxandall@${1}.socrates.teleport.sh  -A"
  ssh -t oliver.baxandall@${1}.socrates.teleport.sh -A 'bash -o vi'
  if [[ $2 = "c" ]]; then
    echo "tsh ssh oliver.baxandall@$1"
    tsh ssh -A oliver.baxandall 'bash -o vi'
  fi
}

function adb() {
  echo "tsh db connect --db-user=rds-readonly --db-name=${2} $1"
  tsh db connect --db-user=rds-readonly --db-name=$2 $1
}

function gdb() {
  echo "tsh db connect --db-user=cloudsql-readonly@talos-ava-prod.iam --db-name=${2} $1"
  tsh db connect --db-user=cloudsql-readonly@talos-ava-prod.iam --db-name=$2 $1
}

function toscp() {
  echo "tsh scp $2 oliver.baxandall@$1:/home/oliver.baxandall/$2"
  tsh scp $2 oliver.baxandall@$1:/home/oliver.baxandall/$2
}

function frscp() {
  echo "tsh scp oliver.baxandall@$1:/home/oliver.baxandall/$2 $2"
  tsh scp oliver.baxandall@$1:/home/oliver.baxandall/$2 $2
}

function pdb() {
  echo "tsh db connect --db-user=rds-readonly --db-name=postgres $1"
  tsh db connect --db-user=rds-readonly --db-name=postgres $1
}
