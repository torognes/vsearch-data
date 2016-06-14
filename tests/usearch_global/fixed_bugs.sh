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
    # exit -1
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

# Clean
rm "${QUERY}" "${DATABASE}" "${ALNOUT}"

#*****************************************************************************#
#                                                                             #
#     N-tails are converted to A-tails in consensus sequences (issue 181)     #
#                                                                             #
#*****************************************************************************#

DESCRIPTION="N-tails are preserved in consensus sequences (issue 181)"
USEARCH8="$(which usearch8)"
INPUT=$(mktemp)
PADDED=$(mktemp)
CENTROIDS=$(mktemp)
CONSENSUS=$(mktemp)
cat > ${INPUT} <<'EOT'
>seq1;size=1;
CGCCCGTCGCTACTACCGATTGAATGGCTTAGTGAGACCT
EOT

"${USEARCH8}" \
    -fastx_truncate ${INPUT}  \
    -trunclen 50 \
    -padlen 50 \
    -fastaout ${PADDED} > /dev/null 2> /dev/null

"${VSEARCH}" \
  --cluster_fast ${PADDED} \
  --id 0.97 \
  --centroids ${CENTROIDS} \
  --consout ${CONSENSUS} \
  --sizein \
  --sizeout \
  --fasta_width 0 > /dev/null 2> /dev/null

tail -n 1 ${CONSENSUS} | grep -E "N{10}$" && \
    success "${DESCRIPTION}" || \
        failure "${DESCRIPTION}"

## Clean
rm "${INPUT}" "${PADDED}" "${CENTROIDS}" "${CONSENSUS}"


#*****************************************************************************#
#                                                                             #
#                --query_cov and --userfield qcov (issue 182)                 #
#                                                                             #
#*****************************************************************************#

DESCRIPTION="query coverage filtering works (issue 182)"
QUERY=$(mktemp)
DATABASE=$(mktemp)
NOTMATCHED=$(mktemp)
USEROUT=$(mktemp)
ALN=$(mktemp)
COVERAGE="0.90"

cat > ${QUERY} <<'EOT'
>query
CTGGCTCAGG
EOT

cat > ${DATABASE} <<'EOT'
>target
CTGGCTCAGG
EOT

"${VSEARCH}" \
    --usearch_global ${QUERY} \
    --db ${DATABASE} \
    --notmatched ${NOTMATCHED} \
    --userout ${USEROUT} \
    --query_cov ${COVERAGE} \
    --alnout ${ALN} \
    --id 0.7 \
    --minseqlength 1 \
    --rowlen 80 \
    --output_no_hits \
    --userfields query+target+id+qcov > /dev/null 2> /dev/null

## query_cov: (matches + mismatches) / query sequence length. Internal or terminal gaps are not taken into account.

echo "userout"
[[ -s ${USEROUT} ]] && cat ${USEROUT}
echo "not matched"
[[ -s ${NOTMATCHED} ]] && cat ${NOTMATCHED}
echo "alignment"
[[ -s ${ALN} ]] && cat ${ALN}

## Clean
rm "${QUERY}" "${ALN}" "${NOTMATCHED}" "${USEROUT}"

exit 0
