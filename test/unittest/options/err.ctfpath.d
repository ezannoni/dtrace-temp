/*
 * Oracle Linux DTrace.
 * Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

/*
 * ASSERTION: The -xctfpath option overrides the default vmlinux CTF archive.
 *
 * SECTION: Options and Tunables/Consumer Options
 */

/* @@runtest-opts: -xctfpath=/dev/null */

BEGIN
{
	exit(0);
}
