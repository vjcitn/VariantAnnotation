<div id="main" class="col-md-9" role="main">

# Defunct Functions in Package `VariantAnnotation`

<div class="ref-description section level2">

The functions or variables listed here are no longer part of
`VariantAnnotation`.

</div>

<div class="section level2">

## usage

\#\# Removed

-   refLocsToLocalLocs()

-   readVcfLongForm()

-   dbSNPFilter()

-   regionFilter()

-   MatrixToSnpMatrix()

-   getTranscriptSeqs()

-   VRangesScanVcfParam()

-   restrictToSNV()

</div>

<div class="section level2">

## Details

\#\# Removed

-   `refLocsToLocalLocs` has been replaced by `mapToTranscripts` and
    `pmapToTranscripts`.

-   `readVcfLongForm` has been replaced by `expand`.

-   `dbSNPFilter` and `regionFilter` have been replaced by `filterVcf`.

-   `regionFilter` has been replaced by `filterVcf`.

-   `MatrixToSnpMatrix` has been replaced by `genotypeToSnpMatrix`.

-   `getTranscriptSeqs` has been replaced by `extractTranscriptSeqs` in
    the GenomicFeatures package.

-   `VRangesScanVcfParam` has been replaced by `ScanVcfParam`.

-   `restrictToSVN` has been replaced by `isSNV`.

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

-   `expand`

-   `filterVcf`

-   `genotypeToSnpMatrix`

-   `mapToTranscripts`

-   `extractTranscriptSeqs`

-   `isSNV`

-   `ScanVcfParam`

</div>

</div>

</div>
