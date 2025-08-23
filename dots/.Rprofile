options(
  citation.bibtex.max = 999,
  repos = c(
    CRAN = "https://cloud.r-project.org",
    # CRAN = "https://cran.rstudio.com/",
    rOpenGov = "https://ropengov.r-universe.dev",
    aleksanderbl29 = "https://aleksanderbl29.r-universe.dev",
    gadenbuie = 'https://gadenbuie.r-universe.dev'
  ),
  renv.config.pak.enabled = TRUE, # Use pak for installing packages when using renv
  "Authors@R" = utils::person(
    "Aleksander", "Bang-Larsen",
    email = "contact@aleksanderbl.dk",
    role = c("aut", "cre", "cph"),
    comment = c(ORCID = "0009-0007-7984-4650")
  )
)

# if (!"/Users/aleksander/Library/Caches/org.R-project.R/R/renv/sandbox/macos/R-4.4/aarch64-apple-darwin20/f7156815" %in%
#     .libPaths()) {
#   .libPaths("~/Library/Caches/org.R-project.R/R/renv/cache/v5/macos/R-4.4/aarch64-apple-darwin20")
#   }



if (interactive() && requireNamespace("rsthemes", quietly = TRUE)) {
  if (!require("rsthemes", quietly = TRUE)) install.packages("rsthemes",
                                             repos = c(gadenbuie = 'https://gadenbuie.r-universe.dev',
                                                       getOption("repos")))
  # Set preferred themes if not handled elsewhere..
  rsthemes::set_theme_light("Chrome")  # light theme
  rsthemes::set_theme_dark("Ambiance") # dark theme

  # Whenever the R session restarts inside RStudio...
  setHook("rstudio.sessionInit", function(isNewSession) {
    # Automatically choose the correct theme based on time of day
    rsthemes::use_theme_auto(dark_start = "18:00", dark_end = "8:00",
                             lat = "56.162937", lon = "10.203921")
  }, action = "append")
}

if (interactive() && requireNamespace("rsthemes", quietly = TRUE)) {
  rsthemes::set_theme_favorite(c(
    "base16 3024 {rsthemes}", "base16 Ashes {rsthemes}",
    "base16 Brewer {rsthemes}", "base16 Bright {rsthemes}",
    "base16 Default Dark {rsthemes}", "base16 IR Black {rsthemes}"
  ))
}

if (interactive() && requireNamespace("foghorn", quietly = TRUE)) {
  tryCatch({
    foghorn::summary_cran_results(email = "contact@aleksanderbl.dk")
  }, error = function(e) {
    message("Error in foghorn::summary_cran_results: ", e$message)
  })
}
