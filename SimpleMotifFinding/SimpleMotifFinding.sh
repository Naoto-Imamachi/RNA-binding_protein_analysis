#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -soft -l ljob,lmem
#$ -l s_vmem=4G
#$ -l mem_req=4G

###Requisite###
##Software/Scripts##
#gtf2bed.pl
#D_make_3UTR_bed_format_data.pl
#Integrate_same_regions.py
#motif_finding_from_fasta.py
#Define_motif_sites_on_genome.py
#Define_motif_sites_on_transcriptome.py
#A_define_Representative_isoform_from_RNA-seq.py
#bedtools

##dataset##
#Refseq_gene_hg19_June_02_2014.gtf
#hg19.fa
#Predicted_Targets.hg19.bed (Predicted miRNA-binding sites by TargetScan v7.0)
#PUM1KD_isoform_exp.diff
#PUM1KD_gene_exp_RefSeq_result_mRNA.diff

###File_information###
GTFFile='Refseq_gene_hg19_June_02_2014.gtf'
GenomeFastaFile='/home/akimitsu/database/bowtie1_index/hg19.fa'
Motif='TGTAAATA,TGTATATA,TGTAGATA,TGTACATA'
MotifName='PUM_motif'
MotifLength='8'
miRNABedFile='Predicted_Targets.hg19.bed'

CuffdiffGeneResultData='./PUM1KD_gene_exp_RefSeq_result_mRNA.diff'
CuffdiffIsoformData='./PUM1KD_isoform_exp.diff'

###Change gtf to bed file###
Filename=`basename ${GTFFile} .gtf`
#./scripts/gtf2bed.pl ${Filename}.gtf > ${Filename}.bed

###Extract 3UTR region from bed12 file###
#perl ./scripts/D_make_3UTR_bed_format_data.pl ${Filename}.bed ${Filename}_3UTR.bed ${Filename}_non-3UTR.bed

###Convert bed12 file into fasta file using bedtools getfasta command###
#python3 ./scripts/Integrate_same_regions.py ${Filename}_3UTR.bed ${Filename}_3UTR_merged.bed
#bedtools getfasta -name -s -split -fi ${GenomeFastaFile} -bed ${Filename}_3UTR_merged.bed -fo ${Filename}_3UTR_merged.fa

###Find your motif from fasta file###
#python3 ./scripts/motif_finding_from_fasta.py ${Filename}_3UTR_merged.fa ${Motif} ${Filename}_3UTR_merged_${MotifName}.result
python3 ./scripts/Divide_motif_finding_data.py ${Filename}_3UTR_merged_${MotifName}.result ${Filename}_3UTR_merged_${MotifName}.txt 8

###Define motif sites on your genome###
#python3 ./scripts/Define_motif_sites_on_genome.py ${Filename}_3UTR_merged_${MotifName}.result ${MotifLength} ${Filename}_3UTR_merged.bed ${Filename}_3UTR_merged_${MotifName}.bed

###Define miRNA-binding sites on your transcriptome###
miRNAFilename=`basename ${miRNABedFile} .bed`
#bedtools intersect -a ${Filename}_3UTR_merged.bed -b ${miRNAFilename}.bed -wa -wb -split -s > ${miRNAFilename}_vs_${Filename}.txt
#python3 ./scripts/Define_motif_sites_on_transcriptome.py ${miRNAFilename}_vs_${Filename}.txt ${miRNAFilename}_trx_sites.txt

###Define representative isoform from RNA-seq data(Cuffdiff results)###
CuffdiffGeneFilename=`basename ${CuffdiffGeneResultData} .diff`
#python3 ./scripts/A_define_Representative_isoform_from_RNA-seq.py ${CuffdiffIsoformData} ${CuffdiffGeneFilename}.diff ${CuffdiffGeneFilename}_rep_isoform_list.txt

