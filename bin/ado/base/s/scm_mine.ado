*! version 1.0.0  12nov2004
program scm_mine
   version 8

   tempname fh
   file open `fh' using scheme-mine.scheme , write

   file write `fh' "* This is our better demonstration scheme." _n
   file write `fh' "* We should probably go on to describe it further here." _n
   file write `fh' _n

   file write `fh' "*! version 1.0.0   24aug2004" _n
   file write `fh' _n

   file write `fh' "#include s2color" _n
   file write `fh' _n

   file write `fh' "color background  white" _n
   file write `fh' `"color major_grid  "200 200 200""' _n
   file write `fh' _n

   file write `fh' `"color p1          "  0 255   0""' _n
   file write `fh' "color p2          magenta" _n
   file write `fh' _n

   file write `fh' "anglestyle vertical_tick    horizontal" _n
   file write `fh' _n

   file write `fh' "numstyle   legend_cols      1" _n

   file write `fh' "clockdir   legend_position  4" _n
   file write `fh' "linestyle  legend           none" _n
   file write `fh' `"margin     legend           "5 0 0 0""' _n

   file write `fh' _n

   file close `fh'
end
