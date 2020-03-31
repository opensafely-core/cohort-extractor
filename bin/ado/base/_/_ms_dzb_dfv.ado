*! version 1.0.1  30mar2017
program _ms_dzb_dfv, rclass
	version 15.0

	syntax ,var(string) 	///
		matrix(string)
	
	_ms_parse_parts `var'
	if ("`r(type)'"!="factor") {
		di as err "{bf:varname} should be factor variable"
		exit 498
	}
	local fv 	`r(name)'
	local fv_op	`r(op)'

	
	local xvars	: colnames `matrix'	
	local b_ms	: colfullnames `matrix'
	local k_x	= wordcount(`"`xvars'"')
	tempname b b_init
	matrix `b'	= J(1, `k_x', 0)
	matrix colnames `b' = `b_ms'
	matrix `b_init'	= `matrix'

	forvalues i=1/`k_x' {
		local var : word `i' of `xvars'
		_ms_parse_parts `var'
		local omit	= r(omit)
		if (!`omit' & "`r(type)'"=="factor"){
			local name	`r(name)'
			local op	`r(op)'
			local base = r(base)
			if ("`name'"' == `"`fv'"' & `base') {
				matrix `b'[1, `i']=`b_init'[1, `i']	
			}
			else if (`"`name'"'==`"`fv'"' & `"`op'"'== `"`fv_op'"'){
				matrix `b'[1, `i']=`b_init'[1, `i']	
			}
		}
		else if (!`omit' & `"`r(type)'"'=="interaction"){
			local k_names	= r(k_names)	
			local flag	= 0
			forvalues j=1/`k_names' {
				local name	`r(name`j')'
				local op	`r(op`j')'
				local base = r(base`j')
				if (`"`name'"'==`"`fv'"' & 		///
					`"`op'"'== `"`fv_op'"'	&	///
					`flag'!=1){
					local flag	= 1
					matrix `b'[1, `i']=`b_init'[1, `i']	
				}
				else if (`"`name'"' == `"`fv'"' & 	///
					& `base'	&		///
					`flag'!=1) {
					local flag	= 1
					matrix `b'[1, `i']=`b_init'[1, `i']	
				}
				
			}
		}
	}
	ret matrix b	= `b'
end
