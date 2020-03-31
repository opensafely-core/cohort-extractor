*! version 3.0.0  10/26/91
program define kapwgt
	version 3.0
	if "`1'"=="" { error 198 } 
	parse "`*'", parse(" =")
	local name `1'
	capture mac list `name'
	if _rc!=0 & _rc!=111 { 
		mac list `name'		/* error abort */
	}
	if "`2'"=="" { 			/* print matrix */
		if _rc!=0 { 
			mac list `name'	/* error abort */
		}
		parse "$`name'", parse(" ")
		if "`1'"!="kapwgt" { 
			di "`name' not kappa weight matrix"
			exit 198
		}
		mac shift 
		mac shift 
		local n 1
		local i 1
		di
		while "`1'" != "" { 
			di %7.4f `1' _c
			local i=`i'+1 
			if `i'>`n' { 
				di
				local n=`n'+1
				local i 1
			}
			mac shift
		}
		exit
	}
	local 1 "\" 
	local n 0 
	while "`1'"=="\" { 
		local n = `n' + 1 
		local i 1 
		mac shift
		while `i'<=`n' { 
			confirm number `1'
			if `1'<0 | `1'>1 { 
				di in red "elements must be between 0 and 1"
				exit 198
			}
			if `i'==`n' & `1'!=1 { 
				di in red "diagonals must be 1"
				exit 198
			}
			local res "`res' `1'"
			local i=`i'+1
			mac shift 
		}
	}
	if "`1'"!="" { 
		di in red "`1' invalid"
		exit 198
	}
	mac def `name' "kapwgt `n' `res'"
end
