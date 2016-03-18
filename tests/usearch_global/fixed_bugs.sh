#!/bin/bash -

## Print a header
SCRIPT_NAME="Fixed bugs"
LINE=$(printf "%076s\n" | tr " " "-")
printf "# %s %s\n" "${LINE:${#SCRIPT_NAME}}" "${SCRIPT_NAME}"

## Declare a color code for test results
RED="\033[1;31m"
GREEN="\033[1;32m"
NO_COLOR="\033[0m"

failure () {
    printf "${RED}FAIL${NO_COLOR}: ${1}\n"
    exit -1
}

success () {
    printf "${GREEN}PASS${NO_COLOR}: ${1}\n"
}

## Is vsearch installed?
VSEARCH=$(which vsearch)
DESCRIPTION="check if vsearch is in the PATH"
[[ "${VSEARCH}" ]] && success "${DESCRIPTION}" || failure "${DESCRIPTION}"

#*****************************************************************************#
#                                                                             #
#               Segmentation fault with empty query (issue 171)               #
#                                                                             #
#*****************************************************************************#

DESCRIPTION="no segmentation fault when a query is empty (issue 171)"
QUERY=$(mktemp)
DATABASE=$(mktemp)
ALNOUT=$(mktemp)
SEQ="GTCGCTACTACCGATTGAACGTTTTAGTGAGGTCCTCGGACTGTTTGGTAGTCGGATCACTCTGACTGCCTGG"
printf ">seq1\n\n" ${SEQ} > "${QUERY}"
printf ">ref1\n%s\n" ${SEQ} > "${DATABASE}"

"${VSEARCH}" \
    --usearch_global "${QUERY}" \
    -db "${DATABASE}" \
    --alnout "${ALNOUT}" \
    --id 0.97 --quiet && \
    success "${DESCRIPTION}" || \
        failure "${DESCRIPTION}"


## Clean
rm "${QUERY}" "${DATABASE}" "${ALNOUT}"

exit 0
