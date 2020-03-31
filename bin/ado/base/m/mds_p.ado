*! version 1.1.6  19mar2019
program mds_p
	version 10

	if !inlist("`e(cmd)'", "mds","mdsmat","mdslong") {
		error 301
	}

	#del ;
	syntax  anything [if] [in],  
	[
		CONfig
		PAIRwise               // undocumented
		PAIRwisex(str)
		noTRANSform            // undocumented
		SAVing(passthru) 
		REPLACE		      // undocumented
		FULL 
	];
	#del cr

	if `"`if'`in'"' != "" {
		if "`e(cmd)'" == "mdsmat" {
			dis as err "if and in not allowed with predict " ///
			           "after mdsmat"
			exit 100
		}
		if `"`saving'"' != "" {
			dis as err "if and in not allowed with saving()"
			exit 100
		}
		marksample touse, novarlist
		local iftouse if `touse'
	}	
	
	ParseSaving, `saving'
	local saving `s(saving)'
	if "`replace'" == "" {
		local replace `s(replace)'
	}	

	if "`pairwise'" != "" & "`pairwisex'" != "" {
		dis as err "options pairwise and pairwise() are exclusive"
		exit 198
	}
	
	if "`transform'" != "" & "`pairwise'" == "" {
		dis as "option notransform is allowed with pairwise only"
		exit 198
	}
	
	if "`pairwise'" != "" {
		if "`transform'" == "" {
			local pairwisex disp dist tres
		}
		else {
			local pairwisex diss dist rres
		}	
	}
	
	if "`config'" != "" & "`pairwisex'" != "" {
		dis as err "options config and pairwise() are exclusive"
		exit 198
	}
	
	if "`full'" != "" & "`pairwisex'" == "" {
		dis as err "option full is allowed with pairwise() only"
		exit 198
	}	

	if "`pairwisex'" != "" {
		Parse_pairwisex `pairwisex'
		local pairwisex `s(pairwisex)'
	}
	else if "`config'" == "" {
		dis as txt "(option {bf:config} assumed)"
		local config config
	}

	if "`e(cmd)'" != "mdsmat" & "`e(id)'" != "" {
		capt confirm var `e(id)'
		if _rc {
			dis as err "id variable `e(id)' not found"
			exit 198
		}
	}
	
// invoke commands that do the work --------------------------------------

	if "`config'" != "" {
		Config `anything' `iftouse', `saving' `replace'
	}
	if "`pairwisex'" != "" {
		Pairwise `anything' `iftouse', ///
		         `saving' `replace' `full' vars(`pairwisex')
	}
end

// ============================================================================

program Config, sortpreserve
	syntax anything [if] [, saving(str) replace ]

	if `"`saving'"' == "" {
		if inlist("`e(cmd)'","mdslong","mdsmat")  {
			dis as err ///
			    "saving() required with config after `e(cmd)'"
			exit 198
		}
		
		if "`e(duplicates)'" != "0" {
			// merge on id will fail
			local id1 : word 1 of `e(id)'
			dis as err ///
			    "{p}saving() required since id variable "   ///
			    "`id1' was identified as having duplicate " ///
			    "values{p_end}"
			exit 115
		}
	}
	
	preserve
	
// check varlist 	

	local id : word 1 of `e(id)'

	if strpos("`anything'", "*") {
		local ndim = `e(p)'
		_stubstar2names `anything', nvars(`ndim')
		local varlist `s(varlist)'
		local typlist `s(typlist)'
		confirm new var `varlist'
	}
	else {
                Newvarlist `anything'
                local varlist `s(varlist)'
                local typlist `s(typlist)'
	}

	if `"`saving'"' == "" {
		marksample touse , novarlist
		
		capture confirm variable `id'
		if _rc {
			dis as err "id() variable not found in data in memory"
			exit 198
		}
	}

	local nnew : list sizeof varlist 
	if `nnew' > `e(p)' {
		error 103
	}
	if `nnew' < `e(p)' {
		dis as txt "(`=`e(p)'-`nnew'' " ///
			 plural(`=`e(p)'-`nnew'' , "dimension") " ignored)"
	}

// save data in memory to merge on later

	if `"`saving'"' == "" {
		tempfile fmaster
		qui sort `id'
		qui save `"`fmaster'"', replace
	}
	
// create file with config variables

	qui ObjectFile `id' 
	local id `r(id)' 
	
	local vlist `"`varlist'"'
	forvalues j = 1 / `nnew' {
		gettoken v  vlist   : vlist
		gettoken tp typlist : typlist
		qui gen `tp' `v' = el(e(Y),_`id',`j')
		label var `v' "MDS dimension `j'"
	}
	
// save file or merge it with data in memory

	if `"`saving'"' != "" {
		local t    "method=`e(method)',dim=`e(p)'"
		label data "unit statistics for MDS (`t')"
		
		qui compress
		qui sort _`id', stable
		qui save `"`saving'"', `replace'
		
		restore
	}
	else {
		tempfile fmerge
		qui sort `id'
		qui save `"`fmerge'"', replace
		
		qui drop _all
		qui use `"`fmaster'"'
		qui merge `id' using `"`fmerge'"'
		qui drop if _merge == 2
		foreach vi of local varlist {
			qui replace `vi' = . if `touse' == 0
		}
		drop _merge _`id'
		
		restore, not
	}
end

// ============================================================================

program Pairwise, sortpreserve
	syntax anything [if], vars(namelist) ///
	[ saving(str) replace full ]
	
	if `"`saving'"' == "" {
		if inlist("`e(cmd)'","mds","mdsmat") {
			dis as err ///
			    "saving() required with pairwise after `e(cmd)'"
			exit 198
		}
		
		if "`e(duplicates)'" != "0" {
			// merge on id will fail
			local id1 : word 1 of `e(id)'
			dis as err ///
			    "{p}saving() required since id variable "   ///
			    "`id1' was identified as having duplicate " ///
			    "values{p_end}"
			exit 115
		}
	}	
	preserve
	
	local nvars: list sizeof vars
	
	local id `e(id)' 
	gettoken id1 id2 : id
	

	if strpos("`anything'","*") {
		 _stubstar2names `anything', nvars(`nvars')
		local varlist `s(varlist)'
		local typlist `s(typlist)'
		confirm new var `varlist'
	}
	else {
		Newvarlist `anything', n(`nvars')
		local varlist `"`s(varlist)'"'
		local typlist `"`s(typlist)'"'
	}
	if `"`saving'"' == "" { 
		marksample touse, novarlist
		
		capture confirm variable `id'
		if _rc {
			dis as err "id() variable not found in data in memory"
			exit 198
		}
	}
	
// save data in memory to merge on later

	if `"`saving'"' == "" {
		tempfile fmaster
		qui sort `id1' `id2'
		qui save `"`fmaster'"', replace
	}	
	
// create pair file

	qui PairFile `id1' `id2'
	local id1 `r(id1)'
	local id2 `r(id2)'
	qui sort `id1' `id2'
// add the constituent variables

	tempname Disp Diss Dist F Ta Tb

	mds_euclidean `F' = e(Y)
	gen double `Dist' = el( `F', _`id1', _`id2')
	gen double `Diss' = el(e(D), _`id1', _`id2')
	
	if "`e(method)'" == "classical" {
		scalar `Ta' = el(e(linearf),1,1)
		scalar `Tb' = el(e(linearf),1,2)
		gen double `Disp' = `Ta'+`Tb'*`Diss'
	}
	else if "`e(tfunction)'" == "power" {
		scalar `Ta' = e(alpha)
		assert `Ta'!=.
		gen double `Disp' = `Diss'^(`Ta')
	}
	else if "`e(tfunction)'" == "monotonic" {
		capture confirm matrix e(Disparities)
		if _rc {
			dis as err "mds_p: disparity matrix not found"
			exit 498
		}	
		gen double `Disp' = el(e(Disparities), _`id1', _`id2')
	}
	else {
		gen double `Disp' = `Diss'
	}	
		
	if "`e(W)'" == "matrix" {
		local wexp = el(e(W), _`id1', _`id2')
	}
	else {
		local wexp 1
	}	
		
// generate variables to be returned --------------------------------------
	local newvars `varlist'
	foreach v of local vars {
		gettoken vn varlist : varlist
		gettoken tp typlist : typlist
		
		if "`v'" == "distances" {
			gen `tp' `vn' = `Dist'
			lab var `vn' "L2-Distances"		
		}
		else if "`v'" == "dissimilarities" {
			gen `tp' `vn' = `Diss'
			lab var `vn' "Dissimilarities"
		}
		else if "`v'" == "disparities" {
			gen `tp' `vn' = `Disp'
			lab var `vn' "Disparities"	
		}	
		else if "`v'" == "rresiduals" {
			gen `tp' `vn' = `Diss'-`Dist'
			lab var `vn' "rresiduals = Dissimilarities-Distances"
		}			
		else if "`v'" == "tresiduals" {
			gen `tp' `vn' = `Disp'-`Dist'
			lab var `vn' "tresiduals = Disparities-Distances"	
		}
		else if "`v'" == "weights" {
			gen `tp' `vn' = `wexp'
			lab var `vn' "weights"	
		}
		else {
			dis as err "mds_p: statistic `v' not supported"
			exit 498
		}
	}
	drop `Disp' `Diss' `Dist'
	
// save file or merge it with data in memory	
   	
	if `"`saving'"'	!= "" { 
		local t    "method=`e(method)',dim=`e(p)'"
		label data "pairwise statistics for MDS (`t')"

		if "`full'" == "" {
			qui drop if _`id1' <= _`id2'
		}
		qui compress
		qui sort _`id1' _`id2'
		qui save `"`saving'"', `replace'
		
		restore
	}
	else {
		tempfile fmerge
		qui save `"`fmerge'"', replace
			
		qui drop _all
		qui use `"`fmaster'"'
		sort `id1' `id2'
		qui merge `id1' `id2' using `"`fmerge'"'
		qui drop if _merge == 2
		foreach vi of local newvars {
			qui replace `vi' = . if `touse' == 0
		}
		qui drop _merge _`id1' _`id2'
			
		restore, not
	}
end

// ============================================================================

program ObjectFile, rclass
	args id
	
	if "`id'" == "." {
		local id id
	}
	else {
		confirm name `id'
	}
	
	capture confirm variable `id'
	if _rc == 0 {
		local idvallab `: value label `id''
	}
	if "`idvallab'" != "" {
		tempfile fvallab
		label save `idvallab' using `"`fvallab'"'	
	}	

// start with an empty file, with numeric index 1,2,3... only

	tempname Y
	matrix `Y' = e(Y)
	local n = rowsof(`Y')
	
	drop _all
	set obs `n' 
	gen _`id' = _n

// generate id

	if "`e(cmd)'" == "mdsmat" {
		gen str32 `id' = ""
		mata: _mds_rownames2var("`id'")
	}
	else if "`e(idtype)'" != "str" {
		gen `id' = .
		mata: _idcoding2var("`id'")
		if "`idvallab'" != "" {
			label value `id' `idvallab'
			run `"`fvallab'"'	
		}	
	}
	else {
		if `"`e(labels)'"' != "" {
			gen str32 `id' = ""
			mata: _elabels2var("`id'")
		}
		else {
			dis as err "impossible to create id-variable"
			exit 198
		}
	}	
	compress
	sort `id'

	return local id `id'
end

// ============================================================================

program PairFile, rclass
	args id1 id2
	
	if "`id1'" == "" & "`id2'" == "" { 
		local id1 id1
		local id2 id2
	}
	else if "`id2'" == "" {
		local id2 `id1'2
		local id1 `id1'1
	}	

// start with an object file
	capture confirm variable `id1'
	if _rc == 0 {
		qui local idvallab `: value label `id1''
	}
	ObjectFile `id1'
	
// make all pairs in id1
	
	tempvar rest
	expand = c(N)
	
	bys _`id1': gen byte `rest' = _n>1
	bys _`id1': gen      _`id2' = _n
	sort `rest' _`id1'
	gen `id2' = `id1'[_`id2']
	
	compress
	if "`idvallab'" != "" {
		label value `id1' `idvallab'
		label value `id2' `idvallab'
	}

	sort _`id1' _`id2'
	return hidden local id1 `id1' 
	return hidden local id2 `id2' 
end

// ============================================================================

program Parse_pairwisex, sclass
	local holdlist `0'
	foreach word of local holdlist {
		local 0 ,`word'
	
		syntax, [ DISSimilarities DISParities DISTances ///
	 	         RResiduals TResiduals WEights ]

		local returnlist `returnlist' `dissimilarities' 	///
			`disparities' `distances' `rresiduals' 		///
			`tresiduals' `weights'
	}
	local sts `returnlist'

	sreturn clear
	sreturn local pairwisex `sts'
end

// ============================================================================

program Newvarlist, sclass 
	syntax anything [, n(integer 0)]

	local 0 `anything'
	if (`n' > 0) {
		capt syntax newvarlist(min=`n' max=`n')
	}	
	else {
		capt syntax newvarlist
	}	
	if _rc == 0 {
		sreturn clear
		sreturn local varlist `"`varlist'"'
		sreturn local typlist `"`typlist'"'
		exit 0
	}
	
	preserve
	drop _all
	if (`n' > 0) {
		capt noisily syntax newvarlist(min=`n' max=`n')
	}	
	else {
		capt noisily syntax newvarlist
	}	
	local rc = _rc
	restore
	if (`rc' > 0) {
		exit `rc'
	}	

	sreturn clear
	sreturn local varlist `"`varlist'"'
	sreturn local typlist `"`typlist'"' 
	
	foreach vi of local varlist {
		capture drop `vi'
	}
end

program ParseSaving, sclass
	syntax [, SAVing(str)]
	local 0 `saving'
	capture syntax [anything] [, replace]
	if _rc {
		di as err "option saving() invalid, filename required"
		exit 198
	}
	sreturn local saving saving(`anything')
	sreturn local replace replace
end
	
// ============================================================================

mata:

// stores the rownames of e(Y) into the string variable _svar
//
void _mds_rownames2var( string scalar _svar )
{
	string matrix rs
	rs = st_matrixrowstripe("e(Y)")
	st_sstore(., _svar, rs[.,2])
}

// stores the macro e(labels) into the string variable _svar
//
void _elabels2var( string scalar _svar )
{
	st_sstore(., _svar, tokens(st_global("e(labels)"))')
}

// stores the nx1 matrix e(idcoding) into the numeric variable _svar
void _idcoding2var( string scalar _svar )
{
	st_store(., _svar, st_matrix("e(idcoding)"))
}

end
exit
