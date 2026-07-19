<div id="main" class="col-md-9" role="main">

# Filter VCF files

<div class="ref-description section level2">

Filter Variant Call Format (VCF) files from one file to another

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'character'
filterVcf(file, genome, destination, ..., verbose = TRUE,
    index = FALSE, prefilters = FilterRules(), filters = FilterRules(),
    param = ScanVcfParam())

# S4 method for class 'TabixFile'
filterVcf(file, genome, destination, ..., verbose = TRUE,
    index = FALSE, prefilters = FilterRules(), filters = FilterRules(),
    param = ScanVcfParam())
```

</div>

</div>

<div class="section level2">

## Arguments

-   file:

    A `character(1)` file path or `TabixFile` specifying the VCF file to
    be filtered.

-   genome:

    A `character(1)` identifier

-   destination:

    A `character(1)` path to the location where the filtered VCF file
    will be written.

-   ...:

    Additional arguments, possibly used by future methods.

-   verbose:

    A `logical(1)` indicating whether progress messages should be
    printed.

-   index:

    A `logical(1)` indicating whether the filtered file should be
    compressed and indexed (using `bgzip` and `indexTabix`).

-   prefilters:

    A `FilterRules-class` instance contains rules for filtering
    un-parsed lines of the VCF file.

-   filters:

    A `FilterRules-class` instance contains rules for filtering fully
    parsed VCF objects.

-   param:

    A `ScanVcfParam` instance restricting input of particular `info` or
    `geno` fields, or genomic locations. Applicable when applying a
    `filter` only. Prefiltering involves a grep of unparsed lines in the
    file; indexing is not used.

</div>

<div class="section level2">

## Details

This function transfers content of one VCF file to another, removing
records that fail to satisfy `prefilters` and `filters`. Filtering is
done in a memory efficient manner, iterating over the input VCF file in
chunks of default size 100,000 (when invoked with `character(1)` for
`file`) or as specified by the `yieldSize` argument of `TabixFile` (when
invoked with `TabixFile`).

There are up to two passes. In the first pass, unparsed lines are passed
to `prefilters` for filtering, e.g., searching for a fixed character
string. In the second pass lines successfully passing `prefilters` are
parsed into `VCF` instances and made available for further filtering.
One or both of `prefilter` and `filter` can be present.

Filtering works by removing the rows (variants) that do not meet a
criteria. Because this is a row-based approach and samples are
column-based most genotype filters are only meaningful for single-sample
files. If a single samples fails the criteria the entire row (all
samples) are removed. The case where genotype filtering is effective for
multiple samples is when the criteria is applied across samples and not
to the individual (e.g., keep rows where all samples have DP &gt; 10).

</div>

<div class="section level2">

## Value

The destination file path as a `character(1)`.

</div>

<div class="section level2">

## Author

Martin Morgan and Paul Shannon

</div>

<div class="section level2">

## See also

<div class="dont-index">

`readVcf`, `writeVcf`.

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")

## -----------------------------------------------------------------------
## Filter for SNVs in a defined set of ranges:
## -----------------------------------------------------------------------

if (require(TxDb.Hsapiens.UCSC.hg19.knownGene)) {

  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
  exons <- exons(txdb)
  exons22 <- exons[seqnames(exons) == "chr22"]

  library(GenomeInfoDb)
  seqlevelsStyle(exons22) <- "NCBI"  ## match chrom names in VCF file
 
  ## Range-based filter:
  withinRange <- function(rng)
      function(x) x 

  ## The first filter identifies SNVs and the second applies the 
  ## range restriction.
  filters <- FilterRules(list(
      isSNV = isSNV, 
      withinRange = withinRange(exons22)))

  ## Apply
  if (FALSE) { # \dontrun{
  filt1 <- filterVcf(fl, "hg19", tempfile(), filters=filters, verbose=TRUE)
  } # }
}
#> Loading required package: TxDb.Hsapiens.UCSC.hg19.knownGene
#> Loading required package: GenomicFeatures
#> Loading required package: AnnotationDbi
#> Warning: cannot switch some hg19's seqlevels from UCSC to NCBI style

## -----------------------------------------------------------------------
## Using a pre-filter and filter:
## -----------------------------------------------------------------------

## Low coverage exome snp filter:
lowCoverageExomeSNP = function(x) grepl("LOWCOV,EXOME", x, fixed=TRUE)

## The pre-filter identifies low coverage exome snps and the filter
## identifies variants with INFO variable VT = SNP.
pre <- FilterRules(list(lowCoverageExomeSNP = lowCoverageExomeSNP))
filt <- FilterRules(list(VTisSNP = function(x) info(x)$VT == "SNP"))

## Apply
filt2 <- filterVcf(fl, "hg19", tempfile(), prefilters=pre, filters=filt)
#> starting prefilter
#> prefiltering 10376 records
#> prefiltered to /var/folders/yw/gfhgh7k565v9w83x_k764wbc0000gp/T//Rtmp6qB1Ev/file25f05f43a1ce
#> prefilter compressing and indexing ‘/var/folders/yw/gfhgh7k565v9w83x_k764wbc0000gp/T//Rtmp6qB1Ev/file25f05f43a1ce’
#> starting filter
#> filtering 794 records
#> completed filtering

## Filtered results
vcf <- readVcf(filt2, "hg19")
```

</div>

</div>

</div>
