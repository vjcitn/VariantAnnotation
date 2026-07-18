<div id="main" class="col-md-9" role="main">

# PolyPhenDb objects

<div class="ref-description section level2">

The PolyPhenDb class is a container for storing a connection to a
PolyPhen sqlite database.

</div>

<div class="section level2">

## Methods

In the code below, `x` is a `PolyPhenDb` object.

-   `metadata(x)`:

    Returns `x`'s metadata in a data frame.

-   `columns(x)`:

    Returns the names of the `columns` that can be used to subset the
    data columns. For column descriptions see `?PolyPhenDbColumns`.

-   `keys(x)`:

    Returns the names of the `keys` that can be used to subset the data
    rows. The `keys` values are the rsid's.

-   `select(x, keys = NULL, columns = NULL, ...)`:

    Returns a subset of data defined by the character vectors `keys` and
    `columns`. If no `keys` are supplied, all rows are returned. If no
    `columns` are supplied, all columns are returned. See
    `?PolyPhenDbColumns` for column descriptions.

-   `duplicateRSID(x)`:

    Returns a named list of duplicate rsid groups. The names are the
    `keys`, the list elements are the rsid's that have been reported as
    having identical chromosome position and alleles and therefore
    translating into the same amino acid residue substitution.

</div>

<div class="section level2">

## Details

PolyPhen (Polymorphism Phenotyping) is a tool which predicts the
possible impact of an amino acid substitution on the structure and
function of a human protein by applying empirical rules to the sequence,
phylogenetic and structural information characterizing the substitution.

PolyPhen makes its predictions using UniProt features, PSIC profiles
scores derived from multiple alignment and matches to PDP or PQS
structural databases. The procedure can be roughly outlined in the
following steps, see the references for complete details,

-   sequence-based characterization of substitution site

-   calculation of PSIC profile scores for two amino acid variants

-   calculation of structural parameters and contacts

-   prediction

PolyPhen uses empirically derived rules to predict that a non-synonymous
SNP is

-   probably damaging : it is with high confidence supposed to affect
    protein function or structure

-   possibly damaging : it is supposed to affect protein function or
    structure

-   benign : most likely lacking any phenotypic effect

-   unknown : when in some rare cases, the lack of data do not allow
    PolyPhen to make a prediction

</div>

<div class="section level2">

## See also

<div class="dont-index">

`?PolyPhenDbColumns`

</div>

</div>

<div class="section level2">

## References

PolyPhen Home: <http://genetics.bwh.harvard.edu/pph2/dokuwiki/>

Adzhubei IA, Schmidt S, Peshkin L, Ramensky VE, Gerasimova A, Bork P,
Kondrashov AS, Sunyaev SR. Nat Methods 7(4):248-249 (2010).

Ramensky V, Bork P, Sunyaev S. Human non-synonymous SNPs: server and
survey. Nucleic Acids Res 30(17):3894-3900 (2002).

Sunyaev SR, Eisenhaber F, Rodchenkov IV, Eisenhaber B, Tumanyan VG,
Kuznetsov EN. PSIC: profile extraction from sequence alignments with
position-specific counts of independent observations. Protein Eng
12(5):387-394 (1999).

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
library(PolyPhen.Hsapiens.dbSNP131)

## metadata
metadata(PolyPhen.Hsapiens.dbSNP131)
#>                               name
#> 1                          Db type
#> 2                      Data source
#> 3                           Genome
#> 4                Genus and Species
#> 5                     Resource URL
#> 6                      dbSNP build
#> 7                    Creation time
#> 8 RSQLite version at creation time
#> 9                          package
#>                                                     value
#> 1                                              PolyPhenDb
#> 2                                               PolyPhen2
#> 3                                                    hg19
#> 4                                            Homo sapiens
#> 5 http://genetics.bwh.harvard.edu/pph2/dokuwiki/downloads
#> 6                                                     131
#> 7            2012-03-13 16:16:18 -0700 (Tue, 13 Mar 2012)
#> 8                                                  0.11.1
#> 9                                       VariantAnnotation

## available rsid's 
head(keys(PolyPhen.Hsapiens.dbSNP131))
#> [1] "rs10000692" "rs10001580" "rs10002700" "rs10003238" "rs10003369"
#> [6] "rs10004"   

## column descriptions found at ?PolyPhenDbColumns
columns(PolyPhen.Hsapiens.dbSNP131)
#>  [1] "AA1"         "AA2"         "ACC"         "AVENHET"     "AVENINT"    
#>  [6] "AVENSIT"     "BASEDON"     "BFACT"       "CODPOS"      "COMMENTS"   
#> [11] "CPG"         "DPROP"       "DSCORE"      "DVOL"        "EFFECT"     
#> [16] "HBONDS"      "IDENT"       "IDPMAX"      "IDPSNP"      "IDQMIN"     
#> [21] "LENGTH"      "MAPREG"      "MINDHET"     "MINDINT"     "MINDJNC"    
#> [26] "MINDSIT"     "NFILT"       "NOBS"        "NORMACC"     "NSTRUCT"    
#> [31] "NT1"         "NT2"         "OAA1"        "OAA2"        "OACC"       
#> [36] "OPOS"        "OSNPID"      "PDBCH"       "PDBID"       "PDBPOS"     
#> [41] "PFAMHIT"     "PHAT"        "POS"         "PPH2CLASS"   "PPH2FDR"    
#> [46] "PPH2FPR"     "PPH2PROB"    "PPH2TPR"     "PREDICTION"  "REGION"     
#> [51] "RSID"        "SCORE1"      "SCORE2"      "SECSTR"      "SITE"       
#> [56] "SNPID"       "TRAININGSET" "TRANSV"     

## subset on keys and columns 
subst <- c("AA1", "AA2", "PREDICTION")
rsids <- c("rs2142947", "rs4995127", "rs3026284")
select(PolyPhen.Hsapiens.dbSNP131, keys=rsids, columns=subst)
#>        RSID AA1 AA2        PREDICTION
#> 1 rs2142947   F   L            benign
#> 2 rs4995127   F   L probably damaging
#> 3 rs4995127   F   L possibly damaging
#> 4 rs3026284   G   D probably damaging

## retrieve substitution scores 
subst <- c("IDPMAX", "IDPSNP", "IDQMIN")
select(PolyPhen.Hsapiens.dbSNP131, keys=rsids, columns=subst)
#>        RSID IDPMAX IDPSNP IDQMIN
#> 1 rs2142947 33.979 33.979 63.615
#> 2 rs2142947 32.679 32.679 61.181
#> 3 rs2142947 33.355 33.355 62.447
#> 4 rs2142947     NA     NA     NA
#> 5 rs4995127  2.155     NA 61.715
#> 6 rs4995127  2.177     NA 62.343
#> 7 rs4995127     NA     NA     NA
#> 8 rs3026284  2.233     NA 69.349
#> 9 rs3026284     NA     NA     NA

## retrieve the PolyPhen-2 classifiers 
subst <- c("PPH2CLASS", "PPH2PROB", "PPH2FPR", "PPH2TPR", "PPH2FDR")
select(PolyPhen.Hsapiens.dbSNP131, keys=rsids, columns=subst)
#>         RSID   PPH2CLASS PPH2PROB PPH2FPR PPH2TPR PPH2FDR
#> 1  rs2142947     neutral    0.070  0.2000   0.929   0.300
#> 2  rs2142947     neutral    0.018  0.2520   0.952   0.345
#> 3  rs2142947     neutral    0.007  0.3010   0.966   0.383
#> 4  rs2142947        <NA>    0.118  0.4140   0.912      NA
#> 5  rs2142947        <NA>    0.043  0.5070   0.947      NA
#> 6  rs2142947        <NA>    0.019  0.5810   0.964      NA
#> 7  rs4995127 deleterious    0.970  0.0629   0.694   0.153
#> 8  rs4995127        <NA>    0.803  0.1860   0.720      NA
#> 9  rs3026284 deleterious    0.936  0.0746   0.737   0.168
#> 10 rs3026284        <NA>    0.919  0.1330   0.636      NA

## duplicate groups of rsid's
duplicateRSID(PolyPhen.Hsapiens.dbSNP131, c("rs71225486", "rs1063796"))
#> $rs71225486
#> [1] "rs76416839"
#> 
#> $rs1063796
#> [1] "rs17039307" "rs78671912"
#> 
```

</div>

</div>

</div>
