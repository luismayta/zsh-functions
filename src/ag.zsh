#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# agr - Replace value by new value using silver search
function agr {
    ag --hidden --ignore=.git -0 -l "${1}" \
        | AGR_FROM="${1}" AGR_TO="${2}" xargs -0 perl -pi -e 's/$ENV{AGR_FROM}/$ENV{AGR_TO}/g';
}
