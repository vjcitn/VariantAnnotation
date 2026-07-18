<div id="main" class="col-md-9" role="main">

# Convert genotype calls from a VCF file to a SnpMatrix object

<div class="ref-description section level2">

Convert an array of genotype calls from the "GT", "GP", "GL" or "PL"
FORMAT field of a VCF file to a
[SnpMatrix](https://rdrr.io/pkg/snpStats/man/SnpMatrix-class.html).

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'CollapsedVCF'
genotypeToSnpMatrix(x, uncertain=FALSE, ...)
# S4 method for class 'array'
genotypeToSnpMatrix(x, ref, alt, ...)
```

</div>

</div>

<div class="section level2">

## Arguments

-   x:

    A `CollapsedVCF` object or a `array` of genotype data from the "GT",
    "GP", "GL" or "PL" FORMAT field of a VCF file. This `array` is
    created with a call to `readVcf` and can be accessed with
    `geno(<VCF>)`.

-   uncertain:

    A logical indicating whether the genotypes to convert should come
    from the "GT" field (`uncertain=FALSE`) or the "GP", "GL" or "PL"
    field (`uncertain=TRUE`).

-   ref:

    A `DNAStringSet` of reference alleles.

-   alt:

    A `DNAStringSetList` of alternate alleles.

-   ...:

    Additional arguments, passed to methods.

</div>

<div class="section level2">

## Details

`genotypeToSnpMatrix` converts an array of genotype calls from the "GT",
"GP", "GL" or "PL" FORMAT field of a VCF file into a
[SnpMatrix](https://rdrr.io/pkg/snpStats/man/SnpMatrix-class.html). The
following caveats apply,

-   no distinction is made between phased and unphased genotypes

-   variants with &gt;1 ALT allele are set to NA

-   only single nucleotide variants are included; others are set to NA

-   only diploid calls are included; others are set to NA

In VCF files, 0 represents the reference allele and integers greater
than 0 represent the alternate alleles (i.e., 2, 3, 4 would indicate the
2nd, 3rd or 4th allele in the ALT field for a particular variant). This
function only supports variants with a single alternate allele and
therefore the alternate values will always be 1. Genotypes are stored in
the SnpMatrix as 0, 1, 2 or 3 where 0 = missing, 1 = "0/0", 2 = "0/1" or
"1/0" and 3 = "1/1". In SnpMatrix terminology, "A" is the reference
allele and "B" is the risk allele. Equivalent statements to those made
with 0 and 1 allele values would be 0 = missing, 1 = "A/A", 2 = "A/B" or
"B/A" and 3 = "B/B".

The genotype fields are defined as follows:

-   GT : genotype, encoded as allele values separated by either of "/"
    or "\|". The allele values are 0 for the reference allele and 1 for
    the alternate allele.

-   GL : genotype likelihoods comprised of comma separated floating
    point log10-scaled likelihoods for all possible genotypes. In the
    case of a reference allele A and a single alternate allele B, the
    likelihoods will be ordered "A/A", "A/B", "B/B".

-   PL : the phred-scaled genotype likelihoods rounded to the closest
    integer. The ordering of values is the same as for the GL field.

-   GP : the phred-scaled genotype posterior probabilities for all
    possible genotypes; intended to store imputed genotype
    probabilities. The ordering of values is the same as for the GL
    field.

If `uncertain=TRUE`, the posterior probabilities of the three genotypes
("A/A", "A/B", "B/B") are encoded (approximately) as byte values. This
encoding allows uncertain genotypes to be used in
[snpStats](https://rdrr.io/pkg/snpStats/man/snpStats-package.html)
functions, which in some cases may be more appropriate than using only
the called genotypes. The byte encoding conserves memory by allowing the
uncertain genotypes to be stored in a two-dimensional raw matrix. See
the [snpStats](https://rdrr.io/pkg/snpStats/man/snpStats-package.html)
documentation for more details.

</div>

<div class="section level2">

## Value

A list with the following elements,

-   genotypes:

    The output genotype data as an object of class `"SnpMatrix"`. The
    columns are snps and the rows are the samples. See ?`SnpMatrix`
    details of the class structure.

-   map:

    A `DataFrame` giving the snp names and alleles at each locus. The
    `ignore` column indicates which variants were set to `NA` (see `NA`
    criteria in 'details' section).

</div>

<div class="section level2">

## References

<http://www.1000genomes.org/wiki/Analysis/Variant%20Call%20Format/vcf-variant-call-format-version-41>

</div>

<div class="section level2">

## Author

Stephanie Gogarten and Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

[readVcf](https://github.com/vjcitn/VariantAnnotation/reference/readVcf-methods.md),
[VCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md),
[SnpMatrix](https://rdrr.io/pkg/snpStats/man/SnpMatrix-class.html)

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  ## ----------------------------------------------------------------
  ## Non-probability based snp encoding using "GT"
  ## ----------------------------------------------------------------
  fl <- system.file("extdata", "ex2.vcf", package="VariantAnnotation") 
  vcf <- readVcf(fl, "hg19")

  ## This file has no "GL" or "GP" field so we use "GT".
  geno(vcf)
#> List of length 4
#> names(4): GT GQ DP HQ

  ## Convert the "GT" FORMAT field to a SnpMatrix.
  mat <- genotypeToSnpMatrix(vcf)
#> 
#> Attaching package: ‘Matrix’
#> The following object is masked from ‘package:VariantAnnotation’:
#> 
#>     expand
#> The following object is masked from ‘package:S4Vectors’:
#> 
#>     expand
#> Warning: variants with >1 ALT allele are set to NA
#> non-single nucleotide variations are set to NA

  ## The result is a list of length 2.
  names(mat)
#> [1] "genotypes" "map"      

  ## Compare coding in the VCF file to the SnpMatrix.
  geno(vcf)$GT
#>                NA00001 NA00002 NA00003
#> rs6054257      "0|0"   "1|0"   "1/1"  
#> 20:17330_T/A   "0|0"   "0|1"   "0/0"  
#> rs6040355      "1|2"   "2|1"   "2/2"  
#> 20:1230237_T/. "0|0"   "0|0"   "0/0"  
#> microsat1      "0/1"   "0/2"   "1/1"  
  t(as(mat$genotype, "character"))
#>                NA00001 NA00002 NA00003
#> rs6054257      "A/A"   "A/B"   "B/B"  
#> 20:17330_T/A   "A/A"   "A/B"   "A/A"  
#> rs6040355      "NA"    "NA"    "NA"   
#> 20:1230237_T/. "NA"    "NA"    "NA"   
#> microsat1      "NA"    "NA"    "NA"   

  ## The 'ignore' column in 'map' indicates which variants 
  ## were set to NA. Variant rs6040355 was ignored because 
  ## it has multiple alternate alleles, microsat1 is not a 
  ## snp, and chr20:1230237 has no alternate allele.
  mat$map
#> DataFrame with 5 rows and 4 columns
#>        snp.names       allele.1           allele.2    ignore
#>      <character> <DNAStringSet> <DNAStringSetList> <logical>
#> 1      rs6054257              G                  A     FALSE
#> 2   20:17330_T/A              T                  A     FALSE
#> 3      rs6040355              A                G,T      TRUE
#> 4 20:1230237_T/.              T                         TRUE
#> 5      microsat1            GTC             G,GTCT      TRUE

  ## ----------------------------------------------------------------
  ## Probability-based encoding using "GL", "PL" or "GP"
  ## ----------------------------------------------------------------
  ## Read a vcf file with a "GL" field.
  fl <- system.file("extdata", "gl_chr1.vcf", package="VariantAnnotation") 
  vcf <- readVcf(fl, "hg19")
  geno(vcf)
#> List of length 3
#> names(3): GT DS GL

  ## Convert the "GL" FORMAT field to a SnpMatrix
  mat <- genotypeToSnpMatrix(vcf, uncertain=TRUE)
#> non-single nucleotide variations are set to NA

  ## Only 3 of the 9 variants passed the filters.  The
  ## other 6 variants had no alternate alleles.
  mat$map
#> DataFrame with 9 rows and 4 columns
#>     snp.names       allele.1           allele.2    ignore
#>   <character> <DNAStringSet> <DNAStringSetList> <logical>
#> 1  rs58108140              G                  A     FALSE
#> 2 rs189107123              C                         TRUE
#> 3 rs180734498              C                  T     FALSE
#> 4 rs144762171              G                         TRUE
#> 5 rs201747181             TC                         TRUE
#> 6 rs151276478              T                         TRUE
#> 7 rs140337953              G                  T     FALSE
#> 8 rs199681827              C                         TRUE
#> 9 rs200430748              G                         TRUE

  ## Compare genotype representations for a subset of
  ## samples in variant rs180734498.
  ## Original called genotype
  geno(vcf)$GT["rs180734498", 14:16]
#> NA11829 NA11830 NA11831 
#>   "0|1"   "0|0"   "0|1" 

  ## Original genotype likelihoods
  geno(vcf)$GL["rs180734498", 14:16]
#> $NA11829
#> [1] -5  0 -5
#> 
#> $NA11830
#> [1]  0.00 -2.09 -5.00
#> 
#> $NA11831
#> [1] -0.63 -0.12 -5.00
#> 

  ## Posterior probability (computed inside genotypeToSnpMatrix)
  GLtoGP(geno(vcf)$GL["rs180734498", 14:16, drop=FALSE])[1,]
#> $NA11829
#> [1] 9.9998e-06 9.9998e-01 9.9998e-06
#> 
#> $NA11830
#> [1] 9.919274e-01 8.062689e-03 9.919274e-06
#> 
#> $NA11831
#> [1] 2.360729e-01 7.639170e-01 1.007039e-05
#> 

  ## SnpMatrix coding.
  t(as(mat$genotype, "character"))["rs180734498", 14:16]
#>     NA11829     NA11830     NA11831 
#>       "A/B"       "A/A" "Uncertain" 
  t(as(mat$genotype, "numeric"))["rs180734498", 14:16]
#>   NA11829   NA11830   NA11831 
#> 1.0000000 0.0000000 0.7619048 

  ## For samples NA11829 and NA11830, one probability is significantly
  ## higher than the others, so SnpMatrix calls the genotype.  These
  ## calls match the original coding: "0|1" -> "A/B", "0|0" -> "A/A".
  ## Sample NA11831 was originally called as "0|1" but the probability
  ## of "0|0" is only a factor of 3 lower, so SnpMatrix calls it as
  ## "Uncertain" with an appropriate byte-level encoding.
```

</div>

</div>

</div>
