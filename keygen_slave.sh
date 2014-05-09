#!/bin/sh
this="$0"
while [ -h "$this" ]; do
  ls=`ls -ld "$this"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '.*/.*' > /dev/null; then
    this="$link"
else
    this=`dirname "$this"`/"$link"
  fi
done

# init base path
base=`dirname "$this"`
script=`basename "$this"`
base=`cd "$base"; pwd`
this="$base/$script"
hosts="$base/hosts.conf"

echo $base
echo $script
echo $this
echo $hosts

if [ ! -s ~/.ssh/id_rsa ]; then
  expect -c "
  spawn ssh-keygen -t rsa
    expect {
      \"*y/n*\" {send \"y\r\"; exp_continue}
      \"*key*\" {send \"\r\"; exp_continue}
      \"*passphrase*\" {send \"\r\"; exp_continue}
      \"*again*\" {send \"\r\";}
    }
  "
fi

ssh-add $HOME/.ssh/id_rsa # Add private key

# batch ssh   
if [ -s $hosts ]; then
  for p in $(cat $hosts)  # 
  do
    username=$(echo "$p"|cut -f1 -d":") # Get username 
    ip=$(echo "$p"|cut -f2 -d":")       # Get ip  
    password=$(echo "$p"|cut -f3 -d":") # Get password 
    id=$HOME/.ssh/id_rsa.pub

    echo $username
    echo $ip
    echo $password
    echo $id

    # ssh-copy-id    
    expect -c "
    spawn ssh-copy-id -i $id  $username@$ip
      expect {
        \"*yes/no*\" {send \"yes\r\"; exp_continue}
        \"*password*\" {send \"$password\r\"; exp_continue}
        \"*Password*\" {send \"$password\r\";}
      }
    "
  done
fi
