#!/bin/sh

SSH_AGENT_FILE=~/.ssh/agent.env
if [ -f ${SSH_AGENT_FILE} ]; then
    . ${SSH_AGENT_FILE} >/dev/null
    if ! kill -0 "$SSH_AGENT_PID" >/dev/null 2>&1; then
        echo "Stale agent file found. Spawning new agent… "
        eval $(ssh-agent | tee ${SSH_AGENT_FILE})
        ssh-add
    fi
else
    echo "Starting ssh-agent"
    eval $(ssh-agent | tee ${SSH_AGENT_FILE})
    ssh-add
fi
