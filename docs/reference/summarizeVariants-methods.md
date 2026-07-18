<div id="main" class="col-md-9" role="main">

# Summarize variants by sample

<div class="ref-description section level2">

Variants in a VCF file are overlapped with an annotation region and
summarized by sample. Genotype information in the VCF is used to
determine which samples express each variant.

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'TxDb,VCF,CodingVariants'
summarizeVariants(query, subject, mode, ...)
# S4 method for class 'TxDb,VCF,FiveUTRVariants'
summarizeVariants(query, subject, mode, ...)
# S4 method for class 'TxDb,VCF,ThreeUTRVariants'
summarizeVariants(query, subject, mode, ...)
# S4 method for class 'TxDb,VCF,SpliceSiteVariants'
summarizeVariants(query, subject, mode, ...)
# S4 method for class 'TxDb,VCF,IntronVariants'
summarizeVariants(query, subject, mode, ...)
# S4 method for class 'TxDb,VCF,PromoterVariants'
summarizeVariants(query, subject, mode, ...)
# S4 method for class 'GRangesList,VCF,VariantType'
summarizeVariants(query, subject, mode, ...)
# S4 method for class 'GRangesList,VCF,function'
summarizeVariants(query, subject, mode, ...)
```

</div>

</div>

<div class="section level2">

## Arguments

-   query:

    A [TxDb](https://rdrr.io/pkg/GenomicFeatures/man/TxDb-class.html) or
    `GRangesList` object that serves as the annotation. GFF files can be
    converted to
    [TxDb](https://rdrr.io/pkg/GenomicFeatures/man/TxDb-class.html)
    objects with `makeTxDbFromGFF()` in the `txdbmaker` package.

-   subject:

    A
    [VCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md)
    object containing the variants.

-   mode:

    `mode` can be a `VariantType` class or the name of a function.

    When `mode` is a `VariantType` class, counting is done with
    `locateVariants` and counts are summarized transcript-by-sample.
    Supported `VariantType` classes include `CodingVariants`,
    `IntronVariants`, `FiveUTRVariants`, `ThreeUTRVariants`,
    `SpliceSiteVariants` or `PromoterVariants`. `AllVariants()` and
    `IntergenicVariants` are not supported. See ?`locateVariants` for
    more detail on the variant classes.

    `mode` can also be the name of any counting function that outputs a
    `Hits` object. Variants will be summarized by the length of the
    `GRangesList` annotation (i.e., 'length-of-GRangesList'-by-sample).

-   ...:

    Additional arguments passed to methods such as

    ignore.strand

    :   A `logical` indicating if strand should be igored when
        performing overlaps.

</div>

<div class="section level2">

## Details

`summarizeVariants` uses the genotype information in a VCF file to
determine which samples are positive for each variant. Variants are
overlapped with the annotation and the counts are summarized
annotation-by-sample. If the annotation is a `GRangesList` of
transcripts, the count matrix will be transcripts-by-sample. If the
`GRangesList` is genes, the count matrix will be gene-by-sample.

-   Counting with locateVariants() ::

    Variant counts are always summarized transcript-by-sample. When
    `query` is a `GRangesList`, it must be compatible with the
    `VariantType`-class given as the `mode` argument. The list below
    specifies the appropriate `GRangesList` for each `mode`.

    CodingVariants :

    :   coding (CDS) by transcript

    IntronVariants :

    :   introns by transcript

    FiveUTRVariants :

    :   five prime UTR by transcript

    ThreeUTRVariants :

    :   three prime UTR by transcript

    SpliceSiteVariants :

    :   introns by transcript

    PromoterVariants :

    :   list of transcripts

    When `query` is a `TxDb`, the appropriate region-by-transcript
    `GRangesList` listed above is extracted internally and used as the
    annotation.

-   Counting with a user-supplied function ::

    `subject` must be a `GRangesList` and `mode` must be the name of a
    function. The count function must take 'query' and 'subject'
    arguments and return a `Hits` object. Counts are summarized by the
    outer list elements of the `GRangesList`.

</div>

<div class="section level2">

## Value

A `RangedSummarizedExperiment` object with count summaries in the
`assays` slot. The `rowRanges` contains the annotation used for
counting. Information in `colData` and `metadata` are taken from the VCF
file.

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

`readVcf`, `predictCoding`, `locateVariants`

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  library(TxDb.Hsapiens.UCSC.hg19.knownGene)
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene 

  ## Read variants from VCF.
  fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
  vcf <- readVcf(fl, "hg19")
  ## Rename seqlevels to match TxDb; confirm the match.
  seqlevels(vcf) <- paste0("chr", seqlevels(vcf)) 
  intersect(seqlevels(vcf), seqlevels(txdb))
#> [1] "chr22"

  ## ----------------------------------------
  ## Counting with locateVariants()
  ## ----------------------------------------
  ## TxDb as the 'query'
  coding1 <- summarizeVariants(txdb, vcf, CodingVariants())
  colSums(assays(coding1)$counts)
#> HG00096 HG00097 HG00099 HG00100 HG00101 
#>     153     220     180     158     116 

  ## GRangesList as the 'query'
  cdsbytx <- cdsBy(txdb, "tx")
  coding2 <- summarizeVariants(cdsbytx, vcf, CodingVariants()) 

  stopifnot(identical(assays(coding1)$counts, assays(coding2)$counts))

  ## Promoter region variants summarized by transcript
  tx <- transcripts(txdb)
  txlst <- splitAsList(tx, seq_len(length(tx)))
  promoter <- summarizeVariants(txlst, vcf, 
                                PromoterVariants(upstream=100, downstream=10))
  colSums(assays(promoter)$counts)
#> HG00096 HG00097 HG00099 HG00100 HG00101 
#>      56      62      59      40      67 

  ## ----------------------------------------
  ## Counting with findOverlaps() 
  ## ----------------------------------------

  ## Summarize all variants by transcript
  allvariants <- summarizeVariants(txlst, vcf, findOverlaps)
  colSums(assays(allvariants)$counts)
#> HG00096 HG00097 HG00099 HG00100 HG00101 
#>    4090    5387    4411    4075    3283 
```

</div>

</div>

</div>
