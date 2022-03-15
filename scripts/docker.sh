alias k='kubectl'
alias dk='docker'

alias docker-clean=' \
  docker ps --no-trunc -aqf "status=exited" | xargs docker rm ; \
  docker images --no-trunc -aqf "dangling=true" | xargs docker rmi ; \
  docker volume ls -qf "dangling=true" | xargs docker volume rm'
alias docker-clean-hard=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '
alias docker-clean-images='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias docker-clean-1m='docker images --no-trunc --format \"{{.ID}} {{.CreatedSince}}\" \
    | grep \" months\" | awk \"{ print $1 }\" \
    | xargs --no-run-if-empty docker rmi'
alias docker-stop-all='docker kill $(docker ps -q)'
