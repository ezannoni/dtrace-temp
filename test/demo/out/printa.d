/*
 * Oracle Linux DTrace.
 * Copyright (c) 2005, 2022, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

profile:::tick-997
{
	@a[caller] = count();
}

END
{
	printa("%@8u %a\n", @a);
}
