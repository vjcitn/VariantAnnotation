<div id="main" class="col-md-9" role="main">

# Get transcript sequences

<div class="ref-description section level2">

This function is defunct. Use GenomicFeatures::extractTranscriptSeqs()
instead.

Extract transcript sequences from a
[BSgenome](https://rdrr.io/pkg/BSgenome/man/BSgenome-class.html) object
or an [FaFile](https://rdrr.io/pkg/Rsamtools/man/FaFile-class.html).

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'GRangesList,BSgenome'
getTranscriptSeqs(query, subject, ...)
  # S4 method for class 'GRangesList,FaFile'
getTranscriptSeqs(query, subject, ...)
  # S4 method for class 'GRanges,FaFile'
getTranscriptSeqs(query, subject, ...)
```

</div>

</div>

<div class="section level2">

## Arguments

-   query:

    A
    [GRangesList](https://rdrr.io/pkg/GenomicRanges/man/GRangesList-class.html)
    object containing exons or cds grouped by transcript.

-   subject:

    A [BSgenome](https://rdrr.io/pkg/BSgenome/man/BSgenome-class.html)
    object or a
    [FaFile](https://rdrr.io/pkg/Rsamtools/man/FaFile-class.html) from
    which the sequences will be taken.

-   ...:

    Additional arguments

</div>

<div class="section level2">

## Details

`getTranscriptSeqs` is a wrapper for the `extractTranscriptSeqs` and
`getSeq` functions. The purpose is to allow sequence extraction from
either a
[BSgenome](https://rdrr.io/pkg/BSgenome/man/BSgenome-class.html) or
[FaFile](https://rdrr.io/pkg/Rsamtools/man/FaFile-class.html).
Transcript sequences are extracted based on the boundaries of the
feature provided in the `query` (i.e., either exons or cds regions).

</div>

<div class="section level2">

## Value

A
[DNAStringSet](https://rdrr.io/pkg/Biostrings/man/XStringSet-class.html)
instance containing the sequences for all transcripts specified in
`query`.

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

[predictCoding](https://github.com/vjcitn/VariantAnnotation/reference/predictCoding-methods.md)
[extractTranscriptSeqs](https://rdrr.io/pkg/GenomicFeatures/man/extractTranscriptSeqs.html)
[getSeq](https://rdrr.io/pkg/Biostrings/man/getSeq.html)

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
## See ?extractTranscriptSeqs in the GenomicFeatures package.
```

</div>

</div>

</div>
