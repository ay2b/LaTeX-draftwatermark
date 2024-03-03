# Changelog for `draftwatermark`

- R1.0

  - Initial release.

- R1.1

  - Add support for specifying color of textual watermark;
  - Introduce the ‘‘stamp’’, ‘‘nostamp’’ and ‘‘final’’ options to control
    whether the watermark should actually be printed;
  - Many small fixes in the documentation.
  
- R1.2
  - Add support for specifying the watermark horizontal position;
  - Add support for specifying the watermark vertical position.

- R2.0
  - Complete package overhaul
  - Introduction of a keyval option mechanism.

- R2.1
   - Let anchor directives be re-evaluated on every page.
   
- R2.2
  - `\DraftwatermarkStdMark`: wrap watermark text in a shortstack to
     make line breaks possible.
   
- R2.3
  - `\SetWatermarkText`: Fix legacy interface to accept text including commas.

- R3.0
  - Use facilities from newer LaTeX kernels;
  - Automatically load legacy code for older LaTeX formats;
  - Remove dependency on package everypage.

 - R3.1
  - Require ‘xcolor‘ instead of ‘color‘
    - Fixes an error with key colors 

- R3.2
  - Fix name of legacy package in \ProvidesPackage;
  - Fix version number of main package in \ProvidesPackage.
