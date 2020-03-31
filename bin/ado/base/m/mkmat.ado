*! version 2.2.1  14jan2020
program mkmat
	version 9, missing

	#del ;
	syntax  varlist(numeric) [if] [in]
	[,
		MATrix(name)
		noMISsing
		ROWNames(varname)
		ROWEq(varname)
		ROWPREfix(string)
		OBS
		NCHar(numlist integer max=1 >=1 <=32)
	];
	#del cr

	if "`obs'" != "" & "`rownames'" != "" { 
		dis as err "options obs and rownames() are exclusive"
		exit 198
	}

	if "`nchar'" == "" {
		local nchar = 32
	}

// sample ----------------------------------------------------------------------

	local nvar : list sizeof varlist
	if "`missing'" != "" {
		marksample touse
	}
	else {
		marksample touse, novarlist
	}

	qui count if `touse'
	local N = r(N)
	if (`N' == 0) error 2000

	if "`matrix'" != "" { 
		local matdim = max(`N',`nvar')
		if `matdim' > c(max_matdim) {
			error 915
		}
	}
	else { 
		if `N' > c(max_matdim) {
			error 915
		}
	}

// handle the stripes ----------------------------------------------------------

	tempvar rnames
	if "`rownames'" == "" {
		if `"`rowprefix'"' == "" { 
			local rowprefix r
		}	
		if "`obs'" != "" { 
			qui gen `rnames' = string(_n) if `touse'
		}
		else {
		        // careful: no -if `touse'- on purpose  
			qui gen `rnames' = string(sum(`touse')) 
		}
	}
	else {
		if bsubstr("`:type `rownames''",1,3) == "str" {
			CheckStr rownames `rownames' `touse' 
			qui gen `rnames' = `rownames' if `touse'  
		}
		else {
			CheckInt rownames `rownames' `touse' 
			qui gen `rnames' = string(`rownames') if `touse'
		}
	}
	
	if `"`rowprefix'"' != "" { 
		qui replace `rnames' = `"`rowprefix'"' + `rnames' if `touse'
	}	
	CleanUp `rnames' `touse' `nchar' 

	if "`roweq'" != "" {
		tempvar req
		if bsubstr("`:type `roweq''",1,3) == "str" {
		        CheckStr roweq `roweq' `touse' 
			qui gen `req' = `roweq'  
			CleanUp `req' `touse' `nchar' 
		}
		else {
			CheckInt roweq `roweq' `touse' 
			qui gen `req'  = string(`roweq') if `touse'
		}
	}

// use mata to quickly create matrix(ces) with appropriate stripes -------------

	if "`matrix'" != "" {
		mata: mkmat("`varlist'","`touse'","`matrix'","`req'","`rnames'")		
	}
	else {
		foreach v of local varlist {
			mata: mkmat("`v'","`touse'","`v'","`req'","`rnames'")
		}
	}
end


program CleanUp
	args vn touse nchar
	
	qui replace `vn' = subinstr(`vn'," ","_",.) if `touse'
	qui replace `vn' = subinstr(`vn',".","_",.) if `touse'
	qui replace `vn' = usubstr(`vn',1,`nchar')   if `touse'
end


program CheckStr
	args optn vn touse
	
	capt assert !missing(`vn') if `touse' 
	if _rc {
		dis as err "`optn'() invalid; `vn' contains empty strings"
		exit 198
	}
end	


program CheckInt 
	args optn vn touse

	capt assert !missing(`vn') if `touse' 
	if _rc {
		dis as err "`optn'() invalid; `vn' contains missing values"
		exit 198
	}
	
	// should be integer-valued and positive
	capt assert `vn'==round(`vn') if `touse'
	if _rc {
		dis as err "`optn'() invalid; `vn' is not integer valued"
		exit 198
	}
	capt assert `vn'>=0 if `touse' 
	if _rc {
		dis as err "`optn'() invalid; `vn' is not strictly positive" 
		exit 198
	}
end	

// =============================================================================

mata:

void function mkmat( string scalar _vlist,
                     string scalar _touse,
                     string scalar _X,
                     string scalar _roweq,
                     string scalar _rownames )
{
	string matrix S, tV

	tV = tokens(_vlist)
	st_matrix(_X, st_data(., tV, _touse))

	// roweq:    from variable _roweq; or "" if _roweq == ""
	// rownames: from variable _rownames

	if (_roweq == "") { 
	        S = st_sdata(., _rownames, _touse)
		S = ( J(rows(S),1,"") , S )
	}
	else {
		S = st_sdata(., (_roweq,_rownames), _touse)
	}
	st_matrixrowstripe(_X, S)
	
	// coleq:    none
	// colnames: varnames
	st_matrixcolstripe(_X, (J(cols(tV),1,""), tV'))
}
end
exit
