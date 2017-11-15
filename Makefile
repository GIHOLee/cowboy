# See LICENSE for licensing information.

PROJECT = cowboy
PROJECT_DESCRIPTION = Small, fast, modern HTTP server.
PROJECT_VERSION = 2.1.0
PROJECT_REGISTERED = cowboy_clock

# Options.

COMPILE_FIRST = cowboy_middleware cowboy_stream cowboy_sub_protocol
PLT_APPS = public_key ssl
CT_OPTS += -ct_hooks cowboy_ct_hook [] # -boot start_sasl

# Dependencies.

LOCAL_DEPS = crypto

DEPS = cowlib ranch
dep_cowlib = git https://github.com/ninenines/cowlib master
dep_ranch = git https://github.com/ninenines/ranch 1.4.0

DOC_DEPS = asciideck

TEST_DEPS = ct_helper gun
dep_ct_helper = git https://github.com/extend/ct_helper master
dep_gun = git https://github.com/ninenines/gun master

# CI configuration.

BUILD_DEPS = ci.erlang.mk
dep_ci.erlang.mk = git https://github.com/ninenines/ci.erlang.mk master
DEP_EARLY_PLUGINS = ci.erlang.mk

AUTO_CI_OTP ?= OTP-19+
AUTO_CI_HIPE ?= OTP-LATEST
# AUTO_CI_ERLLVM ?= OTP-LATEST

# Standard targets.

include erlang.mk

# Compile options.

ERLC_OPTS += +warn_export_all +warn_missing_spec +warn_untyped_record
TEST_ERLC_OPTS += +'{parse_transform, eunit_autoexport}'

# Generate rebar.config on build.

app:: rebar.config

# Also dialyze the tests.

# DIALYZER_OPTS += --src -r test

# Use erl_make_certs from the tested release.

ci-setup:: clean deps test-deps
	$(gen_verbose) cp ~/.kerl/builds/$(CI_OTP_RELEASE)/otp_src_git/lib/ssl/test/erl_make_certs.erl deps/ct_helper/src/
