<div id="main" class="col-md-9" role="main">

# Predict amino acid coding changes for variants

<div class="ref-description section level2">

Predict amino acid coding changes for variants a coding regions

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'CollapsedVCF,TxDb,ANY,missing'
predictCoding(query, subject, seqSource, varAllele, ..., ignore.strand=FALSE)
# S4 method for class 'ExpandedVCF,TxDb,ANY,missing'
predictCoding(query, subject, seqSource, varAllele, ..., ignore.strand=FALSE)
# S4 method for class 'IntegerRanges,TxDb,ANY,DNAStringSet'
predictCoding(query, subject, seqSource, varAllele, ..., ignore.strand=FALSE)
# S4 method for class 'GRanges,TxDb,ANY,DNAStringSet'
predictCoding(query, subject, seqSource, varAllele, ..., ignore.strand=FALSE)
# S4 method for class 'VRanges,TxDb,ANY,missing'
predictCoding(query, subject, seqSource, varAllele, ..., ignore.strand=FALSE)
```

</div>

</div>

<div class="section level2">

## Arguments

-   query:

    A
    [VCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md),
    [IntegerRanges](https://rdrr.io/pkg/IRanges/man/IntegerRanges-class.html),
    [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
    or `VRanges` instance containing the variants to be annotated. If
    `query` is a
    [IntegerRanges](https://rdrr.io/pkg/IRanges/man/IntegerRanges-class.html)
    or `VRanges` it is coerced to a
    [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html).
    If a
    [VCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md)
    is provided the `GRanges` returned by the `rowRanges()` accessor
    will be used. All metadata columns are ignored.

    When `query` is not a `VCF` object a `varAllele` must be provided.
    The `varAllele` must be a `DNAStringSet` the same length as the
    `query`. If there are multiple alternate alleles per variant the
    `query` must be expanded to one row per each alternate allele. See
    examples.

    NOTE: Variants are expected to conform to the VCF specs as described
    on the 1000 Genomes page (see references). Indels must include the
    reference allele; zero-width ranges are not valid and return no
    matches.

-   subject:

    A [TxDb](https://rdrr.io/pkg/GenomicFeatures/man/TxDb-class.html)
    object that serves as the annotation. GFF files can be converted to
    [TxDb](https://rdrr.io/pkg/GenomicFeatures/man/TxDb-class.html)
    objects with `makeTxDbFromGFF()` in the `txdbmaker` package.

-   seqSource:

    A `BSgenome` instance or an
    [FaFile](https://rdrr.io/pkg/Rsamtools/man/FaFile-class.html) to be
    used for sequence extraction.

-   varAllele:

    A
    [DNAStringSet](https://rdrr.io/pkg/Biostrings/man/XStringSet-class.html)
    containing the variant (alternate) alleles. The length of
    `varAllele` must equal the length of `query`. Missing values are
    represented by a zero width empty element. Ranges with missing
    `varAllele` values are ignored; those with an ‘N’ character are not
    translated.

    When the `query` is a `VCF` object the `varAllele` argument will be
    missing. This value is taken internally from the `VCF` with
    `alt(<VCF>)`.

-   ...:

    Additional arguments passed to methods. Arguments `genetic.code` and
    `if.fuzzy.codon` are supported for the `translate` function.

-   ignore.strand:

    A `logical` indicating if strand should be ignored when performing
    overlaps.

    When `ignore.strand == TRUE` the `query` strand is set to '\*' and
    can overlap with any strand of the `subject`. The return `GRanges`
    reflects the strand of the `subject` hit, however, the positions and
    alleles reported are computed as if both were from the '+' strand.

    `ignore.strand == FALSE` requires the `query` and `subject` to have
    compatible strand. Again the return `GRanges` reports the strand of
    the `subject` hit but in this case positions and alleles are
    computed according to the strand of the `subject`.

</div>

<div class="section level2">

## Details

This function returns the amino acid coding for variants that fall
completely \`within' a coding region. The reference sequences are taken
from a fasta file or
[BSgenome](https://rdrr.io/pkg/BSgenome/man/BSgenome-class.html). The
width of the reference is determined from the start position and width
of the range in the `query`. For guidance on how to represent an
insertion, deletion or substitution see the 1000 Genomes VCF format
(references).

Variant alleles are taken from the `varAllele` when supplied. When the
`query` is a `VCF` object the `varAllele` will be missing. This value is
taken internally from the `VCF` with `alt(<VCF>)`. The variant allele is
substituted into the reference sequences and transcribed. Transcription
only occurs if the substitution, insertion or deletion results in a new
sequence length divisible by 3.

When the `query` is an unstranded (\*) `GRanges` `predictCoding` will
attempt to find overlaps on both the positive and negative strands of
the `subject`. When the subject hit is on the negative strand the return
`varAllele` is reverse complemented. The strand of the returned
`GRanges` represents the strand of the subject hit.

</div>

<div class="section level2">

## Value

A [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
with a row for each variant-transcript match. The result includes only
variants that fell within coding regions. The strand of the output
`GRanges` represents the strand of the `subject` hit.

At a minimum, the metadata columns (accessible with `mcols`) include,

-   `varAllele`:

    Variant allele. This value is reverse complemented for an unstranded
    `query` that overlaps a `subject` on the negative strand.

-   `QUERYID`:

    Map back to the row in the original query

-   `TXID`:

    Internal transcript id from the annotation

-   `CDSID`:

    Internal coding region id from the annotation

-   `GENEID`:

    Internal gene id from the annotation

-   `CDSLOC`:

    Variant location in coding region-based coordinates. This position
    is relative to the start of the coding (cds) region defined in the
    `subject` annotation.

-   `PROTEINLOC`:

    Variant codon triplet location in coding region-based coordinates.
    This position is relative to the start of the coding (cds) region
    defined in the `subject` annotation.

-   `CONSEQUENCE`:

    Possible values are \`synonymous', \`nonsynonymous', \`frameshift',
    \`nonsense' and \`not translated'. Variant sequences are translated
    only when the codon sequence is a multiple of 3. The value will be
    \`frameshift' when a sequence is of incompatible length. \`not
    translated' is used when `varAllele` is missing or there is an ‘N’
    in the sequence. \`nonsense' is used for premature stop codons.

-   `REFCODON`:

    The reference codon sequence. This range is typically greater than
    the width of the range in the `GRanges` because it includes all
    codons involved in the sequence modification. If the reference
    sequence is of width 2 but the alternate allele is of width 4 then
    at least two codons must be included in the `REFSEQ`.

-   `VARCODON`:

    This sequence is the result of inserting, deleting or replacing the
    position(s) in the reference sequence alternate allele. If the
    result of this substitution is not a multiple of 3 it will not be
    translated.

-   `REFAA`:

    The reference amino acid column contains the translated `REFSEQ`.
    When translation is not possible this value is missing.

-   `VARAA`:

    The variant amino acid column contains the translated `VARSEQ`. When
    translation is not possible this value is missing.

</div>

<div class="section level2">

## References

<http://www.1000genomes.org/wiki/analysis/variant-call-format/>
[http://vcftools.sourceforge.net/specs.html](http://vcftools.sourceforge.net/specs.md)

</div>

<div class="section level2">

## Author

Michael Lawrence and Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

[readVcf](https://github.com/vjcitn/VariantAnnotation/reference/readVcf-methods.md),
[locateVariants](https://github.com/vjcitn/VariantAnnotation/reference/locateVariants-methods.md),
[refLocsToLocalLocs](https://github.com/vjcitn/VariantAnnotation/reference/defunct.md)
[getTranscriptSeqs](https://github.com/vjcitn/VariantAnnotation/reference/getTranscriptSeqs-methods.md)

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  library(BSgenome.Hsapiens.UCSC.hg19)
#> Loading required package: BSgenome
#> Loading required package: BiocIO
#> Loading required package: rtracklayer
  library(TxDb.Hsapiens.UCSC.hg19.knownGene)
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene 

  ## ----------------------------
  ## VCF object as query 
  ## ----------------------------
  ## Read variants from a VCF file 
  fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
  vcf <- readVcf(fl, "hg19")

  ## Rename seqlevels in the VCF object to match those in the TxDb.
  seqlevels(vcf) <- "chr22"
  ## Confirm common seqlevels
  intersect(seqlevels(vcf), seqlevels(txdb))
#> [1] "chr22"
 
  ## When 'query' is a VCF object the varAllele argument is missing.
  coding1 <- predictCoding(vcf, txdb, Hsapiens)
#> Warning: GRanges object contains 11135 out-of-bound ranges located on sequences
#>   368369, 364612, 364613, 364614, 364616, 364617, 364628, 368375, 368376,
#>   368377, 364634, 364629, 364632, 364636, 364637, 364638, 364639, 364640,
#>   364642, 364643, 364645, 364646, 368396, 368397, 368400, 368402, 368406,
#>   368411, 368405, 368401, 368403, 368404, 368425, 368443, 368445, 368447,
#>   368453, 364662, 364663, 364655, 364656, 364657, 364658, 364660, 368456,
#>   368462, 368470, 368471, 368472, 368474, 368475, 368476, 368477, 368478,
#>   368481, 368486, 368491, 368490, 368494, 368495, 368488, 368483, 368473,
#>   368469, 368485, 364666, 364667, 364668, 364669, 364670, 364671, 368522,
#>   364672, 364673, 364674, 364676, 364678, 364681, 368533, 368541, 368555,
#>   368553, 368554, 368556, 368573, and 368574. Note that ranges located on a
#>   sequence whose length is unknown (NA) or on a circular sequence are not
#>   considered out-of-bound (use seqlengths() and isCircular() to get the lengths
#>   and circularity flags of the underlying sequences). You can use trim() to
#>   trim these ranges. See ?`trim,GenomicRanges-method` for more information.
  head(coding1, 3)
#> GRanges object with 3 ranges and 17 metadata columns:
#>               seqnames    ranges strand | paramRangeID            REF
#>                  <Rle> <IRanges>  <Rle> |     <factor> <DNAStringSet>
#>   rs114335781    chr22  50301422      - |           NA              G
#>   rs114335781    chr22  50301422      - |           NA              G
#>   rs114335781    chr22  50301422      - |           NA              G
#>                              ALT      QUAL      FILTER      varAllele    CDSLOC
#>               <DNAStringSetList> <numeric> <character> <DNAStringSet> <IRanges>
#>   rs114335781                  A       100        PASS              T       939
#>   rs114335781                  A       100        PASS              T       145
#>   rs114335781                  A       100        PASS              T       470
#>                  PROTEINLOC   QUERYID        TXID         CDSID      GENEID
#>               <IntegerList> <integer> <character> <IntegerList> <character>
#>   rs114335781           313        24      368369 268191,268190       79087
#>   rs114335781            49        24      368370 268191,268190       79087
#>   rs114335781           157        24      368371 268191,268190       79087
#>                 CONSEQUENCE       REFCODON       VARCODON         REFAA
#>                    <factor> <DNAStringSet> <DNAStringSet> <AAStringSet>
#>   rs114335781 synonymous               ATC            ATT             I
#>   rs114335781 nonsynonymous            CAT            TAT             H
#>   rs114335781 nonsynonymous            TCA            TTA             S
#>                       VARAA
#>               <AAStringSet>
#>   rs114335781             I
#>   rs114335781             Y
#>   rs114335781             L
#>   -------
#>   seqinfo: 1 sequence from hg19 genome; no seqlengths

  ## Exon-centric or cDNA locations:
  exonsbytx <- exonsBy(txdb, "tx")

  cDNA <- mapToTranscripts(coding1, exonsbytx)
  mcols(cDNA)$TXID <- names(exonsbytx)[mcols(cDNA)$transcriptsHits]
  cDNA <- cDNA[mcols(cDNA)$TXID == mcols(coding1)$TXID[mcols(cDNA)$xHits]]

  ## Make sure cDNA is parallel to coding1
  stopifnot(identical(mcols(cDNA)$xHits, seq_along(coding1)))

  coding1$cDNA <- ranges(cDNA)

  ## ----------------------------
  ## GRanges object as query 
  ## ----------------------------
  ## A GRanges can also be used as the 'query'. The seqlevels in the VCF
  ## were adjusted in previous example so the GRanges extracted with
  ## has the correct seqlevels.
  rd <- rowRanges(vcf)
 
  ## The GRanges must be expanded to have one row per alternate allele. 
  ## Variants 1, 2 and 10 have two alternate alleles.
  altallele <- alt(vcf)
  eltROWS <- elementNROWS(altallele)
  rd_exp <- rep(rd, eltROWS)
 
  ## Call predictCoding() with the expanded GRanges and the unlisted
  ## alternate allele as the 'varAllele'.
  coding2 <- predictCoding(rd_exp, txdb, Hsapiens, unlist(altallele)) 
#> Warning: GRanges object contains 11135 out-of-bound ranges located on sequences
#>   368369, 364612, 364613, 364614, 364616, 364617, 364628, 368375, 368376,
#>   368377, 364634, 364629, 364632, 364636, 364637, 364638, 364639, 364640,
#>   364642, 364643, 364645, 364646, 368396, 368397, 368400, 368402, 368406,
#>   368411, 368405, 368401, 368403, 368404, 368425, 368443, 368445, 368447,
#>   368453, 364662, 364663, 364655, 364656, 364657, 364658, 364660, 368456,
#>   368462, 368470, 368471, 368472, 368474, 368475, 368476, 368477, 368478,
#>   368481, 368486, 368491, 368490, 368494, 368495, 368488, 368483, 368473,
#>   368469, 368485, 364666, 364667, 364668, 364669, 364670, 364671, 368522,
#>   364672, 364673, 364674, 364676, 364678, 364681, 368533, 368541, 368555,
#>   368553, 368554, 368556, 368573, and 368574. Note that ranges located on a
#>   sequence whose length is unknown (NA) or on a circular sequence are not
#>   considered out-of-bound (use seqlengths() and isCircular() to get the lengths
#>   and circularity flags of the underlying sequences). You can use trim() to
#>   trim these ranges. See ?`trim,GenomicRanges-method` for more information.
```

</div>

</div>

</div>
