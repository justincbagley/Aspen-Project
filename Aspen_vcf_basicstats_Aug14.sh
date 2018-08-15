#!/bin/bash
#$ -N Aspen_popGenStat_run1
#$ -cwd
#$ -V
#$ -S /bin/bash
#$ -e Aspen_popGenStat_run1.err
#$ -o Aspen_popGenStat_run1.out


######################################## START ###########################################
echo "INFO      | $(date) | STEP #1: SETUP. "
	MY_PATH=`pwd -P`
	CR=$(printf '\r'); 
	calc () { 
	bc -l <<< "$@" 
}


############ Set up environment for using R on godel supercomputer:
export TMPDIR=~/tmp  ## Set temp file directory to be within $HOME.
export R_LIBS=$HOME/R
export LD_LIBRARY_PATH=/gpfs_fs/home/jcbagley/miniconda2/lib:$LD_LIBRARY_PATH



##########################################################################################
#
#  Population genetic statistics for Aspen genetic clusters (K=3 ADMIXTURE groups)                      
#
##########################################################################################

############ PAIRWISE FST.

## Calculate FST between populations using vcftools, including all possible pairs of the
## ADMIXTURE clusters (3 combinations, corresponding to 3 ADMIXTURE groups)
## First, make files containing lists of individuals in each cluster:
grep -h 'group1' ind_K3_group.txt | perl -pe 's/\tgroup.*//g' > cluster1.txt
grep -h 'group2' ind_K3_group.txt | perl -pe 's/\tgroup.*//g' > cluster2.txt
grep -h 'group3' ind_K3_group.txt | perl -pe 's/\tgroup.*//g' > cluster3.txt

vcftools --vcf AspenSNPs.33.5K_n183.vcf --weir-fst-pop cluster1.txt --weir-fst-pop cluster2.txt --out clust1_clust2_fst
vcftools --vcf AspenSNPs.33.5K_n183.vcf --weir-fst-pop cluster1.txt --weir-fst-pop cluster3.txt --out clust1_clust3_fst
vcftools --vcf AspenSNPs.33.5K_n183.vcf --weir-fst-pop cluster2.txt --weir-fst-pop cluster3.txt --out clust2_clust3_fst

cp clust1_clust2_fst.weir.fst clust1_clust2_fst.weir.fst.txt
cp clust1_clust3_fst.weir.fst clust1_clust3_fst.weir.fst.txt
cp clust2_clust3_fst.weir.fst clust2_clust3_fst.weir.fst.txt


############ SPLIT VCF BY REG AND NON-EDGE ADMIXTURE CLUSTER GROUPS.

## Separate merged vcf file into separate files per ADMIXTURE cluster/population to calculate inbreeding coefficient:
vcftools --gzvcf AspenSNPs.33.5K_n183.vcf.gz --keep cluster1.txt --recode --recode-INFO-all --out AspenSNPs.33.5K_n183_cluster1_SNPs
vcftools --gzvcf AspenSNPs.33.5K_n183.vcf.gz --keep cluster2.txt --recode --recode-INFO-all --out AspenSNPs.33.5K_n183_cluster2_SNPs
vcftools --gzvcf AspenSNPs.33.5K_n183.vcf.gz --keep cluster3.txt --recode --recode-INFO-all --out AspenSNPs.33.5K_n183_cluster3_SNPs

vcftools --gzvcf AspenSNPs.33.5K_n183.vcf.gz --keep cluster3_noOut.txt --recode --recode-INFO-all --out AspenSNPs.33.5K_n182_cluster3_SNPs


## Calculate inbreeding coefficient for each population:
vcftools --vcf AspenSNPs.33.5K_n183_cluster1_SNPs.recode.vcf --het --out cluster1_inbreeding
vcftools --vcf AspenSNPs.33.5K_n183_cluster2_SNPs.recode.vcf --het --out cluster2_inbreeding
vcftools --vcf AspenSNPs.33.5K_n183_cluster3_SNPs.recode.vcf --het --out cluster3_inbreeding

vcftools --vcf AspenSNPs.33.5K_n182_cluster3_SNPs.recode.vcf --het --out cluster3_n89_inbreeding



############ TRANSITION/TRANSVERSION RATIO - FULL AND NO-OUT DATASETS.

## Calculate Transition/Transversion ratio:
vcftools --vcf AspenSNPs.33.5K_n183.vcf --TsTv-summary --out transition_transversion_ratio


## Full n=182 vcf file (no outgroup Nisqualley sample), and its Ts/Tv ratio:
vcftools --gzvcf AspenSNPs.33.5K_n183.vcf.gz --remove outgroup.txt --recode --recode-INFO-all --out AspenSNPs.33.5K_n182
#
cp AspenSNPs.33.5K_n182.recode.vcf AspenSNPs.33.5K_n182.vcf
#
vcftools --vcf AspenSNPs.33.5K_n182.vcf --TsTv-summary --out transition_transversion_ratio








