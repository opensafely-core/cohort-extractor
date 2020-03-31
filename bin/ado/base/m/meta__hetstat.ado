*! version 1.0.0  29apr2019
program meta__hetstat, eclass
	version 16
	syntax [varlist(fv default=none)], 	///
		ESvar(varname)			/// 
		SEvar(varname) 			///
		MEthod(string)			/// 
		touse(varname)			///	 
		[noCONStant			/// 
		maxiter(real 100)		///	
		TOLerance(real 1e-6)		///
		NRTOLerance(real 1e-5)		///
		from(real -1)			///
		SHOWTRace]
	
	tempname hetstat 
	
	if ("`varlist'" == "" & "`constant'" == "noconstant") {
		di as err "option {bf: noconstant} cannot be specified with" _c
		di as err "an empty {it:varlist}"
		exit 198
	}
	local addcons = cond("`constant'" == "", 1,0)
	local iterlog = cond(missing("`showtrace'"), 0, 1)
	
	eret clear
	mata: st_matrix("`hetstat'",_het_stat("`varlist'","`esvar'", ///
		 "`sevar'", "`method'", `addcons', "`touse'", `maxiter', ///
		 `tolerance', `iterlog', `nrtolerance'))
	
		
	if ("`isWARNING'"=="1") ereturn local iswarning	   = `isWARNING'
	if ("`isERROR'"=="1")    ereturn local iserror	   = `isERROR'
	ereturn scalar _meta_i2    = `hetstat'[1,1]
	ereturn scalar _meta_h2    = `hetstat'[1,2]
	ereturn scalar _meta_tau2 = `hetstat'[1,3]
	ereturn scalar _meta_r2    = `hetstat'[1,4]
	ereturn scalar _meta_Q    = `hetstat'[1,5]
	
	
end	
