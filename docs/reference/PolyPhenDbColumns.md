<div id="main" class="col-md-9" role="main">

# PolyPhenDb Columns

<div class="ref-description section level2">

Description of the PolyPhen Sqlite Database Columns

</div>

<div class="section level2">

## Column descriptions

These column names are displayed when `columns` is called on a
`PolyPhenDb` object.

-   rsid : rsid

Original query :

-   OSNPID : original SNP identifier from user input

-   OSNPACC : original protein identifier from user input

-   OPOS : original substitution position in the protein sequence from
    user input

-   OAA1 : original wild type (reference) aa residue from user input

-   OAA2 : original mutant (reference) aa residue from user input

Mapped query :

-   SNPID : SNP identifier mapped to dbSNP rsID if available, otherwise
    same as o\_snp\_id. This value was used as the rsid column

-   ACC : protein UniProtKB accession if known protein, otherwise same
    as o\_acc

-   POS : substitution position mapped to UniProtKB protein sequence if
    known, otherwise same as o\_pos

-   AA1 : wild type aa residue

-   AA2 : mutant aa residue

-   NT1 : wild type allele nucleotide

-   NT2 : mutant allele nucleotide

PolyPhen-2 prediction :

-   PREDICTION : qualitative ternary classification FPR thresholds

PolyPhen-1 prediction :

-   BASEDON : prediction basis

-   EFFECT : predicted substitution effect on the protein structure or
    function

PolyPhen-2 classifiers :

-   PPH2CLASS : binary classifier outcome ("damaging" or "neutral")

-   PPH2PROB : probability of the variation being dammaging

-   PPH2FPR : false positive rate at the pph2\_prob level

-   PPH2TPR : true positive rate at the pph2\_prob level

-   PPH2FDR : false discovery rate at the pph2\_prob level

UniProtKB-SwissProt derived protein sequence annotations :

-   SITE : substitution SITE annotation

-   REGION : substitution REGION annotation

-   PHAT : PHAT matrix element for substitution in the TRANSMEM region

Multiple sequence alignment scores :

-   DSCORE : difference of PSIC scores for two aa variants (Score1 -
    Score2)

-   SCORE1 : PSIC score for wild type aa residue (aa1)

-   SCORE2 : PSIC score for mutant aa residue (aa2)

-   NOBS : number of residues observed at the substitution position in
    the multiple alignment (sans gaps)

Protein 3D structure features :

-   NSTRUCT : initial number of BLAST hits to similar proteins with 3D
    structures in PDB

-   NFILT : number of 3D BLAST hits after identity threshold filtering

-   PDBID : protein structure identifier from PDB

-   PDBPOS : position of substitution in PDB protein sequence

-   PDBCH : PDB polypeptide chain identifier

-   IDENT : sequence identity between query and aligned PDB sequences

-   LENGTH : PDB sequence alignment length

-   NORMACC : normalized accessible surface

-   SECSTR : DSSP secondary structure assignment

-   MAPREG : region of the phi-psi (Ramachandran) map derived from the
    residue dihedral angles

-   DVOL : change in residue side chain volume

-   DPROP : change in solvent accessible surface propensity resulting
    from the substitution

-   BFACT : normalized B-factor (temperature factor) for the residue

-   HBONDS : number of hydrogen sidechain-sidechain and
    sidechain-mainchain bonds formed by the residue

-   AVENHET : average number of contacts with heteroatoms per residue

-   MINDHET : closest contact with heteroatom

-   AVENINT : average number of contacts with other chains per residue

-   MINDINT : closest contact with other chain

-   AVENSIT : average number of contacts with critical sites per residue

-   MINDSIT : closest contact with a critical site

Nucleotide sequence features (CpG/codon/exon junction) :

-   TRANSV : whether substitution is a transversion

-   CODPOS : position of the substitution within the codon

-   CPG : whether or not the substitution changes CpG context

-   MINDJNC : substitution distance from exon/intron junction

Pfam protein family :

-   PFAMHIT : Pfam identifier of the query protein

Substitution scores :

-   IDPMAX : maximum congruency of the mutant aa residue to all
    sequences in multiple alignment

-   IDPSNP : maximum congruency of the mutant aa residue to the sequence
    in alignment with the mutant residue

-   IDQMIN : query sequence identity with the closest homologue
    deviating from the wild type aa residue

Comments :

-   COMMENTS : Optional user comments

</div>

<div class="section level2">

## See also

<div class="dont-index">

`?PolyPhenDb`

</div>

</div>

<div class="section level2">

## Author

Valerie Obenchain

</div>

</div>
