/*
 * Oracle Linux DTrace.
 * Copyright (c) 2006, 2021, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

/*
 *
 * ASSERTION:
 * Testing -F option with several probes.
 *
 * SECTION: dtrace Utility/-F Option
 *
 * NOTES:
 * Verify that the for the indent characters are -> <- for non-syscall
 * entry/return pairs (e.g. fbt ones) and => <= for syscall ones and
 * | for profile ones.
 *
 */

/* @@runtest-opts: -FZ */
/* @@timeout: 70 */
/* @@trigger: readwholedir */

BEGIN
{
	i = 0;
	j = 0;
	k = 0;
}

syscall::read:
{
	printf("syscall: %d\n", i++);
}

fbt:vmlinux:SyS_read:,
fbt:vmlinux:__arm64_sys_read:,
fbt:vmlinux:__x64_sys_read:
{
	printf("fbt: %d\n", j++);
}

profile:::tick-10sec
{
	printf("profile: %d\n", k++);
}

profile:::tick-10sec
/ i > 0 && j > 0 && k > 3 /
{
	exit(0);
}
