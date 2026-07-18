<div id="main" class="col-md-9" role="main">

# Parameters for scanning VCF files

<div class="ref-description section level2">

Use `ScanVcfParam()` to create a parameter object influencing which
records and fields are imported from a VCF file. Record parsing is based
on genomic coordinates and requires a Tabix index file. Individual VCF
elements can be specified in the ‘fixed’, ‘info’, ‘geno’ and ‘samples’
arguments.

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
ScanVcfParam(fixed=character(), info=character(), geno=character(), 
               samples=character(), trimEmpty=TRUE, which, ...)

  ## Getters and Setters 
 
  vcfFixed(object)
vcfFixed(object) <- value
  vcfInfo(object)
vcfInfo(object) <- value
  vcfGeno(object)
vcfGeno(object) <- value
  vcfSamples(object)
vcfSamples(object) <- value
  vcfTrimEmpty(object)
vcfTrimEmpty(object) <- value
  vcfWhich(object)
vcfWhich(object) <- value
```

</div>

</div>

<div class="section level2">

## Arguments

-   fixed:

    A character() vector of fixed fields to be returned. Possible values
    are ALT, QUAL and FILTER. The CHROM, POS, ID and REF fields are
    needed to create the `GRanges` of variant locations. Because these
    are essential fields there is no option to request or omit them. If
    not specified, all fields are returned; if `fixed=NA` only REF is
    returned.

-   info:

    A character() vector naming the ‘INFO’ fields to return.
    `scanVcfHeader()` returns a vector of available fields. If not
    specified, all fields are returned; if `info=NA` no fields are
    returned.

-   geno:

    A character() vector naming the ‘GENO’ fields to return.
    `scanVcfHeader()` returns a vector of available fields. If not
    specified, all fields are returned; if `geno=NA` no fields are
    returned and requests for specific samples are ignored.

-   samples:

    A character() vector of sample names to return.
    `samples(scanVcfHeader())` returns all possible names. If not
    specified, data for all samples are returned; if either `samples=NA`
    or `geno=NA` no fields are returned. Requests for specific samples
    when `geno=NA` are ignored.

-   trimEmpty:

    A logical(1) indicating whether ‘GENO’ fields with no values should
    be returned.

-   which:

    A
    [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
    describing the sequences and ranges to be queried. Variants whose
    `POS` lies in the interval(s) `[start, end]` are returned. If
    `which` is not specified all ranges are returned.

-   object:

    An instance of class `ScanVcfParam`.

-   value:

    An instance of the corresponding slot, to be assigned to `object`.

-   ...:

    Arguments passed to methods.

</div>

<div class="section level2">

## Objects from the Class

Objects can be created by calls of the form `ScanVcfParam()`.

</div>

<div class="section level2">

## Slots

-   `which`::

    Object of class `"IntegerRangesList"` indicating which reference
    sequence and coordinate variants must overlap.

-   `fixed`::

    Object of class `"character"` indicating fixed fields to be
    returned.

-   `info`::

    Object of class `"character"` indicating portions of ‘INFO’ to be
    returned.

-   `geno`::

    Object of class `"character"` indicating portions of ‘GENO’ to be
    returned.

-   `samples`::

    Object of class `"character"` indicating the samples to be returned.

-   `trimEmpty`::

    Object of class `"logical"` indicating whether empty ‘GENO’ fields
    are to be returned.

</div>

<div class="section level2">

## Functions and methods

See 'Usage' for details on invocation.

Constructor:

-   ScanVcfParam::

    Returns a `ScanVcfParam` object. The `which` argument to the
    constructor can be one of several types, as documented above.

Accessors:

-   vcfFixed, vcfInfo, vcfGeno, vcfSamples, vcfTrimEmpty, vcfWhich::

    Return the corresponding field from `object`.

Methods:

-   show:

    Compactly display the object.

</div>

<div class="section level2">

## Author

Martin Morgan and Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

`readVcf`

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  ScanVcfParam()
#> class: ScanVcfParam 
#> vcfWhich: 0 elements
#> vcfFixed: character() [All] 
#> vcfInfo:  
#> vcfGeno:  
#> vcfSamples:  

  fl <- system.file("extdata", "structural.vcf", package="VariantAnnotation")
  compressVcf <- bgzip(fl, tempfile())
  idx <- indexTabix(compressVcf, "vcf")
  tab <- TabixFile(compressVcf, idx)
  ## ---------------------------------------------------------------------
  ## 'which' argument
  ## ---------------------------------------------------------------------
  ## To subset on genomic coordinates, supply an object 
  ## containing the ranges of interest. These ranges can
  ## be given directly to the 'param' argument or wrapped
  ## inside ScanVcfParam() as the 'which' argument. 

  ## When using a list, the outer list names must correspond to valid
  ## chromosome names in the vcf file. In this example they are "1" 
  ## and "2".
  gr1 <- GRanges("1", IRanges(13219, 2827695, name="regionA"))
  gr2 <- GRanges(rep("2", 2), IRanges(c(321680, 14477080), 
                 c(321689, 14477090), name=c("regionB", "regionC")))
  grl <- GRangesList("1"=gr1, "2"=gr2)
  vcf <- readVcf(tab, "hg19", grl)

  ## Names of the ranges are in the 'paramRangeID' metadata column of the
  ## GRanges object returned by the rowRanges() accessor.
  rowRanges(vcf)
#> GRanges object with 4 ranges and 5 metadata columns:
#>                                                                                      seqnames
#>                                                                                         <Rle>
#>                                                                      1:13220_T/<DEL>        1
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C        1
#>                                                                     2:321682_T/<DEL>        2
#>                                                            2:14477084_C/<DEL:ME:ALU>        2
#>                                                                                               ranges
#>                                                                                            <IRanges>
#>                                                                      1:13220_T/<DEL>           13220
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C 2827693-2827762
#>                                                                     2:321682_T/<DEL>          321682
#>                                                            2:14477084_C/<DEL:ME:ALU>        14477084
#>                                                                                      strand
#>                                                                                       <Rle>
#>                                                                      1:13220_T/<DEL>      *
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C      *
#>                                                                     2:321682_T/<DEL>      *
#>                                                            2:14477084_C/<DEL:ME:ALU>      *
#>                                                                                      |
#>                                                                                      |
#>                                                                      1:13220_T/<DEL> |
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C |
#>                                                                     2:321682_T/<DEL> |
#>                                                            2:14477084_C/<DEL:ME:ALU> |
#>                                                                                      paramRangeID
#>                                                                                          <factor>
#>                                                                      1:13220_T/<DEL>      regionA
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C      regionA
#>                                                                     2:321682_T/<DEL>      regionB
#>                                                            2:14477084_C/<DEL:ME:ALU>      regionC
#>                                                                                                          REF
#>                                                                                               <DNAStringSet>
#>                                                                      1:13220_T/<DEL>                       T
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C CCGTGGATGC...TCCCCTCGCA
#>                                                                     2:321682_T/<DEL>                       T
#>                                                            2:14477084_C/<DEL:ME:ALU>                       C
#>                                                                                                  ALT
#>                                                                                      <CharacterList>
#>                                                                      1:13220_T/<DEL>           <DEL>
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C               C
#>                                                                     2:321682_T/<DEL>           <DEL>
#>                                                            2:14477084_C/<DEL:ME:ALU>    <DEL:ME:ALU>
#>                                                                                           QUAL
#>                                                                                      <numeric>
#>                                                                      1:13220_T/<DEL>         6
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C        NA
#>                                                                     2:321682_T/<DEL>         6
#>                                                            2:14477084_C/<DEL:ME:ALU>        12
#>                                                                                           FILTER
#>                                                                                      <character>
#>                                                                      1:13220_T/<DEL>        PASS
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C        PASS
#>                                                                     2:321682_T/<DEL>        PASS
#>                                                            2:14477084_C/<DEL:ME:ALU>        PASS
#>   -------
#>   seqinfo: 2 sequences from hg19 genome; no seqlengths

  ## which can be used for subsetting the VCF object
  vcf[rowRanges(vcf)$paramRangeID == "regionA"]
#> class: CollapsedVCF 
#> dim: 2 1 
#> rowRanges(vcf):
#>   GRanges with 5 metadata columns: paramRangeID, REF, ALT, QUAL, FILTER
#> info(vcf):
#>   DataFrame with 10 columns: BKPTID, CIEND, CIPOS, END, HOMLEN, HOMSEQ, IMPR...
#> info(header(vcf)):
#>              Number Type    Description                                        
#>    BKPTID    .      String  ID of the assembled alternate allele in the asse...
#>    CIEND     2      Integer Confidence interval around END for imprecise var...
#>    CIPOS     2      Integer Confidence interval around POS for imprecise var...
#>    END       1      Integer End position of the variant described in this re...
#>    HOMLEN    .      Integer Length of base pair identical micro-homology at ...
#>    HOMSEQ    .      String  Sequence of base pair identical micro-homology a...
#>    IMPRECISE 0      Flag    Imprecise structural variation                     
#>    MEINFO    4      String  Mobile element info of the form NAME,START,END,P...
#>    SVLEN     .      Integer Difference in length between REF and ALT alleles   
#>    SVTYPE    1      String  Type of structural variant                         
#> geno(vcf):
#>   List of length 4: CN, CNQ, GQ, GT
#> geno(header(vcf)):
#>        Number Type    Description                                      
#>    CN  1      Integer Copy number genotype for imprecise events        
#>    CNQ 1      Float   Copy number genotype quality for imprecise events
#>    GQ  1      Float   Genotype quality                                 
#>    GT  1      String  Genotype                                         
 
  ## When using ranges, the seqnames must correspond to valid
  ## chromosome names in the vcf file.
  gr <- unlist(grl, use.names=FALSE)
  vcf <- readVcf(tab, "hg19", gr)
 
  ## ---------------------------------------------------------------------
  ## 'fixed', 'info', 'geno' and 'samples' arguments
  ## ---------------------------------------------------------------------
  ## This param specifies the "GT" 'geno' field for a single sample
  ## and the subset of ranges in 'which'. All 'fixed' and 'info' fields 
  ## will be returned. 
  ScanVcfParam(geno="GT", samples="NA00002", which=gr)
#> class: ScanVcfParam 
#> vcfWhich: 2 elements
#> vcfFixed: character() [All] 
#> vcfInfo:  
#> vcfGeno: GT 
#> vcfSamples: NA00002 
 
  ## Here two 'fixed' and one 'geno' field are specified
  ScanVcfParam(fixed=c("ALT", "QUAL"), geno="GT", info=NA) 
#> class: ScanVcfParam 
#> vcfWhich: 0 elements
#> vcfFixed: ALT, QUAL 
#> vcfInfo: NA 
#> vcfGeno: GT 
#> vcfSamples:  

  ## Return only the 'fixed' fields
  ScanVcfParam(geno=NA, info=NA) 
#> class: ScanVcfParam 
#> vcfWhich: 0 elements
#> vcfFixed: character() [All] 
#> vcfInfo: NA 
#> vcfGeno: NA 
#> vcfSamples:  
```

</div>

</div>

</div>
