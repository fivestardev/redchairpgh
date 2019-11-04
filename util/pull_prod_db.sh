#!/bin/bash

if [ -z ${RCPGH_ROOT+x} ]; then
	echo "you must set RCPGH_ROOT"
	exit -1
fi

# pull the production database down via ssh
# set target path to first argument or cwd

AWS_USR="ec2-user"
AWS_PEM="${RCPGH_ROOT}/util/env/fivestardev.pem"
AWS_DNS="ec2-52-90-229-189.compute-1.amazonaws.com"
AWS_PROD_DB_PATH="/var/app/current/db/production.sqlite3"

TARGET_PATH=$1
if [ -z "$TARGET_PATH" ]; then
	TARGET_PATH=$RCPGH_ROOT
fi

scp -i $AWS_PEM $AWS_USR@$AWS_DNS:$AWS_PROD_DB_PATH $TARGET_PATH
