<div id="main" class="col-md-9" role="main">

# VCF class objects

<div class="ref-description section level2">

The VCF class is a virtual class extended from
`RangedSummarizedExperiment`. The subclasses, `CompressedVCF` and
`ExtendedVCF`, are containers for holding data from Variant Call Format
files.

</div>

<div class="section level2">

## Constructors

-   `readVcf(file, genome, param, ..., row.names=TRUE)`:

-   `VCF(rowRanges, colData, exptData, fixed, info, geno, ...)`:

    `VCF(rowRanges = GRanges(), colData = DataFrame(),                 exptData = list(header = VCFHeader()),                 fixed = DataFrame(), info = DataFrame(),                 geno = SimpleList(), ..., collapsed=TRUE,                 verbose = FALSE)`
    Creates CollapsedVCF when `collapsed = TRUE` and an ExpandedVCF when
    `collapsed = FALSE`.

    This is a low-level constructor used internally. Most instances of
    the `VCF` class are created with `readVCF`.

</div>

<div class="section level2">

## Accessors

In the following code snippets `x` is a CollapsedVCF or ExpandedVCF
object.

-   `rowRanges(x, ..., fixed = TRUE)`, `rowRanges(x) <- value`:

    Gets or sets the rowRanges. The CHROM, POS, ID, POS and REF fields
    are used to create a `GRanges` object. The start of the ranges are
    defined by POS and the width is equal to the width of the reference
    allele REF. The IDs become the rownames. If they are missing (i.e.,
    ‘.’) a string of CHROM:POS\_REF/ALT is used instead. The `genome`
    argument is stored in the seqinfo of the `GRanges` and can be
    accessed with `genome(<VCF>)`.

    When `fixed = TRUE`, REF, ALT, QUAL and FILTER metadata columns are
    displayed as metadata columns. To modify the `fixed` fields, use the
    `fixed<-` setter.

    One metadata column, `paramRangeID`, is included with the
    `rowRanges`. This ID is meaningful when multiple ranges are
    specified in the `ScanVcfParam` and distinguishes which records
    match each range.

    The metadata columns of a VCF object are accessed with the
    following:

    `ref(x)`, `ref(x) <- value`:

    :   Gets or sets the reference allele (REF). `value` must be a
        `DNAStringSet`.

    `alt(x)`, `alt(x) <- value`:

    :   Gets or sets the alternate allele data (ALT). When `x` is a
        CollapsedVCF, `value` must be a `DNAStringSetList` or
        `CompressedCharacterList`. For ExpandedVCF, `value` must be a
        `DNAStringSet` or `character`.

    `qual(x)`, `qual(x) <- value`:

    :   Returns or sets the quality scores (QUAL). `value` must be an
        `numeric(1L)`.

    `filt(x)`, `filt(x) <- value`:

    :   Returns or sets the filter data. `value` must be a
        `character(1L)`. Names must be one of 'REF', 'ALT', 'QUAL' or
        'FILTER'.

-   `mcols(x)`, `mcols(x) <- value`:

    These methods behave the same as `mcols(rowRanges(x))` and
    `mcols(rowRanges(x)) <- value`. This method does not manage the
    fixed fields, 'REF', 'ALT', 'QUAL' or 'FILTER'. To modify those
    columns use `fixed<-`.

-   `fixed(x)`, `fixed(x) <- value`:

    Gets or sets a DataFrame of REF, ALT, QUAL and FILTER only. Note
    these fields are displayed as metadata columns with the rowRanges()
    data (set to fixed = FALSE to suppress).

-   `info(x, ..., row.names = TRUE)`, `info(x) <- value`:

    Gets or sets a DataFrame of INFO variables. Row names are added if
    unique and `row.names=TRUE`.

-   `geno(x, withDimnames=TRUE)`, `geno(x) <- value`:

    Gets a SimpleList of genotype data. `value` is a SimpleList. To
    replace a single variable in the SimpleList use
    `geno(x)$variable <- value`; in this case `value` must be a matrix
    or array. By default row names are returned; to override specify
    `geno(vcf, withDimnames=FALSE)`.

-   `metadata(x)`:

    Gets a `list` of experiment-related data. By default this list
    includes the ‘header’ information from the VCF file. See the use of
    `header()` for details in extracting header information.

-   `colData(x)`, `colData(x) <- value`:

    Gets or sets a `DataFrame` of sample-specific information. Each row
    represents a sample in the VCF file. `value` must be a `DataFrame`
    with rownames representing the samples in the VCF file.

-   `genome(x)`:

    Extract the `genome` information from the `GRanges` object returned
    by the `rowRanges` accessor.

-   `seqlevels(x)`:

    Extract the `seqlevels` from the `GRanges` object returned by the
    `rowRanges` accessor.

-   `strand(x)`:

    Extract the `strand` from the `GRanges` object returned by the
    `rowRanges` accessor.

-   `header(x)`, `header(x)<- value`:

    Get or set the VCF header information. Replacement value must be a
    `VCFHeader` object. To modify individual elements use `info<-`,
    `geno<-` or `meta<-` on a ‘VCFHeader’ object. See ?`VCFHeader` man
    page for details.

    -   `info(header(x))`

    -   `geno(header(x))`

    -   `meta(header(x))`

    -   `samples(header(x))`

-   `vcfFields(x)`:

    Returns a `CharacterList` of all available VCF fields, with names of
    `fixed`, `info`, `geno` and `samples` indicating the four
    categories. Each element is a character() vector of available VCF
    field names within each category.

</div>

<div class="section level2">

## Subsetting and combining

In the following code `x` is a VCF object, and ... is a list of VCF
objects.

-   `x[i, j]`, `x[i, j] <- value`:

    Gets or sets rows and columns. `i` and `j` can be integer or logical
    vectors. `value` is a replacement `VCF` object.

-   `subset(x, subset, select, ...)`:

    Restricts `x` by evaluating the `subset` argument in the scope of
    `rowData(x)` and `info(x)`, and `select` in the context of
    `colData(x)`. The `subset` argument restricts by rows, while the
    `select` argument restricts by column. The `...` are passed to the
    underlying `subset()` calls.

-   `cbind(...)`, `rbind(...)`:

    `cbind` combines objects with identical ranges (`rowRanges`) but
    different samples (columns in `assays`). The colnames in `colData`
    must match or an error is thrown. Columns with duplicate names in
    `fixed`, `info` and `mcols(rowRanges(VCF))` must contain the same
    data.

    `rbind` combines objects with different ranges (`rowRanges`) and the
    same subjects (columns in `assays`). Columns with duplicate names in
    `colData` must contain the same data. The ‘Samples’ columns in
    `colData` (created by `readVcf`) are renamed with a numeric
    extension ordered as they were input to `rbind` e.g., “Samples.1,
    Samples.2, ...” etc.

    `metadata` from all objects are combined into a `list` with no name
    checking.

</div>

<div class="section level2">

## expand

In the following code snippets `x` is a CollapsedVCF object.

-   `expand(x, ..., row.names = FALSE)`:

    Expand (unlist) the ALT column of a CollapsedVCF object to one row
    per ALT value. Variables with Number='A' have one value per
    alternate allele and are expanded accordingly. The 'AD' genotype
    field (and any variables with 'Number' set to 'R') is expanded into
    REF/ALT pairs. For all other fields, the rows are replicated to
    match the elementNROWS of ALT.

    The output is an ExpandedVCF with ALT as a `DNAStringSet` or
    `character` (structural variants). By default rownames are NULL.
    When `row.names=TRUE` the expanded output has duplicated rownames
    corresponding to the original `x`.

</div>

<div class="section level2">

## genotypeCodesToNucleotides(vcf, ...)

This function converts the \`GT\` genotype codes in a `VCF` object to
nucleotides. See also ?`readGT` to read in only \`GT\` data as codes or
nucleotides.

</div>

<div class="section level2">

## SnpMatrixToVCF(from, seqSource)

This function converts the output from the
[read.plink](https://rdrr.io/pkg/snpStats/man/read.plink.html) function
to a `VCF` class. `from` must be a list of length 3 with named elements
"map", "fam" and "genotypes". `seqSource` can be a `BSgenome` or an
[FaFile](https://rdrr.io/pkg/Rsamtools/man/FaFile-class.html) used for
reference sequence extraction.

</div>

<div class="section level2">

## Variant Type

Functions to identify variant type include
[isSNV](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md),
[isInsertion](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md),
[isDeletion](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md),
[isIndel](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md),
[isSubstitution](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md)
and
[isTransition](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md).
See the ?`isSNV` man page for details.

</div>

<div class="section level2">

## Arguments

-   geno:

    A `list` or `SimpleList` of matrix elements, or a `matrix`
    containing the genotype information from a VCF file. If present,
    these data immediately follow the FORMAT field in the VCF.

    Each element of the list must have the same dimensions, and
    dimension names (if present) must be consistent across elements and
    with the row names of `rowRanges`, `colData`.

-   info:

    A `DataFrame` of data from the INFO field of a VCF file. The number
    of rows must match that in the `rowRanges` object.

-   fixed:

    A `DataFrame` of REF, ALT, QUAL and FILTER fields from a VCF file.
    The number of rows must match that of the `rowRanges` object.

-   rowRanges:

    A `GRanges` instance describing the ranges of interest. Row names,
    if present, become the row names of the `VCF`. The length of the
    `GRanges` must equal the number of rows of the matrices in `geno`.

-   colData:

    A `DataFrame` describing the samples. Row names, if present, become
    the column names of the `VCF`.

-   metadata:

    A `list` describing the header of the VCF file or additional
    information for the overall experiment.

-   ...:

    For `cbind` and `rbind` a list of VCF objects. For all other methods
    ... are additional arguments passed to methods.

-   collapsed:

    A `logical(1)` indicating whether a CollapsedVCF or ExpandedVCF
    should be created. The ALT in a CollapsedVCF is a `DNAStringSetList`
    while in a ExpandedVCF it is a `DNAStringSet`.

-   verbose:

    A `logical(1)` indicating whether messages about data coercion
    during construction should be printed.

</div>

<div class="section level2">

## Details

The `VCF` class is a virtual class with two concrete subclasses,
`CollapsedVCF` and `ExtendedVCF`.

Slots unique to `VCF` and subclasses,

-   `fixed`: A
    [DataFrame](https://rdrr.io/pkg/S4Vectors/man/DataFrame-class.html)
    containing the REF, ALT, QUAL and FILTER fields from a VCF file.

-   `info`: A
    [DataFrame](https://rdrr.io/pkg/S4Vectors/man/DataFrame-class.html)
    containing the INFO fields from a VCF file.

Slots inherited from `RangedSummarizedExperiment`,

-   `metadata`: A `list` containing the file header or other information
    about the overall experiment.

-   `rowRanges`: A
    [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
    class instance defining the variant ranges and associated metadata
    columns of REF, ALT, QUAL and FILTER. While the REF, ALT, QUAL and
    FILTER fields can be displayed as metadata columns they cannot be
    modified with `rowRanges<-`. To modify these fields use `fixed<-`.

-   `colData`: A
    [DataFrame](https://rdrr.io/pkg/S4Vectors/man/DataFrame-class.html)
    class instance describing the samples and associated metadata.

-   `geno`: The `assays` slot from `RangedSummarizedExperiment` has been
    renamed as `geno` for the VCF class. This slot contains the genotype
    information immediately following the FORMAT field in a VCF file.
    Each element of the `list` or `SimpleList` is a matrix or array.

It is expected that users will not create instances of the VCF class but
instead one of the concrete subclasses, CollapsedVCF or ExpandVCF.
CollapsedVCF contains the ALT data as a `DNAStringSetList` allowing for
multiple alleles per variant. The ExpandedVCF ALT data is a
`DNAStringSet` where the ALT column has been expanded to create a flat
form of the data with one row per variant-allele combination. In the
case of strucutral variants, ALT will be a `CompressedCharacterList` or
`character` in the collapsed or expanded forms.

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

[GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html),
[DataFrame](https://rdrr.io/pkg/S4Vectors/man/DataFrame-class.html),
[SimpleList](https://rdrr.io/pkg/S4Vectors/man/SimpleList-class.html),
[RangedSummarizedExperiment](https://rdrr.io/pkg/SummarizedExperiment/man/RangedSummarizedExperiment-class.html),
`readVcf`, `writeVcf` `isSNV`

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
## readVcf() parses data into a VCF object: 

fl <- system.file("extdata", "structural.vcf", package="VariantAnnotation")
vcf <- readVcf(fl, genome="hg19")

## ----------------------------------------------------------------
## Accessors 
## ----------------------------------------------------------------
## Variant locations are stored in the GRanges object returned by
## the rowRanges() accessor.
rowRanges(vcf)
#> GRanges object with 7 ranges and 5 metadata columns:
#>                                                                                      seqnames
#>                                                                                         <Rle>
#>                                                                      1:13220_T/<DEL>        1
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C        1
#>                                                                     2:321682_T/<DEL>        2
#>                                                            2:14477084_C/<DEL:ME:ALU>        2
#>                                                              3:9425916_C/<INS:ME:L1>        3
#>                                                                   3:12665100_A/<DUP>        3
#>                                                            4:18665128_T/<DUP:TANDEM>        4
#>                                                                                               ranges
#>                                                                                            <IRanges>
#>                                                                      1:13220_T/<DEL>           13220
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C 2827693-2827762
#>                                                                     2:321682_T/<DEL>          321682
#>                                                            2:14477084_C/<DEL:ME:ALU>        14477084
#>                                                              3:9425916_C/<INS:ME:L1>         9425916
#>                                                                   3:12665100_A/<DUP>        12665100
#>                                                            4:18665128_T/<DUP:TANDEM>        18665128
#>                                                                                      strand
#>                                                                                       <Rle>
#>                                                                      1:13220_T/<DEL>      *
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C      *
#>                                                                     2:321682_T/<DEL>      *
#>                                                            2:14477084_C/<DEL:ME:ALU>      *
#>                                                              3:9425916_C/<INS:ME:L1>      *
#>                                                                   3:12665100_A/<DUP>      *
#>                                                            4:18665128_T/<DUP:TANDEM>      *
#>                                                                                      |
#>                                                                                      |
#>                                                                      1:13220_T/<DEL> |
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C |
#>                                                                     2:321682_T/<DEL> |
#>                                                            2:14477084_C/<DEL:ME:ALU> |
#>                                                              3:9425916_C/<INS:ME:L1> |
#>                                                                   3:12665100_A/<DUP> |
#>                                                            4:18665128_T/<DUP:TANDEM> |
#>                                                                                      paramRangeID
#>                                                                                          <factor>
#>                                                                      1:13220_T/<DEL>           NA
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C           NA
#>                                                                     2:321682_T/<DEL>           NA
#>                                                            2:14477084_C/<DEL:ME:ALU>           NA
#>                                                              3:9425916_C/<INS:ME:L1>           NA
#>                                                                   3:12665100_A/<DUP>           NA
#>                                                            4:18665128_T/<DUP:TANDEM>           NA
#>                                                                                                          REF
#>                                                                                               <DNAStringSet>
#>                                                                      1:13220_T/<DEL>                       T
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C CCGTGGATGC...TCCCCTCGCA
#>                                                                     2:321682_T/<DEL>                       T
#>                                                            2:14477084_C/<DEL:ME:ALU>                       C
#>                                                              3:9425916_C/<INS:ME:L1>                       C
#>                                                                   3:12665100_A/<DUP>                       A
#>                                                            4:18665128_T/<DUP:TANDEM>                       T
#>                                                                                                  ALT
#>                                                                                      <CharacterList>
#>                                                                      1:13220_T/<DEL>           <DEL>
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C               C
#>                                                                     2:321682_T/<DEL>           <DEL>
#>                                                            2:14477084_C/<DEL:ME:ALU>    <DEL:ME:ALU>
#>                                                              3:9425916_C/<INS:ME:L1>     <INS:ME:L1>
#>                                                                   3:12665100_A/<DUP>           <DUP>
#>                                                            4:18665128_T/<DUP:TANDEM>    <DUP:TANDEM>
#>                                                                                           QUAL
#>                                                                                      <numeric>
#>                                                                      1:13220_T/<DEL>         6
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C        NA
#>                                                                     2:321682_T/<DEL>         6
#>                                                            2:14477084_C/<DEL:ME:ALU>        12
#>                                                              3:9425916_C/<INS:ME:L1>        23
#>                                                                   3:12665100_A/<DUP>        14
#>                                                            4:18665128_T/<DUP:TANDEM>        11
#>                                                                                           FILTER
#>                                                                                      <character>
#>                                                                      1:13220_T/<DEL>        PASS
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C        PASS
#>                                                                     2:321682_T/<DEL>        PASS
#>                                                            2:14477084_C/<DEL:ME:ALU>        PASS
#>                                                              3:9425916_C/<INS:ME:L1>        PASS
#>                                                                   3:12665100_A/<DUP>        PASS
#>                                                            4:18665128_T/<DUP:TANDEM>        PASS
#>   -------
#>   seqinfo: 4 sequences from hg19 genome; no seqlengths

## Suppress fixed fields:
rowRanges(vcf, fixed=FALSE)
#> GRanges object with 7 ranges and 1 metadata column:
#>                                                                                      seqnames
#>                                                                                         <Rle>
#>                                                                      1:13220_T/<DEL>        1
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C        1
#>                                                                     2:321682_T/<DEL>        2
#>                                                            2:14477084_C/<DEL:ME:ALU>        2
#>                                                              3:9425916_C/<INS:ME:L1>        3
#>                                                                   3:12665100_A/<DUP>        3
#>                                                            4:18665128_T/<DUP:TANDEM>        4
#>                                                                                               ranges
#>                                                                                            <IRanges>
#>                                                                      1:13220_T/<DEL>           13220
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C 2827693-2827762
#>                                                                     2:321682_T/<DEL>          321682
#>                                                            2:14477084_C/<DEL:ME:ALU>        14477084
#>                                                              3:9425916_C/<INS:ME:L1>         9425916
#>                                                                   3:12665100_A/<DUP>        12665100
#>                                                            4:18665128_T/<DUP:TANDEM>        18665128
#>                                                                                      strand
#>                                                                                       <Rle>
#>                                                                      1:13220_T/<DEL>      *
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C      *
#>                                                                     2:321682_T/<DEL>      *
#>                                                            2:14477084_C/<DEL:ME:ALU>      *
#>                                                              3:9425916_C/<INS:ME:L1>      *
#>                                                                   3:12665100_A/<DUP>      *
#>                                                            4:18665128_T/<DUP:TANDEM>      *
#>                                                                                      |
#>                                                                                      |
#>                                                                      1:13220_T/<DEL> |
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C |
#>                                                                     2:321682_T/<DEL> |
#>                                                            2:14477084_C/<DEL:ME:ALU> |
#>                                                              3:9425916_C/<INS:ME:L1> |
#>                                                                   3:12665100_A/<DUP> |
#>                                                            4:18665128_T/<DUP:TANDEM> |
#>                                                                                      paramRangeID
#>                                                                                          <factor>
#>                                                                      1:13220_T/<DEL>           NA
#>   1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C           NA
#>                                                                     2:321682_T/<DEL>           NA
#>                                                            2:14477084_C/<DEL:ME:ALU>           NA
#>                                                              3:9425916_C/<INS:ME:L1>           NA
#>                                                                   3:12665100_A/<DUP>           NA
#>                                                            4:18665128_T/<DUP:TANDEM>           NA
#>   -------
#>   seqinfo: 4 sequences from hg19 genome; no seqlengths

## Individual fields can be extracted with ref(), alt(), qual(), filt() etc.
qual(vcf)
#> [1]  6 NA  6 12 23 14 11
ref(vcf)
#> DNAStringSet object of length 7:
#>     width seq
#> [1]     1 T
#> [2]    70 CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA
#> [3]     1 T
#> [4]     1 C
#> [5]     1 C
#> [6]     1 A
#> [7]     1 T
head(info(vcf))
#> DataFrame with 6 rows and 10 columns
#>                                                                                                 BKPTID
#>                                                                                        <CharacterList>
#> 1:13220_T/<DEL>                                                                                       
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C Pindel_LCS_D1099159
#> 2:321682_T/<DEL>                                                                                      
#> 2:14477084_C/<DEL:ME:ALU>                                                                             
#> 3:9425916_C/<INS:ME:L1>                                                                               
#> 3:12665100_A/<DUP>                                                                                    
#>                                                                                            CIEND
#>                                                                                    <IntegerList>
#> 1:13220_T/<DEL>                                                                           -10,62
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C         NA,NA
#> 2:321682_T/<DEL>                                                                          -10,62
#> 2:14477084_C/<DEL:ME:ALU>                                                                 -12,32
#> 3:9425916_C/<INS:ME:L1>                                                                    NA,NA
#> 3:12665100_A/<DUP>                                                                      -500,500
#>                                                                                            CIPOS
#>                                                                                    <IntegerList>
#> 1:13220_T/<DEL>                                                                           -56,20
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C         NA,NA
#> 2:321682_T/<DEL>                                                                          -56,20
#> 2:14477084_C/<DEL:ME:ALU>                                                                 -22,18
#> 3:9425916_C/<INS:ME:L1>                                                                   -16,22
#> 3:12665100_A/<DUP>                                                                      -500,500
#>                                                                                          END
#>                                                                                    <integer>
#> 1:13220_T/<DEL>                                                                        13221
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C   2827680
#> 2:321682_T/<DEL>                                                                      321887
#> 2:14477084_C/<DEL:ME:ALU>                                                           14477381
#> 3:9425916_C/<INS:ME:L1>                                                              9425916
#> 3:12665100_A/<DUP>                                                                  12686200
#>                                                                                           HOMLEN
#>                                                                                    <IntegerList>
#> 1:13220_T/<DEL>                                                                                 
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C             1
#> 2:321682_T/<DEL>                                                                                
#> 2:14477084_C/<DEL:ME:ALU>                                                                       
#> 3:9425916_C/<INS:ME:L1>                                                                         
#> 3:12665100_A/<DUP>                                                                              
#>                                                                                             HOMSEQ
#>                                                                                    <CharacterList>
#> 1:13220_T/<DEL>                                                                                   
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C               C
#> 2:321682_T/<DEL>                                                                                  
#> 2:14477084_C/<DEL:ME:ALU>                                                                         
#> 3:9425916_C/<INS:ME:L1>                                                                           
#> 3:12665100_A/<DUP>                                                                                
#>                                                                                    IMPRECISE
#>                                                                                    <logical>
#> 1:13220_T/<DEL>                                                                         TRUE
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C     FALSE
#> 2:321682_T/<DEL>                                                                        TRUE
#> 2:14477084_C/<DEL:ME:ALU>                                                               TRUE
#> 3:9425916_C/<INS:ME:L1>                                                                 TRUE
#> 3:12665100_A/<DUP>                                                                      TRUE
#>                                                                                              MEINFO
#>                                                                                     <CharacterList>
#> 1:13220_T/<DEL>                                                                        NA,NA,NA,...
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C     NA,NA,NA,...
#> 2:321682_T/<DEL>                                                                       NA,NA,NA,...
#> 2:14477084_C/<DEL:ME:ALU>                                                          AluYa5,5,307,...
#> 3:9425916_C/<INS:ME:L1>                                                             L1HS,1,6025,...
#> 3:12665100_A/<DUP>                                                                     NA,NA,NA,...
#>                                                                                            SVLEN
#>                                                                                    <IntegerList>
#> 1:13220_T/<DEL>                                                                             -105
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C           -66
#> 2:321682_T/<DEL>                                                                            -105
#> 2:14477084_C/<DEL:ME:ALU>                                                                   -297
#> 3:9425916_C/<INS:ME:L1>                                                                     6027
#> 3:12665100_A/<DUP>                                                                         21100
#>                                                                                         SVTYPE
#>                                                                                    <character>
#> 1:13220_T/<DEL>                                                                            DEL
#> 1:2827693_CCGTGGATGCGGGGACCCGCATCCCCTCTCCCTTCACAGCTGAGTGACCCACATCCCCTCTCCCCTCGCA/C         DEL
#> 2:321682_T/<DEL>                                                                           DEL
#> 2:14477084_C/<DEL:ME:ALU>                                                                  DEL
#> 3:9425916_C/<INS:ME:L1>                                                                    INS
#> 3:12665100_A/<DUP>                                                                         DUP

## All available VCF field names can be contracted with vcfFields(). 
vcfFields(vcf)
#> CharacterList of length 4
#> [["fixed"]] REF ALT QUAL FILTER
#> [["info"]] BKPTID CIEND CIPOS END HOMLEN HOMSEQ IMPRECISE MEINFO SVLEN SVTYPE
#> [["geno"]] GT GQ CN CNQ
#> [["samples"]] NA00001

## Extract genotype fields with geno(). Access specific fields with 
## '$' or '[['.
geno(vcf)
#> List of length 4
#> names(4): GT GQ CN CNQ
identical(geno(vcf)$GQ, geno(vcf)[[2]])
#> [1] TRUE

## ----------------------------------------------------------------
## Renaming seqlevels and subsetting 
## ----------------------------------------------------------------
## Overlap and matching operations require that the objects
## being compared have the same seqlevels (chromosome names).
## It is often the case that the seqlevesls in on of the objects
## needs to be modified to match the other. In this VCF, the 
## seqlevels are numbers instead of preceded by "chr" or "ch". 

seqlevels(vcf)
#> [1] "1" "2" "3" "4"

## Rename the seqlevels to start with 'chr'.
vcf2 <- vcf
seqlevels(vcf2) <- paste0("chr", seqlevels(vcf2))
seqlevels(vcf2)
#> [1] "chr1" "chr2" "chr3" "chr4"

## Dropping some of the seqlevels can have the effect of reducing
## the length of the VCF object by keeping only its elements that
## belong to the remaining seqlevels.
vcf3 <- vcf2
length(vcf3)
#> [1] 7
seqlevels(vcf3, pruning.mode="coarse") <- "chr2"
seqlevels(vcf3)
#> [1] "chr2"
length(vcf3)
#> [1] 2

## ----------------------------------------------------------------
## Header information 
## ----------------------------------------------------------------

## Header data can be modified in the 'meta', 'info' and 'geno'
## slots of the VCFHeader object. See ?VCFHeader for details.

## Current 'info' fields.
rownames(info(header(vcf)))
#>  [1] "BKPTID"    "CIEND"     "CIPOS"     "END"       "HOMLEN"    "HOMSEQ"   
#>  [7] "IMPRECISE" "MEINFO"    "SVLEN"     "SVTYPE"   

## Add a new field to the header.
newInfo <- DataFrame(Number=1, Type="Integer",
                     Description="Number of Samples With Data",
                     row.names="NS")
info(header(vcf)) <- rbind(info(header(vcf)), newInfo)
rownames(info(header(vcf)))
#>  [1] "BKPTID"    "CIEND"     "CIPOS"     "END"       "HOMLEN"    "HOMSEQ"   
#>  [7] "IMPRECISE" "MEINFO"    "SVLEN"     "SVTYPE"    "NS"       

## ----------------------------------------------------------------
## Collapsed and Expanded VCF 
## ----------------------------------------------------------------
## readVCF() produces a CollapsedVCF object.
fl <- system.file("extdata", "ex2.vcf", 
                  package="VariantAnnotation")
vcf <- readVcf(fl, genome="hg19")
vcf
#> class: CollapsedVCF 
#> dim: 5 3 
#> rowRanges(vcf):
#>   GRanges with 5 metadata columns: paramRangeID, REF, ALT, QUAL, FILTER
#> info(vcf):
#>   DataFrame with 6 columns: NS, DP, AF, AA, DB, H2
#> info(header(vcf)):
#>       Number Type    Description                
#>    NS 1      Integer Number of Samples With Data
#>    DP 1      Integer Total Depth                
#>    AF A      Float   Allele Frequency           
#>    AA 1      String  Ancestral Allele           
#>    DB 0      Flag    dbSNP membership, build 129
#>    H2 0      Flag    HapMap2 membership         
#> geno(vcf):
#>   List of length 4: GT, GQ, DP, HQ
#> geno(header(vcf)):
#>       Number Type    Description      
#>    GT 1      String  Genotype         
#>    GQ 1      Integer Genotype Quality 
#>    DP 1      Integer Read Depth       
#>    HQ 2      Integer Haplotype Quality

## The ALT column is a DNAStringSetList to allow for more
## than one alternate allele per variant.
alt(vcf)
#> DNAStringSetList of length 5
#> [[1]] A
#> [[2]] A
#> [[3]] G T
#> [[4]] 
#> [[5]] G GTCT

## For structural variants ALT is a CharacterList.
fl <- system.file("extdata", "structural.vcf", 
                  package="VariantAnnotation")
vcf <- readVcf(fl, genome="hg19")
alt(vcf)
#> CharacterList of length 7
#> [[1]] <DEL>
#> [[2]] C
#> [[3]] <DEL>
#> [[4]] <DEL:ME:ALU>
#> [[5]] <INS:ME:L1>
#> [[6]] <DUP>
#> [[7]] <DUP:TANDEM>

## ExpandedVCF is the 'flattened' counterpart of CollapsedVCF.
## The ALT and all variables with Number='A' in the header are
## expanded to one row per alternate allele.
vcfLong <- expand(vcf)
alt(vcfLong)
#> [1] "<DEL>"        "C"            "<DEL>"        "<DEL:ME:ALU>" "<INS:ME:L1>" 
#> [6] "<DUP>"        "<DUP:TANDEM>"

## Also see the ?VRanges class for an alternative form of
## 'flattened' VCF data.

## ----------------------------------------------------------------
## isSNV()
## ----------------------------------------------------------------
## isSNV() returns a subset VCF containing SNVs only.

vcf <- VCF(rowRanges = GRanges("chr1", IRanges(1:4*3, width=c(1, 2, 1, 1))))
alt(vcf) <- DNAStringSetList("A", c("TT"), c("G", "A"), c("TT", "C"))
ref(vcf) <- DNAStringSet(c("G", c("AA"), "T", "G"))
fixed(vcf)[c("REF", "ALT")]
#> DataFrame with 4 rows and 2 columns
#>              REF                ALT
#>   <DNAStringSet> <DNAStringSetList>
#> 1              G                  A
#> 2             AA                 TT
#> 3              T                G,A
#> 4              G               TT,C

## SNVs are present in rows 1 (single ALT value), 3 (both ALT values) 
## and 4 (1 of the 2 ALT values).
vcf[isSNV(vcf, singleAltOnly=TRUE)] 
#> class: CollapsedVCF 
#> dim: 1 0 
#> rowRanges(vcf):
#>   GRanges with 4 metadata columns: REF, ALT, QUAL, FILTER
#> info(vcf):
#>   DataFrame with 0 columns: 
#> geno(vcf):
#>   List of length 0: 
vcf[isSNV(vcf, singleAltOnly=FALSE)] ## all 3 SNVs
#> class: CollapsedVCF 
#> dim: 3 0 
#> rowRanges(vcf):
#>   GRanges with 4 metadata columns: REF, ALT, QUAL, FILTER
#> info(vcf):
#>   DataFrame with 0 columns: 
#> geno(vcf):
#>   List of length 0: 
```

</div>

</div>

</div>
