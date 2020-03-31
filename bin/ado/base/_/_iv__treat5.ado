*! version 1.0.2  25mar2016
program _iv__treat5
	version 14
	syntax varlist if [fweight iweight pweight], 		///
			at(name) 				///
			y1(varlist)				///                      
			ty(varlist) 				///
			[					///
			derivatives(varlist)			///
			*					///
			]		
	quietly {
		tempvar mut mub mub1 muate muatet muy0 muy1
		tokenize `varlist'
		local by1   `1'
		matrix score double `mub1'   = `at' `if', eq(#1) 	
		qui replace `by1'   = (`y1'-exp(`mub1'))*(`ty')   `if'

		if "`derivatives'" == "" {
			exit
		}
	
		local d1: word 1 of `derivatives'
		
		quietly {
			replace `d1'  = -`ty'*exp(`mub1') `if'
		}
	}
end
