/*
 * Oracle Linux DTrace.
 * Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

/*
 * ASSERTION: progenyof() should take a pid_t argument.
 *
 * SECTION: Actions and Subroutines/progenyof()
 */

BEGIN
{
	progenyof("some_string");
	exit(0);
}
