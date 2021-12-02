# Datasets for testing

AF091148.fsa is a tiny dataset with 180,704 nt in 1,403 seqs, from 103 to 137 nt (avg 129).

BioMarKs.fsa is a larger dataset with 119,117,805 nt in 312,503 seqs, from 2 to 532 nt (avg 381). It is compressed with gzip due to GitHub's 100MB file size limit.

constaint.fsa.bz2 - fasta file for constraint checking, i.e. special cases such as 2048-long reads that can break the code

PR2-18S-rRNA-V4.fsa is the older 18S rRNA V4 reference from PR2 (https://pr2-database.org/).

Rfam_9_1.fasta is a dataset with 33,931,362 nt in 192,445 seqs, from 20 to 1,250 nt (avg 176). It is Rfam release v9.1 (Gardner et al., 2009). It was used for USEARCH testing in Edgar's paper. Source: ftp://ftp.ebi.ac.uk/pub/databases/Rfam/9.1/Rfam.fasta.gz

Rfam_11_0.fasta is a dataset with 52,588,875 nt in 380,919 seqs, from 19 to 1,875 nt (avg 138). It is Rfam release v11.0 (Gardner et al., 2009). It was used for USEARCH testing (http://drive5.com/usearch/benchmark_rfam.html). Source: ftp://ftp.ebi.ac.uk/pub/databases/Rfam/11.0/Rfam.fasta.gz

### File sizes and hashes
```
[vsearch-data]$ du * -h
490K  AF091148.fsa
28M	  BioMarKs50k.fsa
20M   BioMarKs.fsa.bz2
33M   BioMarKs.fsa.gz
26K   constaint.fsa.bz2
46M   PR2-18S-rRNA-V4.derep.fsa
78M   PR2-18S-rRNA-V4.fsa
9.8M  PR2-18S-rRNA-V4.fsa.bz2
26K   README.md
109M  Rfam_11_0.fasta
714K  Rfam_11_0.repr.fasta
55M   Rfam_9_1.fasta
850K  simm.tar.gz

[vsearch-data]$ shasum *
ebee4c2de4a23d1c7736eb3d89cf7129fe329026  AF091148.fsa
44b30c8a54bf890e06b92c69119e64351700509c  BioMarKs50k.fsa
ffd3644f9a6873a442f95b39aece096b219b204e  BioMarKs.fsa.bz2
d3118ad981ef1123bbffa06eb8188b892fb355bb  BioMarKs.fsa.gz
5749244570054da35be18d5f9efc6c3f2b996d86  constaint.fsa.bz2
b129a00eb5bf9d8991ca0d30673dfab49ca892e7  PR2-18S-rRNA-V4.derep.fsa
a1f734bf54439f7113f89380f29f9eaa6f17fcbd  PR2-18S-rRNA-V4.fsa
b0a888538262cf17f0515b6de7b53001d04c5874  PR2-18S-rRNA-V4.fsa.bz2
5092c0b7b1089345ead49c24bed4c4c6329a2a53  README.md
3b76b92511bc434df202551bc8df4523b46923a2  Rfam_11_0.fasta
23e9dea3205a9ef472371350f26f2bec451e5a06  Rfam_11_0.repr.fasta
886ea6ddbf91664c8ef9ba92aacf859995689fdf  Rfam_9_1.fasta
3debe9b02e859ccf3feae10191dbe6810a78f524  simm.tar.gz
```


