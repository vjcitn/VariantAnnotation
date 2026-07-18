<div id="main" class="col-md-9" role="main">

# Convert posterior genotype probability to a SnpMatrix object

<div class="ref-description section level2">

Convert a matrix of posterior genotype probabilites P(AA), P(AB), P(BB)
to a [SnpMatrix](https://rdrr.io/pkg/snpStats/man/SnpMatrix-class.html).

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
probabilityToSnpMatrix(probs)
```

</div>

</div>

<div class="section level2">

## Arguments

-   probs:

    Matrix with three columns for the posterior probabilities of the
    three genotypes: "P(A/A)", "P(A/B)", "P(B/B)". Each row must sum
    to 1.

</div>

<div class="section level2">

## Details

`probabilityToSnpMatrix` converts a matrix of posterior probabilites of
genotype calls into a
[SnpMatrix](https://rdrr.io/pkg/snpStats/man/SnpMatrix-class.html).

</div>

<div class="section level2">

## Value

An object of class `"SnpMatrix"` with one row (one sample). Posterior
probabilities are encoded (approximately) as byte values, one per SNP.
See the help page for
[SnpMatrix](https://rdrr.io/pkg/snpStats/man/SnpMatrix-class.html) for
complete details of the class structure.

</div>

<div class="section level2">

## Author

Stephanie Gogarten &lt;sdmorris@u.washington.edu&gt;

</div>

<div class="section level2">

## See also

<div class="dont-index">

[genotypeToSnpMatrix](https://github.com/vjcitn/VariantAnnotation/reference/genotypeToSnpMatrix-methods.md),
[SnpMatrix](https://rdrr.io/pkg/snpStats/man/SnpMatrix-class.html)

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
probs <- matrix(c(1,0,0,
                  0,1,0,
                  0,0,1,
                  NA,NA,NA),
                  ncol=3, byrow=TRUE,
                  dimnames=list(1:4,c("A/A","A/B","B/B")))
sm <- probabilityToSnpMatrix(probs)
as(sm, "character")
#>      1     2     3     4   
#> [1,] "A/A" "A/B" "B/B" "NA"
```

</div>

</div>

</div>
