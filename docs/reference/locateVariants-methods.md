<div id="main" class="col-md-9" role="main">

# Locate variants

<div class="ref-description section level2">

Variant location with respect to gene function

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
locateVariants(query, subject, region, ...)
# S4 method for class 'VCF,TxDb,VariantType'
locateVariants(query, subject, region, ...,
    cache=new.env(parent=emptyenv()), ignore.strand=FALSE, asHits=FALSE)
# S4 method for class 'GRanges,TxDb,VariantType'
locateVariants(query, subject, region, ...,
    cache=new.env(parent=emptyenv()), ignore.strand=FALSE, asHits=FALSE)
```

</div>

</div>

<div class="section level2">

## Arguments

-   query:

    A
    [IntegerRanges](https://rdrr.io/pkg/IRanges/man/IntegerRanges-class.html),
    [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
    or
    [VCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md)
    object containing the variants. Metadata columns are allowed but
    ignored.

    NOTE: Zero-width ranges are treated as width-1 ranges; start values
    are decremented to equal the end value.

-   subject:

    A [TxDb](https://rdrr.io/pkg/GenomicFeatures/man/TxDb-class.html) or
    `GRangesList` object that serves as the annotation. GFF files can be
    converted to
    [TxDb](https://rdrr.io/pkg/GenomicFeatures/man/TxDb-class.html)
    objects with `makeTxDbFromGFF()` in the `txdbmaker` package.

-   region:

    An instance of one of the 8 VariantType classes: `CodingVariants`,
    `IntronVariants`, `FiveUTRVariants`, `ThreeUTRVariants`,
    `IntergenicVariants`, `SpliceSiteVariants`, `PromoterVariants`,
    `AllVariants`. All objects can be instantiated with no arguments,
    e.g., CodingVariants() will create an object of `CodingVariants`.

    `AllVariants`, `PromoterVariants` and `IntergenicVariants` have
    `upstream` and `downstream` arguments. For `PromoterVariants` and
    `IntergenicVariants` these are single integer values &gt;= 0. For
    `AllVariants` these are integer vectors of length 2 named ‘promoter’
    and ‘intergenic’. See ?`upstream` for more details.

    When using `AllVariants`, a range in `query` may fall in multiple
    regions (e.g., 'intergenic' and 'promoter'). In this case the result
    will have a row for each match. All data in the row will be
    equivalent except the LOCATION column.

-   ...:

    Additional arguments passed to methods

-   cache:

    An `environment` into which required components of `subject` are
    loaded. Provide, and re-use, a cache to speed repeated queries to
    the same `subject` across different `query` instances.

-   ignore.strand:

    A `logical` indicating if strand should be ignored when performing
    overlaps.

-   asHits:

    A `logical` indicating if the results should be returned as a
    [Hits](https://rdrr.io/pkg/S4Vectors/man/Hits-class.html) object.
    Not applicable when `region` is AllVariants or IntergenicVariants.

</div>

<div class="section level2">

## Details

-   Range representation::

    The ranges in `query` should reflect the position(s) of the
    reference allele. For snps the range will be of width 1. For range
    insertions or deletions the reference allele could be a sequence
    such as GGTG in which case the width of the range should be 4.

-   Location::

    Possible locations are ‘coding’, ‘intron’, ‘threeUTR’, ‘fiveUTR’,
    ‘intergenic’, ‘spliceSite’, or ‘promoter’.

    Overlap operations for ‘coding’, ‘intron’, ‘threeUTR’, and ‘fiveUTR’
    require variants to fall completely within the defined region to be
    classified as such.

    To be classified as a ‘spliceSite’ the variant must overlap with any
    portion of the first 2 or last 2 nucleotides in an intron.

    ‘intergenic’ variants are ranges that do not fall within a defined
    gene region. ‘transcripts by gene’ are extracted from the annotation
    and overlapped with the variant positions. Variants with no overlaps
    are classified as `intergenic`. When available, gene IDs for the
    flanking genes are provided as `PRECEDEID` and `FOLLOWID`.
    `upstream` and `downstream` arguments define the acceptable distance
    from the query for the flanking genes. `PRECEDEID` and `FOLLOWID`
    results are lists and contain all genes that fall within the defined
    distance. See the examples for how to compute the distance from
    ranges to PRECEDEID and FOLLOWID.

    ‘promoter’ variants fall within a specified range upstream and
    downstream of the transcription start site. Ranges values can be set
    with the `upstream` and `downstream` arguments when creating the
    `PromoterVariants()` or `AllVariants()` classes.

-   Subject as GRangesList::

    The `subject` can be a `TxDb` or `GRangesList` object. When using a
    `GRangesList` the type of data required is driven by the
    `VariantType` class. Below is a description of the appropriate
    `GRangesList` for each `VariantType`.

    CodingVariants:

    :   coding (CDS) by transcript

    IntronVariants:

    :   introns by transcript

    FiveUTRVariants:

    :   five prime UTR by transcript

    ThreeUTRVariants:

    :   three prime UTR by transcript

    IntergenicVariants:

    :   transcripts by gene

    SpliceSiteVariants:

    :   introns by transcript

    PromoterVariants:

    :   list of transcripts

    AllVariants:

    :   no GRangeList method available

-   Using the cache::

    When processing multiple VCF files performance is enhanced by
    specifying an environment as the `cache` argument. This cache is
    used to store and reuse extracted components of the subject (TxDb)
    required by the function. The first call to the function (i.e.,
    processing the first VCF file in a list of many) populates the
    cache; repeated calls to `locateVariants` will access these objects
    from the cache vs re-extracting the same information.

</div>

<div class="section level2">

## Value

A `GRanges` object with a row for each variant-transcript match. Strand
of the output is from the `subject` hit except in the case of
IntergenicVariants. For intergenic, multiple precede and follow gene ids
are returned for each variant. When `ignore.strand=TRUE` the return
strand is `*` because genes on both strands are considered and it is
possible to have a mixture. When `ignore.strand=FALSE` the strand will
match the `query` because only genes on the same strand are considered.

Metadata columns are `LOCATION`, `QUERYID`, `TXID`, `GENEID`,
`PRECEDEID`, `FOLLOWID` and `CDSID`. Results are ordered by `QUERYID`,
`TXID` and `GENEID`. Columns are described in detail below.

-   `LOCATION`:

    Possible locations are ‘coding’, ‘intron’, ‘threeUTR’, ‘fiveUTR’,
    ‘intergenic’, ‘spliceSite’ and ‘promoter’.

    To be classified as ‘coding’, ‘intron’, ‘threeUTR’ or ‘fiveUTR’ the
    variant must fall completely within the region.

    ‘intergenic’ variants do not fall within a transcript. The ‘GENEID’
    for these positions are `NA`. Lists of flanking genes that fall
    within the distance defined by `upstream` and `downstream` are given
    as ‘PRECEDEID’ and ‘FOLLOWID’. By default, the gene ID is returned
    in the ‘PRECEDEID’ and ‘FOLLOWID’ columns. To return the transcript
    ids instead set `idType = "tx"` in the `IntergenicVariants()`
    constructor.

    A ‘spliceSite’ variant overlaps any portion of the first 2 or last 2
    nucleotides of an intron.

-   `LOCSTART, LOCEND`:

    Genomic position in LOCATION-centric coordinates. If LOCATION is
    \`intron\`, these are intron-centric coordinates, if LOCATION is
    \`coding\` then cds-centric. All coordinates are relative to the
    start of the transcript. SpliceSiteVariants, IntergenicVariants and
    PromoterVariants have no formal extraction \`by transcript\` so for
    these variants LOCSTART and LOCEND are NA. Coordinates are computed
    with `mapToTranscripts`; see ?`mapToTranscripts` in the
    GenomicFeatures package for details.

-   `QUERYID`:

    The `QUERYID` column provides a map back to the row in the original
    `query`. If the `query` was a `VCF` object this index corresponds to
    the row in the `GRanges` object returned by the `rowRanges`
    accessor.

-   `TXID`:

    The transcript id taken from the `TxDb` object.

-   `CDSID`:

    The coding sequence id(s) taken from the `TxDb` object.

-   `GENEID`:

    The gene id taken from the `TxDb` object.

-   `PRECEDEID`:

    IDs for all genes the query precedes within the defined `upstream`
    and `downstream` distance. Only applicable for ‘intergenic’
    variants. By default this column contains gene ids; to return
    transcript ids set `idType = "tx"` in the `IntergenicVariants`
    constructor.

-   `FOLLOWID`:

    IDs for all genes the query follows within the defined `upstream`
    and `downstream` distance. Only applicable for ‘intergenic’
    variants. By default this column contains gene ids; to return
    transcript ids set `idType = "tx"` in the `IntergenicVariants`
    constructor.

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

-   The
    [readVcf](https://github.com/vjcitn/VariantAnnotation/reference/readVcf-methods.md)
    function.

-   The
    [predictCoding](https://github.com/vjcitn/VariantAnnotation/reference/predictCoding-methods.md)
    function.

-   The promoters function on the
    [intra-range-methods](https://rdrr.io/pkg/GenomicRanges/man/intra-range-methods.html)
    man page in the GenomicRanges package.

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  library(TxDb.Hsapiens.UCSC.hg19.knownGene)
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene

  ## ---------------------------------------------------------------------
  ## Variants in all gene regions
  ## ---------------------------------------------------------------------
  ## Read variants from a VCF file.
  fl <- system.file("extdata", "gl_chr1.vcf",
                    package="VariantAnnotation")
  vcf <- readVcf(fl, "hg19")

  ## Often the seqlevels in the VCF file do not match those in the TxDb.
  head(seqlevels(vcf))
#> [1] "1"
  head(seqlevels(txdb))
#> [1] "chr1" "chr2" "chr3" "chr4" "chr5" "chr6"
  intersect(seqlevels(vcf), seqlevels(txdb))
#> character(0)

  ## Rename seqlevels with renameSeqlevesl().
  seqlevels(vcf) <- paste0("chr", seqlevels(vcf))

  ## Confirm.
  intersect(seqlevels(vcf), seqlevels(txdb))
#> [1] "chr1"

  ## Overlaps for all possible variant locations.
  loc_all <- locateVariants(vcf, txdb, AllVariants())
#> 'select()' returned many:1 mapping between keys and columns
#> 'select()' returned many:1 mapping between keys and columns
  table(loc_all$LOCATION)
#> 
#> spliceSite     intron    fiveUTR   threeUTR     coding intergenic   promoter 
#>          0        178          0          0          0          5        322 

  ## ---------------------------------------------------------------------
  ## Variants in intergenic regions
  ## ---------------------------------------------------------------------
  ## Intergenic variants do not overlap a gene range in the
  ## annotation and therefore 'GENEID' is always NA. Flanking genes
  ## that fall within the 'upstream' and 'downstream' distances are
  ## reported as PRECEDEID and FOLLOWID.
  region <- IntergenicVariants(upstream=70000, downstream=70000)
  loc_int <- locateVariants(vcf, txdb, region)
  mcols(loc_int)[c("LOCATION", "PRECEDEID", "FOLLOWID")]
#> DataFrame with 5 rows and 3 columns
#>               LOCATION                   PRECEDEID                FOLLOWID
#>               <factor>             <CharacterList>         <CharacterList>
#> rs58108140  intergenic 100287102,645520,653635,...                        
#> rs189107123 intergenic 100287102,645520,653635,...                        
#> rs140337953 intergenic                645520,79501        100287102,653635
#> rs199681827 intergenic                       79501 100287102,645520,653635
#> rs200430748 intergenic                       79501 100287102,645520,653635

  ## Distance to the flanking genes can be computed for variants that
  ## have PRECEDEID(s) or FOLLOWID(s). Each variant can have multiple
  ## flanking id's so we first expand PRECEDEID and the corresponding
  ## variant ranges.
  p_ids <- unlist(loc_int$PRECEDEID, use.names=FALSE)
  exp_ranges <- rep(loc_int,  elementNROWS(loc_int$PRECEDEID))

  ## Compute distances with the distance method defined in GenomicFeatures.
  ## Help page can be found at ?`distance,GenomicRanges,TxDb-method`.
  ## The method returns NA for ids that cannot be collapsed into a single
  ## range (e.g., genes with ranges on multiple chromosomes).
  distance(exp_ranges, txdb, id=p_ids, type="gene")
#>  [1]   537 23969  3772 54835   509 23941  3744 54807  3629 34495 19016 18228

  ## To search for distance by transcript id set idType='tx' in the
  ## IntergenicVariants() constructor, e.g.,
  ## locateVariants(vcf, txdb, region=IntergenicVariants(idType="tx"))

  ## Unlist ids and expand ranges as before to get p_ids and exp_ranges.
  ## Then call distance() with type = "tx":
  ## distance(exp_ranges, txdb, id=p_ids, type="tx")


  ## ---------------------------------------------------------------------
  ## GRangesList as subject
  ## ---------------------------------------------------------------------
  ## When 'subject' is a GRangesList the GENEID is unavailable and
  ## will always be reported as NA. This is because the GRangesList
  ## objects are extractions of region-by-transcript, not region-by-gene.
  if (FALSE) { # \dontrun{
  cdsbytx <- cdsBy(txdb)
  locateVariants(vcf, cdsbytx, CodingVariants())

  intbytx <- intronsByTranscript(txdb)
  locateVariants(vcf, intbytx, IntronVariants())
  } # }

  ## ---------------------------------------------------------------------
  ## Using the cache
  ## ---------------------------------------------------------------------
  ## When processing multiple VCF files, the 'cache' can be used
  ## to store the extracted components of the TxDb
  ## (i.e., cds by tx, introns by tx etc.). This avoids having to
  ## re-extract these GRangesLists during each loop.
  if (FALSE) { # \dontrun{
  myenv <- new.env()
  files <- list(vcf1, vcf2, vcf3)
  lapply(files,
      function(fl) {
          vcf <- readVcf(fl, "hg19")
          ## modify seqlevels to match TxDb
          seqlevels(vcf_mod) <- paste0("chr", seqlevels(vcf))
          locateVariants(vcf_mod, txdb, AllVariants(), cache=myenv)
      })
  } # }

  ## ---------------------------------------------------------------------
  ## Parallel implmentation
  ## ---------------------------------------------------------------------
  if (FALSE) { # \dontrun{
  library(BiocParallel)

  ## A connection to a TxDb object is established when
  ## the package is loaded. Because each process reading from an
  ## sqlite db must have a unique connection the TxDb
  ## object cannot be passed as an argument when running in
  ## parallel. Instead the package must be loaded on each worker.

  ## The overhead of the multiple loading may defeat the
  ## purpose of running the job in parallel. An alternative is
  ## to instead pass the appropriate GRangesList as an argument.
  ## The details section on this man page under the heading
  ## 'Subject as GRangesList' explains what GRangesList is
  ## appropriate for each variant type.

  ## A. Passing a GRangesList:

  fun <- function(x, subject, ...)
      locateVariants(x, subject, IntronVariants())

  library(TxDb.Hsapiens.UCSC.hg19.knownGene)
  grl <- intronsByTranscript(TxDb.Hsapiens.UCSC.hg19.knownGene)
  mclapply(c(vcf, vcf), fun, subject=grl)


  ## B. Passing a TxDb:

  ## Forking:
  ## In the case of forking, the TxDb cannot be loaded
  ## in the current workspace.
  ## To detach the NAMESPACE:
  ##     unloadNamespace("TxDb.Hsapiens.UCSC.hg19.knownGene")

  fun <- function(x) {
      library(TxDb.Hsapiens.UCSC.hg19.knownGene)
      locateVariants(x, TxDb.Hsapiens.UCSC.hg19.knownGene,
                     IntronVariants())
  }
  mclapply(c(vcf, vcf), fun)

  ## Clusters:
  cl <- makeCluster(2, type = "SOCK")
  fun <- function(query, subject, region) {
      library(VariantAnnotation)
      library(TxDb.Hsapiens.UCSC.hg19.knownGene)
      locateVariants(query, TxDb.Hsapiens.UCSC.hg19.knownGene, region)
  }
  parLapply(cl, c(vcf, vcf), fun, region=IntronVariants())
  stopCluster(cl)
  } # }
```

</div>

</div>

</div>
