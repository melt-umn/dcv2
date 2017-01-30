#!/bin/sh

set -e;

loudlyRm() {
	echo rm -f $@;
	rm -f $@;
};

loudlyRm build.xml;
loudlyRm dcv2.jar;
loudlyRm Parser_edu_umn_cs_melt_dcv2_compiler_parse.copperdump.html;
