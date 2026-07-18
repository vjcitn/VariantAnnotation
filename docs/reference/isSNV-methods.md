<div id="main" class="col-md-9" role="main">

# Identification of genomic variant types.

<div class="ref-description section level2">

Functions for identifying variant types such as SNVs, insertions,
deletions, transitions, and structural rearrangements.

</div>

<div class="section level2">

## Usage

<div class="sourceCode">

``` r
# S4 method for class 'VRanges'
isSNV(x, ...)
# S4 method for class 'ExpandedVCF'
isSNV(x, ...)
# S4 method for class 'CollapsedVCF'
isSNV(x, ..., singleAltOnly = TRUE)

# S4 method for class 'VRanges'
isInsertion(x, ...)
# S4 method for class 'ExpandedVCF'
isInsertion(x, ...)
# S4 method for class 'CollapsedVCF'
isInsertion(x, ..., singleAltOnly = TRUE)

# S4 method for class 'VRanges'
isDeletion(x, ...)
# S4 method for class 'ExpandedVCF'
isDeletion(x, ...)
# S4 method for class 'CollapsedVCF'
isDeletion(x, ..., singleAltOnly = TRUE)

# S4 method for class 'VRanges'
isIndel(x, ...)
# S4 method for class 'ExpandedVCF'
isIndel(x, ...)
# S4 method for class 'CollapsedVCF'
isIndel(x, ..., singleAltOnly = TRUE)

# S4 method for class 'VRanges'
isDelins(x, ...)
# S4 method for class 'ExpandedVCF'
isDelins(x, ...)
# S4 method for class 'CollapsedVCF'
isDelins(x, ..., singleAltOnly = TRUE)

# S4 method for class 'VRanges'
isTransition(x, ...)
# S4 method for class 'ExpandedVCF'
isTransition(x, ...)
# S4 method for class 'CollapsedVCF'
isTransition(x, ..., singleAltOnly = TRUE)

# S4 method for class 'VRanges'
isSubstitution(x, ...)
# S4 method for class 'ExpandedVCF'
isSubstitution(x, ...)
# S4 method for class 'CollapsedVCF'
isSubstitution(x, ..., singleAltOnly = TRUE)
```

</div>

</div>

<div class="section level2">

## Arguments

-   x:

    A
    [VCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md)
    or
    [VRanges](https://github.com/vjcitn/VariantAnnotation/reference/VRanges-class.md)
    object.

-   singleAltOnly:

    A `logical` only applicable when `x` is a
    [CollapsedVCF](https://github.com/vjcitn/VariantAnnotation/reference/VCF-class.md)
    class.

    When `TRUE` (default) only variants with a single alternate allele
    are evaluated; all multi-alt variants evaluate to `FALSE`. When
    `singleAltOnly=FALSE` all ref / alt pairs for each variant are
    evaluated. If any ref / alt pairs meet the test criteria a value of
    TRUE is returned for the variant; this may result in a value of TRUE
    for a variant with a mixture of alternate alleles, some that pass
    the criteria and some that do not. To retain single ref / alt pairs
    that pass the critera use `expand` on the `CollapsedVCF` and then
    apply the test.

-   ...:

    Arguments passed to other methods.

</div>

<div class="section level2">

## Details

All functions return a logical vector the length of `x`. Variants in
gvcf files with NON\_REF alt alleles return TRUE; structural variants
return FALSE.

-   isSNV: :

    Reference and alternate alleles are both a single nucleotide long.

-   isInsertion: :

    Reference allele is a single nucleotide and the alternate allele is
    greater (longer) than a single nucleotide and the first nucleotide
    of the alternate allele matches the reference.

-   isDeletion: :

    Alternate allele is a single nucleotide and the reference allele is
    greater (longer) than a single nucleotide and the first nucleotide
    of the reference allele matches the alternate.

-   isIndel: :

    The variant is either a deletion or insertion as determined by
    `isDeletion` and `isInsertion`.

-   isDelins: :

    The variant is a deletion followed by an insertion, either of them
    involving two or more nucleotides.

-   isSubstition: :

    Reference and alternate alleles are the same length (1 or more
    nucleotides long).

-   isTransition: :

    Reference and alternate alleles are both a single nucleotide long.
    The reference-alternate pair interchange is of either two-ring
    purines (A &lt;-&gt; G) or one-ring pyrimidines (C &lt;-&gt; T).

</div>

<div class="section level2">

## Value

A `logical` vector the same length as `x`.

</div>

<div class="section level2">

## Author

Michael Lawrence, Valerie Obenchain and Robert Castelo

</div>

<div class="section level2">

## Examples

<div class="sourceCode">

``` r
  fl <- system.file("extdata", "ex2.vcf", package="VariantAnnotation")
  ## ---------------------------------------------------------------------
  ## VCF objects 
  ## ---------------------------------------------------------------------
  vcf <- readVcf(fl, "hg19")
  DataFrame(ref(vcf), alt(vcf))
#> DataFrame with 5 rows and 2 columns
#>         ref.vcf.           alt.vcf.
#>   <DNAStringSet> <DNAStringSetList>
#> 1              G                  A
#> 2              T                  A
#> 3              A                G,T
#> 4              T                   
#> 5            GTC             G,GTCT

  ## This vcf has transitions in row 2 and 3. When 'singleAltOnly=TRUE' 
  ## only the row 2 variant is identified:
  isTransition(vcf)
#> [1]  TRUE FALSE FALSE FALSE FALSE

  ## Both row 2 and 3 are identified when 'singleAltOnly=FALSE':
  isTransition(vcf, singleAltOnly=FALSE)
#> [1]  TRUE FALSE  TRUE FALSE FALSE

  ## Expand the CollapsedVCF to ExpandedVCF
  evcf <- expand(vcf)
#> Error: unable to find an inherited method for function ‘expand’ for signature ‘x = "CollapsedVCF"’
 
  ## All ref / alt pairs are now expanded and there is no need to 
  ## use 'singleAltOnly'. The return length is now 7 instead of 5:
  transition <- isTransition(evcf)
#> Error in h(simpleError(msg, call)): error in evaluating the argument 'x' in selecting a method for function 'isTransition': object 'evcf' not found
  transition
#> Error: object 'transition' not found
  DataFrame(ref(evcf)[transition], alt(evcf)[transition])
#> Error in h(simpleError(msg, call)): error in evaluating the argument 'x' in selecting a method for function 'ref': object 'evcf' not found
 
  ## ---------------------------------------------------------------------
  ## VRanges objects 
  ## ---------------------------------------------------------------------
  ## A VRanges object holds data from a VCF class in a completely
  ## 'flat' fashion. INFO and FORMAT variables for all subjects are
  ## 'repped' out such that each row is a unique combination of data.
  vr <- as(vcf, "VRanges")
  isSNV(vr, singleAltOnly=FALSE)
#>  [1]  TRUE  TRUE  TRUE  TRUE    NA FALSE FALSE  TRUE  TRUE  TRUE  TRUE    NA
#> [13] FALSE FALSE  TRUE  TRUE  TRUE  TRUE    NA FALSE FALSE
```

</div>

</div>

</div>
