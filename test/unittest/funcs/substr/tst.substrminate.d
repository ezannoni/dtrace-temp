/*
 * Oracle Linux DTrace.
 * Copyright (c) 2008, 2023, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */
/* @@trigger: bogus-ioctl */

#pragma D option quiet
#pragma D option aggsortkey

/*
 * This is to check that we're correctly null-terminating the result of the
 * substr() subroutine.
 */

syscall::ioctl:entry
/pid == $target && i++ > 10/
{
	exit(0);
}

syscall::ioctl:entry
/pid == $target/
{
	@[substr((i & 1) ? "Bryan is smart" : "he's not a dummy", 0,
	    (i & 1) ? 8 : 18)] = count();
}

END
{
	printa("%s\n", @);
}
