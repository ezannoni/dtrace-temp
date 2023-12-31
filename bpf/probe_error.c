// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2021, 2022, Oracle and/or its affiliates. All rights reserved.
 */
#include <linux/bpf.h>
#include <stdint.h>
#include <bpf-helpers.h>
#include <dt_dctx.h>

#ifndef noinline
# define noinline	__attribute__((noinline))
#endif

extern int64_t dt_error(const dt_dctx_t *dctx);

/*
 * DTrace ERROR probes provide 6 arguments:
 *	arg0 = always NULL (used to be kernel consumer state pointer)
 *	arg1 = EPID of probe that triggered the fault
 *	arg2 = clause index of code that triggered the fault
 *	arg3 = BPF offset in the clause that triggered the fault (or -1)
 *	arg4 = fault type
 *	arg5 = fault-specific value (usually address being accessed or 0)
 */
noinline void dt_probe_error(const dt_dctx_t *dctx, uint64_t pc, uint64_t fault,
			     uint64_t illval)
{
	dt_mstate_t	*mst = dctx->mst;

	mst->argv[0] = 0;
	mst->argv[1] = mst->epid;
	mst->argv[2] = mst->clid;
	mst->argv[3] = pc;
	mst->argv[4] = fault;
	mst->argv[5] = illval;

	dt_error(dctx);

	mst->fault = fault;
}
