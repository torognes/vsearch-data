#!/bin/bash -

## Print a header
SCRIPT_NAME="Fasta parsing"
line=$(printf "%076s\n" | tr " " "-")
printf "# %s %s\n" "${line:${#SCRIPT_NAME}}" "${SCRIPT_NAME}"

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
#               Fastq valid and invalid examples (Cocks, 2010)                #
#                                                                             #
#*****************************************************************************#

## Find the absolute path to the fastq file suite
path=$(pwd)
path=${path/vsearch-data*/vsearch-data\/fastq-test-suite\/}

## Return status should be zero (success)
find "${path}" -name "*.fastq" ! -name "error*" -print | \
    while read f ; do
        DESCRIPTION="vsearch: $(basename ${f}) is a valid file"
        "${VSEARCH}" --fastq_chars "${f}" 2> /dev/null > /dev/null && \
            success  "${DESCRIPTION}" || \
                failure "${DESCRIPTION}"
    done

## Return status should be !zero (failure)
find "${path}" -name "error*.fastq" -print | \
    while read f ; do
        DESCRIPTION="vsearch: $(basename ${f}) is an invalid file"
        "${VSEARCH}" --fastq_chars "${f}" 2> /dev/null > /dev/null && \
            failure "${DESCRIPTION}" || \
                success  "${DESCRIPTION}"
    done


exit 0
