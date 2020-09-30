/*
 * Oracle Linux DTrace.
 * Copyright (c) 2006, 2020, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

/*
 * ASSERTION:
 *
 * Simple profile-ms simple test.
 *
 * SECTION: profile Provider/profile-n probes
 *
 */


#pragma D option quiet

profile-1ms
{
	exit(0);
}
