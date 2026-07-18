### =========================================================================
### run_vep: interface to a locally installed Ensembl VEP script
### =========================================================================

#' Run a locally installed Ensembl VEP script on a VCF object or file
#'
#' @param x A \code{VCF} object or \code{character(1)} path to a VCF file.
#' @param assembly character(1) genome assembly passed to VEP via
#'   \code{--assembly}, e.g. \code{"GRCh38"} or \code{"GRCh37"}.
#' @param species character(1) species name as used by VEP, e.g.
#'   \code{"homo_sapiens"}.
#' @param fork integer(1) number of forks for parallel processing; 1 (the
#'   default) means no forking.
#' @param extra_args character() additional flags passed verbatim to the
#'   \code{vep} command, e.g. \code{c("--sift", "b", "--polyphen", "b")}.
#' @param vep_path character(1) or NULL; full path to the \code{vep}
#'   executable. When NULL (default) \code{Sys.which("vep")} is used.
#' @return A \code{CollapsedVCF} object read from VEP-annotated output.
#'   Consequence annotations appear in the \code{CSQ} field of \code{info()}.
#' @details
#' Requires a locally installed Ensembl VEP and a matching annotation cache.
#' See \url{https://www.ensembl.org/info/docs/tools/vep/script/vep_download.html}
#' for installation instructions. VEP is invoked with
#' \code{--vcf --no_stats --force_overwrite}; the annotated VCF is read back
#' with \code{readVcf} and returned to the caller.
#'
#' This complements \code{\link{vep_by_region}}, which uses the Ensembl REST
#' API (limited to 200 variants per request); the local script has no such
#' limit and supports offline operation via \code{--offline} in
#' \code{extra_args}.
#' @seealso \code{\link{vep_by_region}} for the REST API alternative.
#' @examples
#' \dontrun{
#'   fl <- system.file("extdata", "chr22.vcf.gz", package = "VariantAnnotation")
#'   vcf <- readVcf(fl)
#'   result <- run_vep(vcf[1:10], assembly = "GRCh38")
#'   info(result)$CSQ
#' }
#' @export
run_vep <- function(x, assembly = "GRCh38", species = "homo_sapiens",
                    fork = 1L, extra_args = character(), vep_path = NULL) {
    if (is.null(vep_path)) {
        vep_path <- Sys.which("vep")
        if (!nzchar(vep_path))
            stop("'vep' executable not found on PATH; ",
                 "install ensembl-vep or supply 'vep_path'")
    }

    if (inherits(x, "VCF")) {
        infile <- tempfile(fileext = ".vcf")
        on.exit(unlink(infile), add = TRUE)
        writeVcf(x, infile)
    } else if (is.character(x) && length(x) == 1L) {
        infile <- x
    } else {
        stop("'x' must be a VCF object or a path to a VCF file")
    }

    outfile <- tempfile(fileext = ".vcf")
    on.exit(unlink(outfile), add = TRUE)

    args <- c(
        "--input_file",  infile,
        "--output_file", outfile,
        "--vcf",
        "--no_stats",
        "--force_overwrite",
        "--assembly", assembly,
        "--species",  species
    )
    if (fork > 1L)
        args <- c(args, "--fork", as.character(fork))
    args <- c(args, extra_args)

    status <- system2(vep_path, args = args)
    if (status != 0L)
        stop("vep exited with non-zero status (", status, ")")

    readVcf(outfile, genome = assembly)
}
