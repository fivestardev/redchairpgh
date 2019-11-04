#!/bin/bash

if [ -z ${RCPGH_ROOT+x} ]; then
	echo "you must set RCPGH_ROOT"
	exit -1
fi

# package the repository for a deploy
# 	1. pull production database
#	2. zip repository

NOW=$(date +%Y%m%d%H%M)
ARTIFACT_NAME="${NOW}_redchairpgh.zip"

function pull_prod_db {
	cd $RCPGH_ROOT/util
	./pull_prod_db.sh $RCPGH_ROOT/db
}

function zip_repo {
	# i wrote rtail myself, it's pretty cool ;)
	cd $RCPGH_ROOT
	if [ -n "$(which rtail)" ]; then
		rtail -b 5 -d zip -r $RCPGH_ROOT/$ARTIFACT_NAME .
		echo zipped project to $RCPGH_ROOT/$ARTIFACT_NAME
	else
		zip -r $RCPGH_ROOT/$ARTIFACT_NAME .
	fi
}

pull_prod_db
zip_repo
