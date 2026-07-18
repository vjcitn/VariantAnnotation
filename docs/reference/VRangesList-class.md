<div id="main" class="col-md-9" role="main">

# VRangesList objects

<div class="ref-description section level2">

VRangesList is a virtual class representing a list of `VRanges` objects
and should behave much like any other derivative of `List`. It has both
a simple and compressed implementation. VRangesList provides
conveniences for manipulating sets of `VRanges` objects.

</div>

<div class="section level2">

## Constructor

-   `VRangesList(...)`:

    Creates a VRangesList object from `VRanges` objects in ....

</div>

<div class="section level2">

## Accessors

-   `alt(x)`:

    Returns a CharacterList or RleList, effectively by calling
    `alt(x[[i]])` on each element of `x`.

-   `ref(x)`:

    Returns a CharacterList, effectively by calling `ref(x[[i]])` on
    each element of `x`.

</div>

<div class="section level2">

## Utilities

-   `stackSamples(x)`:

    Concentrates the elements in `x`, using `names(x)` to appropriately
    fill `sampleNames` in the result.

</div>

<div class="section level2">

## Author

Michael Lawrence

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
## construction
example(VRanges)
#> 
#> VRangs> ## construction
#> VRangs> vr <- VRanges(seqnames = c("chr1", "chr2"),
#> VRangs+               ranges = IRanges(c(1, 10), c(5, 20)),
#> VRangs+               ref = c("T", "A"), alt = c("C", "T"),
#> VRangs+               refDepth = c(5, 10), altDepth = c(7, 6),
#> VRangs+               totalDepth = c(12, 17), sampleNames = letters[1:2],
#> VRangs+               hardFilters =
#> VRangs+                 FilterRules(list(coverage = function(x) totalDepth > 10)),
#> VRangs+               softFilterMatrix =
#> VRangs+                 FilterMatrix(matrix = cbind(depth = c(TRUE, FALSE)),
#> VRangs+                              FilterRules(depth = function(x) altDepth(x) > 6)),
#> VRangs+               tumorSpecific = c(FALSE, TRUE))
#> 
#> VRangs> ## simple accessors
#> VRangs> ref(vr)
#> [1] "T" "A"
#> 
#> VRangs> alt(vr)
#> [1] "C" "T"
#> 
#> VRangs> altDepth(vr)
#> [1] 7 6
#> 
#> VRangs> vr$tumorSpecific
#> [1] FALSE  TRUE
#> 
#> VRangs> called(vr)
#> [1]  TRUE FALSE
#> 
#> VRangs> ## coerce to VCF and write
#> VRangs> vcf <- as(vr, "VCF")
#> 
#> VRangs> ## writeVcf(vcf, "example.vcf")
#> VRangs> ## or just
#> VRangs> ## writeVcf(vr, "example.vcf")
#> VRangs> 
#> VRangs> ## other utilities
#> VRangs> match(vr, vr[2:1])
#> [1] 2 1
vrl <- VRangesList(sampleA = vr, sampleB = vr)
stackSamples(vrl)
#> VRanges object with 4 ranges and 1 metadata column:
#>       seqnames    ranges strand         ref              alt     totalDepth
#>          <Rle> <IRanges>  <Rle> <character> <characterOrRle> <integerOrRle>
#>   [1]     chr1       1-5      *           T                C             12
#>   [2]     chr2     10-20      *           A                T             17
#>   [3]     chr1       1-5      *           T                C             12
#>   [4]     chr2     10-20      *           A                T             17
#>             refDepth       altDepth   sampleNames softFilterMatrix |
#>       <integerOrRle> <integerOrRle> <factorOrRle>         <matrix> |
#>   [1]              5              7       sampleA             TRUE |
#>   [2]             10              6       sampleA            FALSE |
#>   [3]              5              7       sampleB             TRUE |
#>   [4]             10              6       sampleB            FALSE |
#>       tumorSpecific
#>           <logical>
#>   [1]         FALSE
#>   [2]          TRUE
#>   [3]         FALSE
#>   [4]          TRUE
#>   -------
#>   seqinfo: 2 sequences from an unspecified genome; no seqlengths
#>   hardFilters(1): coverage
```

</div>

</div>

</div>
