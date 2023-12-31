/*
 * Oracle Linux DTrace.
 * Copyright (c) 2006, 2022, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

/*
 * ASSERTION: In D, the an array variable can be assigned to a pointer.
 *
 * SECTION: Pointers and Arrays/Pointer and Array Relationship
 *
 * NOTES:
 *
 */

#pragma D option quiet

int array[5];
int *p;

BEGIN
{
	array[0] = 100;
	array[1] = 200;
	array[2] = 300;
	array[3] = 400;
	array[4] = 500;

	p = array;

	printf("array[0]: %d\tp[0]: %d\n", array[0], p[0]);
	printf("array[1]: %d\tp[1]: %d\n", array[1], p[1]);
	printf("array[2]: %d\tp[2]: %d\n", array[2], p[2]);
	printf("array[3]: %d\tp[3]: %d\n", array[3], p[3]);
	printf("array[4]: %d\tp[4]: %d\n", array[4], p[4]);

	exit(0);

}

END
/(array[0] != p[0]) || (array[1] != p[1]) || (array[2] != p[2]) ||
    (array[3] != p[3]) || (array[4] != p[4])/
{
	printf("Error");
	exit(1);
}



