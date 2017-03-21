#!/bin/sh

set -e;

silver -o dcv2.jar $@ edu:umn:cs:melt:dcv2:compiler;
silver -o dcv2-monto.jar $@ edu:umn:cs:melt:dcv2:monto;
