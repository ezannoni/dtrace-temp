/*
 * Oracle Linux DTrace.
 * Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

#pragma D option quiet
#pragma D option destructive

BEGIN
{
	system("printf '\xc0\xa8\x01\x17' > /dev/null 2>&1");
}

syscall::write:entry
/ppid == $pid/
{
	p = alloca(4);
	copyinto(arg1, 4, p);
	printf("%s\n", inet_ntoa(p));
	exit(0);
}

ERROR { exit(1); }
