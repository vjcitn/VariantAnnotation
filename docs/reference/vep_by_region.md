<div id="main" class="col-md-9" role="main">

# Use the VEP region API on variant information in a VCF object as defined in VariantAnnotation.

<div class="ref-description section level2">

Use the VEP region API on variant information in a VCF object as defined
in VariantAnnotation.

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
vep_by_region(vcfobj, snv_only = TRUE, chk_max = TRUE)
```

</div>

</div>

<div class="section level2">

## Arguments

-   vcfobj:

    instance of VCF class; note the difference between the CollapsedVCF
    and ExpandedVCF instances.

-   snv\_only:

    logical(1) if TRUE filter the VCF to information about single
    nucleotide addresses

-   chk\_max:

    logical(1) requests to ensembl VEP API are limited to 200 positions;
    if TRUE and the request involves more than 200 positions, an error
    is thrown by this function.

</div>

<div class="section level2">

## Value

instance of 'response' from httr package

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
r22 = readVcf(fl)
dr = which(width(rowRanges(r22))!=1)
r22s = r22[-dr]
res = vep_by_region(r22[1:100], snv_only=FALSE, chk_max=FALSE)
ans = jsonlite::fromJSON(jsonlite::toJSON(httr::content(res)))
```

</div>

</div>

</div>
