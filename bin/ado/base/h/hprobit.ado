*! version 3.2.7  18jan1994/18sep2000/28jun2011/28jan2015
program define hprobit
	quietly version 
	if _result(1)>=5 { 
		OodMsg 
		exit
	}
	version 3.1
	if "`1'"!="" & bsubstr("`1'",1,1)!="," {
		local options "Group(string) Level(integer $S_level) *"
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
		qui probit `*' `wt', `options', if `touse'
		if _result(1)==0 | _result(1)==. { 
			probit `*' `wt', `options', if `touse'
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
		* somebody should check this algebra
		qui gen `ys'=exp(-0.5*`yi'*`yi')/sqrt(2*_pi)/`yp' if `1'!=0
		qui replace `ys'=-exp(-0.5*`yi'*`yi')/sqrt(2*_pi)/(1-`yp') if `1'==0
		qui replace `yp' = `ys'*(`yi'+`ys')
		mac shift
		qui reg `yi' `*' `wt', `options' depn(`dv')
		qui _huber `ys' `yp', `grs' level(`level'), /*
			*/ [`weight'`exp']
		mat `coefs'=get(_b)
		mat `VCE'=get(VCE)
		mat post `coefs' `VCE', obs(`nobs') depn(`dv')
		global S_E_depv "`dv'"
		global S_E_nobs `nobs'
		global S_E_mdf `mdf'
		global S_E_grs "`group'"
		global S_E_ll `ll'
		global S_E_pr2 `pr2'
		global S_E_dv "`dv'"
		global S_E_tdf .
		global S_E_cmd "hprobit"
	}
	else {
		if ("$S_E_cmd"!="hprobit") { error 301 }
		local options "Level(integer $S_level)"
		parse "`*'"
	}
	#delimit ;
	di _n in gr
	"Probit Regression with Huber standard errors" _col(56)
		"Number of obs =" in yel %8.0f $S_E_nobs _n
	in gre "Log Likelihood =" in yel %10.0g $S_E_ll
		_col(56) in gr "Pseudo R2     ="
		in yel %8.4f $S_E_pr2
		_n ;
	#delimit cr
	if "$S_E_grs"!="" {
		di in gr "Grouping variable: $S_E_grs"
	}
	mat mlout, level(`level') 
end


program define OodMsg
	version 5.0
	#delimit ; 
	di in ye "hprobit" in gr 
		" is an out-of-date command; " in ye "probit, robust" in gr 
		" is its replacement." _n ; 
	di in smcl in gr 
		"    Rather than typing" _col(42) "Type:" _n 
		"    {hline 33}    {hline 36}" ;
	di in ye "    . hprobit" in gr " yvar xvars" in ye _col(42)
		"probit " in gr "yvar xvars" in ye ", robust" ;
	di in ye "    . hprobit" in gr " yvar xvars" in ye ", group(" in gr 
		"gvar" in ye ")" _col(42)
		"probit" in gr " yvar xvars" in ye ", cluster(" in gr 
		"gvar" in ye ")" ;
	di in ye "    . hprobit" in gr " yvar xxvars" in ye " [pw=" in gr "w"
			in ye "]" _col(42) 
		"probit" in gr " yvar xvars" in ye " [pw=" in gr "w" 
			in ye "]" ;
	di in smcl in gr "    {hline 33}    {hline 36}" ;
	di in gr _col(42) "Note:  " in ye "cluster()" 
		in gr " implies " in ye "robust" _n _col(49)
		"pweight" in gr "s imply " in ye "robust" _n ;

	di in gr "The only difference is that " in ye 
		"probit, robust" in gr " applies a degree-of-freedom" _n 
		"correction to the VCE that " in ye "hprobit" in gr 
		" did not.  " in ye "probit, robust" in gr 
		" is better." _n(2) 
		"If you must use " in ye "hprobit" in gr ", type" _n ;
 
	di in ye _col(8) ". version 4.0" _n 
		_col(8) ". hprobit " in gr "..." in ye _n 
		_col(8) ". version 6.0" _n ;
	#delimit cr
	exit 199
end
exit
	
hprobit is an out-of-date command; probit, robust is its replacement.

    Rather than typing                   Type:
    --------------------------------     ------------------------------------
    . hprobit yvars vars                 . probit yvar xvars, robust
    . hprobit yvar xvars, group(gvar)    . probit yvar xvars, cluster(gvar)
    . hprobit yvar xvars [pw=2]          . probit yvar xvars [pw=w]
    --------------------------------     ------------------------------------
                                         Note:  cluster() implies robust
                                                pweights imply robust

The only difference is that probit, robust applies a degree-of-freedom 
correction to the VCE that hprobit did not.  probit, robust is better.

If you must use hprobit, type

        . version 4.0
        . hprobit ...
        . version 6.0

r(199);
