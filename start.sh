#!/bin/bash     

JENKINS_URL=$1
PASS=$2

RANDOMAGENT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

#sed -i '' 's/NODENAME/'$1'/g' nodeTemplate.json MacVersion

sed -i  's/NODENAME/'$RANDOMAGENT'/g' nodeTemplate.json

CREATE_NEW_AGENT=$(curl -L -s -u admin:$PASS  -F json=@nodeTemplate.json -X POST "$JENKINS_URL/computer/doCreateItem?name=$RANDOMAGENT&type=hudson.slaves.DumbSlave")

# Just waste some time to give Jenkins time to have all ready for the new node 
sleep 5

JENKINS_KEY=$(curl -L -s -u admin:$PASS  -X GET $JENKINS_URL/computer/$RANDOMAGENT/slave-agent.jnlp | sed "s/.*<application-desc main-class=\"hudson.remoting.jnlp.Main\"><argument>\([a-z0-9]*\).*/\1/")

echo "$JENKINS_KEY"

jenkins-slave -url $JENKINS_URL $JENKINS_KEY $RANDOMAGENT
