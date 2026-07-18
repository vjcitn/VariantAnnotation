<div id="main" class="col-md-9" role="main">

# Convert genotype likelihoods to genotype probabilities

<div class="ref-description section level2">

Convert an array of genotype likelihoods to posterior genotype
probabilities.

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
GLtoGP(gl)
PLtoGP(pl)
```

</div>

</div>

<div class="section level2">

## Arguments

-   gl:

    Array of genotype likelihoods (log10-scaled). The format can be a
    matrix of lists, or a three-dimensional array in which the third
    dimension corresponds to the probabilities for each genotype.

-   pl:

    Array of genotype likelihoods (phred-scaled, i.e. -10\*log10). The
    format can be a matrix of lists, or a three-dimensional array in
    which the third dimension corresponds to the probabilities for each
    genotype.

</div>

<div class="section level2">

## Details

`GLtoGP` computes the probability of each genotype as
`10^x / sum(10^x)`. `PLtoGP` first divides by -10 and then proceeds as
in `GLtoGP`.

</div>

<div class="section level2">

## Value

An array of posterior genotype probabilities, in the same format as the
input (matrix of lists or 3D array).

</div>

<div class="section level2">

## Author

Stephanie Gogarten &lt;sdmorris@u.washington.edu&gt;

</div>

<div class="section level2">

## See also

<div class="dont-index">

[readVcf](https://github.com/vjcitn/VariantAnnotation/reference/readVcf-methods.md),
[genotypeToSnpMatrix](https://github.com/vjcitn/VariantAnnotation/reference/genotypeToSnpMatrix-methods.md)

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  ## Read a vcf file with a "GL" field.
  vcfFile <- system.file("extdata", "gl_chr1.vcf", package="VariantAnnotation") 
  vcf <- readVcf(vcfFile, "hg19")

  ## extract genotype likelihoods as a matrix of lists
  gl <- geno(vcf)$GL
  class(gl)
#> [1] "matrix" "array" 
  mode(gl)
#> [1] "list"

  # convert to posterior probabilities
  gp <- GLtoGP(gl)

  ## Read a vcf file with a "PL" field.
  vcfFile <- system.file("extdata", "hapmap_exome_chr22.vcf.gz", 
                         package="VariantAnnotation") 
  vcf <- readVcf(vcfFile, "hg19")
#> Warning: duplicate keys in header will be forced to unique rownames

  ## extract genotype likelihoods as a matrix of lists
  pl <- geno(vcf)$PL
  class(pl)
#> [1] "matrix" "array" 
  mode(pl)
#> [1] "list"

  # convert to posterior probabilities
  gp <- PLtoGP(pl)
```

</div>

</div>

</div>
