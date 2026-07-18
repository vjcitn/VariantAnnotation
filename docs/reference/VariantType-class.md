<div id="main" class="col-md-9" role="main">

# VariantType subclasses

<div class="ref-description section level2">

`VariantType` subclasses specify the type of variant to be located with
`locateVariants`.

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
CodingVariants()
    IntronVariants()
    FiveUTRVariants()
    ThreeUTRVariants()
    SpliceSiteVariants()
    IntergenicVariants(upstream = 1e+06L, downstream = 1e+06L,
                       idType=c("gene", "tx"))
    PromoterVariants(upstream = 2000L, downstream = 200L)
    AllVariants(promoter = PromoterVariants(),
                intergenic = IntergenicVariants())
```

</div>

</div>

<div class="section level2">

## Details

`VariantType` is a virtual class inherited by the `CodingVariants`,
`IntronVariants`, `FiveUTRVariants`, `ThreeUTRVariants`,
`SpliceSiteVariants`, `IntergenicVariants` and `AllVariants` subclasses.

The subclasses are used as the `region` argument to `locateVariants`.
They designate the type of variant (i.e., region of the annotation to
match) when calling `locateVariants`.

The majority of subclasses have no slots and require no arguments for an
instance to be created. `PromoterVariants` and `IntergenicVariants` and
accept `upstream` and `downstream` arguments that define the number of
base pairs upstream from the 5'-end and downstream from the 3'-end of
the transcript region. See the ?`locateVariants` man page for details.
`IntergenicVariants` also accepts a `idType` that controls what IDs are
returned in the PRECEDEID and FOLLOWID metadata columns.

`AllVariants` accepts `promoter` and `intergenic` arguments which are
`PromoterVariants()` and `IntergenicVariants()` objects with the
appropriate `upstream` and `downstream` values.

</div>

<div class="section level2">

## Arguments

-   upstream, downstream:

    Single `integer` values representing the number of base pairs
    upstream of the 5'-end and downstream of the 3'-end. Used in
    contructing `PromoterVariants()` and `IntergenicVariants()` objects
    only.

-   idType:

    `character` indicating if the ids in the PRECEDEID and FOLLOWID
    metadata columns should be gene ids ("gene") or transcript ids
    ("tx"). Applicable to `IntergenicVariants()` objects only.

-   promoter:

    `PromoterVariants` object with appropriate `upstream` and
    `downstream` values. Used when constructing `AllVariants` objects
    only.

-   intergenic:

    `IntergenicVariants` object with appropriate `upstream` and
    `downstream` values. Used when constructing `AllVariants` objects
    only.

</div>

<div class="section level2">

## Accessors

In the following code, `x` is a `PromoterVariants` or a `AllVariants`
object.

-   `upstream(x)`, `upstream(x) <- value`:

    Gets or sets the number of base pairs defining a range upstream of
    the 5' end (excludes 5' start value).

-   `downstream(x)`, `downstream(x) <- value`:

    Gets or sets the number of base pairs defining a range downstream of
    the 3' end (excludes 3' end value).

-   `idType(x)`, `idType(x) <- value`:

    Gets or sets the `character()` which controls the id returned in the
    PRECEDEID and FOLLOWID output columns. Possible values are "gene"
    and "tx".

-   `promoters(x)`, `promoters(x) <- value`:

    Gets or sets the `PromoterVariants` in the `AllVariants` object.

-   `intergenic(x)`, `intergenic(x) <- value`:

    Gets or sets the `IntergenicVariants` in the `AllVariants` object.

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

-   The promoters function on the
    [intra-range-methods](https://rdrr.io/pkg/GenomicRanges/man/intra-range-methods.html)
    man page in the GenomicRanges package.

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  CodingVariants()
#> class: CodingVariants 
  SpliceSiteVariants()
#> class: SpliceSiteVariants 
  PromoterVariants(upstream=1000, downstream=10000)
#> class: PromoterVariants 
#> upstream: 1000 
#> downstream: 10000 

  ## Default values for PromoterVariants and IntergenicVariants
  AllVariants()
#> class: AllVariants 
#> promoter: 
#>   upstream: 2000 
#>   downstream: 200 
#> intergenic: 
#>   upstream: 1000000 
#>   downstream: 1000000 
#>   idType: gene 
  ## Modify 'upstream' and 'downstream' for IntergenicVariants
  AllVariants(intergenic=IntergenicVariants(500, 100))
#> class: AllVariants 
#> promoter: 
#>   upstream: 2000 
#>   downstream: 200 
#> intergenic: 
#>   upstream: 500 
#>   downstream: 100 
#>   idType: gene 
  ## Reset PromoterVariants on existing AllVariants object
  av <- AllVariants()
  av
#> class: AllVariants 
#> promoter: 
#>   upstream: 2000 
#>   downstream: 200 
#> intergenic: 
#>   upstream: 1000000 
#>   downstream: 1000000 
#>   idType: gene 
  promoter(av) <- PromoterVariants(100, 50)
  av
#> class: AllVariants 
#> promoter: 
#>   upstream: 100 
#>   downstream: 50 
#> intergenic: 
#>   upstream: 1000000 
#>   downstream: 1000000 
#>   idType: gene 
```

</div>

</div>

</div>
