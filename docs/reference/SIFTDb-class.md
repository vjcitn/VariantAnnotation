<div id="main" class="col-md-9" role="main">

# SIFTDb objects

<div class="ref-description section level2">

The SIFTDb class is a container for storing a connection to a SIFT
sqlite database.

</div>

<div class="section level2">

## Methods

In the code below, `x` is a `SIFTDb` object.

-   `metadata(x)`:

    Returns `x`'s metadata in a data frame.

-   `columns(x)`:

    Returns the names of the `columns` that can be used to subset the
    data columns.

-   `keys(x)`:

    Returns the names of the `keys` that can be used to subset the data
    rows. The `keys` values are the rsid's.

-   `select(x, keys = NULL, columns = NULL, ...)`:

    Returns a subset of data defined by the character vectors `keys` and
    `columns`. If no `keys` are supplied, all rows are returned. If no
    `columns` are supplied, all columns are returned. For column
    descriptions see `?SIFTDbColumns`.

</div>

<div class="section level2">

## Details

SIFT is a sequence homology-based tool that sorts intolerant from
tolerant amino acid substitutions and predicts whether an amino acid
substitution in a protein will have a phenotypic effect. SIFT is based
on the premise that protein evolution is correlated with protein
function. Positions important for function should be conserved in an
alignment of the protein family, whereas unimportant positions should
appear diverse in an alignment.

SIFT uses multiple alignment information to predict tolerated and
deleterious substitutions for every position of the query sequence. The
procedure can be outlined in the following steps,

-   search for similar sequences

-   choose closely related sequences that may share similar function to
    the query sequence

-   obtain the alignment of the chosen sequences

-   calculate normalized probabilities for all possible substitutions
    from the alignment.

Positions with normalized probabilities less than 0.05 are predicted to
be deleterious, those greater than or equal to 0.05 are predicted to be
tolerated.

</div>

<div class="section level2">

## References

SIFT Home: <http://sift.jcvi.org/>

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
if (interactive()) {
    library(SIFT.Hsapiens.dbSNP132)
    
    ## metadata
    metadata(SIFT.Hsapiens.dbSNP132)
    
    ## available rsid's 
    head(keys(SIFT.Hsapiens.dbSNP132))
    
    ## for column descriptions see ?SIFTDbColumns
    columns(SIFT.Hsapiens.dbSNP132)
    
    ## subset on keys and columns 
    rsids <- c("rs2142947", "rs17970171", "rs8692231", "rs3026284") 
    subst <- c("RSID", "PREDICTION", "SCORE")
    select(SIFT.Hsapiens.dbSNP132, keys=rsids, columns=subst)
    select(SIFT.Hsapiens.dbSNP132, keys=rsids[1:2])
}
```

</div>

</div>

</div>
