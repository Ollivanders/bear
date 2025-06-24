alias tlogin="tsh login --proxy=socrates.teleport.sh --auth=okta"
alias ttoken="tctl tokens add --type=node"
alias tshs="tsh ls --search"
alias tkill="export PROCCESSES=\$(ps -ef | grep 'tsh proxy ssh' | grep -v 'grep tsh proxy ssh' | awk '{print \$2}'); kill \$PROCCESSES ; unset PROCCESSES"
