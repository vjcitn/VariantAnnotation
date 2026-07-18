<div id="main" class="col-md-9" role="main">

# Package index

<div class="section level2">

## All functions

</div>

<div class="section level2">

-   `GLtoGP()` `PLtoGP()` : Convert genotype likelihoods to genotype
    probabilities

-   `PROVEAN` `PROVEANDb` `class:PROVEANDb` `PROVEANDb-class`
    `columns,PROVEANDb-method` `keys,PROVEANDb-method`
    `keytypes,PROVEANDb-method` `select,PROVEANDb-method` : PROVEANDb
    objects

-   `PolyPhen` `PolyPhenDb` `class:PolyPhenDb` `PolyPhenDb-class`
    `duplicateRSID` `metadata,PolyPhenDb-method`
    `columns,PolyPhenDb-method` `keys,PolyPhenDb-method`
    `select,PolyPhenDb-method` : PolyPhenDb objects

-   `PolyPhenDbColumns` : PolyPhenDb Columns

-   `SIFT` `SIFTDb` `class:SIFTDb` `SIFTDb-class`
    `metadata,SIFTDb-method` `columns,SIFTDb-method`
    `keys,SIFTDb-method` `select,SIFTDb-method` : SIFTDb objects

-   `SIFTDbColumns` : SIFTDb Columns

-   `ScanVcfParam()` `vcfFixed()` `` `vcfFixed<-`() `` `vcfInfo()`
    `` `vcfInfo<-`() `` `vcfGeno()` `` `vcfGeno<-`() `` `vcfSamples()`
    `` `vcfSamples<-`() `` `vcfTrimEmpty()` `` `vcfTrimEmpty<-`() ``
    `vcfWhich()` `` `vcfWhich<-`() `` : Parameters for scanning VCF
    files

-   `class:VCF` `VCF-class` `CollapsedVCF` `class:CollapsedVCF`
    `CollapsedVCF-class` `ExpandedVCF` `class:ExpandedVCF`
    `ExpandedVCF-class` `VCF` `SnpMatrixToVCF` `updateObject,VCF-method`
    `fixed` `fixed,VCF-method` `fixed<-` `fixed<-,VCF,DataFrame-method`
    `ref` `ref,VCF-method` `ref<-` `ref<-,VCF,DNAStringSet-method` `alt`
    `alt,VCF-method` `alt<-` `alt<-,CollapsedVCF,CharacterList-method`
    `alt<-,ExpandedVCF,character-method`
    `alt<-,CollapsedVCF,DNAStringSetList-method`
    `alt<-,ExpandedVCF,DNAStringSet-method` `qual` `qual,VCF-method`
    `qual<-` `qual<-,VCF,numeric-method` `filt` `filt,VCF-method`
    `filt<-` `filt<-,VCF,character-method` `info` `info,VCF-method`
    `info<-` `info<-,VCF,DataFrame-method` `rowRanges,VCF-method`
    `rowRanges<-,VCF,GRanges-method` `mcols<-,VCF-method`
    `mcols<-,VCF,ANY-method` `dimnames<-,VCF,list-method` `geno`
    `geno,VCF-method` `geno,VCF,ANY-method` `geno,VCF,character-method`
    `geno,VCF,numeric-method` `geno,VCFHeader,ANY-method` `geno<-`
    `geno<-,VCF,character,matrix-method`
    `geno<-,VCF,numeric,matrix-method`
    `geno<-,VCF,missing,matrix-method`
    `geno<-,VCF,missing,SimpleList-method` `strand,VCF-method`
    `strand<-,VCF,ANY-method` `header,VCF-method` `header<-`
    `header<-,VCF,VCFHeader-method` `vcfFields,VCF-method`
    `[,VCF-method` `[,VCF,ANY,ANY-method` `[,VCF,ANY,ANY,ANY-method`
    `subset,VCF-method` `[<-,VCF,ANY,ANY,VCF-method` `cbind,VCF-method`
    `rbind,VCF-method` `genome,VCF-method` `seqlevels,VCF-method`
    `expand,CollapsedVCF-method` `expand,ExpandedVCF-method`
    `genotypeCodesToNucleotides` `show,VCF-method`
    `show,CollapsedVCF-method` `show,ExpandedVCF-method` : VCF class
    objects

-   `VCFHeader-class` `VCFHeader` `reference`
    `reference,VCFHeader-method` `samples` `samples,VCFHeader-method`
    `header` `header,VCFHeader-method` `contig`
    `contig,VCFHeader-method` `meta` `meta,VCFHeader-method` `meta<-`
    `meta<-,VCFHeader,DataFrame-method`
    `meta<-,VCFHeader,DataFrameList-method` `fixed,VCFHeader-method`
    `fixed<-,VCFHeader,DataFrameList-method` `info,VCFHeader-method`
    `info<-,VCFHeader,DataFrame-method` `geno,VCFHeader-method`
    `geno<-,VCFHeader,missing,DataFrame-method`
    `seqinfo,VCFHeader-method` `vcfFields` `vcfFields,VCFHeader-method`
    `show,VCFHeader-method` : VCFHeader instances

-   `class:VRanges` `VRanges-class` `VRanges` `VRanges`
    `makeVRangesFromGRanges` `asVCF` `asVCF,VRanges-method`
    `coerce,VRanges,VCF-method` `coerce,VCF,VRanges-method`
    `coerce,GRanges,VRanges-method` `alt,VRanges-method`
    `alt<-,VRanges,ANY-method` `ref,VRanges-method`
    `ref<-,VRanges,ANY-method` `altDepth` `altDepth,VRanges-method`
    `altDepth<-` `altDepth<-,VRanges-method` `refDepth`
    `refDepth,VRanges-method` `refDepth<-` `refDepth<-,VRanges-method`
    `totalDepth` `totalDepth,VRanges-method` `totalDepth<-`
    `totalDepth<-,VRanges-method` `altFraction`
    `altFraction,VRanges-method` `called` `called,VRanges-method`
    `hardFilters<-` `hardFilters<-,VRanges-method` `hardFilters`
    `hardFilters,VRanges-method` `sampleNames,VRanges-method`
    `sampleNames<-,VRanges,ANY-method` `softFilterMatrix`
    `softFilterMatrix,VRanges-method` `softFilterMatrix<-`
    `softFilterMatrix<-,VRanges-method` `resetFilter` `tabulate`
    `tabulate,VRanges-method` `writeVcf,VRanges,ANY-method`
    `readVcfAsVRanges` `match,VRanges,VRanges-method` `softFilter`
    `characterRle-class` `characterOrRle-class` `complexRle-class`
    `factorRle-class` `factorOrRle-class` `integerRle-class`
    `integerOrRle-class` `logicalRle-class` `numericRle-class`
    `rawRle-class` : VRanges objects

-   `class:VRangesList` `VRangesList-class`
    `CompressedVRangesList-class` `class:CompressedVRangesList`
    `SimpleVRangesList-class` `class:SimpleVRangesList` `VRangesList`
    `alt,VRangesList-method` `ref,VRangesList-method` `stackSamples`
    `stackSamples,VRangesList-method` : VRangesList objects

-   `CodingVariants()` `IntronVariants()` `FiveUTRVariants()`
    `ThreeUTRVariants()` `SpliceSiteVariants()` `IntergenicVariants()`
    `PromoterVariants()` `AllVariants()` : VariantType subclasses

-   `VcfFile-class` `VcfFileList-class` `VcfFile` `VcfFileList`
    `vcfFields,missing-method` `vcfFields,character-method`
    `vcfFields,VcfFile-method` `vcfFields,VcfFileList-method` :
    Manipulate Variant Call Format (Vcf) files.

-   `VariantAnnotation-defunct` `refLocsToLocalLocs`
    `refLocsToLocalLocs,GRanges,TxDb,missing-method`
    `refLocsToLocalLocs,GRanges,missing,GRangesList-method`
    `readVcfLongForm`
    `readVcfLongForm,TabixFile,character,GRanges-method`
    `readVcfLongForm,TabixFile,character,missing-method`
    `readVcfLongForm,TabixFile,character,IntegerRangesList-method`
    `readVcfLongForm,TabixFile,character,ScanVcfParam-method`
    `readVcfLongForm,character,character,ScanVcfParam-method`
    `readVcfLongForm,character,character,missing-method`
    `readVcfLongForm,character,missing,missing-method` `dbSNPFilter`
    `regionFilter` `MatrixToSnpMatrix` `VRangesScanVcfParam`
    `restrictToSNV` :

    Defunct Functions in Package `VariantAnnotation`

-   `filterVcf(<character>)` `filterVcf(<TabixFile>)` : Filter VCF files

-   `genotypeToSnpMatrix(<CollapsedVCF>)` `genotypeToSnpMatrix(<array>)`
    : Convert genotype calls from a VCF file to a SnpMatrix object

-   `getTranscriptSeqs(<GRangesList>,<BSgenome>)`
    `getTranscriptSeqs(<GRangesList>,<FaFile>)`
    `getTranscriptSeqs(<GRanges>,<FaFile>)` : Get transcript sequences

-   `indexVcf(<character>)` `indexVcf(<VcfFile>)`
    `indexVcf(<VcfFileList>)` : Create index files for VCF files

-   `isSNV(<VRanges>)` `isSNV(<ExpandedVCF>)` `isSNV(<CollapsedVCF>)`
    `isInsertion(<VRanges>)` `isInsertion(<ExpandedVCF>)`
    `isInsertion(<CollapsedVCF>)` `isDeletion(<VRanges>)`
    `isDeletion(<ExpandedVCF>)` `isDeletion(<CollapsedVCF>)`
    `isIndel(<VRanges>)` `isIndel(<ExpandedVCF>)`
    `isIndel(<CollapsedVCF>)` `isDelins(<VRanges>)`
    `isDelins(<ExpandedVCF>)` `isDelins(<CollapsedVCF>)`
    `isTransition(<VRanges>)` `isTransition(<ExpandedVCF>)`
    `isTransition(<CollapsedVCF>)` `isSubstitution(<VRanges>)`
    `isSubstitution(<ExpandedVCF>)` `isSubstitution(<CollapsedVCF>)` :
    Identification of genomic variant types.

-   `locateVariants()` : Locate variants

-   `post_Hs_region()` : elementary vep/homo\_sapiens/region call to
    ensembl VEP REST API

-   `predictCoding(<CollapsedVCF>,<TxDb>,<ANY>,<missing>)`
    `predictCoding(<ExpandedVCF>,<TxDb>,<ANY>,<missing>)`
    `predictCoding(<IntegerRanges>,<TxDb>,<ANY>,<DNAStringSet>)`
    `predictCoding(<GRanges>,<TxDb>,<ANY>,<DNAStringSet>)`
    `predictCoding(<VRanges>,<TxDb>,<ANY>,<missing>)` : Predict amino
    acid coding changes for variants

-   `probabilityToSnpMatrix()` : Convert posterior genotype probability
    to a SnpMatrix object

-   `readVcf(<TabixFile>,<ScanVcfParam>)`
    `readVcf(<TabixFile>,<IntegerRangesList>)`
    `readVcf(<TabixFile>,<GRanges>)`
    `readVcf(<TabixFile>,<GRangesList>)`
    `readVcf(<TabixFile>,<missing>)` `readVcf(<character>,<ANY>)`
    `readVcf(<character>,<missing>)` `readInfo()` `readGeno()`
    `readGT()` `import(<VcfFile>,<ANY>,<ANY>)` : Read VCF files

-   `scanVcfHeader()` `scanVcf()` : Import VCF files

-   `seqinfo(<VcfFile>)` `seqinfo(<VcfFileList>)` : Get seqinfo for VCF
    file

-   `snpSummary(<CollapsedVCF>)` : Counts and distribution statistics
    for SNPs in a VCF object

-   `summarizeVariants(<TxDb>,<VCF>,<CodingVariants>)`
    `summarizeVariants(<TxDb>,<VCF>,<FiveUTRVariants>)`
    `summarizeVariants(<TxDb>,<VCF>,<ThreeUTRVariants>)`
    `summarizeVariants(<TxDb>,<VCF>,<SpliceSiteVariants>)`
    `summarizeVariants(<TxDb>,<VCF>,<IntronVariants>)`
    `summarizeVariants(<TxDb>,<VCF>,<PromoterVariants>)`
    `summarizeVariants(<GRangesList>,<VCF>,<VariantType>)`
    `summarizeVariants(<GRangesList>,<VCF>,<function>)` : Summarize
    variants by sample

-   `variant_body()` : helper function to construct inputs for VEP REST
    API

-   `vep_by_region()` : Use the VEP region API on variant information in
    a VCF object as defined in VariantAnnotation.

-   `writeVcf(<VCF>,<character>)` `writeVcf(<VCF>,<connection>)` : Write
    VCF files

</div>

</div>
