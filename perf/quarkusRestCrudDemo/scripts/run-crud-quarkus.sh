#!/bin/bash

TEST_RESROOT=$1
QUARKUS_HOME=$TEST_RESROOT/../../../openjdk-tests/perf/quarkusRestCrudDemo/quarkusRestCrudDemo/quarkus
EXT_SCRIPTS=$TEST_RESROOT/../../../openjdk-tests/perf/quarkusRestCrudDemo/scripts
UTILS_HOME=$TEST_RESROOT/../../../openjdk-tests/perf/utils
RESULTS_DIR=$QUARKUS_HOME/../../../TKG/RESULTS

mkdir -p $RESULTS_DIR

#Affinities for DB and Server hardcoded now.
DB_CPUS=0-7
SERVER_CPUS=0

# Start the postgres DB
	$EXT_SCRIPTS/run-docker-db.sh start $DB_CPUS

# Run the benchmark


WARMUPS=3
MEASURES=5

echo "Running ${WARMUPS} warmups"
for(( run=0; run<${WARMUPS}; run++ ))
do
	$QUARKUS_HOME/run-quarkus-jvm.sh start warmup $run $RESULTS_DIR $SERVER_CPUS &
	quarkus_pid=$!
	# Run work load
	$QUARKUS_HOME/run-quarkus-jvm.sh stop	
done 

echo "Running ${MEASURES} measures"
for(( run=0; run<${MEASURES}; run++ ))
do
	$QUARKUS_HOME/run-quarkus-jvm.sh start measure $run $RESULTS_DIR $SERVER_CPUS &
	quarkus_pid=$!
        # Run wrk load
        $QUARKUS_HOME/run-quarkus-jvm.sh stop
done 

# Stop the postgres DB
	$EXT_SCRIPTS/run-docker-db.sh stop
