<div id="main" class="col-md-9" role="main">

# Import VCF files

<div class="ref-description section level2">

Import Variant Call Format (VCF) files in text or binary format

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
scanVcfHeader(file, ...)
# S4 method for class 'character'
scanVcfHeader(file, ...)

scanVcf(file, ..., param)
# S4 method for class 'character,ScanVcfParam'
scanVcf(file, ..., param)
# S4 method for class 'character,missing'
scanVcf(file, ..., param)
# S4 method for class 'connection,missing'
scanVcf(file, ..., param)

# S4 method for class 'TabixFile'
scanVcfHeader(file, ...)
# S4 method for class 'TabixFile,missing'
scanVcf(file, ..., param)
# S4 method for class 'TabixFile,ScanVcfParam'
scanVcf(file, ..., param)
# S4 method for class 'TabixFile,GRanges'
scanVcf(file, ..., param)
# S4 method for class 'TabixFile,IntegerRangesList'
scanVcf(file, ..., param)
```

</div>

</div>

<div class="section level2">

## Arguments

-   file:

    For `scanVcf` and `scanVcfHeader`, the character() file name,
    `TabixFile`, or class `connection` (`file()` or `bgzip()`) of the
    ‘VCF’ file to be processed.

-   param:

    A instance of `ScanVcfParam` influencing which records are parsed
    and the ‘INFO’ and ‘GENO’ information returned.

-   ...:

    Additional arguments for methods

</div>

<div class="section level2">

## Details

The argument `param` allows portions of the file to be input, but
requires that the file be bgzip'd and indexed as a `TabixFile`.

`scanVcf` with `param="missing"` and `file="character"` or
`file="connection"` scan the entire file. With `file="connection"`, an
argument `n` indicates the number of lines of the VCF file to input; a
connection open at the beginning of the call is open and incremented by
`n` lines at the end of the call, providing a convenient way to stream
through large VCF files.

The INFO field of the scanned VCF file is returned as a single ‘packed’
vector, as in the VCF file. The GENO field is a list of matrices, each
matrix corresponds to a field as defined in the FORMAT field of the VCF
header. Each matrix has as many rows as scanned in the VCF file, and as
many columns as there are samples. As with the INFO field, the elements
of the matrix are ‘packed’. The reason that INFO and GENO are returned
packed is to facilitate manipulation, e.g., selecting particular rows or
samples in a consistent manner across elements.

</div>

<div class="section level2">

## Value

`scanVcfHeader` returns a `VCFHeader` object with header information
parsed into five categories, `samples`, `meta`, `fixed`, `info` and
`geno`. Each can be accessed with a \`getter' of the same name (e.g.,
info(&lt;VCFHeader&gt;)). If the file header has multiple rows with the
same name (e.g., 'source') the row names of the DataFrame are made
unique in the usual way, 'source', 'source.1' etc.

`scanVcf` returns a list, with one element per range. Each list has 7
elements, obtained from the columns of the VCF specification:

-   rowRanges:

    `GRanges` instance derived from `CHROM`, `POS`, `ID`, and the width
    of `REF`

-   REF:

    reference allele

-   ALT:

    alternate allele

-   QUAL:

    phred-scaled quality score for the assertion made in ALT

-   FILTER:

    indicator of whether or not the position passed all filters applied

-   INFO:

    additional information

-   GENO:

    genotype information immediately following the FORMAT field in the
    VCF

The `GENO` element is itself a list, with elements corresponding to
those defined in the VCF file header. For `scanVcf`, elements of GENO
are returned as a matrix of records x samples; if the description of the
element in the file header indicated multiplicity other than 1 (e.g.,
variable number for “A”, “G”, or “.”), then each entry in the matrix is
a character string with sub-entries comma-delimited.

</div>

<div class="section level2">

## References

[http://vcftools.sourceforge.net/specs.html](http://vcftools.sourceforge.net/specs.md)
outlines the VCF specification.

[http://samtools.sourceforge.net/mpileup.shtml](http://samtools.sourceforge.net/mpileup.smd)
contains information on the portion of the specification implemented by
`bcftools`.

<http://samtools.sourceforge.net/> provides information on `samtools`.

</div>

<div class="section level2">

## See also

<div class="dont-index">

`readVcf` `BcfFile` `TabixFile`

</div>

</div>

<div class="section level2">

## Author

Martin Morgan and Valerie Obenchain&gt;

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  fl <- system.file("extdata", "ex2.vcf", package="VariantAnnotation")
  scanVcfHeader(fl)
#> class: VCFHeader 
#> samples(3): NA00001 NA00002 NA00003
#> meta(8): fileDate fileformat ... SAMPLE PEDIGREE
#> fixed(1): FILTER
#> info(6): NS DP ... DB H2
#> geno(4): GT GQ DP HQ
  vcf <- scanVcf(fl)
  ## value: list-of-lists
  str(vcf)
#> List of 1
#>  $ *:*-*:List of 7
#>   ..$ rowRanges:Formal class 'GRanges' [package "GenomicRanges"] with 7 slots
#>   .. .. ..@ seqnames       :Formal class 'Rle' [package "S4Vectors"] with 4 slots
#>   .. .. .. .. ..@ values         : Factor w/ 1 level "20": 1
#>   .. .. .. .. ..@ lengths        : int 5
#>   .. .. .. .. ..@ elementMetadata: NULL
#>   .. .. .. .. ..@ metadata       : list()
#>   .. .. ..@ ranges         :Formal class 'IRanges' [package "IRanges"] with 6 slots
#>   .. .. .. .. ..@ start          : int [1:5] 14370 17330 1110696 1230237 1234567
#>   .. .. .. .. ..@ width          : int [1:5] 1 1 1 1 3
#>   .. .. .. .. ..@ NAMES          : chr [1:5] "rs6054257" "20:17330_T/A" "rs6040355" "20:1230237_T/." ...
#>   .. .. .. .. ..@ elementType    : chr "ANY"
#>   .. .. .. .. ..@ elementMetadata: NULL
#>   .. .. .. .. ..@ metadata       : list()
#>   .. .. ..@ strand         :Formal class 'Rle' [package "S4Vectors"] with 4 slots
#>   .. .. .. .. ..@ values         : Factor w/ 3 levels "+","-","*": 3
#>   .. .. .. .. ..@ lengths        : int 5
#>   .. .. .. .. ..@ elementMetadata: NULL
#>   .. .. .. .. ..@ metadata       : list()
#>   .. .. ..@ seqinfo        :Formal class 'Seqinfo' [package "Seqinfo"] with 4 slots
#>   .. .. .. .. ..@ seqnames   : chr "20"
#>   .. .. .. .. ..@ seqlengths : int NA
#>   .. .. .. .. ..@ is_circular: logi NA
#>   .. .. .. .. ..@ genome     : chr NA
#>   .. .. ..@ elementMetadata:Formal class 'DFrame' [package "S4Vectors"] with 6 slots
#>   .. .. .. .. ..@ rownames       : NULL
#>   .. .. .. .. ..@ nrows          : int 5
#>   .. .. .. .. ..@ elementType    : chr "ANY"
#>   .. .. .. .. ..@ elementMetadata: NULL
#>   .. .. .. .. ..@ metadata       : list()
#>   .. .. .. .. ..@ listData       : Named list()
#>   .. .. ..@ elementType    : chr "ANY"
#>   .. .. ..@ metadata       : list()
#>   ..$ REF      :Formal class 'DNAStringSet' [package "Biostrings"] with 5 slots
#>   .. .. ..@ pool           :Formal class 'SharedRaw_Pool' [package "XVector"] with 2 slots
#>   .. .. .. .. ..@ xp_list                    :List of 1
#>   .. .. .. .. .. ..$ :<pointer: 0x0> 
#>   .. .. .. .. ..@ .link_to_cached_object_list:List of 1
#>   .. .. .. .. .. ..$ :<environment: 0x1475e01d8> 
#>   .. .. ..@ ranges         :Formal class 'GroupedIRanges' [package "XVector"] with 7 slots
#>   .. .. .. .. ..@ group          : int [1:5] 1 1 1 1 1
#>   .. .. .. .. ..@ start          : int [1:5] 6 2 1 2 3
#>   .. .. .. .. ..@ width          : int [1:5] 1 1 1 1 3
#>   .. .. .. .. ..@ NAMES          : NULL
#>   .. .. .. .. ..@ elementType    : chr "ANY"
#>   .. .. .. .. ..@ elementMetadata: NULL
#>   .. .. .. .. ..@ metadata       : list()
#>   .. .. ..@ elementType    : chr "DNAString"
#>   .. .. ..@ elementMetadata: NULL
#>   .. .. ..@ metadata       : list()
#>   ..$ ALT      :List of 5
#>   .. ..$ : chr "A"
#>   .. ..$ : chr "A"
#>   .. ..$ : chr [1:2] "G" "T"
#>   .. ..$ : chr ""
#>   .. ..$ : chr [1:2] "G" "GTCT"
#>   ..$ QUAL     : num [1:5] 29 3 67 47 50
#>   ..$ FILTER   : chr [1:5] "PASS" "q10" "PASS" "PASS" ...
#>   ..$ INFO     :List of 6
#>   .. ..$ NS: int [1:5] 3 3 2 3 3
#>   .. ..$ DP: int [1:5] 14 11 10 13 9
#>   .. ..$ AF:List of 5
#>   .. .. ..$ : num 0.5
#>   .. .. ..$ : num 0.017
#>   .. .. ..$ : num [1:2] 0.333 0.667
#>   .. .. ..$ : num NA
#>   .. .. ..$ : num [1:2] NA NA
#>   .. .. ..- attr(*, "dim")= int [1:2] 5 1
#>   .. ..$ AA: chr [1:5] NA NA "T" "T" ...
#>   .. ..$ DB: logi [1:5] TRUE FALSE TRUE FALSE FALSE
#>   .. ..$ H2: logi [1:5] TRUE FALSE FALSE FALSE FALSE
#>   ..$ GENO     :List of 4
#>   .. ..$ GT: chr [1:5, 1:3] "0|0" "0|0" "1|2" "0|0" ...
#>   .. .. ..- attr(*, "dimnames")=List of 2
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "NA00001" "NA00002" "NA00003"
#>   .. ..$ GQ: int [1:5, 1:3] 48 49 21 54 35 48 3 2 48 17 ...
#>   .. .. ..- attr(*, "dimnames")=List of 2
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "NA00001" "NA00002" "NA00003"
#>   .. ..$ DP: int [1:5, 1:3] 1 3 6 7 4 8 5 0 4 2 ...
#>   .. .. ..- attr(*, "dimnames")=List of 2
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "NA00001" "NA00002" "NA00003"
#>   .. ..$ HQ: int [1:5, 1:3, 1:2] 51 58 23 56 NA 51 65 18 51 NA ...
#>   .. .. ..- attr(*, "dimnames")=List of 3
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "NA00001" "NA00002" "NA00003"
#>   .. .. .. ..$ : NULL
  names(vcf[[1]][["GENO"]])
#> [1] "GT" "GQ" "DP" "HQ"
  vcf[[1]][["GENO"]][["GT"]]
#>      NA00001 NA00002 NA00003
#> [1,] "0|0"   "1|0"   "1/1"  
#> [2,] "0|0"   "0|1"   "0/0"  
#> [3,] "1|2"   "2|1"   "2/2"  
#> [4,] "0|0"   "0|0"   "0/0"  
#> [5,] "0/1"   "0/2"   "1/1"  
```

</div>

</div>

</div>
