/*
 * Oracle Linux DTrace.
 * Copyright (c) 2006, 2022, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

/*
 * ASSERTION:
 *
 * Test invocation of offsetof() with an invalid member.
 * This should fail at compile time.
 *
 * SECTION: Structs and Unions/Member Sizes and Offsets
 *
 * NOTES:
 *
 */

BEGIN
{
	trace(offsetof(vnode_t, v_no_such_member));
}
