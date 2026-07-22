<div id="main" class="col-md-9" role="main">

# Quick Start: VariantAnnotation Function Categories

<div class="section level2">

## Overview

This vignette reviews the main function categories of the
`VariantAnnotation` package using the bundled `chr22.vcf.gz` example
file. For deeper coverage see `vignette("DetailedView")`,
`vignette("filterVcf")`, and `vignette("ensemblVEP")`.

</div>

<div class="section level2">

## Installation and startup

Use `BiocManager::install("VariantAnnotation")` to install this package
in a current version of R. Once installed, code in this vignette can be
run after the following commands are used:

<div id="cb1" class="sourceCode">

``` r
library(VariantAnnotation)
library(IRanges)
fl <- system.file("extdata", "chr22.vcf.gz", package = "VariantAnnotation")
```

</div>

</div>

<div class="section level2">

## VCF I/O

Read, write, scan, and filter VCF files. `ScanVcfParam` controls which
chromosomal regions, samples, and fields are loaded.

<div id="cb2" class="sourceCode">

``` r
vcf <- readVcf(fl, genome = "hg19")
vcf
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

<div id="cb4" class="sourceCode">

``` r
dest <- tempfile(fileext = ".vcf")
writeVcf(vcf, dest)

## Filter to variants with QUAL > 100 and read back to confirm reduced records
filt_dest <- tempfile(fileext = ".vcf.gz")
filterVcf(fl, genome = "hg19", destination = filt_dest,
          filters = FilterRules(list(
              minQ = function(x) !is.na(fixed(x)$QUAL) & fixed(x)$QUAL > 100)))
vcf_filt <- readVcf(filt_dest, genome = "hg19")
dim(vcf_filt)
```

</div>

    ## [1] 339   5

Key functions: `readVcf`, `writeVcf`, `scanVcf`, `scanVcfHeader`,
`filterVcf`, `indexVcf`, `VcfFile`, `ScanVcfParam`

</div>

<div class="section level2">

## VCF Data Structures and Accessors

`CollapsedVCF` (one row per variant, multi-allelic ALT stored as list)
and `ExpandedVCF` (one row per allele) form the core data model.

<div id="cb6" class="sourceCode">

``` r
ref(vcf)[1:4]
```

</div>

    ## DNAStringSet object of length 4:
    ##     width seq
    ## [1]     1 A
    ## [2]     1 C
    ## [3]     1 G
    ## [4]     1 C

<div id="cb8" class="sourceCode">

``` r
alt(vcf)[1:4]
```

</div>

    ## DNAStringSetList of length 4
    ## [[1]] G
    ## [[2]] T
    ## [[3]] A
    ## [[4]] T

<div id="cb10" class="sourceCode">

``` r
info(vcf)[1:4, 1:4]
```

</div>

    ## DataFrame with 4 rows and 4 columns
    ##                  LDAF   AVGPOST       RSQ     ERATE
    ##             <numeric> <numeric> <numeric> <numeric>
    ## rs7410291      0.3431    0.9890    0.9856     2e-03
    ## rs147922003    0.0091    0.9963    0.8398     5e-04
    ## rs114143073    0.0098    0.9891    0.5919     7e-04
    ## rs141778433    0.0062    0.9950    0.6756     9e-04

<div id="cb12" class="sourceCode">

``` r
geno(vcf)$GT[1:4, 1:3]
```

</div>

    ##             HG00096 HG00097 HG00099
    ## rs7410291   "0|0"   "0|0"   "1|0"  
    ## rs147922003 "0|0"   "0|0"   "0|0"  
    ## rs114143073 "0|0"   "0|0"   "0|0"  
    ## rs141778433 "0|0"   "0|0"   "0|0"

<div id="cb14" class="sourceCode">

``` r
header(vcf)
```

</div>

    ## class: VCFHeader 
    ## samples(5): HG00096 HG00097 HG00099 HG00100 HG00101
    ## meta(1): fileformat
    ## fixed(2): FILTER ALT
    ## info(22): LDAF AVGPOST ... VT SNPSOURCE
    ## geno(3): GT DS GL

<div id="cb16" class="sourceCode">

``` r
evcf <- VariantAnnotation::expand(vcf)
evcf
```

</div>

    ## class: ExpandedVCF 
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

Key functions/classes: `VCF`, `CollapsedVCF`, `ExpandedVCF`,
`VCFHeader`, `fixed`, `ref`, `alt`, `qual`, `filt`, `info`, `geno`,
`header`, `meta`, `vcfFields`, `expand`

</div>

<div class="section level2">

## Variant Classification

Classify variants by mutation type. All functions operate on `VCF` or
`VRanges` objects and return logical vectors.

<div id="cb18" class="sourceCode">

``` r
table(isSNV(vcf))
```

</div>

    ## 
    ## FALSE  TRUE 
    ##   407  9969

<div id="cb20" class="sourceCode">

``` r
table(isIndel(vcf))
```

</div>

    ## 
    ## FALSE  TRUE 
    ##  9970   406

<div id="cb22" class="sourceCode">

``` r
table(isTransition(vcf))
```

</div>

    ## 
    ## FALSE  TRUE 
    ##  2868  7508

<div id="cb24" class="sourceCode">

``` r
table(isSubstitution(vcf))
```

</div>

    ## 
    ## FALSE  TRUE 
    ##   407  9969

Key functions: `isSNV`, `isInsertion`, `isDeletion`, `isIndel`,
`isDelins`, `isTransition`, `isSubstitution`; `VariantType` class
hierarchy (`CodingVariants`, `SpliceSiteVariants`, `IntronVariants`,
`FiveUTRVariants`, `ThreeUTRVariants`, `IntergenicVariants`,
`PromoterVariants`)

</div>

<div class="section level2">

## Functional Annotation

Map variants to transcripts and predict protein-level consequences. The
example VCF uses NCBI-style seqnames (“22”) while the TxDb uses UCSC
style (“chr22”), so we harmonise with `seqlevelsStyle`.

<div id="cb26" class="sourceCode">

``` r
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(BSgenome.Hsapiens.UCSC.hg19)

txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene

## seqlevelsStyle() silently fails on VCFs with no seqlengths; rename directly
seqlevels(vcf) <- paste0("chr", seqlevels(vcf))   # "22" -> "chr22"

loc <- locateVariants(vcf, txdb, region = CodingVariants())
head(loc, 4)
```

</div>

    ## GRanges object with 4 ranges and 9 metadata columns:
    ##               seqnames    ranges strand | LOCATION  LOCSTART    LOCEND
    ##                  <Rle> <IRanges>  <Rle> | <factor> <integer> <integer>
    ##   rs114335781    chr22  50301422      - |   coding       939       939
    ##   rs114335781    chr22  50301422      - |   coding       145       145
    ##   rs114335781    chr22  50301422      - |   coding       470       470
    ##     rs8135963    chr22  50301476      - |   coding       885       885
    ##                 QUERYID        TXID         CDSID      GENEID       PRECEDEID
    ##               <integer> <character> <IntegerList> <character> <CharacterList>
    ##   rs114335781        24      368369 268191,268190       79087                
    ##   rs114335781        24      368370 268191,268190       79087                
    ##   rs114335781        24      368371 268191,268190       79087                
    ##     rs8135963        25      368369 268191,268190       79087                
    ##                      FOLLOWID
    ##               <CharacterList>
    ##   rs114335781                
    ##   rs114335781                
    ##   rs114335781                
    ##     rs8135963                
    ##   -------
    ##   seqinfo: 1 sequence from an unspecified genome; no seqlengths

<div id="cb28" class="sourceCode">

``` r
coding <- predictCoding(vcf, txdb, seqSource = Hsapiens)
head(coding[, c("varAllele", "CONSEQUENCE", "GENEID")], 4)
```

</div>

    ## GRanges object with 4 ranges and 3 metadata columns:
    ##               seqnames    ranges strand |      varAllele   CONSEQUENCE
    ##                  <Rle> <IRanges>  <Rle> | <DNAStringSet>      <factor>
    ##   rs114335781    chr22  50301422      - |              T synonymous   
    ##   rs114335781    chr22  50301422      - |              T nonsynonymous
    ##   rs114335781    chr22  50301422      - |              T nonsynonymous
    ##     rs8135963    chr22  50301476      - |              G synonymous   
    ##                    GENEID
    ##               <character>
    ##   rs114335781       79087
    ##   rs114335781       79087
    ##   rs114335781       79087
    ##     rs8135963       79087
    ##   -------
    ##   seqinfo: 1 sequence from hg19 genome; no seqlengths

Key functions: `locateVariants`, `predictCoding`, `summarizeVariants`,
`getTranscriptSeqs`

</div>

<div class="section level2">

## Genotype Analysis

Convert VCF genotype calls to a `SnpMatrix` for downstream association
testing with the **snpStats** package.

<div id="cb30" class="sourceCode">

``` r
library(snpStats)
seqlevels(vcf) <- sub("^chr", "", seqlevels(vcf))   # "chr22" -> "22"
sm <- genotypeToSnpMatrix(vcf)
head(col.summary(sm$genotypes), 4)
```

</div>

    ##             Calls Call.rate Certain.calls RAF MAF P.AA P.AB P.BB    z.HWE
    ## rs7410291       5         1             1 0.1 0.1  0.8  0.2    0 0.248452
    ## rs147922003     5         1             1 0.0 0.0  1.0  0.0    0       NA
    ## rs114143073     5         1             1 0.0 0.0  1.0  0.0    0       NA
    ## rs141778433     5         1             1 0.0 0.0  1.0  0.0    0       NA

Key functions: `genotypeToSnpMatrix`, `GLtoGP`, `probabilityToSnpMatrix`

</div>

<div class="section level2">

## Variant Ranges (VRanges)

`VRanges` extends `GRanges` with per-variant fields: alleles, read
depth, and soft/hard filter results.

<div id="cb32" class="sourceCode">

``` r
vr <- VRanges(seqnames = "chr1", ranges = IRanges(1000, 1000),
              ref = "A", alt = "T",
              totalDepth = 30, altDepth = 15,
              sampleNames = "sample1")
altFraction(vr)
```

</div>

    ## numeric-Rle of length 1 with 1 run
    ##   Lengths:   1
    ##   Values : 0.5

<div id="cb34" class="sourceCode">

``` r
asVCF(vr)
```

</div>

    ## class: ExpandedVCF 
    ## dim: 1 1 
    ## rowRanges(vcf):
    ##   GRanges with 4 metadata columns: REF, ALT, QUAL, FILTER
    ## info(vcf):
    ##   DataFrame with 0 columns: 
    ## geno(vcf):
    ##   List of length 3: AD, DP, FT
    ## geno(header(vcf)):
    ##       Number Type    Description                                             
    ##    AD 2      Integer Allelic depths (number of reads in each observed allele)
    ##    DP 1      Integer Total read depth                                        
    ##    FT 1      String  Variant filters

Key functions/classes: `VRanges`, `VRangesList`,
`makeVRangesFromGRanges`, `totalDepth`, `altDepth`, `refDepth`,
`altFraction`, `softFilterMatrix`, `hardFilters`, `called`, `asVCF`,
`stackSamples`

</div>

<div class="section level2">

## Ensembl VEP REST API

Query the Ensembl Variant Effect Predictor via its REST endpoint for
human variants (hg38 / GRCh38). A live internet connection is required;
the chunk is skipped gracefully if the endpoint is unreachable.

<div id="cb36" class="sourceCode">

``` r
vep_ok <- tryCatch({
    resp <- post_Hs_region(chr = "7", pos = 155800001,
                           id = "myVar", ref = "A", alt = "T")
    httr::status_code(resp) == 200L
}, error = function(e) FALSE)

if (vep_ok) {
    vcf_vep <- readVcf(fl)
    hits <- vep_by_region(vcf_vep[1:10], snv_only = FALSE, chk_max = FALSE)
    cat("VEP response status:", httr::status_code(hits), "\n")
    result <- jsonlite::fromJSON(jsonlite::toJSON(httr::content(hits)))
    print(head(result[, c("id", "most_severe_consequence")], 4))
} else {
    message("Ensembl VEP REST endpoint not reachable; skipping.")
}
```

</div>

    ## VEP response status: 200 
    ##            id most_severe_consequence
    ## 1   rs7410291            intron_v....
    ## 2 rs147922003            intron_v....
    ## 3 rs114143073            intron_v....
    ## 4 rs141778433            intron_v....

Key functions: `post_Hs_region`, `vep_by_region`

</div>

<div class="section level2">

## Session Information

<div id="cb38" class="sourceCode">

``` r
sessionInfo()
```

</div>

    ## R version 4.6.1 (2026-06-24)
    ## Platform: aarch64-apple-darwin23
    ## Running under: macOS Sequoia 15.7.7
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.6/Resources/lib/libRblas.0.dylib 
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.6/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.1
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## time zone: America/New_York
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] stats4    stats     graphics  grDevices utils     datasets  methods  
    ## [8] base     
    ## 
    ## other attached packages:
    ##  [1] snpStats_1.63.0                         
    ##  [2] Matrix_1.7-5                            
    ##  [3] survival_3.8-6                          
    ##  [4] BSgenome.Hsapiens.UCSC.hg19_1.4.3       
    ##  [5] BSgenome_1.81.0                         
    ##  [6] rtracklayer_1.73.0                      
    ##  [7] BiocIO_1.23.3                           
    ##  [8] TxDb.Hsapiens.UCSC.hg19.knownGene_3.22.1
    ##  [9] GenomicFeatures_1.65.0                  
    ## [10] AnnotationDbi_1.75.0                    
    ## [11] VariantAnnotation_1.59.2                
    ## [12] Rsamtools_2.29.0                        
    ## [13] Biostrings_2.81.5                       
    ## [14] XVector_0.53.0                          
    ## [15] SummarizedExperiment_1.43.0             
    ## [16] Biobase_2.73.1                          
    ## [17] GenomicRanges_1.65.1                    
    ## [18] IRanges_2.47.2                          
    ## [19] S4Vectors_0.51.5                        
    ## [20] Seqinfo_1.3.0                           
    ## [21] MatrixGenerics_1.25.0                   
    ## [22] matrixStats_1.5.0                       
    ## [23] BiocGenerics_0.59.10                    
    ## [24] generics_0.1.4                          
    ## [25] BiocStyle_2.41.0                        
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] KEGGREST_1.53.5          rjson_0.2.23             xfun_0.60               
    ##  [4] bslib_0.11.0             htmlwidgets_1.6.4        lattice_0.22-9          
    ##  [7] vctrs_0.7.3              tools_4.6.1              bitops_1.0-9            
    ## [10] curl_7.1.0               parallel_4.6.1           RSQLite_3.53.3          
    ## [13] blob_1.3.0               pkgconfig_2.0.3          BiocBaseUtils_1.15.1    
    ## [16] cigarillo_1.3.1          desc_1.4.3               lifecycle_1.0.5         
    ## [19] compiler_4.6.1           textshaping_1.0.5        codetools_0.2-20        
    ## [22] htmltools_0.5.9          sass_0.4.10              RCurl_1.98-1.19         
    ## [25] yaml_2.3.12              pkgdown_2.2.1            crayon_1.5.3            
    ## [28] jquerylib_0.1.4          BiocParallel_1.47.0      DelayedArray_0.39.3     
    ## [31] cachem_1.1.0             abind_1.4-8              digest_0.6.39           
    ## [34] restfulr_0.0.17          bookdown_0.47            splines_4.6.1           
    ## [37] fastmap_1.2.0            grid_4.6.1               cli_3.6.6               
    ## [40] SparseArray_1.13.2       S4Arrays_1.13.0          XML_3.99-0.23           
    ## [43] bit64_4.8.2              rmarkdown_2.31           httr_1.4.8              
    ## [46] bit_4.6.0                otel_0.2.0               ragg_1.5.2              
    ## [49] png_0.1-9                memoise_2.0.1            evaluate_1.0.5          
    ## [52] knitr_1.51               rlang_1.3.0              DBI_1.3.0               
    ## [55] BiocManager_1.30.27      jsonlite_2.0.0           R6_2.6.1                
    ## [58] GenomicAlignments_1.49.1 systemfonts_1.3.2        fs_2.1.0

</div>

</div>
