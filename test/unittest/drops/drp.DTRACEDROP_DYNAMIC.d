/*
 * Oracle Linux DTrace.
 * Copyright (c) 2006, 2023, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

#pragma D option strsize=512
#pragma D option dynvarsize=1024

BEGIN
{
	a["Harding"] = 1;
	a["Hoover"] = 1;
	a["Nixon"] = 1;
	a["Bush"] = 1;
}

BEGIN
{
	exit(0);
}
