alias k=kubectl
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgpn="kubectl get pods -n"
alias kdp="kubectl delete pods"
alias kdpn="kubectl delete pods -n"
alias kcuc="kubectl config use-context"
alias kl="kubectl logs"
alias kln="kubectl logs -n"
alias kpf="kubectl port-forward"
alias kpfn="kubectl port-forward -n"
alias kd="kubectl delete"
alias kgj="kubectl get jobs"
alias kgjn="kubectl get jobs -n"
alias kgcm="kubectl get cm"
alias kgcmn="kubectl get cm -n"
alias kgs="kubectl get services"

# Bash completion for kubectl aliases (skip on macOS)
if [[ "$OSTYPE" != "darwin"* ]] && command -v complete >/dev/null 2>&1; then
    complete -F __start_kubectl k
    complete -F __start_kubectl_get kg
    complete -F __start_kubectl_get_pods kgp
    complete -F __start_kubectl_get_pods_-n kgpn
    complete -F __start_kubectl_delete_pods kdp
    complete -F __start_kubectl_delete_pods_-n kdpn
    complete -F __start_kubectl_config_use-context kcuc
    complete -F __start_kubectl_logs kl
    complete -F __start_kubectl_logs_-n kln
    complete -F __start_kubectl_port_forward kpf
    complete -F __start_kubectl_port_forward_-n kpfn
    complete -F __start_kubectl_delete kd
    complete -F __start_kubectl_get_jobs kgj
    complete -F __start_kubectl_get_jobs_-n kgjn
    complete -F __start_kubectl_get_cm kgcm
    complete -F __start_kubectl_get_cm_-n kgcmn
    complete -F __start_kubectl_get_services kgs
fi
