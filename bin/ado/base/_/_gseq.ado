*! version 7.0.2  09feb2015
program define _gseq
	version 6.0, missing
	gettoken type 0 : 0
	gettoken g 0 : 0
	gettoken eqs 0 : 0
	gettoken lparen 0 : 0, parse("(")
	gettoken rparen 0 : 0, parse(")")

	syntax [if] [in] [ , by(string) Block(int 1) /*
		*/ From(int 1) To(str)]
	
	if `block' < 1 {
		di in r "block should be at least 1"
		exit 498
	}

	if "`to'" == "" { 
		local to = _N 
	}
	else {
		confirm integer n `to'
	}

	if `from' > `to' {
		local temp = `from'
		local from = `to'
		local to = `temp'
	}

	marksample touse

	quietly {
		tempvar porder
		gen `c(obs_t)' `porder' = _n
		gen byte `g' = .
		sort `touse' `by' `porder'
		#delimit ;
		by `touse' `by':
		replace `g'
			= `from' + int(mod((_n - 1) / `block', 
			`to' - `from' + 1))
			if `touse' ;
		#delimit cr
		if "`temp'" != "" { 
			replace `g' = `to' + `from' - `g' 
		}
	}
end

