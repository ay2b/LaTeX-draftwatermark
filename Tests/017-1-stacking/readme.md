# Bug in z-order of watermark

There may be issues in the z-axis placement of the watermark when using some
packages that also interact with the LaTeX shipout hooks.

Notable potentially critical cases are `eso-pic` and `pdfpages`.

A test case here is provided for `pdfpages`.
