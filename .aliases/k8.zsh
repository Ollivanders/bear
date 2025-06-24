alias k=kubectl
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kdp="kubectl describe pod"
alias kgpa="kubectl get pods --all-namespaces"
#alias klf="kubectl logs -f"
alias kll='_aliaskll(){ echo "kubectl logs -f -l app=\"$1\" -c \"$1\""; kubectl logs -f -l app="$1" -c "$1";}; _aliaskll'
alias kgpn='kubectl get pods -o wide --sort-by="{.spec.nodeName}"'
alias kgpan='kubectl get pods --all-namespaces -o wide --sort-by="{.spec.nodeName}"'
#alias ke='kubectl exec -it $*'
#alias kdelp='kubectl delete pod'

alias kcc="kubectl config current-context; kubectl config view --minify -o jsonpath='{..namespace}'; echo ''"
alias ksc="kubectl config set-context --current --namespace"
