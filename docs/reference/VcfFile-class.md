<div id="main" class="col-md-9" role="main">

# Manipulate Variant Call Format (Vcf) files.

<div class="ref-description section level2">

Use `VcfFile()` to create a reference to a Vcf file (and its index).
Once opened, the reference remains open across calls to methods,
avoiding costly index re-loading.

`VcfFileList()` provides a convenient way of managing a list of
`VcfFile` instances.

</div>

<div class="section level2">

## usage

\#\# Constructors

-   VcfFile:

    VcfFile(file, index = paste(file, "tbi", sep="."), ...,
    yieldSize=NA\_integer\_)

-   VcfFileList:

    VcfFileList(..., yieldSize=NA\_integer\_)

\#\# Accessors

-   index:

    index(object)

-   path:

    path(object, ...)

-   isOpen:

    isOpen(con, rw="")

-   yieldSize:

    yieldSize(object, ...)

-   yieldSize&lt;-:

    yieldSize(object, ...) &lt;- value

-   show:

    show(object)

\#\# Opening / closing

-   open:

    open(con, ...)

-   close:

    close(con, ...)

\#\# method

-   vcfFields:

    vcfFields(object)

</div>

<div class="section level2">

## arguments

-   con:

    An instance of `VcfFile`.

-   file:

    A character(1) vector to the Vcf file path; can be remote (http://,
    ftp://).

-   index:

    A character(1) vector of the Vcf file index (.tbi file).

-   yieldSize:

    Number of records to yield each time the file is read from using
    `scanVcf` or `readVcf`.

-   ...:

    Additional arguments. For `VcfFileList`, this can either be a single
    character vector of paths to Vcf files, or several instances of
    `VcfFile` objects.

-   rw:

    character() indicating mode of file.

</div>

<div class="section level2">

## Objects from the Class

Objects are created by calls of the form `VcfFile()`.

</div>

<div class="section level2">

## Fields

`VcfFile` and `VcfFileList` classes inherit fields from the `TabixFile`
and `TabixFileList` classes.

</div>

<div class="section level2">

## Functions and methods

`VcfFile` and `VcfFileList` classes inherit methods from the `TabixFile`
and `TabixFileList` classes.

\#\# Opening / closing:

-   open:

    Opens the (local or remote) `path` and `index`. Returns a `VcfFile`
    instance. `yieldSize` determines the number of records parsed during
    each call to `scanVcf` or `readVcf`; `NA` indicates that all records
    are to be parsed.

-   close:

    Closes the `VcfFile` `con`; returning (invisibly) the updated
    `VcfFile`. The instance may be re-opened with `open.VcfFile`.

\#\# Accessors:

-   path:

    Returns a character(1) vector of the Vcf path name.

-   index:

    Returns a character(1) vector of Vcf index (tabix file) name.

-   yieldSize, yieldSize&lt;-:

    Return or set an integer(1) vector indicating yield size.

\#\# Methods:

-   vcfFields:

    Returns a `CharacterList` of all available VCF fields, with names of
    `fixed`, `info`, `geno` and `samples` indicating the four
    categories. Each element is a character() vector of available VCF
    field names within each category. It works for both local and remote
    vcf file.

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
fl <- system.file("extdata", "chr7-sub.vcf.gz", package="VariantAnnotation",
                  mustWork=TRUE)
vcffile <- VcfFile(fl)
vcffile
#> class: VcfFile 
#> path: /private/var/folders/yw/gfhgh7k565v9w83x_k764wbc0000gp/.../chr7-sub.vcf.gz
#> index: /private/var/folders/yw/gfhgh7k565v9w83x_k764wbc00.../chr7-sub.vcf.gz.tbi
#> isOpen: FALSE 
#> yieldSize: NA 
vcfFields(fl)
#> CharacterList of length 4
#> [["fixed"]] REF ALT QUAL FILTER
#> [["info"]] CGA_BF CGA_BNDG CGA_BNDGO CGA_FI CGA_MEDEL ... MATEID NS SS SVTYPE
#> [["geno"]] GT AD CGA_BNDDEF CGA_BNDMPC CGA_BNDP CGA_BNDPOS ... DP FT GQ HQ PS
#> [["samples"]] HCC1187-H-200-37-ASM-N1 HCC1187-H-200-37-ASM-T1
vcfFields(vcffile)
#> CharacterList of length 4
#> [["fixed"]] REF ALT QUAL FILTER
#> [["info"]] CGA_BF CGA_BNDG CGA_BNDGO CGA_FI CGA_MEDEL ... MATEID NS SS SVTYPE
#> [["geno"]] GT AD CGA_BNDDEF CGA_BNDMPC CGA_BNDP CGA_BNDPOS ... DP FT GQ HQ PS
#> [["samples"]] HCC1187-H-200-37-ASM-N1 HCC1187-H-200-37-ASM-T1

param <- GRanges("7", IRanges(c(55000000,  55900000), width=10000))
vcf <- readVcf(vcffile, "hg19", param=param)
dim(vcf)
#> [1] 45  2

## `vcfFields` also works for remote vcf filepath.  
if (FALSE) { # \dontrun{
chr22url <- "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
vcfFields(chr22url)
} # }
```

</div>

</div>

</div>
