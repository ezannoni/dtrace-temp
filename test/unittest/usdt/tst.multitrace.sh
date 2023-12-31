#!/bin/bash
#
# Oracle Linux DTrace.
# Copyright (c) 2006, 2023, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at
# http://oss.oracle.com/licenses/upl.
#
# Test multiple simultaneous tracers, invoked successively (so there
# are multiple dtracers and multiple processes tracing the same probes).
#
# @@xfail: something up with multiple simultaneous exiting tracers
if [ $# != 1 ]; then
	echo expected one argument: '<'dtrace-path'>'
	exit 2
fi

dtrace=$1
CC=/usr/bin/gcc
CFLAGS=

DIRNAME="$tmpdir/usdt-multitrace.$$.$RANDOM"
mkdir -p $DIRNAME
cd $DIRNAME

cat > multitrace.d <<EOF
provider test_multitrace {
	probe go();
	probe exiting();
};
EOF

$dtrace -h -s multitrace.d
if [ $? -ne 0 ]; then
	echo "failed to generate header file" >& 2
	exit 1
fi

cat > test.c <<EOF
#include <sys/types.h>
#include "multitrace.h"

int
main(int argc, char **argv)
{
	size_t i;

	sleep(5);
	for (i = 0; i < 5; i++) {
		if (TEST_MULTITRACE_GO_ENABLED())
			TEST_MULTITRACE_GO();
		sleep(1);
	}
	TEST_MULTITRACE_EXITING();

	return 0;
}
EOF

${CC} ${CFLAGS} -c test.c
if [ $? -ne 0 ]; then
	echo "failed to compile test.c" >& 2
	exit 1
fi
$dtrace -G -s multitrace.d test.o
if [ $? -ne 0 ]; then
	echo "failed to create DOF" >& 2
	exit 1
fi
${CC} ${CFLAGS} -o test test.o multitrace.o
if [ $? -ne 0 ]; then
	echo "failed to link final executable" >& 2
	exit 1
fi

script() {
	$dtrace -qws /dev/stdin $1 $2 $3 <<'EOF'
	int fired[pid_t];
	int exited[pid_t];

	test_multitrace$1:::go, test_multitrace$2:::go
	{
		printf("tracer %i, process %i fired: %s:%s:%s\n", $3,
		       curpsinfo->pr_pid, probemod, probefunc, probename);
	}

	test_multitrace$1:::go, test_multitrace$2:::go
	/ curpsinfo->pr_pid == $1 || curpsinfo->pr_pid == $2 /
	{
		fired[curpsinfo->pr_pid]++;
	}
	test_multitrace$1:::exiting, test_multitrace$2:::exiting
	/ exited[curpsinfo->pr_pid] != 0 /
	{
		printf("tracer %i: repeated fires of exit probe of %i observed.\n",
		       $3, curpsinfo->pr_pid);
		exit(1);
	}
	test_multitrace$1:::exiting, test_multitrace$2:::exiting
	{
		printf("tracer %i, process %i, %i fires seen.\n", $3,
		       curpsinfo->pr_pid, fired[curpsinfo->pr_pid]);
		exited[curpsinfo->pr_pid] = 1;
	}
	test_multitrace$1:::exiting, test_multitrace$2:::exiting
	/ exited[$1] == 1 && exited[$2] == 1 && fired[$1] == 5 && fired[$2] == 5 /
	{
		printf("tracer %i: exiting\n", $3);
		exit(0);
	}
	test_multitrace$1:::exiting, test_multitrace$2:::exiting
	/ exited[$1] == 1 && exited[$2] == 1 /
	{
		printf("tracer %i, %i fires seen from process %i, %i from process %i\n",
		       $3, fired[$1], $1, fired[$2], $2);
		exit(1);
	}
EOF
	echo tracer $3: exited
}

./test 1 &
ONE=$!
./test 2 0 &
TWO=$!

script $ONE $TWO 1 &
DONE=$!

script $ONE $TWO 2 &
DTWO=$!

if ! wait $DONE; then
    exit 1
fi

if ! wait $DTWO; then
    exit 1
fi

wait $ONE $TWO

exit 0
