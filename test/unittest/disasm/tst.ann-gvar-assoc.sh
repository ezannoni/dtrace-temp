#!/bin/bash
#
# Oracle Linux DTrace.
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at
# http://oss.oracle.com/licenses/upl.
#

dtrace=$1

$dtrace $dt_flags -Sen '
int st[int], ld[int];

BEGIN
{
	st[2] = 42;
	trace(ld[5]);
	exit(0);
}
' 2>&1 | awk '/ call dt_get_assoc/ { sub(/^[^:]+: /, ""); print; }'

exit $?
