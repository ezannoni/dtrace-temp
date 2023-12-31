/*
 * Oracle Linux DTrace.
 * Copyright (c) 2011, 2022, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at
 * http://oss.oracle.com/licenses/upl.
 */

#ifndef DTRACE_SYS_TYPES_H
#define DTRACE_SYS_TYPES_H

#include <sys/types.h>
#include <stdint.h>
#include <endian.h>
#include <unistd.h>

typedef enum { B_FALSE, B_TRUE} boolean_t;

/*
 * POSIX Extensions
 */
typedef unsigned char	uchar_t;
typedef unsigned short	ushort_t;
typedef unsigned int	uint_t;
typedef unsigned long	ulong_t;


typedef long long      offset_t;

typedef unsigned long long hrtime_t;

#define	SHT_SUNW_dof		0x6ffffff4

#define	STV_ELIMINATE	6

/*
 * This is unnecessary on OEL6, but necessary on the snapshot build host, which
 * runs OEL5.
 */
#if !defined(PN_XNUM)
#define PN_XNUM 0xffff		        /* extended program header index */
#endif


/*
 *      Definitions for commonly used resolutions.
 */
#define SEC             1
#define MILLISEC        1000
#define MICROSEC        1000000
#define NANOSEC         1000000000

#define SIG2STR_MAX     32

#ifndef ABS
#define	ABS(a)		((a) < 0 ? -(a) : (a))
#endif

#if __BYTE_ORDER == __LITTLE_ENDIAN
#define _LITTLE_ENDIAN 1
#elif __BYTE_ORDER == __BIG_ENDIAN
#define _BIG_ENDIAN 1
#else
#warning Unknown endianness
#endif

/*
 * return x rounded up to an alignment boundary
 * eg, P2ROUNDUP(0x1234, 0x100) == 0x1300 (0x13*align)
 * eg, P2ROUNDUP(0x5600, 0x100) == 0x5600 (0x56*align)
 */
#define P2ROUNDUP(x, align)	(-(-(x) & -(align)))

/*
 * This comes from <linux/dtrace_os.h>.
 */

typedef uint32_t dtrace_id_t;

#endif
