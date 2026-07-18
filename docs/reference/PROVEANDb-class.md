<div id="main" class="col-md-9" role="main">

# PROVEANDb objects

<div class="ref-description section level2">

The PROVEANDb class is a container for storing a connection to a PROVEAN
sqlite database.

</div>

<div class="section level2">

## Methods

In the code below, `x` is a `PROVEANDb` object.

-   `metadata(x)`::

    Returns `x`'s metadata in a data frame.

-   `columns(x)`::

    Returns the names of the `columns` that can be used to subset the
    data columns.

-   `keys(x, keytype="DBSNPID", ...)`::

    Returns the names of the `keys` that can be used to subset the data
    rows. For SIFT.Hsapiens.dbSNP137 the `keys` are NCBI dbSNP ids.

-   `keytypes(x)`::

    Returns the names of the `columns` that can be used as `keys`. For
    SIFT.Hsapiens.dbSNP137 the NCBI dbSNP ids are the only keytype.

-   `select(x, keys = NULL, columns = NULL, keytype = "DBSNPID", ...)`::

    Returns a subset of data defined by the character vectors `keys` and
    `columns`. If no `keys` are supplied, all rows are returned. If no
    `columns` are supplied, all columns are returned.

</div>

<div class="section level2">

## Details

The SIFT tool is no longer actively maintained. A few of the orginal
authors have started the PROVEAN (Protein Variation Effect Analyzer)
project. PROVEAN is a software tool which predicts whether an amino acid
substitution or indel has an impact on the biological function of a
protein. PROVEAN is useful for filtering sequence variants to identify
nonsynonymous or indel variants that are predicted to be functionally
important.

See the web pages for a complete description of the methods.

-   PROVEAN Home: <http://provean.jcvi.org/index.php/>

-   SIFT Home: <http://sift.jcvi.org/>

Though SIFT is not under active development, the PROVEAN team still
provids the SIFT scores in the pre-computed downloads. This package,
`SIFT.Hsapiens.dbSNP137`, contains both SIFT and PROVEAN scores. One
notable difference between this and the previous SIFT database package
is that `keys` in `SIFT.Hsapiens.dbSNP132` are rs IDs whereas in
`SIFT.Hsapiens.dbSNP137` they are NCBI dbSNP IDs.

</div>

<div class="section level2">

## References

The PROVEAN tool has replaced SIFT: <http://provean.jcvi.org/about.php>

Choi Y, Sims GE, Murphy S, Miller JR, Chan AP (2012) Predicting the
Functional Effect of Amino Acid Substitutions and Indels. PLoS ONE
7(10): e46688.

Choi Y (2012) A Fast Computation of Pairwise Sequence Alignment Scores
Between a Protein and a Set of Single-Locus Variants of Another Protein.
In Proceedings of the ACM Conference on Bioinformatics, Computational
Biology and Biomedicine (BCB '12). ACM, New York, NY, USA, 414-417.

Kumar P, Henikoff S, Ng PC. Predicting the effects of coding
non-synonymous variants on protein function using the SIFT algorithm.
Nat Protoc. 2009;4(7):1073-81

Ng PC, Henikoff S. Predicting the Effects of Amino Acid Substitutions on
Protein Function Annu Rev Genomics Hum Genet. 2006;7:61-80.

Ng PC, Henikoff S. SIFT: predicting amino acid changes that affect
protein function. Nucleic Acids Res. 2003 Jul 1;31(13):3812-4.

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  if (require(SIFT.Hsapiens.dbSNP137)) {
      ## metadata
      metadata(SIFT.Hsapiens.dbSNP137)

      ## keys are the DBSNPID (NCBI dbSNP ID)
      dbsnp <- keys(SIFT.Hsapiens.dbSNP137)
      head(dbsnp)
      columns(SIFT.Hsapiens.dbSNP137)

      ## Return all columns. Note that the key, DBSNPID,
      ## is always returned. 
      select(SIFT.Hsapiens.dbSNP137, dbsnp[10])
      ## subset on keys and cols 
      cols <- c("VARIANT", "PROVEANPRED", "SIFTPRED")
      select(SIFT.Hsapiens.dbSNP137, dbsnp[20:23], cols)
  }
#> Loading required package: SIFT.Hsapiens.dbSNP137
#> Loading required package: RSQLite
#> Warning: package ‘RSQLite’ was built under R version 4.6.1
#>    DBSNPID         VARIANT PROVEANPRED  SIFTPRED
#> 1 10004242 4,159782570,G,A Deleterious  Damaging
#> 2 10004516 4,111398208,A,G     Neutral Tolerated
#> 3 10005030  4,77317626,T,C     Neutral Tolerated
#> 4 10005739  4,16020122,T,G Deleterious  Damaging
```

</div>

</div>

</div>
