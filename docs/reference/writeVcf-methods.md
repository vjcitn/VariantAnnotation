<div id="main" class="col-md-9" role="main">

# Write VCF files

<div class="ref-description section level2">

Write Variant Call Format (VCF) files to disk

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'VCF,character'
writeVcf(obj, filename, index = FALSE, ...)
# S4 method for class 'VCF,connection'
writeVcf(obj, filename, index = FALSE, ...)
```

</div>

</div>

<div class="section level2">

## Arguments

-   obj:

    Object containing data to be written out. At present only accepts
    [VCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md).

-   filename:

    The character() name of the VCF file, or a connection (e.g.,
    `file()`), to be written out. A connection opened with `open = "a"`
    will have header information written only if the file does not
    already exist.

-   index:

    Whether to bgzip the output file and generate a tabix index.

-   ...:

    Additional arguments, passed to methods.

    -   nchunk: Integer or NA. When provided this argument overrides the
        default chunking behavior of `writeVcf`, see Details section. An
        integer value specifies the number of records in each chunk; NA
        disables chunking.

</div>

<div class="section level2">

## Note

NOTE: `VariantAnnotation` &gt;= 1.27.6 supports VCFv4.3. See the NOTE on
the `?VCFHeader` man page under the `meta()` extractor for a description
of how header parsing has changed to accommodate the new header lines
with key name of 'META'.

</div>

<div class="section level2">

## Details

A VCF file can be written out from data in a `VCF` object. More general
methods to write out from other objects may be added in the future.

`writeVcf` writes out the header fields in a `VCF` object 'as-is' with
the exception of these key-value pairs:

-   fileformat: When missing, a line is added at the top of the file
    with the current supported version. `VariantAnnotation` &gt;=1.27.6
    supports VCFv4.3.

-   fileDate: When missing, a line is added with today's date. If the
    key-value pair exists, the date is overwritten with today's date.

-   contig: When missing, `VariantAnnotation` attempts to use the
    `Seqinfo` of the `VCF` object to determine the contig information.

Large VCF files (i.e., &gt; 1e5 records) are written out in chunks; VCF
files with &lt; 1e5 records are not chunked. The optimal number of
records per chunk depends on both the number of records and complexity
of the data. Currently `writeVcf` determines records per chunk based on
the total number of records only. To override this behavior or
experiment with other values use `nchunk` as an integer or NA. An
integer value represents the number of records per chunk regardless of
the size of the VCF; NA disables all chunking.

-   writeVcf(vcf, tempfile()) \#\# default chunking

-   writeVcf(vcf, tempfile(), nchunk = 1e6) \#\# chunk by 1e6

-   writeVcf(vcf, tempfile(), nchunk = NA) \#\# no chunking

</div>

<div class="section level2">

## Value

VCF file

</div>

<div class="section level2">

## References

[http://vcftools.sourceforge.net/specs.html](http://vcftools.sourceforge.net/specs.md)
outlines the VCF specification.

[http://samtools.sourceforge.net/mpileup.shtml](http://samtools.sourceforge.net/mpileup.smd)
contains information on the portion of the specification implemented by
`bcftools`.

<http://samtools.sourceforge.net/> provides information on `samtools`.

</div>

<div class="section level2">

## Author

Valerie Obenchain and Michael Lawrence

</div>

<div class="section level2">

## See also

<div class="dont-index">

`readVcf`

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  fl <- system.file("extdata", "ex2.vcf", package="VariantAnnotation")
 
  out1.vcf <- tempfile()
  out2.vcf <- tempfile() 
  in1 <- readVcf(fl, "hg19")
  writeVcf(in1, out1.vcf)
  in2 <- readVcf(out1.vcf, "hg19")
  writeVcf(in2, out2.vcf)
  in3 <- readVcf(out2.vcf, "hg19")
  stopifnot(all(in2 == in3))

  ## write incrementally
  out3.vcf <- tempfile()
  con <- file(out3.vcf, open="a")
  writeVcf(in1[1:2,], con)
  writeVcf(in1[-(1:2),], con)
  close(con)
  readVcf(out3.vcf, "hg19")
#> class: CollapsedVCF 
#> dim: 5 3 
#> rowRanges(vcf):
#>   GRanges with 5 metadata columns: paramRangeID, REF, ALT, QUAL, FILTER
#> info(vcf):
#>   DataFrame with 6 columns: NS, DP, AF, AA, DB, H2
#> info(header(vcf)):
#>       Number Type    Description                
#>    NS 1      Integer Number of Samples With Data
#>    DP 1      Integer Total Depth                
#>    AF A      Float   Allele Frequency           
#>    AA 1      String  Ancestral Allele           
#>    DB 0      Flag    dbSNP membership, build 129
#>    H2 0      Flag    HapMap2 membership         
#> geno(vcf):
#>   List of length 4: GT, GQ, DP, HQ
#> geno(header(vcf)):
#>       Number Type    Description      
#>    GT 1      String  Genotype         
#>    GQ 1      Integer Genotype Quality 
#>    DP 1      Integer Read Depth       
#>    HQ 2      Integer Haplotype Quality
```

</div>

</div>

</div>
