*! version 1.0.0  12jan2005
program _plotpos
	version 9

	syntax varlist(numeric min=2 max=2) [if] [in] , gen(str) [ARROWs]

	if `: word count `gen'' != 1 {
		dis as err `"_plotpos: gen(`gen') invalid"'
		exit 198
	}
	confirm new var `gen'
	marksample touse
	gettoken x y : varlist

	tempname xmin xmax ymin ymax pos
	if "`arrows'" == "" {
		quietly {
			summ `x' if `touse', meanonly
			scalar `xmin' = r(min) + 0.10*(r(max)-r(min))
			scalar `xmax' = r(max) - 0.10*(r(max)-r(min))

			summ `y' if `touse', meanonly
			scalar `ymin' = r(min) + 0.10*(r(max)-r(min))
			scalar `ymax' = r(max) - 0.10*(r(max)-r(min))

			gen byte `pos'=  6  if `touse'
			replace `pos' = 12  if `touse'  &  inrange(`x',`xmin',`xmax')  &  `y'<`ymin'
			replace `pos' =  6  if `touse'  &  inrange(`x',`xmin',`xmax')  &  `y'>`ymax'
			replace `pos' =  3  if `touse'  &  inrange(`y',`ymin',`ymax')  &  `x'<`xmin'
			replace `pos' =  9  if `touse'  &  inrange(`y',`ymin',`ymax')  &  `x'>`xmax'
			replace `pos' =  1  if `touse'  &  `y'<`ymin'  &  `x'<`xmin'
			replace `pos' = 11  if `touse'  &  `y'<`ymin'  &  `x'>`xmax'
			replace `pos' =  5  if `touse'  &  `y'>`ymax'  &  `x'<`xmin'
			replace `pos' =  7  if `touse'  &  `y'>`ymax'  &  `x'>`xmax'

			gen byte `gen'= `pos' if `touse'
		}
	}
	else {
		quietly {
			gen byte `pos'=  .  if `touse'
			replace `pos' =  1  if `touse'  &  `x' >  0 & `y' >  0 & `y' >= `x'
			replace `pos' =  2  if `touse'  &  `x' >  0 & `y' >  0 & `y' <  `x'
			replace `pos' = 11  if `touse'  &  `x' <  0 & `y' >  0 & `y' >= (`x'*-1)
			replace `pos' = 10  if `touse'  &  `x' <  0 & `y' >  0 & `y' <  (`x'*-1)
			replace `pos' =  5  if `touse'  &  `x' >  0 & `y' <  0 & (`y'*-1) > `x'
			replace `pos' =  4  if `touse'  &  `x' >  0 & `y' <  0 & (`y'*-1) < `x'
			replace `pos' =  8  if `touse'  &  `x' <  0 & `y' <  0 & `y' >= `x'
			replace `pos' =  7  if `touse'  &  `x' <  0 & `y' <  0 & `y' <  `x'
			
			replace `pos' = 12  if `touse'  &  `y' >= 0 & (`y'/`x' >= 2.5 | `y'/`x' <= -2.5)
			replace `pos' =  6  if `touse'  &  `y' <  0 & (`y'/`x' >= 2.5 | `y'/`x' <= -2.5)
			replace `pos' =  9  if `touse'  &  `x' <  0 & (`x'/`y' >= 2.5 | `x'/`y' <= -2.5)
			replace `pos' =  3  if `touse'  &  `x' >= 0 & (`x'/`y' >= 2.5 | `x'/`y' <= -2.5)	

			gen byte `gen'= `pos' if `touse'
		}
	}
end
exit

   Carefully determine positions of a string variable.

   E.g., if a plotpoint is close to the right margin, the text is
   positioned to the left of the point, i.e., at clock position 9.


