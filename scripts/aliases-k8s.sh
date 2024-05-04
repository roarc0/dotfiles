alias k=kubectl
complete -F __start_kubectl k
alias kg="kubectl get"
complete -F __start_kubectl_get kg
alias kgp="kubectl get pods"
complete -F __start_kubectl_get_pods kgp
alias kgpn="kubectl get pods -n"
complete -F __start_kubectl_get_pods_-n kgpn
alias kdp="kubectl delete pods"
complete -F __start_kubectl_delete_pods kdp
alias kdpn="kubectl delete pods -n"
complete -F __start_kubectl_delete_pods_-n kdpn
alias kcuc="kubectl config use-context"
complete -F __start_kubectl_config_use-context kcuc
alias kl="kubectl logs"
complete -F __start_kubectl_logs kl
alias kln="kubectl logs -n"
complete -F __start_kubectl_logs_-n kln
alias kpf="kubectl port-forward"
complete -F __start_kubectl_port_forward kpf
alias kpfn="kubectl port-forward -n"
complete -F __start_kubectl_port_forward_-n kpfn
alias kd="kubectl delete"
complete -F __start_kubectl_delete kd
alias kgj="kubectl get jobs"
complete -F __start_kubectl_get_jobs kgj
alias kgjn="kubectl get jobs -n"
complete -F __start_kubectl_get_jobs_-n kgjn
alias kgcm="kubectl get cm"
complete -F __start_kubectl_get_cm kgcm
alias kgcmn="kubectl get cm -n"
complete -F __start_kubectl_get_cm_-n kgcmn
alias kgs="kubectl get services"
complete -F __start_kubectl_get_services kgs
