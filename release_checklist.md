# Checklist for releasing to CTAN

1. Check that the version number and version date has been entered
   consistently in the `draftwatermark.dtx` file. This involves
   checking
   - The portion of the file with `% \def\fileversion`, `%
     \def\filedate` and `% \def\docdate`;
   - The portion of the file with `\ProvidesPackage{draftwatermark}`

2. Check that there are changes lines for the latest version and that the dates
   are consistent.

3. Run the `package.sh` script
