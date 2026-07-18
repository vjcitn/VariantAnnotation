<div id="main" class="col-md-9" role="main">

# SIFTDb Columns

<div class="ref-description section level2">

Description of the SIFT Sqlite Database Columns

</div>

<div class="section level2">

## Column descriptions

These column names are displayed when `columns` is called on a `SIFTDb`
object.

-   RSID : rsid

-   PROTEINID : NCBI RefSeq protein ID

-   AACHANGE : amino acid substitution; reference aa is preceeding,
    followed by the position and finally the snp aa

-   METHOD : method of obtaining related sequences using PSI-BLAST

-   AA : either the reference or snp residue amino acid

-   PREDICTION : SIFT prediction

-   SCORE : SIFT score (range 0 to 1)

    -   TOLERATED : score is greater than 0.05

    -   DAMAGING : score is less than or equal to 0.05

    -   NOT SCORED : no prediction is made if there are less than 2
        homologous sequences that have an amino acid at the position of
        the given SNP or if the SIFT prediction is not available

-   MEDIAN : diversity measurement of the sequences used for prediction
    (range 0 to 4.32)

-   POSITIONSEQS : number of sequences with an amino acide at the
    position of prediction

-   TOTALSEQS : total number of sequences in alignment

</div>

<div class="section level2">

## See also

<div class="dont-index">

`?SIFTDb`

</div>

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

</div>
