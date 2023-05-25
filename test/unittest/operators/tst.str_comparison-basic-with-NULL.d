/*
 * Oracle Linux DTrace.
 * Copyright (c) 2021, 2023, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

/*
 * ASSERTION: String comparisons work.
 *
 * SECTION:  Operators
 */

#pragma D option quiet

BEGIN
{
	nerrors = 0;

	s1 = "abcdefghi";
	s2 = "jklmnopqr";
	s3 = "stuvwxyz!";

	/* Compare normal strings, where lhs < rhs */

	nerrors += (s1 <= s2 ? 0 : 1);
	nerrors += (s1 <  s2 ? 0 : 1);
	nerrors += (s1 == s2 ? 1 : 0);
	nerrors += (s1 != s2 ? 0 : 1);
	nerrors += (s1 >= s2 ? 1 : 0);
	nerrors += (s1 >  s2 ? 1 : 0);

	/* Compare normal strings, where lhs == rhs */

	nerrors += (s2 <= s2 ? 0 : 1);
	nerrors += (s2 <  s2 ? 1 : 0);
	nerrors += (s2 == s2 ? 0 : 1);
	nerrors += (s2 != s2 ? 1 : 0);
	nerrors += (s2 >= s2 ? 0 : 1);
	nerrors += (s2 >  s2 ? 1 : 0);

	/* Compare normal strings, where lhs > rhs */

	nerrors += (s3 <= s2 ? 1 : 0);
	nerrors += (s3 <  s2 ? 1 : 0);
	nerrors += (s3 == s2 ? 1 : 0);
	nerrors += (s3 != s2 ? 0 : 1);
	nerrors += (s3 >= s2 ? 0 : 1);
	nerrors += (s3 >  s2 ? 0 : 1);

	/* Compare strings, where one is NULL */

	s2 = NULL;
	nerrors += (s3 <= s2 ? 1 : 0);
	nerrors += (s3 <  s2 ? 1 : 0);
	nerrors += (s3 == s2 ? 1 : 0);
	nerrors += (s3 != s2 ? 0 : 1);
	nerrors += (s3 >= s2 ? 0 : 0);
	nerrors += (s3 >  s2 ? 0 : 0);

	nerrors += (s2 <= s3 ? 0 : 1);
	nerrors += (s2 <  s3 ? 0 : 1);
	nerrors += (s2 == s3 ? 1 : 0);
	nerrors += (s2 != s3 ? 0 : 1);
	nerrors += (s2 >= s3 ? 1 : 0);
	nerrors += (s2 >  s3 ? 1 : 0);

	/* Compare NULL and empty strings */

	s3 = "";
	nerrors += (s3 <= s2 ? 1 : 0);
	nerrors += (s3 <  s2 ? 1 : 0);
	nerrors += (s3 == s2 ? 1 : 0);
	nerrors += (s3 != s2 ? 0 : 1);
	nerrors += (s3 >= s2 ? 0 : 0);
	nerrors += (s3 >  s2 ? 0 : 0);

	nerrors += (s2 <= s3 ? 0 : 1);
	nerrors += (s2 <  s3 ? 0 : 1);
	nerrors += (s2 == s3 ? 1 : 0);
	nerrors += (s2 != s3 ? 0 : 1);
	nerrors += (s2 >= s3 ? 1 : 0);
	nerrors += (s2 >  s3 ? 1 : 0);

	/* Compare two NULL strings */

	s3 = NULL;
	nerrors += (s2 <= s3 ? 0 : 1);
	nerrors += (s2 <  s3 ? 1 : 0);
	nerrors += (s2 == s3 ? 0 : 1);
	nerrors += (s2 != s3 ? 1 : 0);
	nerrors += (s2 >= s3 ? 0 : 1);
	nerrors += (s2 >  s3 ? 1 : 0);

	printf("%d errors\n", nerrors);
	exit(nerrors == 0 ? 0 : 1);
}
ERROR
{
	exit(1);
}
