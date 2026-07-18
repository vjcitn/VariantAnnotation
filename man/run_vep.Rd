\name{run_vep}
\alias{run_vep}
\title{Run a locally installed Ensembl VEP script on a VCF object or file}
\description{
  Calls a locally installed \code{vep} executable, annotates variants, and
  returns the result as a \code{CollapsedVCF} object.  This complements
  \code{\link{vep_by_region}}, which uses the Ensembl REST API but is limited
  to 200 variants per request.  The local script has no such limit and
  supports fully offline operation.
}
\usage{
run_vep(x, assembly = "GRCh38", species = "homo_sapiens",
        fork = 1L, extra_args = character(), vep_path = NULL)
}
\arguments{
  \item{x}{A \code{\link{VCF}} object or \code{character(1)} path to a VCF
    file.}
  \item{assembly}{character(1) genome assembly passed to VEP via
    \code{--assembly}, e.g. \code{"GRCh38"} or \code{"GRCh37"}.}
  \item{species}{character(1) species name as used by VEP, e.g.
    \code{"homo_sapiens"}.}
  \item{fork}{integer(1) number of forks for parallel processing.  Default
    \code{1L} disables forking.}
  \item{extra_args}{character() additional flags passed verbatim to
    \code{vep}, e.g. \code{c("--sift", "b", "--polyphen", "b")} or
    \code{"--offline"}.}
  \item{vep_path}{character(1) or NULL.  Full path to the \code{vep}
    executable.  When NULL (default) \code{Sys.which("vep")} is used.}
}
\details{
  Requires a locally installed Ensembl VEP and a matching annotation cache.
  See \url{https://www.ensembl.org/info/docs/tools/vep/script/vep_download.html}
  for installation and cache setup instructions.

  VEP is invoked with \code{--vcf --no_stats --force_overwrite}.  The
  annotated output VCF is read back with \code{\link{readVcf}} and returned.
  Consequence annotations are stored in the \code{CSQ} field of
  \code{info()}.

  Pass \code{"--offline"} in \code{extra_args} for fully offline operation
  (requires a local cache).
}
\value{
  A \code{CollapsedVCF} object.  VEP consequence annotations appear in
  \code{info(result)$CSQ}.
}
\seealso{
  \code{\link{vep_by_region}} for the REST API alternative;
  \code{\link{readVcf}}, \code{\link{writeVcf}}.
}
\examples{
\dontrun{
  fl <- system.file("extdata", "chr22.vcf.gz", package = "VariantAnnotation")
  vcf <- readVcf(fl)
  result <- run_vep(vcf[1:10], assembly = "GRCh38")
  info(result)$CSQ
}
}
\keyword{manip}
