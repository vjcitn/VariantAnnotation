<div id="main" class="col-md-9" role="main">

# Run a locally installed Ensembl VEP script on a VCF object or file

<div class="ref-description section level2">

Calls a locally installed `vep` executable, annotates variants, and
returns the result as a `CollapsedVCF` object. This complements
`vep_by_region`, which uses the Ensembl REST API but is limited to 200
variants per request. The local script has no such limit and supports
fully offline operation.

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
run_vep(x, assembly = "GRCh38", species = "homo_sapiens",
        fork = 1L, extra_args = character(), vep_path = NULL)
```

</div>

</div>

<div class="section level2">

## Arguments

-   x:

    A `VCF` object or `character(1)` path to a VCF file.

-   assembly:

    character(1) genome assembly passed to VEP via `--assembly`, e.g.
    `"GRCh38"` or `"GRCh37"`.

-   species:

    character(1) species name as used by VEP, e.g. `"homo_sapiens"`.

-   fork:

    integer(1) number of forks for parallel processing. Default `1L`
    disables forking.

-   extra\_args:

    character() additional flags passed verbatim to `vep`, e.g.
    `c("--sift", "b", "--polyphen", "b")` or `"--offline"`.

-   vep\_path:

    character(1) or NULL. Full path to the `vep` executable. When NULL
    (default) `Sys.which("vep")` is used.

</div>

<div class="section level2">

## Details

Requires a locally installed Ensembl VEP and a matching annotation
cache. See
<https://www.ensembl.org/info/docs/tools/vep/script/vep_download.html>
for installation and cache setup instructions.

VEP is invoked with `--vcf --no_stats --force_overwrite`. The annotated
output VCF is read back with `readVcf` and returned. Consequence
annotations are stored in the `CSQ` field of `info()`.

Pass `"--offline"` in `extra_args` for fully offline operation (requires
a local cache).

</div>

<div class="section level2">

## Value

A `CollapsedVCF` object. VEP consequence annotations appear in
`info(result)$CSQ`.

</div>

<div class="section level2">

## See also

<div class="dont-index">

`vep_by_region` for the REST API alternative; `readVcf`, `writeVcf`.

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
if (FALSE) { # \dontrun{
  fl <- system.file("extdata", "chr22.vcf.gz", package = "VariantAnnotation")
  vcf <- readVcf(fl)
  result <- run_vep(vcf[1:10], assembly = "GRCh38")
  info(result)$CSQ
} # }
```

</div>

</div>

</div>
