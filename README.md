
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active) [![Travis-CI Build Status](https://travis-ci.org/hrbrmstr/wand.svg?branch=master)](https://travis-ci.org/hrbrmstr/wand)

`wand` : Retrieve 'Magic' Attributes from Files and Directories

The `libmagic` library must be installed on \*nix/macOS and available to use this.

-   `apt-get install libmagic-dev` on Ubuntu/Debian-ish systems
-   `brew install libmagic` on macOS
-   `yum install file-devel` on RHEL/CentOS/Fedora

While the package was developed using the 5.28 version of `libmagic` it has been configured to work with older versions. Note that some fields in the resultant data frame might not be available with older library versions. When using the function `magic_wand_file()` it checks for which version of `libmagic` is installed on your system and provides a suitable `magic.mgc` file for it.

The package also works on Windows but it's a bit of a hack because, well, *Windows*. The Windows version makes two `system2()` calls and relies on `Rtools` being installed and `file.exe` being available on the Windows `PATH`, so it's sub-optimal at best. Help to get it working in C would be greatly appreciated. Windows folk can go [here](https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows) to find out more info on `Rtools`.

The following functions are implemented:

-   `incant` : returns the "magic" metadata of the files in the input vector (as a data frame)
-   `magic_wand_file` : provides a full path to the package-provided `magic` file

The following datasets are included:

-   `mime_db` : a database of all mime types from <https://github.com/jshttp/mime-db>

### Installation

``` r
devtools::install_github("hrbrmstr/wand")
```

### Usage

``` r
library(wand)
library(dplyr)

system.file("extdata", "img", package="wand") %>% 
  list.files(full.names=TRUE) %>% 
  incant() %>% 
  glimpse()
```

    ## Observations: 10
    ## Variables: 5
    ## $ file        <chr> "/Library/Frameworks/R.framework/Versions/3.3/Resources/library/wand/extdata/img/example_dir", ...
    ## $ mime_type   <chr> "inode/directory", "text/x-c", "text/html", "text/plain", "text/rtf", "image/jpeg", "applicatio...
    ## $ encoding    <chr> "binary", "us-ascii", "us-ascii", "us-ascii", "us-ascii", "binary", "binary", "binary", "us-asc...
    ## $ extensions  <list> [NA, <"c", "cc", "cpp", "cxx", "dic", "h", "hh">, <"htm", "html", "shtml">, <"conf", "def", "i...
    ## $ description <chr> "directory", "C source, ASCII text", "HTML document, ASCII text, with CRLF line terminators", "...

``` r
# Use a non-system magic-file

system.file("extdata", "img", package="wand") %>% 
  list.files(full.names=TRUE) %>% 
  incant(magic_wand_file()) %>% 
  select(description) %>% 
  unlist(use.names=FALSE)
```

    ##  [1] "directory"                                                                                                                                                                                                        
    ##  [2] "C source, ASCII text"                                                                                                                                                                                             
    ##  [3] "HTML document, ASCII text, with CRLF line terminators"                                                                                                                                                            
    ##  [4] "ASCII text, with no line terminators"                                                                                                                                                                             
    ##  [5] "Rich Text Format data, version 1, ANSI"                                                                                                                                                                           
    ##  [6] "JPEG image data, JFIF standard 1.01, aspect ratio, density 72x72, segment length 16, Exif Standard: [TIFF image data, big-endian, direntries=2, orientation=upper-left], baseline, precision 8, 800x700, frames 3"
    ##  [7] "PDF document, version 1.3"                                                                                                                                                                                        
    ##  [8] "PNG image data, 800 x 700, 8-bit/color RGBA, non-interlaced"                                                                                                                                                      
    ##  [9] "ASCII text, with very long lines, with CRLF line terminators"                                                                                                                                                     
    ## [10] "TIFF image data, big-endian"

``` r
# what kinds of extensions are associated with these mime types
system.file("extdata", "img", package="wand") %>% 
  list.files(full.names=TRUE) %>% 
  incant(magic_wand_file()) %>% 
  select(extensions) %>% 
  as.data.frame()
```

    ##                                  extensions
    ## 1                                        NA
    ## 2               c, cc, cpp, cxx, dic, h, hh
    ## 3                          htm, html, shtml
    ## 4  conf, def, in, ini, list, log, text, txt
    ## 5                                       rtf
    ## 6                      jfif, jpe, jpeg, jpg
    ## 7                                       pdf
    ## 8                                       png
    ## 9  conf, def, in, ini, list, log, text, txt
    ## 10                                tif, tiff

``` r
# current verison
packageVersion("wand")
```

    ## [1] '0.2.0'

### Test Results

``` r
library(wand)
library(testthat)

date()
```

    ## [1] "Mon Aug 15 14:56:16 2016"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 1 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================