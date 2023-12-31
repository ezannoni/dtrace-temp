# Top-level makefile for dtrace.
#
# Build files in subdirectories are included by this file.
#
# Oracle Linux DTrace.
# Copyright (c) 2011, 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at
# http://oss.oracle.com/licenses/upl.

.DELETE_ON_ERROR:
.SUFFIXES:
.SECONDEXPANSION:

SHELL = /bin/bash

PROJECT := dtrace
VERSION := 2.0.0

# Verify supported hardware.

ARCH := $(shell uname -m)

$(if $(subst sparc64,,$(subst aarch64,,$(subst x86_64,,$(ARCH)))), \
    $(error "Error: DTrace for Linux only supports x86_64, ARM64 and sparc64"),)
$(if $(subst Linux,,$(shell uname -s)), \
    $(error "Error: DTrace only supports Linux"),)

CFLAGS ?= -O2 -Wall -pedantic -Wno-unknown-pragmas
LDFLAGS ?=
BITNESS := 64
NATIVE_BITNESS_ONLY := $(shell echo 'int main (void) { }' | gcc -x c -o /dev/null -m32 - 2>/dev/null || echo t)
ARCHINC := $(subst sparc64,sparc,$(subst aarch64,arm64,$(subst x86_64,i386,$(ARCH))))
INVARIANT_CFLAGS := -std=gnu99 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 $(if $(NATIVE_BITNESS_ONLY),-DNATIVE_BITNESS_ONLY) -D_DT_VERSION=\"$(VERSION)\"
CPPFLAGS += -Iinclude -Iuts/common -Iinclude/$(ARCHINC) -I$(objdir)

export CC = gcc
override CFLAGS += $(INVARIANT_CFLAGS)
PREPROCESS = $(CC) -E
export BPFC = bpf-unknown-none-gcc

BPFCPPFLAGS += -D$(subst sparc64,__sparc,$(subst aarch64,__aarch64__,$(subst x86_64,__amd64,$(ARCH))))
BPFCFLAGS ?= -O2 -Wall -Wno-unknown-pragmas
export BPFLD = bpf-unknown-none-ld

# The first non-system uid on this system.
USER_UID=$(shell grep '^UID_MIN' /etc/login.defs | awk '{print $$2;}')

# A uid suitable for unprivileged execution.
UNPRIV_UID ?= -3

# The group one must run as to invoke dumpcap: by default the group of
# the dumpcap binary.  If dumpcap is owned by root, use the same gid as
# the UNPRIV_UID unless otherwise overridden.
DUMPCAP_GROUP ?= $(filter-out root,$(shell stat -c %G /usr/sbin/dumpcap /usr/bin/dumpcap 2>/dev/null | head -1))

# Unwritable but readable directory suitable for overriding as the $HOME of
# unprivileged processes.
UNPRIV_HOME ?= /run/initramfs

# The substitution process in libdtrace needs kernel build trees for every
# kernel this userspace will be used with.  It only needs to know about major
# versions because to a first approximation the kernel-header-file #defines and
# data structures needed in translators do not change on a finer grain than
# that.  It also needs to know the name of the kernel architecture (as used in
# pathnames), and about the pieces of the pathname before and after the kernel
# version (so it can build include paths).

KERNELS=$(shell uname -r)
KERNELDIRPREFIX=/lib/modules
KERNELODIR=
# This allows you to build using a locally installed kernel built with O= by
# just specifying KERNELODIR=relative/path/to/your/kernel/o/dir.
KERNELDIRSUFFIX=$(if $(KERNELODIR),/source,/build)
KERNELARCH := $(subst sparc64,sparc,$(subst aarch64,arm64,$(subst x86_64,x86,$(ARCH))))

# Paths.

prefix = /usr
export objdir := $(abspath build)
LIBDIR := $(prefix)/lib$(BITNESS)
INSTLIBDIR := $(DESTDIR)$(LIBDIR)
BINDIR := $(prefix)/bin
INSTBINDIR := $(DESTDIR)$(BINDIR)
INCLUDEDIR := $(prefix)/include
INSTINCLUDEDIR := $(DESTDIR)$(INCLUDEDIR)
SBINDIR := $(prefix)/sbin
INSTSBINDIR := $(DESTDIR)$(SBINDIR)
UDEVDIR := $(prefix)/lib/udev/rules.d
INSTUDEVDIR := $(DESTDIR)$(UDEVDIR)
SYSTEMDUNITDIR := $(prefix)/lib/systemd/system
INSTSYSTEMDUNITDIR := $(DESTDIR)$(SYSTEMDUNITDIR)
DOCDIR := $(prefix)/share/doc/dtrace-$(VERSION)
INSTDOCDIR := $(DESTDIR)$(DOCDIR)
MANDIR := $(prefix)/share/man/man8
INSTMANDIR := $(DESTDIR)$(MANDIR)
TESTDIR := $(prefix)/lib$(BITNESS)/dtrace/testsuite
INSTTESTDIR := $(DESTDIR)$(TESTDIR)
TARGETS =

DTRACE ?= $(objdir)/dtrace

all::

# Include everything.

$(shell mkdir -p $(objdir))

include Makeoptions
include Makefunctions
include Makeconfig
-include $(objdir)/config.mk
include Build $(sort $(wildcard */Build))
-include $(objdir)/*.deps
include Makerules
include Maketargets
include Makecheck

# Tarball distribution.

PHONIES += dist

.git/index:

.git-version.tmp:  .git/index
	if [[ -f .git/index ]]; then \
		git log --no-walk --pretty=format:%H > .git-version.tmp; \
	else \
		cp .git-archive-version .git-version.tmp; \
	fi

.git-version: .git-version.tmp
	if test -r "$@" && cmp -s "$@" "$^"; then \
		rm -f "$^"; \
	else \
		printf "VERSION: .git-version\n"; \
		mv -f "$^" "$@"; \
	fi

dist::
	git archive --prefix=dtrace-$(VERSION)/ HEAD | bzip2 > dtrace-$(VERSION).tar.bz2

clean::
	rm -f .git-version

.PHONY: $(PHONIES)
