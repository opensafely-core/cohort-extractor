*! version 3.0.4  17sep2004
program define collaps4
* touched by kth -- all done -- this code is for pre version 5.0 calls only.
	version 3.0, missing
	local varlist "req ex"
	local if "opt"
	local in "opt"
	local options "BY(string) Count(string) Iqr(string) MAx(string) MEAn(string) MEDian(string) MIn(string) P25(string) P75(string) SD(string) SUm(string)"
	parse "`*'"
	quietly count `if' `in'
	if r(N)==0 { 
		error 2000
	}
	if "`by'"!="" { 
		confirm var `by'
		unabbrev `by'
		local by "`s(varlist)'"
		local byg "by(`by')"
	}

	global S_FN
	global S_FNDATE
	if "`if'`in'"!="" { 
		quietly keep `if' `in'
	}
	keep `varlist' `by'

	parse "`varlist'", parse(" ")
	local nv = 0
	while "`1'"!="" { 
		tempvar new 
		local vl "`vl' `new'"
		rename `1' `new'
		local lbl : variable label `new'
		if "`lbl'"=="" { 
			label var `new' "`1'"
		}
		local nv = `nv' + 1
		mac shift 
	}


	if "`count'"~="" { 
		_crclpse count `nv' "`count'" long count "`vl'" "`byg'"
	}
	if "`iqr'"!="" { 
		_crclpse iqr `nv' "`iqr'" float iqr "`vl'" "`byg'"
	}
	if "`max'"!="" { 
		_crclpse max `nv' "`max'" * max "`vl'" "`byg'"
	}
	if "`mean'"!="" { 
		_crclpse mean `nv' "`mean'" float mean "`vl'" "`byg'"
	}
	if "`median'"!="" {
		_crclpse median `nv' "`median'" float median "`vl'" "`byg'"
	}
	if "`min'"!="" { 
		_crclpse min `nv' "`min'" * min "`vl'" "`byg'"
	}
	if "`p25'"!="" { 
		_crclpse p25 `nv' "`p25'" float pctile "`vl'" "`byg' p(25)"
	}
	if "`p75'"!="" { 
		_crclpse p75 `nv' "`p75'" float pctile "`vl'" "`byg' p(75)"
	}
	if "`sd'"!="" { 
		_crclpse sd `nv' "`sd'" float sd "`vl'" "`byg'"
	}
	if "`sum'"!="" { 
		_crclpse sum `nv' "`sum'" double sum "`vl'" "`byg'"
	}
	quietly { 
		if "`by'"!="" { 
			sort `by'
			by `by': keep if _n==_N
			label data "stats by `by'"
		}
		else { 
			keep in l 
			label data "summary stats"
		}
	}
end

program define _crclpse
	local name `1'
	local n `2'
	local new "`3'"
	local type "`4'"
	local fcn "`5'"
	local orig "`6'"
	local opts "`7'"
	local rtype "`type'"

	local i 1 
	while `i'<=`n' { 
		parse "`new'", parse(" ")
		if "``i''"=="" { 
			exit
		}
		capture confirm new var ``i''
		if _rc { 
			if "``i''"!="." { 
				di in blue /*
				*/ "(cannot create `name' in ``i'':  skipping)"
			}
		}
		else { 
			local newv "``i''"
			parse "`orig'", parse(" ")
			if "`type'"=="*" { 
				local rtype : type ``i''
			}
			quietly egen `rtype' `newv' = `fcn'(``i''), `opts'
			local lbl : variable label ``i''
			label var `newv' "`name' `lbl'"
		}
		local i=`i'+1
	}
end
