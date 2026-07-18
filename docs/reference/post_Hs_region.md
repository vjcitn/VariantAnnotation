<div id="main" class="col-md-9" role="main">

# elementary vep/homo\_sapiens/region call to ensembl VEP REST API

<div class="ref-description section level2">

elementary vep/homo\_sapiens/region call to ensembl VEP REST API

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
post_Hs_region(chr, pos, id, ref, alt)
```

</div>

</div>

<div class="section level2">

## Arguments

-   chr:

    character(1) ensembl chromosome identifier (e.g., "7")

-   pos:

    numeric(1) 1-based chromosome position

-   id:

    character(1) arbitrary identifier

-   ref:

    character(1) reference allele

-   alt:

    character(1) alternative allele

</div>

<div class="section level2">

## Value

Instance of 'response' defined in httr package.

</div>

<div class="section level2">

## Note

This function prepares a POST to
rest.ensembl.org/vep/homo\_sapiens/region endpoint.

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
chk = post_Hs_region("7", 155800001, "chk", "A", "T")
chk
#> Response [https://rest.ensembl.org/vep/homo_sapiens/region]
#>   Date: 2026-07-18 16:11
#>   Status: 200
#>   Content-Type: application/json
#>   Size: 1.4 kB
#> 
res = jsonlite::fromJSON(jsonlite::toJSON(httr::content(chk)))
dim(chk)
#> NULL
```

</div>

</div>

</div>
