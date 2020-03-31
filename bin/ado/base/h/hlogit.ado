*! version 3.2.5  08jan1993/18sep2000/28jan2015
program define hlogit
	quietly version 
	if _result(1)>=5 { 
		OodMsg 
		exit
	}
	version 3.1
	local options "Level(integer $S_level) OR"
	if "`1'"!="" & bsubstr("`1'",1,1)!="," {
		local options "`options' Group(string) *"
		local varlist "req ex"
		local in "opt"
		local if "opt"
		local weight "fweight aweight pweight iweight"
		parse "`*'"
		parse "`varlist'", parse(" ")
		tempvar yp ys yi touse
		tempname coefs VCE
		mark `touse' [`weight'`exp'] `if' `in'
		markout `touse' `varlist' `group'
		if ("`group'"!="") {
			sort `group'
			local grs "group(`group')"
		}
		if ("`exp'"!="") { local wt "[aw`exp']" }
		qui logit `*' `wt', `options', if `touse'
		if _result(1)==0 | _result(1)==. { 
			logit `*' `wt', `options', if `touse'
			exit 498
		}
		local dv "`1'"
		local nobs = _result(1)
		local mdf = _result(3)
		local ll = _result(2)
		local pr2 = _result(7)
		capture assert `touse'
		if _rc {
			preserve
			qui keep if `touse'
		}
		qui predict `yp' 
		qui predict `yi', index
		qui gen `ys' = `yp'*(1-`yp')
		qui replace `yp' = `1' - `yp'
		local lhs "`1'"
		mac shift
		qui reg `yi' `*' `wt', depn(`lhs') `options'
		if "`or'"!="" { 
			local or "eform(OR)"
		}
		qui _huber `yp' `ys', `grs' level(`level') `or', /*
				*/ [`weight'`exp']
		mat `coefs'=get(_b)
		mat `VCE'=get(VCE)
		mat post `coefs' `VCE', obs(`nobs') depn(`dv')
		global S_E_depv "`dv'"
		global S_E_nobs `nobs'
		global S_E_mdf `mdf'
		global S_E_grs "`group'"
		global S_E_dv "`dv'"
		global S_E_ll `ll'
		global S_E_pr2 `pr2'
		global S_E_tdf .
		global S_E_cmd "hlogit"
	}
	else {
		if ("$S_E_cmd"!="hlogit") { error 301 }
		parse "`*'"
		if "`or'"!="" { 
			local or "eform(OR)"
		}
	}
	#delimit ;
	di _n in gr
	"Logit Regression with Huber standard errors" _col(56)
		"Number of obs =" in yel %8.0f $S_E_nobs _n
	in gre "Log Likelihood = " in yel %10.0g $S_E_ll
		_col(56) in gr "Pseudo R2     ="
		in yel %8.4f $S_E_pr2
		_n ;
	#delimit cr
	if "$S_E_grs"!="" {
		di in gr "Grouping variable: $S_E_grs"
	}
	matrix mlout, level(`level') `or'
end

program define OodMsg
	version 5.0
	#delimit ; 
	di in ye "hlogit" in gr 
		" is an out-of-date command; " in ye "logit, robust" in gr 
		" is its replacement." _n ; 
	di in smcl in gr 
		"    Rather than typing" _col(41) "Type:" _n 
		"    {hline 32}    {hline 36}" ;
	di in ye "    . hlogit" in gr " yvar xvars" in ye _col(41)
		"logit " in gr "yvar xvars" in ye ", robust" ;
	di in ye "    . hlogit" in gr " yvar xvars" in ye ", group(" in gr 
		"gvar" in ye ")" _col(41)
		"logit" in gr " yvar xvars" in ye ", cluster(" in gr 
		"gvar" in ye ")" ;
	di in ye "    . hlogit" in gr " yvar xxvars" in ye " [pw=" in gr "w"
			in ye "]" _col(41) 
		"logit" in gr " yvar xvars" in ye " [pw=" in gr "w" 
			in ye "]" ;
	di in smcl in gr "    {hline}    {hline 36}" ;
	di in gr _col(41) "Note:  " in ye "cluster()" 
		in gr " implies " in ye "robust" _n _col(49)
		"pweight" in gr "s imply " in ye "robust" _n ;

	di in gr "The only difference is that " in ye 
		"logit, robust" in gr " applies a degree-of-freedom" _n 
		"correction to the VCE that " in ye "hlogit" in gr 
		" did not.  " in ye "logit, robust" in gr 
		" is better." _n(2) 
		"If you must use " in ye "hlogit" in gr ", type" _n ;
 
	di in ye _col(8) ". version 4.0" _n 
		_col(8) ". hlogit " in gr "..." in ye _n 
		_col(8) ". version 6.0" _n ;
	#delimit cr
	exit 199
end
exit
	
hlogit is an out-of-date command; logit, robust is its replacement.

    Rather than typing                  Type:
    --------------------------------    ------------------------------------
    . hlogit yvars vars                 . logit yvar xvars, robust
    . hlogit yvar xvars, group(gvar)    . logit yvar xvars, cluster(gvar)
    . hlogit yvar xvars [pw=2]          . logit yvar xvars [pw=w]
    --------------------------------    ------------------------------------
                                        Note:  cluster() implies robust
                                               pweights imply robust

The only difference is that logit, robust applies a degree-of-freedom 
correction to the VCE that hlogit did not.  logit, robust is better.

If you must use hlogit, type

        . version 4.0
        . hlogit ...
        . version 6.0

r(199);
