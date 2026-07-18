<div id="main" class="col-md-9" role="main">

# Counts and distribution statistics for SNPs in a VCF object

<div class="ref-description section level2">

Counts and distribution statistics for SNPs in a VCF object

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'CollapsedVCF'
snpSummary(x, ...)
```

</div>

</div>

<div class="section level2">

## Arguments

-   x:

    A
    [CollapsedVCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md)
    object.

-   ...:

    Additional arguments to methods.

</div>

<div class="section level2">

## Details

Genotype counts, allele counts and Hardy Weinberg equilibrium (HWE)
statistics are calculated for single nucleotide variants in a
[CollapsedVCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md)
object. HWE has been established as a useful quality filter on genotype
data. This equilibrium should be attained in a single generation of
random mating. Departures from HWE are indicated by small p values and
are almost invariably indicative of a problem with genotype calls.

The following caveats apply:

-   No distinction is made between phased and unphased genotypes.

-   Only diploid calls are included.

-   Only \`valid' SNPs are included. A \`valid' SNP is defined as having
    a reference allele of length 1 and a single alternate allele of
    length 1.

Variants that do not meet these criteria are set to NA.

</div>

<div class="section level2">

## Value

The object returned is a `data.frame` with seven columns.

-   g00:

    Counts for genotype 00 (homozygous reference).

-   g01:

    Counts for genotype 01 or 10 (heterozygous).

-   g11:

    Counts for genotype 11 (homozygous alternate).

-   a0Freq:

    Frequency of the reference allele.

-   a1Freq:

    Frequency of the alternate allele.

-   HWEzscore:

    Z-score for departure from a null hypothesis of Hardy Weinberg
    equilibrium.

-   HWEpvalue:

    p-value for departure from a null hypothesis of Hardy Weinberg
    equilibrium.

</div>

<div class="section level2">

## Author

Chris Wallace &lt;cew54@cam.ac.uk&gt;

</div>

<div class="section level2">

## See also

<div class="dont-index">

[genotypeToSnpMatrix](https://github.com/vjcitn/VariantAnnotation/reference/genotypeToSnpMatrix-methods.md),
[probabilityToSnpMatrix](https://github.com/vjcitn/VariantAnnotation/reference/probabilityToSnpMatrix.md)

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  fl <- system.file("extdata", "ex2.vcf", package="VariantAnnotation")
  vcf <- readVcf(fl, "hg19")

  ## The return value is a data.frame with genotype counts
  ## and allele frequencies.
  df <- snpSummary(vcf)
  df
#>                g00 g01 g11    a0Freq    a1Freq  HWEzscore HWEpvalue
#> rs6054257        1   1   1 0.5000000 0.5000000 -0.5773503 0.5637029
#> 20:17330_T/A     2   1   0 0.8333333 0.1666667 -0.3464102 0.7290345
#> rs6040355       NA  NA  NA        NA        NA         NA        NA
#> 20:1230237_T/.  NA  NA  NA        NA        NA         NA        NA
#> microsat1       NA  NA  NA        NA        NA         NA        NA

  ## Compare to ranges in the VCF object:
  rowRanges(vcf)
#> GRanges object with 5 ranges and 5 metadata columns:
#>                  seqnames          ranges strand | paramRangeID            REF
#>                     <Rle>       <IRanges>  <Rle> |     <factor> <DNAStringSet>
#>        rs6054257       20           14370      * |           NA              G
#>     20:17330_T/A       20           17330      * |           NA              T
#>        rs6040355       20         1110696      * |           NA              A
#>   20:1230237_T/.       20         1230237      * |           NA              T
#>        microsat1       20 1234567-1234569      * |           NA            GTC
#>                                 ALT      QUAL      FILTER
#>                  <DNAStringSetList> <numeric> <character>
#>        rs6054257                  A        29        PASS
#>     20:17330_T/A                  A         3         q10
#>        rs6040355                G,T        67        PASS
#>   20:1230237_T/.                           47        PASS
#>        microsat1             G,GTCT        50        PASS
#>   -------
#>   seqinfo: 1 sequence from hg19 genome

  ## No statistics were computed for the variants in rows 3, 4 
  ## and 5. They were omitted because row 3 has two alternate 
  ## alleles, row 4 has none and row 5 is not a SNP.
```

</div>

</div>

</div>
