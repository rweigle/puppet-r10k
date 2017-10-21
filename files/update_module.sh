#!/bin/bash

MODULE=$1

if [[ ! "$MODULE" =~ ^[A-Za-z0-9_]+$ ]]; then
   echo "$MODULE not allowed, only [A-Za-z0-9_]+ allowed as module name"
   exit 1
fi

(cd /etc/puppet; r10k --config=r10k.yaml deploy --verbose=debug module $MODULE 2>&1 |grep -E '(INFO|Updating)')
