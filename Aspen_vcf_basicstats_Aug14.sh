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

vcftools --vcf AspenSNPs.33.5K_n182.vcf --weir-fst-pop cluster1.txt --weir-fst-pop cluster2_noEdge.txt --out clust1_clust2_fst
vcftools --vcf AspenSNPs.33.5K_n182.vcf --weir-fst-pop cluster1.txt --weir-fst-pop cluster3_noOut_noEdge.txt --out clust1_clust3_fst
vcftools --vcf AspenSNPs.33.5K_n182.vcf --weir-fst-pop cluster2_noEdge.txt --weir-fst-pop cluster3_noOut_noEdge.txt --out clust2_clust3_fst

cp clust1_clust2_fst.weir.fst clust1_clust2_fst.weir.fst.txt
cp clust1_clust3_fst.weir.fst clust1_clust3_fst.weir.fst.txt
cp clust2_clust3_fst.weir.fst clust2_clust3_fst.weir.fst.txt


############ TRANSITION/TRANSVERSION RATIO.

## Calculate Transition/Transversion ratio:
vcftools --vcf AspenSNPs.33.5K_n182.vcf --TsTv-summary --out transition_transversion_ratio


############ NEW NON-EDGE VCF FILES.

## Remake cluster 2 and cluster 3 vcf files while using lists that exclude edge population individuals:
vcftools --gzvcf AspenSNPs.33.5K_n183.vcf.gz --keep cluster2_noEdge.txt --recode --recode-INFO-all --out AspenSNPs.33.5K_n182_cluster2_SNPs
vcftools --gzvcf AspenSNPs.33.5K_n183.vcf.gz --keep cluster3_noOut_noEdge.txt --recode --recode-INFO-all --out AspenSNPs.33.5K_n182_cluster3_SNPs


############ NON-EDGE INBREEDING F CALCULATIONS.

## Calculate inbreeding coefficient for each population:
vcftools --vcf AspenSNPs.33.5K_n183_cluster1_SNPs.recode.vcf --het --out cluster1_inbreeding
#vcftools --vcf AspenSNPs.33.5K_n183_cluster2_SNPs.recode.vcf --het --out cluster2_inbreeding
#vcftools --vcf AspenSNPs.33.5K_n182_cluster3_SNPs.recode.vcf --het --out cluster3_n89_inbreeding

vcftools --vcf AspenSNPs.33.5K_n182_cluster2_SNPs.recode.vcf --het --out cluster2_noEdge_inbreeding
vcftools --vcf AspenSNPs.33.5K_n182_cluster3_SNPs.recode.vcf --het --out cluster3_noEdge_inbreeding

cp cluster1_inbreeding.het cluster1_inbreeding.het.txt
cp cluster2_noEdge_inbreeding.het cluster2_noEdge_inbreeding.het.txt
cp cluster3_noEdge_inbreeding.het cluster3_noEdge_inbreeding.het.txt


############ NEW OVERALL NON-EDGE vs. EDGE VCF DATASETS AND STATISTICS.

## Make new vcf file containing only non-edge populations/indivs:
vcftools --vcf AspenSNPs.33.5K_n182.vcf --keep clust1-3_n166_noEdge.txt --recode --out AspenSNPs.33.5K_n166_noEdge
cp AspenSNPs.33.5K_n166_noEdge.recode.vcf AspenSNPs.33.5K_n166_noEdge.vcf

## Make new vcf file containing only edge (admixed) populations/indivs:
vcftools --vcf AspenSNPs.33.5K_n182.vcf --remove clust1-3_n166_noEdge.txt --recode --out AspenSNPs.33.5K_n16_edge
cp AspenSNPs.33.5K_n16_edge.recode.vcf AspenSNPs.33.5K_n16_edge.vcf

## Calculate inbreeding coefficient for non-edge vs. edge datasets:
vcftools --vcf AspenSNPs.33.5K_n166_noEdge.vcf --het --out n166_noEdge_inbreeding
cp n166_noEdge_inbreeding.het n166_noEdge_inbreeding.het.txt

vcftools --vcf AspenSNPs.33.5K_n16_edge.vcf --het --out n16_edge_inbreeding
cp n16_edge_inbreeding.het n16_edge_inbreeding.het.txt




