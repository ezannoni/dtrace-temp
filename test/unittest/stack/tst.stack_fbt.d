/*
 * Oracle Linux DTrace.
 * Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

/*
 * ASSERTION: Test the stack action with the default stack depth.
 *
 * SECTION: Output Formatting/printf()
 */

#pragma D option destructive

BEGIN
{
	system("echo write something > /dev/null");
}

fbt::__vfs_write:entry
{
	stack();
	exit(0);
}
