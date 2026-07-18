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

    ##  [1] "most_severe_consequence"         "allele_string"                  
    ##  [3] "start"                           "end"                            
    ##  [5] "assembly_name"                   "id"                             
    ##  [7] "input"                           "transcript_consequences"        
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
    ##   consequence_terms regulatory_feature_id      biotype variant_allele   impact
    ## 1      regulato....          ENSR22_5.... CTCF_bin....              T MODIFIER

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
    ##         seqnames    ranges strand | most_severe_consequence
    ##            <Rle> <IRanges>  <Rle> |                  <list>
    ##     [1]       22  50300078      * |          intron_variant
    ##     [2]       22  50300086      * |          intron_variant
    ##     [3]       22  50300101      * |          intron_variant
    ##     [4]       22  50300113      * |          intron_variant
    ##     [5]       22  50300166      * |   splice_region_variant
    ##     ...      ...       ...    ... .                     ...
    ##    [96]       22  50304748      * |          intron_variant
    ##    [97]       22  50304805      * |          intron_variant
    ##    [98]       22  50304935      * |          intron_variant
    ##    [99]       22  50304943      * |          intron_variant
    ##   [100]       22  50305084      * |          intron_variant
    ##   -------
    ##   seqinfo: 1 sequence from an unspecified genome; no seqlengths

<div id="cb17" class="sourceCode">

``` r
names(mcols(tstg))
```

</div>

    ##  [1] "most_severe_consequence"         "allele_string"                  
    ##  [3] "assembly_name"                   "id"                             
    ##  [5] "input"                           "transcript_consequences"        
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
    ##    consequence_terms variant_allele strand gene_symbol      gene_id
    ## 1       intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 2       intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 3       intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 4       intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 5       intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 6       intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 7       intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 8       intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 9       intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 10      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 11      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 12      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 13      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 14      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 15      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 16      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 17      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 18      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 19      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 20      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 21      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 22      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 23      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 24      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 25      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 26      intron_v....              G     -1      PLXNB2 ENSG0000....
    ## 27      intron_v....              G     -1      PLXNB2 ENSG0000....
    ##    transcript_id gene_symbol_source   hgnc_id      biotype   impact      flags
    ## 1   ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 2   ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER cds_end_NF
    ## 3   ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER cds_end_NF
    ## 4   ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 5   ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 6   ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 7   ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 8   ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 9   ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 10  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 11  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 12  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 13  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 14  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 15  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 16  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 17  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 18  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 19  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 20  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 21  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 22  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 23  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 24  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 25  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 26  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER           
    ## 27  ENST0000....               HGNC HGNC:9104 protein_.... MODIFIER

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
