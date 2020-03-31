*! version 1.1.3  16feb2015
program mdsconfig
	version 10

	if !inlist("`e(cmd)'","mds","mdsmat","mdslong") {
		error 301
	}

	if colsof(e(Y)) == 1 {
		dis as txt "(plot suppressed for dim=1)"
		exit
	}

	syntax [, 					///
		MAXlength(numlist min=1 max=1 >=2 <=32) ///
		AUTOaspect				///
		ASPECTratio(str)			///
		XNEGate					///
		YNEGate					///
		DIMensions(numlist integer min=2 max=2)	///
		* 					///
	]
	
	local dim `dimensions'

	if "`aspectratio'" != "" & "`autoaspect'" != "" {
		display as error				///
		    "options aspectratio() and autoaspect may not be combined"
		exit 198
	}

	if "`maxlength'" == "" {
		local maxlength 32
	}

	tempname Y
	matrix `Y' = e(Y)
	if `maxlength' < 32 {
		local rnames : rownames `Y'
		forvalues i = 1 / `=rowsof(`Y')' {
			gettoken fulln rnames : rnames
			local abvn = usubstr("`fulln'",1,`maxlength')
			local abvns `abvns' `abvn'
		}
		matrix rownames `Y' = `abvns'
	}

	if "`dim'" == "" {
		local dim 2 1
	}
	else {
		local cols = colsof(`Y')
		local i1 : word 1 of `dim'
		local i2 : word 2 of `dim'
		if !inrange(`i1',1,`cols') | !inrange(`i2',1,`cols')  {
			dis as err "dim() invalid; index out of range"
			exit 125
		}
		if `i1' == `i2' {
			dis as err "dim() invalid; distinct values expected"
			exit 198
		}
	}

	local dim1 : word 2 of `dim'
	local dim2 : word 1 of `dim'
	local columns columns(2 1)

	tempname R xmin xmax ymin ymax

	// use only columns that were requested (1=x, 2=y)
	matrix `R' = `Y'[1..., `dim1'] , `Y'[1..., `dim2']
	
	// negate axes
	if "`xnegate'" != "" {
		matrix `R' = (-`R'[1...,1]) , (`R'[1...,2...])
	}
	if "`ynegate'" != "" {
		matrix `R' = (`R'[1...,1]) , (-`R'[1...,2...])
	}
	matrix `Y' = `R'
	
	mata: _mds_myminmax("`R'", "`R'")
	scalar `xmin' = `R'[1,1]
	scalar `xmax' = `R'[2,1]
	scalar `ymin' = `R'[1,2]
	scalar `ymax' = `R'[2,2]

	.atk = .aspect_axis_toolkit.new
	.atk.setPreferredLabelCount 7

	_parse comma aspect_ratio placement : aspectratio
	if "`aspect_ratio'" != "" {
		confirm number `aspect_ratio'
		.atk.setPreferredAspect `aspect_ratio'
		.atk.setShowAspectTrue
	}

	if "`autoaspect'" != "" {
		.atk.setAutoAspectTrue
	}

	.atk.getAspectAdjustedScales ,					///
		xmin(`=`xmin'') xmax(`=`xmax'') ymin(`=`ymin'') ymax(`=`ymax'')

	LabelOK, `options'
	if `s(labelok)' {
		local n = rowsof(`Y')
		if `n' > _N {
			preserve
			qui set obs `n'
		}
		tempvar name
		qui gen str`maxlength' `name' = ""
		if `"`e(labels)'"' != "" {
			mata : _mds_labels2var(`"`e(labels)'"',"`name'")
		}
		else { // "`e(idtype)'" == "float" 
			mata: _mds_labels2var(`"`:rowfullnames `Y''"',"`name'")
			qui replace `name' = subinstr(`name',"_",".",1)
		}
		local labopt nonames mlabel(`name')
		local options `s(options)'
	}
	else if "`s(mlabel)'" != "" {
		tempvar name
		if (bsubstr("`:type `s(mlabel)''",1,3) != "str") {
			local fmt : format `s(mlabel)'
			qui gen str`maxlength' `name' = string(`s(mlabel)')
		}
		else {
			qui gen str`maxlength' `name' = `s(mlabel)'
		}
		local labopt nonames mlabel(`name')
		local options `s(options)'
	}
		
	if "`e(loss)'" == "" {
		local note note(Classical MDS, span)
	}
	else {
		local note `"Modern MDS (loss=`e(loss)'; transform=`e(tfunction)')"'
		local note note(`note',span)
	}	
		
	_matplot `Y' , title(MDS configuration, span) 			///
		`columns' `note'					///
		aspectratio(`s(aspectratio)'`placement') `s(scales)' 	///
		xtitle(Dimension `dim1') ytitle(Dimension `dim2') 	///
		`labopt' `options'
end


program LabelOK, sclass
	syntax [, mlabel(varname) noNAMes *]

	sreturn local labelok = ("`mlabel'"=="" & "`names'"=="" & ///
		(`"`e(labels)'"'!=""|"`e(idtype)'"=="float"))
	sreturn local mlabel `mlabel'
	sreturn local names `names'
	sreturn local options `options'
end

// == Mata FUNCTIONS ==========================================================

version 10
mata:

void _mds_labels2var( string scalar labels, string scalar _svar )
{
	real scalar n
	string colvector labs

	labs = tokens(labels)'
	n = st_nobs()
	if (length(labs) < n)
	n = length(labs)
	
	st_sstore( range(1,n,1), _svar, tokens(labels)' )
}

void _mds_myminmax(string scalar _M, string scalar _result)
{
	real matrix M

	M = st_matrix(_M)
	st_matrix( _result, (colmin(M) \ colmax(M)) )
}

end

exit
