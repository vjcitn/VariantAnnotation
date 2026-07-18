# VariantAnnotation

Bioconductor package for reading, writing, and annotating genetic variants in
VCF format. Full documentation at
<https://vjcitn.github.io/VariantAnnotation/>.

## Installation

```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("VariantAnnotation")
```

## Function categories

### VCF I/O

Read, write, scan, and filter VCF files. `ScanVcfParam` controls which
chromosomal regions, samples, and fields are loaded.

```r
vcf <- readVcf("variants.vcf.gz", genome = "hg19")
writeVcf(vcf, "output.vcf")
filterVcf("variants.vcf.gz", genome = "hg19", destination = "filtered.vcf.gz",
          filters = FilterRules(list(minQ = function(x) !is.na(fixed(x)$QUAL) & fixed(x)$QUAL > 20)))
```

Key functions: `readVcf`, `writeVcf`, `scanVcf`, `scanVcfHeader`,
`filterVcf`, `indexVcf`, `VcfFile`, `ScanVcfParam`

---

### VCF data structures and accessors

`CollapsedVCF` (one row per variant, multi-allelic ALT stored as list) and
`ExpandedVCF` (one row per allele) form the core data model. Standard
accessors retrieve each VCF component.

```r
ref(vcf)        # reference alleles
alt(vcf)        # alternate alleles (DNAStringSetList for CollapsedVCF)
info(vcf)       # INFO fields as a DataFrame
geno(vcf)$GT    # genotype matrix
header(vcf)     # VCFHeader with meta, contig, and format info
evcf <- VariantAnnotation::expand(vcf)  # CollapsedVCF -> ExpandedVCF
```

Key functions/classes: `VCF`, `CollapsedVCF`, `ExpandedVCF`, `VCFHeader`,
`fixed`, `ref`, `alt`, `qual`, `filt`, `info`, `geno`, `header`, `meta`,
`contig`, `vcfFields`, `expand`

---

### Variant classification

Classify variants by mutation type. All functions operate on `VCF` or
`VRanges` objects and return logical vectors.

```r
isSNV(vcf)          # single nucleotide variants
isIndel(vcf)        # insertions and deletions
isTransition(vcf)   # transitions (A<->G, C<->T)
isSubstitution(vcf) # substitutions (same-length alleles)
```

Key functions: `isSNV`, `isInsertion`, `isDeletion`, `isIndel`, `isDelins`,
`isTransition`, `isSubstitution`; `VariantType` class
hierarchy (`CodingVariants`, `SpliceSiteVariants`, `IntronVariants`,
`FiveUTRVariants`, `ThreeUTRVariants`, `IntergenicVariants`,
`PromoterVariants`)

---

### Functional annotation

Map variants to transcripts and predict protein-level consequences.

```r
loc <- locateVariants(vcf, txdb, region = CodingVariants())
coding <- predictCoding(vcf, txdb, seqSource = Hsapiens)
summ <- summarizeVariants(vcf, txdb, mode = CodingVariants())
```

Key functions: `locateVariants`, `predictCoding`, `summarizeVariants`,
`getTranscriptSeqs`

---

### Genotype analysis

Convert VCF genotype calls to a `SnpMatrix` for downstream association
testing (e.g. with the **snpStats** package).

```r
library(snpStats)
sm <- genotypeToSnpMatrix(vcf)
col.summary(sm$genotypes)
```

Key functions: `genotypeToSnpMatrix`, `GLtoGP`,
`probabilityToSnpMatrix`

---

### Variant ranges (VRanges)

`VRanges` extends `GRanges` with per-variant fields: alleles, read depth,
and soft/hard filter results. Useful for variant calling pipelines.

```r
vr <- VRanges(seqnames = "chr1", ranges = IRanges(1000, 1000),
              ref = "A", alt = "T",
              totalDepth = 30, altDepth = 15,
              sampleNames = "sample1")
altFraction(vr)
asVCF(vr)
```

Key functions/classes: `VRanges`, `VRangesList`, `makeVRangesFromGRanges`,
`totalDepth`, `altDepth`, `refDepth`, `altFraction`, `refFraction`,
`softFilterMatrix`, `hardFilters`, `called`, `asVCF`, `stackSamples`

---

### External annotation databases

Interfaces to prebuilt SQLite databases for SIFT, PolyPhen-2, and PROVEAN
pathogenicity predictions.

```r
library(SIFT.Hsapiens.dbSNP132)
db <- SIFT.Hsapiens.dbSNP132
SIFTDbColumns(db)
select(db, keys = "rs17970171", columns = SIFTDbColumns(db))
```

Key classes: `SIFTDb`, `PolyPhenDb`, `PROVEANDb`

---

### Ensembl VEP REST API

Query the Ensembl Variant Effect Predictor via its REST endpoint for
human variants (hg38 / GRCh38).

```r
resp <- post_Hs_region(chr = "7", pos = 155800001,
                       id = "myVar", ref = "A", alt = "T")
fl <- system.file("extdata", "chr22.vcf.gz", package = "VariantAnnotation")
vcf <- readVcf(fl)
hits <- vep_by_region(vcf[1:10], snv_only = FALSE, chk_max = FALSE)
```

Key functions: `post_Hs_region`, `vep_by_region`
