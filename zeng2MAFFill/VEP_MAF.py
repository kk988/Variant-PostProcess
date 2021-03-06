class VEP_MAF(object):
    fields=[
            "Hugo_Symbol","Entrez_Gene_Id","Center","NCBI_Build","Chromosome",
            "Start_Position","End_Position","Strand","Variant_Classification","Variant_Type",
            "Reference_Allele","Tumor_Seq_Allele1","Tumor_Seq_Allele2","dbSNP_RS","dbSNP_Val_Status",
            "Tumor_Sample_Barcode","Matched_Norm_Sample_Barcode","Match_Norm_Seq_Allele1","Match_Norm_Seq_Allele2","Tumor_Validation_Allele1",
            "Tumor_Validation_Allele2","Match_Norm_Validation_Allele1","Match_Norm_Validation_Allele2","Verification_Status","Validation_Status",
            "Mutation_Status","Sequencing_Phase","Sequence_Source","Validation_Method","Score",
            "BAM_File","Sequencer","Tumor_Sample_UUID","Matched_Norm_Sample_UUID","HGVSc",
            "HGVSp","HGVSp_Short","Transcript_ID","Exon_Number","t_depth",
            "t_ref_count","t_alt_count","n_depth","n_ref_count","n_alt_count",
            "all_effects","Allele","Gene","Feature","Feature_type",
            "Consequence","cDNA_position","CDS_position","Protein_position","Amino_acids",
            "Codons","Existing_variation","ALLELE_NUM","DISTANCE","STRAND",
            "SYMBOL","SYMBOL_SOURCE","HGNC_ID","BIOTYPE","CANONICAL",
            "CCDS","ENSP","SWISSPROT","TREMBL","UNIPARC",
            "RefSeq","SIFT","PolyPhen","EXON","INTRON",
            "DOMAINS","GMAF","AFR_MAF","AMR_MAF","ASN_MAF",
            "EUR_MAF","AA_MAF","EA_MAF","CLIN_SIG","SOMATIC",
            "PUBMED","MOTIF_NAME","MOTIF_POS","HIGH_INF_POS","MOTIF_SCORE_CHANGE",
            "Caller"
        ]
    @classmethod
    def header(cls):
        return "\t".join(cls.fields)
    @classmethod
    def addFields(cls,newFields):
        cls.fields.extend(newFields)
    def __init__(self, kw):
        for fi in VEP_MAF.fields:
            self.__dict__[fi]=""
        self.Center="bic.mskcc.org"
        self.NCBI_Build="hg19"
        for ki in kw:
            self.__dict__[ki]=kw[ki]
    def __str__(self):
        return "\t".join([str(self.__dict__[fi]) for fi in VEP_MAF.fields])
