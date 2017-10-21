#!/bin/bash

ENV=$1
ENV2=$2

if [[ "$ENV" == '' ]]; then
   echo orig: $SSH_ORIGINAL_COMMAND
   ENV=`echo $SSH_ORIGINAL_COMMAND|awk -F' ' '{print $2}'`
   ENV2=`echo $SSH_ORIGINAL_COMMAND|awk -F' ' '{print $3}'`
fi

if [[ ! "$ENV" =~ ^[A-Za-z0-9_]+$ ]]; then  
   echo "$ENV not allowed, only [A-Za-z0-9_]+ allowed as environment/module"
   exit 1
fi

if [[ "$ENV" == 'MODULE' ]]; then
   if [[ ! "$ENV2" =~ ^[A-Za-z0-9_]+$ ]]; then  
      echo "$ENV2 not allowed, only [A-Za-z0-9_]+ allowed as module"
      exit 1
   fi
   (cd /etc/puppet; r10k --config=r10k.yaml deploy --verbose=debug module $ENV2 2>&1 |grep -E '(INFO|Updating)')
else
   if [[ ! ( "$ENV2" == '' || "$ENV2" == '--puppetfile' ) ]]; then
      echo "only --puppetfile allowed as second argument"
      exit 1
   fi
   if [[ $ENV == 'all' ]]; then
      ENV=''
   fi
   (cd /etc/puppet; r10k --config=r10k.yaml deploy --verbose=debug environment $ENV $ENV2 2>&1 |grep -E '(INFO|Updating)')
fi
