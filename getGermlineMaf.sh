#!/bin/bash

SDIR="$( cd "$( dirname "$0" )" && pwd )"

VEPPATH=/opt/common/CentOS_6/vep/v79
GENOME=/common/data/assemblies/H.sapiens/hg19/hg19.fasta
BEDTOOLS=/opt/common/CentOS_6/bedtools/bedtools-2.22.0/bin/bedtools

PROJECT=$1
VCF=$2
TDIR=$3

if [ ! -f "$TDIR/$(basename $GENOME)" ]; then
	ln -s $GENOME $TDIR/$(basename $GENOME)
fi

if [ ! -f "$TDIR/germline.maf0" ]; then
    echo "Generating MAF0"
    $SDIR/vcf2maf0.py -c haplotypecaller -i $VCF -o $TDIR/germline.maf0
fi
echo "MAF0 ready"

$SDIR/pA_GermlineV2.py  <$TDIR/germline.maf0 >$TDIR/germline.maf1
$SDIR/oldMAF2tcgaMAF.py hg19 $TDIR/germline.maf1 $TDIR/germline.maf2

if [ ! -f "$TDIR/germline.maf2.vep" ]; then
    /opt/common/CentOS_6/bin/v1/perl /opt/common/CentOS_6/vcf2maf/v1.5.2/maf2maf.pl \
    --vep-forks 12 \
    --tmp-dir /scratch/socci \
    --vep-path $VEPPATH \
    --vep-data $VEPPATH \
    --ref-fasta $TDIR/$(basename $GENOME) \
    --retain-cols Center,Verification_Status,Validation_Status,Mutation_Status,Sequencing_Phase,Sequence_Source,Validation_Method,Score,BAM_file,Sequencer,Tumor_Sample_UUID,Matched_Norm_Sample_UUID,Caller \
    --input-maf $TDIR/germline.maf2 \
    --output-maf $TDIR/germline.maf2.vep
fi

echo "MAF2.VEP ready"

cat $TDIR/germline.maf2.vep \
    | egrep -v "(^#|^Hugo_Symbol)" \
    | awk '{print $5,$6-1,$7}' \
    | tr ' ' '\t'  >$TDIR/germline.maf2.bed

$BEDTOOLS slop -g ~/lib/bedtools/genomes/human.hg19.genome -b 1 -i $TDIR/germline.maf2.bed \
    | $BEDTOOLS getfasta -tab \
    -fi $GENOME -fo $TDIR/germline.maf2.seq -bed -

$BEDTOOLS intersect -a $TDIR/germline.maf2.bed \
    -b /ifs/data/socci/Work/SeqAna/Db/Target/hg19/IMPACT_410_hg19/IMPACT_410_hg19_targets.bed -wa \
    | $BEDTOOLS sort -i - | awk '{print $1":"$2+1"-"$3}' | uniq >$TDIR/germline.maf2.impact410

$SDIR/mkTaylorMAF.py $TDIR/germline.maf2.seq $TDIR/germline.maf2.impact410 $TDIR/germline.maf2.vep \
    > ${PROJECT}___GERMLINE.vep.maf

