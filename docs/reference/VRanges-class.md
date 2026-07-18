<div id="main" class="col-md-9" role="main">

# VRanges objects

<div class="ref-description section level2">

The VRanges class is a container for variant calls, including SNVs and
indels. It extends `GRanges` to provide special semantics on top of a
simple vector of genomic locations. While it is not as expressive as the
`VCF` object, it is a simpler alternative that may be convenient for
variant calling/filtering and similar exercises.

</div>

<div class="section level2">

## Details

VRanges extends GRanges to store the following components. Except where
noted, the components are considered columns in the dataset, i.e., their
lengths match the number of variants. Many columns can be stored as
either an atomic vector or an Rle.

-   `ref`:

    (`character`), the reference allele. The range (start/end/width)
    should always correspond to this sequence.

-   `alt`:

    (`character/Rle`), the alternative allele (NA allowed). By
    convention there is only a single alt allele per element (row) of
    the VRanges. Many methods, like `match`, make this assumption.

-   `refCount`:

    (`integer/Rle`), read count for the reference allele (NA allowed)

-   `altCount`:

    (`integer/Rle`), read count for the alternative allele (NA allowed)

-   `totalCount`:

    (`integer/Rle`), total read count at the position, must be at least
    `refCount+altCount` (NA allowed)

-   `sampleNames`:

    (`factor/Rle`), name of the sample - results from multiple samplse
    can be combined into the same object (NA allowed)

-   `softFilterMatrix`:

    (`matrix/FilterMatrix`), variant by filter matrix, `TRUE` where
    variant passed the filter; use a `FilterMatrix` to store the actual
    `FilterRules` object that was applied

-   `hardFilters`:

    (`FilterRules`) record of hard filters applied, i.e., only the
    variants that passed the filters are present in this object; this is
    the only component that is not a column, i.e., its length does not
    match the number of variants

Except in the special circumstances described here, a `VRanges` may be
treated like a `GRanges`. The range should span the sequence in `ref`.
Indels are typically represented by the VCF convention, i.e., the start
position is one upstream of the event. The strand is always constrained
to be positive (+).

Indels, by convention, should be encoded VCF-style, with the upstream
reference base prepended to the indel sequence. The ref/alt for a
deletion of GCGT before A might be AGCGT/A and for an insertion might be
A/AGCGT. Since the range always matches the `ref` sequence, this means a
deletion will be the width of the deletion + 1, and an insertion is
always of width 1.

VRanges and the VCF class: The VRanges and VCF classes encode different
types of information and are semantically incompatible. While methods
exist for converting a VCF object to a VRanges and vice versa,
information is lost in the transformation. There is no way to collapse
multiple rows of a VRanges at the same genomic position and accurately
represent missing data. For this reason, it is not reasonable to assume
that an object resulting from multiple conversions (VRanges -&gt; VCF
-&gt; VRanges) will be equivalent to the original.

</div>

<div class="section level2">

## Constructors

-   `VRanges(...)`:

    `VRanges(seqnames = Rle(), ranges = IRanges(), ref = character(),         alt = NA_character_, totalDepth = NA_integer_, refDepth = NA_integer_,         altDepth = NA_integer_, ..., sampleNames = NA_character_,         softFilterMatrix = FilterMatrix(matrix(nrow = length(gr),         ncol = 0L), FilterRules()), hardFilters = FilterRules())`:
    Creates a VRanges object.

    `seqnames`

    :   Rle object, character vector, or factor containing the sequence
        names.

    `ranges`

    :   IRanges object containing the ranges.

    `ref`

    :   character vector, containing the reference allele.

    `alt`

    :   character vector/Rle, containing the alternative allele (NA
        allowed).

    `totalDepth`

    :   integer vector/Rle, containing the total read depth (NA
        allowed).

    `refDepth`

    :   integer vector/Rle, containing the reference read depth (NA
        allowed).

    `altDepth`

    :   integer vector/Rle, containing the reference read depth (NA
        allowed).

    `...`

    :   Arguments passed to the `GRanges` constructor.

    `sampleNames`

    :   character/factor vector/Rle, containing the sample names (NA
        allowed).

    `softFilterMatrix`

    :   a matrix (typically a `FilterMatrix`) of dimension variant by
        filter, with logical values indicating whether a variant passed
        the filter.

    `hardFilters`

    :   a `FilterRules`, containing the filters that have already been
        applied to subset the object to its current state.

-   `makeVRangesFromGRanges(...)`:

    `makeVRangesFromGRanges(gr,                                    ref.field="ref",                                    alt.field="alt",                                    totalDepth.field="totalDepth",                                    refDepth.field="refDepth",                                    altDepth.field="altDepth",                                    sampleNames.field="sampleNames",                                    keep.extra.columns=TRUE)`:
    Creates a VRanges object from a GRanges.

    `gr`

    :   A
        [GenomicRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
        object.

    `ref.field`

    :   The `character(1)` name of the GRanges metadata column to be
        used as the VRanges `ref` field.

    `alt.field`

    :   The `character(1)` name of the GRanges metadata column to be
        used as the VRanges `alt` field.

    `totalDepth.field`

    :   The `character(1)` name of the GRanges metadata column to be
        used as the VRanges `totalDepth` field.

    `refDepth.field`

    :   The `character(1)` name of the GRanges metadata column to be
        used as the VRanges `refDepth` field.

    `altDepth.field`

    :   The `character(1)` name of the GRanges metadata column to be
        used as the VRanges `altDepth` field.

    `sampleNames.field`

    :   The `character(1)` name of the GRanges metadata column to be
        used as the VRanges `sampleNames` field.

    `keep.extra.columns`

    :   `TRUE` (the default) or `FALSE`. If `TRUE`, then the columns in
        `gr` that are not used to form the VRanges are retained as
        metadata columns. Otherwise, they will be ignored.

</div>

<div class="section level2">

## Coercion

These functions/methods coerce objects to and from `VRanges`:

-   `asVCF(x, info, filter, meta)`:

    `asVCF(x, info = character(), filter = character(), meta =         character())`:
    Creates a VCF object from a VRanges object. The following gives the
    mapping from VRanges components to VCF:

    seqnames(x)

    :   CHROM column

    start(x)

    :   POS column

    names(x)

    :   ID column

    ref(x)

    :   REF column

    alt(x)

    :   ALT column

    totalDepth(x)

    :   DP in FORMAT column

    altDepth(x), refDepth(x)

    :   AD in FORMAT column

    sampleNames(x)

    :   Names the sample columns

    softFilterMatrix(x)

    :   FT in FORMAT column, except filters named in `filter` argument,
        which are considered per-position and placed in the FILTER
        column

    hardFilters(x)

    :   Not yet exported

    mcols(x)

    :   Become fields in the FORMAT column; unless they are named in the
        `info` argument, in which case they are considered per-position
        and placed in the INFO column

    metadata(x)

    :   If named in the `meta` argument, output in the VCF header; a
        component is required to be coercible to a character vector of
        length one.

    Note that `identical(x, as(as(x, "VCF"), "VRanges"))` generally
    return `FALSE`. During coercion to VCF, the "geno" components are
    reshaped into matrix form, with NAs filling the empty cells. The
    reverse coercion will not drop the NA values, so rows are added to
    the new VRanges. All logical values will become integers in VCF, and
    there is no automatic way of regenerating the logical column with
    the reverse coercion. There are many other cases of irreversibility.

-   `as(from, "VCF")`:

    Like calling `asVCF(from)`.

-   `as(from, "VRanges")`:

    When `from` is a `VCF` this coercion is essentially the inverse of
    `asVCF`. Information missing in the VCF is imputed as NA.

    When `from` is a `GRanges`, metadata columns of `ref`, `alt`,
    `refDepth`, `altDepth`, `totalDepth` and `sampleNames` are
    transfered to the `VRanges` object. Additional metadata columns in
    the `GRanges` can be retained or dropped with `keep.extra.columns`.
    See also `makeVRangesFromGRanges`.

</div>

<div class="section level2">

## Accessors

In addition to all of the `GRanges` accessors, `VRanges` provides the
following, where `x` is a VRanges object.

-   `alt(x)`, `alt(x) <- value`:

    Get or set the alt allele (character).

-   `ref(x)`, `ref(x) <- value`:

    Get or set the ref allele (character).

-   `altDepth(x)`, `altDepth(x) <- value`:

    Get or set the alt allele read depth (integer).

-   `refDepth(x)`, `refDepth(x) <- value`:

    Get or set the ref allele read depth (integer).

-   `totalDepth(x)`, `totalDepth(x) <- value`:

    Get or set the total read depth (integer).

-   `altFraction(x)`:

    Returns `altDepth(x)/totalDepth(x)` (numeric).

-   `sampleNames(x)`, `sampleNames(x) <- value`:

    Get or set the sample names (character/factor).

-   `softFilterMatrix(x)`, `softFilterMatrix(x) <- value`:

    Gets or sets the soft filter matrix (any matrix, but ideally a
    `FilterMatrix`).

-   `resetFilter(x)`:

    Removes all columns from `softFilterMatrix`.

-   `called(x)`:

    Returns whether all filter results in `softFilterMatrix(x)` are
    `TRUE` for each variant.

-   `hardFilters(x)`, `hardFilters(x) <- value`:

    Gets or sets the hard filters (those applied to yield the current
    subset).

</div>

<div class="section level2">

## Utilities and Conveniences

-   `match(x)`:

    Like GRanges `match`, except matches on the combination of
    chromosome, start, width, and **alt**.

-   `tabulate(bin)`:

    Finds `unique(bin)` and counts how many times each unique element
    occurs in `bin`. The result is stored in `mcols(bin)$sample.count`.

-   `softFilter(x, filters, ...)`:

    Applies the `FilterRules` in `filters` to `x`, storing the results
    in `softFilterMatrix`.

</div>

<div class="section level2">

## Input/Output to/from VCF

-   `writeVcf(obj, filename, ...)`:

    Coerces to a VCF object and writes it to a file; see `writeVcf`.

-   `readVcfAsVRanges(x, genome, param, ...)`:

    `readVcfAsVRanges(x, genome, param = ScanVcfParam(), ...)`: Reads a
    VCF `x` directly into a `VRanges`; see `readVcf` for details on the
    arguments. `readVcfAsVRanges` is an alternative syntax to

    <div class="sourceCode">

          as(readVcf(), "VRanges") 

    </div>

    NOTE: By default all INFO and FORMAT fields are read in with
    `ScanVcfParam()`. The minimal information needed to create the
    `VRanges` can be specified as follows:

    <div class="sourceCode">

          ScanVcfParam(fixed = "ALT", info = NA, geno = "AD")) 

    </div>

</div>

<div class="section level2">

## Variant Type

Functions to identify variant type include
[isSNV](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md),
[isInsertion](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md),
[isDeletion](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md),
[isIndel](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md),
[isSubstitution](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md)
and
[isTransition](https://github.com/vjcitn/VariantAnnotation/reference/isSNV-methods.md).
See the ?`isSNV` man page for details.

</div>

<div class="section level2">

## Author

Michael Lawrence. `makeVRangesFromGRanges` was contributed by Thomas
Sandmann.

</div>

<div class="section level2">

## See also

<div class="dont-index">

[VRangesList](https://github.com/vjcitn/VariantAnnotation/reference/VRangesList-class.md),
a list of `VRanges`; `bam_tally` in the gmapR package, which generates a
`VRanges`.

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
## construction
vr <- VRanges(seqnames = c("chr1", "chr2"),
              ranges = IRanges(c(1, 10), c(5, 20)),
              ref = c("T", "A"), alt = c("C", "T"),
              refDepth = c(5, 10), altDepth = c(7, 6),
              totalDepth = c(12, 17), sampleNames = letters[1:2],
              hardFilters =
                FilterRules(list(coverage = function(x) totalDepth > 10)),
              softFilterMatrix =
                FilterMatrix(matrix = cbind(depth = c(TRUE, FALSE)),
                             FilterRules(depth = function(x) altDepth(x) > 6)),
              tumorSpecific = c(FALSE, TRUE))

## simple accessors
ref(vr)
#> [1] "T" "A"
alt(vr)
#> [1] "C" "T"
altDepth(vr)
#> [1] 7 6
vr$tumorSpecific
#> [1] FALSE  TRUE
called(vr)
#> [1]  TRUE FALSE

## coerce to VCF and write
vcf <- as(vr, "VCF")
## writeVcf(vcf, "example.vcf")
## or just
## writeVcf(vr, "example.vcf")

## other utilities
match(vr, vr[2:1])
#> [1] 2 1
```

</div>

</div>

</div>
