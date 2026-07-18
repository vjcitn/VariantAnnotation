<div id="main" class="col-md-9" role="main">

# VCFHeader instances

<div class="ref-description section level2">

The `VCFHeader` class holds Variant Call Format (VCF) file header
information and is produced from a call to `scanVcfHeader`.

</div>

<div class="section level2">

## Constructor

-   `VCFHeader`:

    `VCFHeader(reference = character(), samples = character(),                       header = DataFrameList(), ...)       `

</div>

<div class="section level2">

## Accessors

In the following code snippets `x` is a VCFHeader object.

-   `samples(x)`:

    Returns a character() vector of names of samples.

-   `header(x)`:

    Returns all information in the header slot which includes `meta`,
    `info` and `geno` if present.

-   `meta(x)`, `meta(x)<- value`:

    The getter returns a `DataFrameList`. Each `DataFrame` represents a
    unique "key" name in the header file. Multiple header lines with the
    same "key" are parsed into the same `DataFrame` with the "ID" field
    as the row names. Simple header lines have no "ID" field in which
    case the "key" is used as the row name.

    NOTE: In VariantAnnotation &lt;= 1.27.5, the `meta()` extractor
    returned a `DataFrame` called "META" which held all simple key-value
    header lines. The VCF 4.3 specs allowed headers lines with key name
    "META" which caused a name clash with the pre-existing "META"
    `DataFrame`.

    In `VariantAnnotation` &gt;=1.27.6 the "META" `DataFrame` was split
    and each row became its own separate `DataFrame`. Calling `meta()`
    on a `VCFHeader` object now returns a list of `DataFrames`, one for
    each unique key name in the header.

-   `fixed(x)`, `fixed(x)<- value`:

    Returns a `DataFrameList` of information pertaining to any of ‘REF’,
    ‘ALT’, ‘FILTER’ and ‘QUAL’. Replacement value must be a
    `DataFrameList` with one or more of the following names, ‘QUAL’,
    ‘FILTER’, ‘REF’ and ‘ALT’.

-   `info(x)`, `info(x)<- value`:

    Gets or sets a `DataFrame` of ‘INFO’ information. Replacement value
    must be a `DataFrame` with 3 columns named ‘Number’, ‘Type’ and
    ‘Description’.

-   `geno(x)`, `geno(x)<- value`:

    Returns a `DataFrame` of ‘FORMAT’ information. Replacement value
    must be a `DataFrame` with 3 columns named ‘Number’, ‘Type’ and
    ‘Description’.

-   `reference(x)`:

    Returns a character() vector with names of reference sequences. Not
    relevant for `scanVcfHeader`.

-   `vcfFields(x)`:

    Returns a `CharacterList` of all available VCF fields, with names of
    `fixed`, `info`, `geno` and `samples` indicating the four
    categories. Each element is a character() vector of available VCF
    field names within each category.

</div>

<div class="section level2">

## Arguments

-   reference:

    A character() vector of sequences.

-   sample:

    A character() vector of sample names.

-   header:

    A `DataFrameList` of parsed header lines (preceeded by “\#\#”)
    present in the VCF file.

-   ...:

    Additional arguments passed to methods.

</div>

<div class="section level2">

## Details

The `VCFHeader` class holds header information from a VCF file.

Slots :

-   `reference`:

    character() vector

-   `sample`:

    character() vector

-   `header`:

    [DataFrameList](https://rdrr.io/pkg/IRanges/man/DataFrameList-class.html)
    class

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

<div class="section level2">

## See also

<div class="dont-index">

`scanVcfHeader`, `DataFrameList`

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  fl <- system.file("extdata", "structural.vcf", package="VariantAnnotation")
  hdr <- scanVcfHeader(fl)

  fixed(hdr)
#> DataFrameList of length 2
#> names(2): FILTER ALT
  info(hdr)
#> DataFrame with 10 rows and 3 columns
#>                Number        Type            Description
#>           <character> <character>            <character>
#> BKPTID              .      String ID of the assembled ..
#> CIEND               2     Integer Confidence interval ..
#> CIPOS               2     Integer Confidence interval ..
#> END                 1     Integer End position of the ..
#> HOMLEN              .     Integer Length of base pair ..
#> HOMSEQ              .      String Sequence of base pai..
#> IMPRECISE           0        Flag Imprecise structural..
#> MEINFO              4      String Mobile element info ..
#> SVLEN               .     Integer Difference in length..
#> SVTYPE              1      String Type of structural v..
  geno(hdr)
#> DataFrame with 4 rows and 3 columns
#>          Number        Type            Description
#>     <character> <character>            <character>
#> GT            1      String               Genotype
#> GQ            1       Float       Genotype quality
#> CN            1     Integer Copy number genotype..
#> CNQ           1       Float Copy number genotype..
  vcfFields(hdr)
#> CharacterList of length 4
#> [["fixed"]] REF ALT QUAL FILTER
#> [["info"]] BKPTID CIEND CIPOS END HOMLEN HOMSEQ IMPRECISE MEINFO SVLEN SVTYPE
#> [["geno"]] GT GQ CN CNQ
#> [["samples"]] NA00001
```

</div>

</div>

</div>
