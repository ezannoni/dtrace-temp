#!/bin/bash
#
# Oracle Linux DTrace.
# Copyright (c) 2007, 2020, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at
# http://oss.oracle.com/licenses/upl.
#

dtrace_script()
{
	$dtrace $dt_flags -w -s /dev/stdin <<EOF

	/*
	 * ASSERTION:
	 *	Verify that copyoutstr() handles bad addresses.
	 *
	 * SECTION: Actions and Subroutines/copyoutstr()
	 *
	 */

	BEGIN
	{
		ptr = alloca(sizeof(char *));
		copyinto(curpsinfo->pr_envp, sizeof(char *), ptr);
		copyoutstr(ptr, 0, sizeof(char *));
	}

	ERROR
	{
		exit(1)
	}
EOF
}

if [ $# != 1 ]; then
	echo expected one argument: '<'dtrace-path'>'
	exit 2
fi

dtrace=$1

dtrace_script &
child=$!

wait $child
status=$?

exit $status
