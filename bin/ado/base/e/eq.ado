*! version 1.0.6  13feb2015
program define eq, rclass
* touched by kth -- double saves
	version 3.1
	if "$S_eqnum"=="" {
		global S_eqnum 0
	}
	if "`1'"=="?" | "`1'"=="??" {
		if "`3'"!="" {
			error 198
		}
		_crceqnm `2'
		local ename "${S_eqeq`r(n_eq)'}"
		if "`1'"=="?" & "`ename'"!= "" {
			local varlist "req ex"
			capture parse "`ename'"
			if _rc {
				di in red "`r(eqname)':" _col(11) "`ename'"
				local varlist "req ex"
				parse "`ename'"
				/*NOTREACHED*/
			}
			local ename "`varlist'"
		}
		ret local eq "`ename'"
		ret local eqname "`r(eqname)'"
		/* double save in r() and S_#  */
		global S_1 `return(eq)'
		global S_3 `return(eqname)'
		exit
	}
	if "`1'"=="dir" | "`1'"=="list" {
		local cmd "`1'"
		mac shift 
		if "`1'"=="" {
			local 1 "_all"
		}
		_crceqlu `*'
		parse "`r(eqnums)'", parse(" ")
		if "`cmd'"=="dir" {
			while "`1'"!="" {
				di in gr "${S_eqnm`1'}"
				mac shift
			}
			exit
		}
		while "`1'"!="" {
			di in gr "${S_eqnm`1'}:" _col(11) in ye "${S_eqeq`1'}"
			mac shift
		}
		exit
	}
	if "`1'"=="drop" {
		mac shift
		if "`*'"=="" {
			error 198
		}
		local arg "`*'"
		_crceqlu `*'
		parse "`r(eqnums)'", parse(" ")
		while "`1'"!="" {
			_crceqdp `1'
			mac shift
		}
		if "`arg'"=="_all" {
			global S_eqnum
		}
		exit
	}
	parse "`*'", parse(" :")
	if "`1'"=="define" {
		mac shift
	}
	local nm "`1'"
	mac shift
	if "`1'"==":" {
		local hascln "y"
		mac shift 
	}
	else if "`*'"=="" {
		error 198 
	}
	if "`hascln'"!="y" {
		local eq "`nm' `*'"
	}
	else	local eq "`*'"

	capture _crceqnm `nm'
	if _rc { 
		local i=$S_eqnum+1
	}
	else	local i `r(n_eq)'

	global S_eqnm`i' "`nm'"
	global S_eqeq`i' "`eq'"
	if `i'>$S_eqnum {
		global S_eqnum `i'
	}
end

program define _crceqdp /* # */
	version 3.1
	global S_eqnm`1'
	global S_eqeq`1'
	if `1'==$S_eqnum {
		global S_eqnum = $S_eqnum - 1
	}
end

program define _crceqlu, rclass /* [name(s)] */
				/* #s returned in r(eqnums) */
	version 3.1
	if "`*'" == "" { exit }
	if "`*'" == "_all" {
		local i 1
		while `i'<=$S_eqnum {
			if "${S_eqnm`i'}"!="" {
				ret local eqnums "`return(eqnums)' `i'"
			}
			local i=`i'+1
		}
		exit
	}
	while "`1'"!="" {
		_crceqnm `1'
		ret local eqnums "`return(eqnums)' `r(n_eq)'"
		mac shift
	}
end

program define _crceqnm, rclass /* name  (which may be abbreviated) */
			        /* # returned in r(n_eq) */
			        /* unabbreviated in r(eqname) */
	version 3.1
	local l = length("`1'")
	local m 0 
	local j 0 
	local i 1 
	while `i'<=$S_eqnum {
		if "${S_eqnm`i'}"=="`1'" {
			ret scalar n_eq = `i'
			ret local eqname ${S_eqnm`i'}
			exit
		}
		if `m'==0 & bsubstr("${S_eqnm`i'}",1,`l')=="`1'" {
			if `j' {
				local m 1
			}
			else	local j `i'
		}
		local i=`i'+1
	}
	if `j' & `m'==0 {
		ret scalar n_eq = `j'
		ret local eqname ${S_eqnm`j'}
		exit
	}
	if `j' {
		di in red "equation `1' ambiguous abbreviation"
	}
	else	di in red "equation `1' not found"
	exit 111
end
exit
/*
eq [define] name : stuff
eq stuff

eq dir [_all | name(s)]
eq list [_all | name(s)]
eq drop {_all | name(s)}

eq ? name
	returns in r(eqname) the equation , expanded

eq ?? name
	returns in r(eqname) the equation AS-IS.

Design:
	S_eqnum		number of stored equations
	S_eqeq##	storage of eqtn #
	S_eqnm##	name of eqtn #
*/
