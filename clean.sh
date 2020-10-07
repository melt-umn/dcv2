#!/bin/bash

set -euxo pipefail

loudlyRm() {
	echo rm -f "$@"
	rm -f "$@"
}

loudlyRm build.xml
loudlyRm edu.umn.cs.melt.dcv2.compiler.jar
loudlyRm Parser_edu_umn_cs_melt_dcv2_compiler_parse.copperdump.html
