<div id="main" class="col-md-9" role="main">

# ensemblVEP: using the REST API with Bioconductor

    ## Warning: package 'BiocGenerics' was built under R version 4.6.1

    ## Warning: package 'GenomicRanges' was built under R version 4.6.1

    ## Warning: package 'Biostrings' was built under R version 4.6.1

<div class="section level2">

## Introduction

Ensembl’s Variant Effect Predictor is described in McLaren et al.
(2016).

Prior to Bioconductor 3.19, the ensemblVEP package provided access to
Ensembl’s predictions through an interface between Perl and MySQL.

In 3.19 VariantAnnotation supports the use of the VEP component of the
REST API at [https://rest.ensembl.org](https://rest.ensembl.org/).

</div>

<div class="section level2">

## Acquire annotation on variants from a VCF file

The function `vep_by_region` will accept a VCF object as defined in
*[VariantAnnotation](https://bioconductor.org/packages/3.24/VariantAnnotation)*.

<div id="cb4" class="sourceCode">

``` r
library(VariantAnnotation)
fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
r22 = readVcf(fl)
r22
```

</div>

    ## class: CollapsedVCF 
    ## dim: 10376 5 
    ## rowRanges(vcf):
    ##   GRanges with 5 metadata columns: paramRangeID, REF, ALT, QUAL, FILTER
    ## info(vcf):
    ##   DataFrame with 22 columns: LDAF, AVGPOST, RSQ, ERATE, THETA, CIEND, CIPOS,...
    ## info(header(vcf)):
    ##              Number Type    Description                                        
    ##    LDAF      1      Float   MLE Allele Frequency Accounting for LD             
    ##    AVGPOST   1      Float   Average posterior probability from MaCH/Thunder    
    ##    RSQ       1      Float   Genotype imputation quality from MaCH/Thunder      
    ##    ERATE     1      Float   Per-marker Mutation rate from MaCH/Thunder         
    ##    THETA     1      Float   Per-marker Transition rate from MaCH/Thunder       
    ##    CIEND     2      Integer Confidence interval around END for imprecise var...
    ##    CIPOS     2      Integer Confidence interval around POS for imprecise var...
    ##    END       1      Integer End position of the variant described in this re...
    ##    HOMLEN    .      Integer Length of base pair identical micro-homology at ...
    ##    HOMSEQ    .      String  Sequence of base pair identical micro-homology a...
    ##    SVLEN     1      Integer Difference in length between REF and ALT alleles   
    ##    SVTYPE    1      String  Type of structural variant                         
    ##    AC        .      Integer Alternate Allele Count                             
    ##    AN        1      Integer Total Allele Count                                 
    ##    AA        1      String  Ancestral Allele, ftp://ftp.1000genomes.ebi.ac.u...
    ##    AF        1      Float   Global Allele Frequency based on AC/AN             
    ##    AMR_AF    1      Float   Allele Frequency for samples from AMR based on A...
    ##    ASN_AF    1      Float   Allele Frequency for samples from ASN based on A...
    ##    AFR_AF    1      Float   Allele Frequency for samples from AFR based on A...
    ##    EUR_AF    1      Float   Allele Frequency for samples from EUR based on A...
    ##    VT        1      String  indicates what type of variant the line represents 
    ##    SNPSOURCE .      String  indicates if a snp was called when analysing the...
    ## geno(vcf):
    ##   List of length 3: GT, DS, GL
    ## geno(header(vcf)):
    ##       Number Type   Description                      
    ##    GT 1      String Genotype                         
    ##    DS 1      Float  Genotype dosage from MaCH/Thunder
    ##    GL G      Float  Genotype Likelihoods

In this example we confine attention to single nucleotide variants.

There is a limit of 200 locations in a request, and 55000 requests per
hour. We’ll base our query on 100 positions in the chr22 VCF.

<div id="cb6" class="sourceCode">

``` r
dr = which(width(rowRanges(r22))!=1)
r22s = r22[-dr]
res = vep_by_region(r22[1:100], snv_only=FALSE, chk_max=FALSE)
jans = toJSON(content(res))
```

</div>

There are various ways to work with the result of this query to the API.
We’ll use the
*[rjsoncons](https://CRAN.R-project.org/package=rjsoncons)* JSON
processing infrastructure to dig in and understand aspects of the API
behavior.

First, the top-level concepts produced for each variant can be retrieved
using

<div id="cb7" class="sourceCode">

``` r
library(rjsoncons)
names(jsonlite::fromJSON(jmespath(jans, "[*]")))
```

</div>

    ##  [1] "assembly_name"                   "most_severe_consequence"        
    ##  [3] "start"                           "input"                          
    ##  [5] "transcript_consequences"         "end"                            
    ##  [7] "id"                              "allele_string"                  
    ##  [9] "strand"                          "seq_region_name"                
    ## [11] "colocated_variants"              "motif_feature_consequences"     
    ## [13] "regulatory_feature_consequences"

Annotation of the most severe consequence known will typically be of
interest:

<div id="cb9" class="sourceCode">

``` r
table(jsonlite::fromJSON(jmespath(jans, "[*].most_severe_consequence")))
```

</div>

    ## 
    ##   5_prime_UTR_variant        intron_variant splice_region_variant 
    ##                    22                    76                     2

There is variability in the structure of data returned for each query.

<div id="cb11" class="sourceCode">

``` r
head(fromJSON(jmespath(jans, "[*].regulatory_feature_consequences")))
```

</div>

    ## [[1]]
    ##   variant_allele      biotype   impact regulatory_feature_id consequence_terms
    ## 1              T CTCF_bin.... MODIFIER          ENSR22_5....      regulato....

Furthermore, the content of the motif feature consequences field seems
very peculiar.

<div id="cb13" class="sourceCode">

``` r
table(unlist(fromJSON(jmespath(jans, "[*].motif_feature_consequences"))))
```

</div>

    ## 
    ##                  -0.018                      -1                       0 
    ##                       1                       2                       4 
    ##                       1                      13                       2 
    ##                       3                       1                       1 
    ##                       4                       5                       7 
    ##                       1                       1                       1 
    ##                       A         ENSM00000606562         ENSM00000606563 
    ##                       1                       1                       1 
    ##         ENSM00000606566         ENSM00000606569              ENSPFM0109 
    ##                       2                       1                       1 
    ##              ENSPFM0290              ENSPFM0357                       G 
    ##                       2                       2                       4 
    ##                   HNF4A                MODIFIER                       N 
    ##                       2                       5                       3 
    ##                   NR2F1                    RXRA                     SP1 
    ##                       2                       2                       2 
    ##                   TBX21 TF_binding_site_variant                       Y 
    ##                       1                       5                       2

</div>

<div class="section level2">

## Transforming the API response to GRanges

We’ll consider the following approach to converting the API response to
a GenomicRanges GRanges instance. Eventually this may become part of the
package.

<div id="cb15" class="sourceCode">

``` r
library(GenomicRanges)
.make_GRanges = function( vep_response ) {
  stopifnot(inherits(vep_response, "response"))  # httr
  nested = fromJSON(toJSON(content(vep_response)))
  ini = GRanges(seqnames = unlist(nested$seq_region_name),
    IRanges(start=unlist(nested$start), end=unlist(nested$end)))
  dr = match(c("seq_region_name", "start", "end"), names(nested))
  mcols(ini) = DataFrame(nested[,-dr])
  ini
}
tstg = .make_GRanges( res )
tstg[,1]  # full print is unwieldy
```

</div>

    ## GRanges object with 100 ranges and 1 metadata column:
    ##         seqnames    ranges strand | assembly_name
    ##            <Rle> <IRanges>  <Rle> |        <list>
    ##     [1]       22  50300078      * |        GRCh38
    ##     [2]       22  50300086      * |        GRCh38
    ##     [3]       22  50300101      * |        GRCh38
    ##     [4]       22  50300113      * |        GRCh38
    ##     [5]       22  50300166      * |        GRCh38
    ##     ...      ...       ...    ... .           ...
    ##    [96]       22  50304748      * |        GRCh38
    ##    [97]       22  50304805      * |        GRCh38
    ##    [98]       22  50304935      * |        GRCh38
    ##    [99]       22  50304943      * |        GRCh38
    ##   [100]       22  50305084      * |        GRCh38
    ##   -------
    ##   seqinfo: 1 sequence from an unspecified genome; no seqlengths

<div id="cb17" class="sourceCode">

``` r
names(mcols(tstg))
```

</div>

    ##  [1] "assembly_name"                   "most_severe_consequence"        
    ##  [3] "input"                           "transcript_consequences"        
    ##  [5] "id"                              "allele_string"                  
    ##  [7] "strand"                          "colocated_variants"             
    ##  [9] "motif_feature_consequences"      "regulatory_feature_consequences"

Now information about variants can be retrieved with range operations.
Deep annotation requires nested structure of the metadata columns.

<div id="cb19" class="sourceCode">

``` r
mcols(tstg)[1, "transcript_consequences"]
```

</div>

    ## [[1]]
    ##      impact variant_allele      gene_id gene_symbol transcript_id
    ## 1  MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 2  MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 3  MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 4  MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 5  MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 6  MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 7  MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 8  MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 9  MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 10 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 11 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 12 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 13 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 14 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 15 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 16 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 17 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 18 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 19 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 20 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 21 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 22 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 23 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 24 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 25 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 26 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ## 27 MODIFIER              G ENSG0000....      PLXNB2  ENST0000....
    ##    gene_symbol_source      biotype   hgnc_id strand consequence_terms
    ## 1                HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 2                HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 3                HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 4                HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 5                HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 6                HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 7                HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 8                HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 9                HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 10               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 11               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 12               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 13               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 14               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 15               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 16               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 17               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 18               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 19               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 20               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 21               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 22               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 23               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 24               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 25               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 26               HGNC protein_.... HGNC:9104     -1      intron_v....
    ## 27               HGNC protein_.... HGNC:9104     -1      intron_v....
    ##         flags
    ## 1            
    ## 2  cds_end_NF
    ## 3  cds_end_NF
    ## 4            
    ## 5            
    ## 6            
    ## 7            
    ## 8            
    ## 9            
    ## 10           
    ## 11           
    ## 12           
    ## 13           
    ## 14           
    ## 15           
    ## 16           
    ## 17           
    ## 18           
    ## 19           
    ## 20           
    ## 21           
    ## 22           
    ## 23           
    ## 24           
    ## 25           
    ## 26           
    ## 27

</div>

<div class="section level2">

## Further work

An important element of prior work in ensemblVEP supports feeding
annotation back into the VCF used to generate the effect prediction
query. This seems feasible but concrete use cases are of interest.

</div>

<div class="section level2">

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-McLaren2016" class="csl-entry">

McLaren, William, Laurent Gil, Sarah E. Hunt, Harpreet Singh Riat,
Graham R. S. Ritchie, Anja Thormann, Paul Flicek, and Fiona Cunningham.
2016. “The Ensembl Variant Effect Predictor.” *Genome Biology* 17 (1):
122. <https://doi.org/10.1186/s13059-016-0974-4>.

</div>

</div>

</div>

</div>
