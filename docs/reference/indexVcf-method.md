<div id="main" class="col-md-9" role="main">

# Create index files for VCF files

<div class="ref-description section level2">

`indexVcf()` creates an index file for compressed VCF files, if the
index file does not exist.

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'character'
indexVcf(x, ...)
# S4 method for class 'VcfFile'
indexVcf(x, ...)
# S4 method for class 'VcfFileList'
indexVcf(x, ...)
```

</div>

</div>

<div class="section level2">

## Arguments

-   x:

    `character()`, `VcfFile`, or `VcfFileList` pointing to
    bgzf-compressed VCF files.

-   ...:

    Additional arguments to `indexTabix`

</div>

<div class="section level2">

## Details

If `x` is a character vector, assumes they are the path(s) to
bgzf-compressed VCF file(s). If an index does not exist, one is created.
VCF files can be compreseed using `bgzip`. A `VcfFile` or `VcfFileList`
is returned.

If a `VcfFile` or `VcfFileList` is given, the index file is checked, if
it does not exist it will crete one. If the index file was NA or
missing, the path of the associated VCF file is used as the index file
path. An updated `VcfFile` or `VcfFileList` is returned.

</div>

<div class="section level2">

## Value

VcfFile or VcfFileList

</div>

<div class="section level2">

## Author

Lori Shepherd

</div>

<div class="section level2">

## See also

<div class="dont-index">

`VcfFile`

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
fl <- system.file(
    "extdata", "chr7-sub.vcf.gz", package="VariantAnnotation",
    mustWork=TRUE
)
vcf1 <- indexVcf(fl)
vcf1
#> class: VcfFile 
#> path: /private/var/folders/yw/gfhgh7k565v9w83x_k764wbc0000gp/.../chr7-sub.vcf.gz
#> index: /private/var/folders/yw/gfhgh7k565v9w83x_k764wbc00.../chr7-sub.vcf.gz.tbi
#> isOpen: FALSE 
#> yieldSize: NA 
```

</div>

</div>

</div>
