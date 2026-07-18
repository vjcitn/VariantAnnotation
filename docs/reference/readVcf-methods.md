<div id="main" class="col-md-9" role="main">

# Read VCF files

<div class="ref-description section level2">

Read Variant Call Format (VCF) files

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'TabixFile,ScanVcfParam'
readVcf(file, genome, param, 
      ..., row.names=TRUE)
  # S4 method for class 'TabixFile,IntegerRangesList'
readVcf(file, genome, param, 
      ..., row.names=TRUE)
  # S4 method for class 'TabixFile,GRanges'
readVcf(file, genome, param, 
      ..., row.names=TRUE)
  # S4 method for class 'TabixFile,GRangesList'
readVcf(file, genome, param, 
      ..., row.names=TRUE)
  # S4 method for class 'TabixFile,missing'
readVcf(file, genome, param, 
      ..., row.names=TRUE)
  # S4 method for class 'character,ANY'
readVcf(file, genome, param, 
      ..., row.names=TRUE)
  # S4 method for class 'character,missing'
readVcf(file, genome, param, 
      ..., row.names=TRUE)
  # S4 method for class 'character,missing'
readVcf(file, genome, param, 
      ..., row.names=TRUE)

## Lightweight functions to read a single variable
readInfo(file, x, param=ScanVcfParam(), ..., row.names=TRUE)
readGeno(file, x, param=ScanVcfParam(), ..., row.names=TRUE)
readGT(file, nucleotides=FALSE, param=ScanVcfParam(), ..., row.names=TRUE)

## Import wrapper
# S4 method for class 'VcfFile,ANY,ANY'
import(con, format, text, ...)
```

</div>

</div>

<div class="section level2">

## Arguments

-   file:

    A `VcfFile` (synonymous with `TabixFile`) instance or character()
    name of the VCF file to be processed. When ranges are specified in
    `param`, `file` must be a `VcfFile`.

    Use of the `VcfFile` methods are encouraged as they are more
    efficient than the character() methods. See ?`VcfFile`, and
    ?`indexVcf` for help creating a `VcfFile`.

-   genome:

    A `character` or `Seqinfo` object.

    `character`:

    :   Genome identifier as a single string or named character vector.
        Names of the character vector correspond to chromosome names in
        the file. This identifier replaces the genome information in the
        VCF `Seqinfo` (i.e., `seqinfo(vcf)`). When not provided,
        `genome` is taken from the VCF file header.

    `Seqinfo`:

    :   When `genome` is provided as a `Seqinfo` it is propagated to the
        VCF output. If seqinfo information can be obtained from the
        file, (i.e., seqinfo(scanVcfHeader(fl)) is not empty), the
        output `Seqinfo` is a product of merging the two.

        If a param (i.e., ScanVcfParam) is used in the call to
        `readVcf`, the seqlevels of the param ranges must be present in
        `genome`.

-   param:

    An instance of `ScanVcfParam`, `GRanges`, `GRangesList` or
    `IntegerRangesList`. VCF files can be subset on genomic coordinates
    (ranges) or elements in the VCF fields. Both genomic coordinates and
    VCF elements can be specified in a `ScanVcfParam`. See
    ?`ScanVcfParam` for details.

-   x:

    `character` name of single `info` or `geno` field to import.
    Applicable to `readInfo` and `readGeno` only.

-   row.names:

    A `logical` specifying if rownames should be returned. In the case
    of `readVcf`, rownames appear on the `GRanges` returned by the
    `rowRanges` accessor.

-   nucleotides:

    A `logical` indicating if genotypes should be returned as
    nucleotides instead of the numeric representation. Applicable to
    `readGT` only.

-   con:

    The `VcfFile` object to import.

-   format, text:

    Ignored.

-   ...:

    Additional arguments, passed to methods. For `import`, the arguments
    are passed to `readVcf`.

</div>

<div class="section level2">

## Details

-   Data Import: :

    VCF object:

    :   `readVcf` imports records from bzip compressed or uncompressed
        VCF files. Data are parsed into a `VCF` object using the file
        header information if available. To import a subset of ranges
        the VCF must have an index file. An index file can be created
        with `bzip` and `indexVcf` functions.

        The `readInfo`, `readGeno` and `readGT` functions are
        lightweight versions of `readVcf` and import a single variable.
        The return object is a vector, matrix or CompressedList instead
        of a VCF class.

    `readVcf` calls `scanVcf`, the details of which can be found with
    `?scanVcf`.

-   Header lines (aka Meta-information): :

    readVcf() reads and parses fields according to the multiplicity and
    data type specified in the header lines. Fields without header lines
    are skipped (not read or parsed). To see what fields are present in
    the header use `scanVcfHeader()`. See ?`VCFHeader` for more details.

    Passing `verbose = TRUE` to `readVcf()` prints the fields with
    header lines that will be parsed by `readVcf`.

-   Data type: :

    CHROM, POS, ID and REF fields are used to create the `GRanges`
    stored in the `VCF` object and accessible with the `rowRanges`
    accessor.

    REF, ALT, QUAL and FILTER are parsed into the `DataFrame` in the
    `fixed` slot. Because ALT can have more than one value per variant
    it is represented as a `DNAStringSetList`. REF is a `DNAStringSet`,
    QUAL is `numeric` and FILTER is a `character`. Accessors include
    `fixed`, `ref`, `alt`, `qual`, and `filt`.

    Data from the INFO field can be accessed with the `info` accessor.
    Genotype data (i.e., data immediately following the FORMAT field in
    the VCF) can be accessed with the `geno` accessor. INFO and genotype
    data types are determined according to the ‘Number’ and ‘Type’
    information in the file header as follows:

    ‘Number’ should only be 0 when ‘Type’ is 'flag'. These fields are
    parsed as logical vectors.

    If ‘Number’ is 1, ‘info’ data are parsed into a `vector` and ‘geno’
    into a `matrix`.

    If ‘Number’ is &gt;1, ‘info’ data are parsed into a `DataFrame` with
    the same number of columns. ‘geno’ are parsed into an `array` with
    the same dimensions as ‘Number’. Columns of the ‘geno’ matrices are
    the samples.

    If ‘Number’ is ‘.’, ‘A’ or ‘G’, both ‘info’ and ‘geno’ data are
    parsed into a `matrix`.

    When the header does not contain any ‘INFO’ lines, the data are
    returned as a single, unparsed column.

-   Missing data: :

    Missing data in VCF files on disk are represented by a dot (".").
    `readVcf` retains the dot as a character string for data type
    character and converts it to `NA` for data types numeric or double.

    Because the data are stored in rectangular data structures there is
    a value for each `info` and `geno` field element in the `VCF` class.
    If the element was missing or was not collected for a particular
    variant the value will be `NA`.

    In the case of the ALT field we have the following treatment of
    special characters / missing values:

    -   '.' true missings become empty characters

    -   '\*' are treated as missing and become empty characters

    -   'I' are treated as undefined and become '.'

-   Efficient Usage: :

    Subsets of data (i.e., specific variables, positions or samples) can
    be read from a VCF file by providing a `ScanVcfParam` object in the
    call to `readVcf`. Other lightweight options are the `readGT`,
    `readInfo` and `readGeno` functions which return data as a matrix
    instead of the `VCF` class.

    Another option for handling large files is to iterate through the
    data in chunks by setting the `yieldSize` parameter in a `VcfFile`
    object. Iteration can be through all data fields or a subset defined
    by a `ScanVcfParam`. See example below, \`Iterating through VCF with
    yieldSize\`.

</div>

<div class="section level2">

## Value

`readVcf` returns a `VCF` object. See ?`VCF` for complete details of the
class structure. `readGT`, `readInfo` and `readGeno` return a `matrix`.

-   rowRanges: :

    The CHROM, POS, ID and REF fields are used to create a `GRanges`
    object. Ranges are created using POS as the start value and width of
    the reference allele (REF). By default, the IDs become the rownames
    ('row.names = FALSE' to turn this off). If IDs are missing (i.e.,
    ‘.’) a string of CHROM:POS\_REF/ALT is used instead. The `genome`
    argument is stored in the seqinfo of the `GRanges` and can be
    accessed with `genome(<VCF>)`.

    One metadata column, `paramRangeID`, is included with the
    `rowRanges`. This ID is meaningful when multiple ranges are
    specified in the `ScanVcfParam` and distinguishes which records
    match each range.

-   fixed: :

    REF, ALT, QUAL and FILTER fields of the VCF are parsed into a
    `DataFrame`.

    REF is returned as a DNAStringSet.

    ALT is a CharacterList when it contains structural variants and a
    DNAStringSetList otherwise. See also the 'Details' section for
    'Missing data'.

-   info: :

    Data from the INFO field of the VCF is parsed into a `DataFrame`.

-   geno: :

    If present, the genotype data are parsed into a list of `matrices`
    or `arrays`. Each list element represents a field in the FORMAT
    column of the VCF file. Rows are the variants, columns are the
    samples.

-   colData: :

    This slot contains a `DataFrame` describing the samples. If present,
    the sample names following FORMAT in the VCF file become the row
    names.

-   metadata: :

    Header information present in the file is put into a `list` in
    `metadata`.

See references for complete details of the VCF file format.

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

Valerie Obenchain&gt;

</div>

<div class="section level2">

## See also

<div class="dont-index">

`indexVcf`, `VcfFile`, `indexTabix`, `TabixFile`, `scanTabix`,
`scanBcf`, `expand,CollapsedVCF-method`

</div>

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  fl <- system.file("extdata", "ex2.vcf", package="VariantAnnotation") 
  vcf <- readVcf(fl, "hg19")
  ## vcf <- readVcf(fl, c("20"="hg19"))  ## 'genome' as named vector

  ## ---------------------------------------------------------------------
  ## Header and genome information 
  ## ---------------------------------------------------------------------
  vcf
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

  ## all header information
  hdr <- header(vcf)

  ## header information for 'info' and 'fixed' fields
  info(hdr)
#> DataFrame with 6 rows and 3 columns
#>         Number        Type            Description
#>    <character> <character>            <character>
#> NS           1     Integer Number of Samples Wi..
#> DP           1     Integer            Total Depth
#> AF           A       Float       Allele Frequency
#> AA           1      String       Ancestral Allele
#> DB           0        Flag dbSNP membership, bu..
#> H2           0        Flag     HapMap2 membership
  fixed(hdr)
#> DataFrameList of length 1
#> names(1): FILTER

  ## ---------------------------------------------------------------------
  ## Accessors
  ## ---------------------------------------------------------------------
  ## fixed fields together
  head(fixed(vcf), 5)
#> DataFrame with 5 rows and 4 columns
#>              REF                ALT      QUAL      FILTER
#>   <DNAStringSet> <DNAStringSetList> <numeric> <character>
#> 1              G                  A        29        PASS
#> 2              T                  A         3         q10
#> 3              A                G,T        67        PASS
#> 4              T                           47        PASS
#> 5            GTC             G,GTCT        50        PASS

  ## fixed fields separately 
  filt(vcf)
#> [1] "PASS" "q10"  "PASS" "PASS" "PASS"
  ref(vcf) 
#> DNAStringSet object of length 5:
#>     width seq
#> [1]     1 G
#> [2]     1 T
#> [3]     1 A
#> [4]     1 T
#> [5]     3 GTC

  ## info data 
  info(hdr)
#> DataFrame with 6 rows and 3 columns
#>         Number        Type            Description
#>    <character> <character>            <character>
#> NS           1     Integer Number of Samples Wi..
#> DP           1     Integer            Total Depth
#> AF           A       Float       Allele Frequency
#> AA           1      String       Ancestral Allele
#> DB           0        Flag dbSNP membership, bu..
#> H2           0        Flag     HapMap2 membership
  info(vcf)
#> DataFrame with 5 rows and 6 columns
#>                       NS        DP            AF          AA        DB
#>                <integer> <integer> <NumericList> <character> <logical>
#> rs6054257              3        14           0.5          NA      TRUE
#> 20:17330_T/A           3        11         0.017          NA     FALSE
#> rs6040355              2        10   0.333,0.667           T      TRUE
#> 20:1230237_T/.         3        13            NA           T     FALSE
#> microsat1              3         9         NA,NA           G     FALSE
#>                       H2
#>                <logical>
#> rs6054257           TRUE
#> 20:17330_T/A       FALSE
#> rs6040355          FALSE
#> 20:1230237_T/.     FALSE
#> microsat1          FALSE
  info(vcf)$DP
#> [1] 14 11 10 13  9

  ## geno data 
  geno(hdr)
#> DataFrame with 4 rows and 3 columns
#>         Number        Type       Description
#>    <character> <character>       <character>
#> GT           1      String          Genotype
#> GQ           1     Integer  Genotype Quality
#> DP           1     Integer        Read Depth
#> HQ           2     Integer Haplotype Quality
  geno(vcf)
#> List of length 4
#> names(4): GT GQ DP HQ
  head(geno(vcf)$GT)
#>                NA00001 NA00002 NA00003
#> rs6054257      "0|0"   "1|0"   "1/1"  
#> 20:17330_T/A   "0|0"   "0|1"   "0/0"  
#> rs6040355      "1|2"   "2|1"   "2/2"  
#> 20:1230237_T/. "0|0"   "0|0"   "0/0"  
#> microsat1      "0/1"   "0/2"   "1/1"  

  ## genome
  unique(genome(rowRanges(vcf)))
#> [1] "hg19"

  ## ---------------------------------------------------------------------
  ## Data subsets with lightweight read* functions 
  ## ---------------------------------------------------------------------

  ## Import a single 'info' or 'geno' variable
  DP <- readInfo(fl, "DP")
  HQ <- readGeno(fl, "HQ")

  ## Import GT as numeric representation 
  GT <- readGT(fl)
  ## Import GT as nucleotides 
  GT <- readGT(fl, nucleotides=TRUE)

  ## ---------------------------------------------------------------------
  ## Data subsets with ScanVcfParam
  ## ---------------------------------------------------------------------

  ## Subset on genome coordinates:
  ## 'file' must have an index
  rngs <- GRanges("20", IRanges(c(14370, 1110000), c(17330, 1234600)))
  names(rngs) <- c("geneA", "geneB")
  param <- ScanVcfParam(which=rngs) 
  compressVcf <- bgzip(fl, tempfile())
  tab <- indexVcf(compressVcf)
  vcf <- readVcf(tab, "hg19", param)

  ## When data are subset by range ('which' argument in ScanVcfParam),
  ## the 'paramRangeID' column provides a map back to the original 
  ## range in 'param'.
  rowRanges(vcf)[,"paramRangeID"]
#> GRanges object with 5 ranges and 1 metadata column:
#>                  seqnames          ranges strand | paramRangeID
#>                     <Rle>       <IRanges>  <Rle> |     <factor>
#>        rs6054257       20           14370      * |        geneA
#>     20:17330_T/A       20           17330      * |        geneA
#>        rs6040355       20         1110696      * |        geneB
#>   20:1230237_T/.       20         1230237      * |        geneB
#>        microsat1       20 1234567-1234569      * |        geneB
#>   -------
#>   seqinfo: 1 sequence from hg19 genome
  vcfWhich(param)
#> IRangesList object of length 1:
#> $`20`
#> IRanges object with 2 ranges and 0 metadata columns:
#>             start       end     width
#>         <integer> <integer> <integer>
#>   geneA     14370     17330      2961
#>   geneB   1110000   1234600    124601
#> 

  ## Subset on samples:
  ## Consult the header for the sample names.
  samples(hdr) 
#> [1] "NA00001" "NA00002" "NA00003"
  ## Specify one or more names in 'samples' in a ScanVcfParam.
  param <- ScanVcfParam(samples="NA00002")
  vcf <- readVcf(tab, "hg19", param)
  geno(vcf)$GT
#>                NA00002
#> rs6054257      "1|0"  
#> 20:17330_T/A   "0|1"  
#> rs6040355      "2|1"  
#> 20:1230237_T/. "0|0"  
#> microsat1      "0/2"  

  ## Subset on 'fixed', 'info' or 'geno' fields:
  param <- ScanVcfParam(fixed="ALT", geno=c("GT", "HQ"), info=c("NS", "AF"))
  vcf_tab <- readVcf(tab, "hg19", param)
  info(vcf_tab)
#> DataFrame with 5 rows and 2 columns
#>                       NS            AF
#>                <integer> <NumericList>
#> rs6054257              3           0.5
#> 20:17330_T/A           3         0.017
#> rs6040355              2   0.333,0.667
#> 20:1230237_T/.         3            NA
#> microsat1              3         NA,NA
  geno(vcf_tab)
#> List of length 2
#> names(2): GT HQ

  ## No ranges are specified in the 'param' so tabix file is not
  ## required. Instead, the uncompressed VCF can be used as 'file'.
  vcf_fname <- readVcf(fl, "hg19", param)

  ## The header will always contain information for all variables
  ## in the original file reguardless of how the data were subset.
  ## For example, all 'geno' fields are listed in the header 
  geno(header(vcf_fname))
#> DataFrame with 4 rows and 3 columns
#>         Number        Type       Description
#>    <character> <character>       <character>
#> GT           1      String          Genotype
#> GQ           1     Integer  Genotype Quality
#> DP           1     Integer        Read Depth
#> HQ           2     Integer Haplotype Quality

  ## but only 'GT' and 'HQ' are present in the VCF object.
  geno(vcf_fname)
#> List of length 2
#> names(2): GT HQ

  ## Subset on both genome coordinates and 'info', 'geno' fields: 
  param <- ScanVcfParam(geno="HQ", info="AF", which=rngs)
  vcf <- readVcf(tab, "hg19", param)

  ## When any of 'fixed', 'info' or 'geno' are omitted (i.e., no
  ## elements specified) all records are retrieved. Use NA to indicate
  ## that no records should be retrieved. This param specifies
  ## all 'fixed fields, the "GT" 'geno' field and none of 'info'.
  ScanVcfParam(geno="GT", info=NA)
#> class: ScanVcfParam 
#> vcfWhich: 0 elements
#> vcfFixed: character() [All] 
#> vcfInfo: NA 
#> vcfGeno: GT 
#> vcfSamples:  

  ## ---------------------------------------------------------------------
  ## Iterate through VCF with 'yieldSize' 
  ## ---------------------------------------------------------------------
  fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
  param <- ScanVcfParam(fixed="ALT", geno=c("GT", "GL"), info=c("LDAF"))
  tab <- VcfFile(fl, yieldSize=4000)
  open(tab)
  while (nrow(vcf_yield <- readVcf(tab, "hg19", param=param)))
      cat("vcf dim:", dim(vcf_yield), "\n")
#> vcf dim: 4000 5 
#> vcf dim: 4000 5 
#> vcf dim: 2376 5 
  close(tab)

  ## ---------------------------------------------------------------------
  ## Debugging with 'verbose'
  ## ---------------------------------------------------------------------
  ## readVcf() uses information in the header lines to parse the data to 
  ## the correct number and type. Fields without header lines are skipped. 
  ## If a call to readVcf() results in no info(VCF) or geno(VCF) data the
  ## file may be missing header lines. Set 'verbose = TRUE' to get
  ## a listing of fields found in the header.

  ## readVcf(myfile, "mygenome", verbose=TRUE)

  ## Header fields can also be discovered with scanVcfHeader().
  hdr <- scanVcfHeader(fl)
  geno(hdr)
#> DataFrame with 3 rows and 3 columns
#>         Number        Type            Description
#>    <character> <character>            <character>
#> GT           1      String               Genotype
#> DS           1       Float Genotype dosage from..
#> GL           G       Float   Genotype Likelihoods
```

</div>

</div>

</div>
