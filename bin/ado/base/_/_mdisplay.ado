*! version 1.0.3 24Jan2002
program define _mdisplay
	version 8.0
	syntax , Mname(string) [ CSize(string) CFormat(string) /*
		*/ LMarg(integer 0) SPaces(string) /*
		*/ OSPaces(string) Table HLadjust(integer 0)]
		

	if `lmarg' <0 {
		di as error "lmarg must strictly positive "
		exit 198
	}

	tempname mymat 
	mat `mymat' = `mname'

	if "`table'" != "" {
		if "`spaces'" != "" {
			foreach val in `spaces' {
				local tot = `tot' + `val' 
			}	
		}
		else {
				local tot 0
		}		
		foreach cs of local csize {
			local lsize = `lsize' + `cs'
		}	
		local lsize = `lsize' + `lmarg' + `tot' + `hladjust'
	}
	else {
		local star "*"
	}	
	

	local cnames : colnames `mymat'
	local cols =colsof(`mymat')
	local col_ck : word count `cformat'
	local rows = rowsof(`mymat')
	
	if `col_ck' > 0 {
		if `cols' != `col_ck' {
			di as error "formats and columns do not match up"
			exit 198
		}
	}
	else {
	 	forvalues i = 1(1)`cols' {
			local cformat "`cformat' %-9.8g "
			local csize "`csize' 10 "
		}
	}

	local cs0 "0"
	forvalues j = 1(1)`cols' {
		if "`spaces'" != "" {
			local sp`j' : word `j' of `spaces'
		}	
		else {
			local sp`j' 0
		}	

		if "`ospaces'" != "" {
			local osp`j' : word `j' of `ospaces'
		}	
		else {
			local osp`j' 0
		}	

		local jm1 = `j' - 1 

		if `j'==1 {
			local cs_j `lmarg'
			local ocs_j `lmarg'
		}
		else {
			local cs_j : word `jm1' of `csize'
			local ocs_j : word `jm1' of `csize'
		}	
		local cs`j' = `cs_j'+`cs`jm1'' + `sp`j'' 
		local ocs`j' = `cs_j'+`cs`jm1'' + `osp`j'' 

		local fm`j' : word `j' of `cformat'
		local name`j' : word `j' of `cnames'
		local name`j' : subinstr local name`j' "_" " ", all
	}

	forvalues j =1(1)`cols' {
		local disp0 `"`disp0' _col(`cs`j'') "`name`j''" "'
	}

	forvalues i=1(1)`rows' {
		forvalues j =1(1)`cols' {
local disp`i' `"`disp`i'' _col(`ocs`j'') `fm`j'' `mymat'[`i',`j'] "'
		}
	}

	`star' di as txt "{hline `lsize'}"

	di as text `disp0'
	
	`star' di as txt "{hline `lsize'}"

	forvalues i=1(1)`rows' {
		di as result `disp`i'' 
		`star' di as txt "{hline `lsize'}"
	}
end
