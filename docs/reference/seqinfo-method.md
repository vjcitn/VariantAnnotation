<div id="main" class="col-md-9" role="main">

# Get seqinfo for VCF file

<div class="ref-description section level2">

Get seqinfo for VCF file

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'VcfFile'
seqinfo(x)
# S4 method for class 'VcfFileList'
seqinfo(x)
```

</div>

</div>

<div class="section level2">

## Arguments

-   x:

    Either character(), `VcfFile`, or `VcfFileList`

</div>

<div class="section level2">

## Details

If a `VcfFile`The file header is scanned an appropriate seqinfo object
in given. If a `VcfFileList` is given, all file headers are scanned, and
appropriate combined seqinfo object is given.

</div>

<div class="section level2">

## Value

Seqinfo object

</div>

<div class="section level2">

## Author

Lori Shepherd

</div>

<div class="section level2">

## See also

<div class="dont-index">

`VcfFile`, `Seqinfo`

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
fl <- system.file("extdata", "chr7-sub.vcf.gz", package="VariantAnnotation",
                  mustWork=TRUE)
vcf <- VcfFile(fl)
seqinfo(vcf)
#> Seqinfo object with no sequences
```

</div>

</div>

</div>
