*! version 3.0.9  01nov1994/18sep2000/28jun2011/28jan2015
program define hreg
	quietly version 
	if _result(1)>=5 { 
		OodMsg 
		exit
	}
	version 3.0
	if "`1'"!="" & bsubstr("`1'",1,1)!="," {
		local options "Group(string) Level(integer $S_level) *"
		local varlist "req ex"
		local in "opt"
		local if "opt"
		local weight "fweight aweight pweight iweight"
		parse "`*'"
		parse "`varlist'", parse(" ")
		tempvar yr ys touse
		mark `touse' [`weight'`exp'] `if' `in'
		markout `touse' `varlist' `group'
		if ("`group'"!="") {
			sort `group'
			local grs "group(`group')"
		}
		if ("`exp'"!="") { 
			local wt "[aw`exp']" 
		}
		qui reg `*' `wt', `options', if `touse'
		if _result(1)==0 | _result(1)==. { error 2000 } 
		local nobs=_result(1)
		local mdf=_result(3)
		local tdf=_result(5)
		local r2=_result(7)
		local ar2=_result(8)
		local rmse=_result(9)
		qui predict `yr' if `touse', resid
		cap assert `touse'
		if _rc { 
			preserve
			qui keep if `touse'
		}
		qui gen byte `ys' = 1
		qui _huber `yr' `ys', `grs' level(`level'), [`weight'`exp']
		mac def S_E_cmd "hreg"
		mac def S_E_grs "`grs'"
		mac def S_E_dv "`1'"
		mac def S_E_depv "`1'"
		mac def S_E_nobs `nobs'
		mac def S_E_tdf `tdf'
		mac def S_E_mdf `mdf'
		mac def S_E_r2 `r2'
		mac def S_E_ar2 `ar2'
		mac def S_E_rmse `rmse'
	}
	else {
		if ("$S_E_cmd"!="hreg") { error 301 }
		local options "Level(integer $S_level)"
		parse "`*'"
	}
	if "$S_E_grs"=="" { local addline "_n" }
	#delimit ;
	di _n in gr
	"Regression with Huber standard errors" _col(53)
		"Number of obs    =" in yel %8.0f $S_E_nobs _n
		_col(53) in gre "R-squared        ="
		in yel %8.4f $S_E_r2 _n
		_col(53) in gr "Adj R-squared    ="
		in yel %8.4f $S_E_ar2 _n
		_col(53) in gr "Root MSE         ="
		in yel %8.0g $S_E_rmse `addline'  ;
	#delimit cr
	_huber, level(`level') $S_E_grs
end

program define OodMsg
	version 5.0
	#delimit ; 
	di in ye "hreg" in gr 
		" is an out-of-date command; " in ye "regress, robust" in gr 
		" is its replacement." _n ; 
	di in smcl in gr 
		"    Rather than typing" _col(41) "Type:" _n 
		"    {hline 30}      {hline 36}" ;
	di in ye "    . hreg" in gr " yvar xvars" in ye _col(41)
		"regress " in gr "yvar xvars" in ye ", robust" ;
	di in ye "    . hreg" in gr " yvar xvars" in ye ", group(" in gr 
		"gvar" in ye ")" _col(41)
		"regress" in gr " yvar xvars" in ye ", cluster(" in gr 
		"gvar" in ye ")" ;
	di in ye "    . hreg" in gr " yvar xxvars" in ye " [pw=" in gr "w"
			in ye "]" _col(41) 
		"regress" in gr " yvar xvars" in ye " [pw=" in gr "w" 
			in ye "]" ;
	di in smcl in gr "    {hline 30}      {hline 36}" ;
	di in gr _col(41) "Note:  " in ye "cluster()" 
		in gr " implies " in ye "robust" _n _col(49)
		"pweight" in gr "s imply " in ye "robust" _n ;

	di in gr "The only difference is that " in ye 
		"regress, robust" in gr " applies a degree-of-freedom" _n 
		"correction to the VCE that " in ye "hreg" in gr 
		" did not.  " in ye "regress, robust" in gr 
		" is better." _n(2) 
		"If you must use " in ye "hreg" in gr ", type" _n ;
 
	di in ye _col(8) ". version 4.0" _n 
		_col(8) ". hreg " in gr "..." in ye _n 
		_col(8) ". version 6.0" _n ;
	#delimit cr
	exit 199
end
exit
	
hreg is an out-of-date command; regress, robust is its replacement.

    Rather than typing                  Type:
    ------------------------------      ------------------------------------
    . hreg yvar xvars                   . regress yvar xvars, robust
    . hreg yvar xvars, group(gvar)      . regress yvar xvars, cluster(gvar)
    . hreg yvar xvars [pw=w]            . regress yvar xvars [pw=w]
    ------------------------------      ------------------------------------
                                        Note:  cluster() implies robust
                                               pweights imply robust

The only difference is that regress, robust applies a degree-of-freedom 
correction to the VCE that hreg did not.  regress, robust is better.

If you must use hreg, type

        . version 4.0
        . hreg ...
        . version 6.0

r(199);
