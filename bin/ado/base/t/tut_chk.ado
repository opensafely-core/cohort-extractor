*! version 1.0.0  08dec1994
program define tut_chk /* tutorial_name */
	version 4.0
	if "$TUT_" == "" { 
		di _n(3) in wh _dup(79) "-"
		di in gr "We have changed the way tutorials are run.  Type" _n
		di _col(8) in wh ". tutorial `1'" _n
		di in gr "to run this tutorial.  Type" _n
		di _col(8) in wh ". tutorial" _n
		di in gr "to obtain a tutorial table of contents."
		di in wh _dup(79) "-" _n(2)
		exit 198
	}
end
