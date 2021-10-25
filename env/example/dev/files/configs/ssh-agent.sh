#!/bin/bash

logfile=~/.ssh-agent.log
>$logfile
#export SSH_AUTH_SOCK=~/.ssh/ssh-agent.$HOSTNAME.sock
if [ -f ~/.ssh-agent ]; then
   sshenv=$(cat ~/.ssh-agent)
   eval $sshenv &>>$logfile
fi
ssh-add -l &>/dev/null
if [ $? -ge 2 ]; then
 echo "SSH Agent is not running, staring it..." >>$logfile
 # ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
 sshenv=`ssh-agent`
 echo $sshenv > ~/.ssh-agent
 eval $sshenv &>>$logfile
else
 echo "SSH Agent already running..." >>$logfile
fi

if [ -f ~/.ssh-agent.sh ]; then
  echo "Adding local keys..." >>$logfile
  ~/.ssh-agent.sh &>>$logfile
else
  echo "No SSH add file found (~/.ssh-agent.sh)!" >>$logfile
fi
