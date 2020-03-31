*! version 1.2.0  25aug2014

program define _parse_initial

	version 14

	/* 
	   Parses the initial values specified in the from() option
	   for commands that use substitutable expressions, such as 
	   -gmm- and -mlexp-.
	   
	   Syntax of from() is
	   
	      parmname [=] # parmname [=] # ...
	      
	   The equals sign is optional.
	   
	   You use this routine AFTER you have parsed the substitutable
	   expression(s) and have created the default initial value 
	   vector (of zeros) and set the column names to be the
	   parameter names.
	
		initial -- whatever the user specified in the
		           initial() option
		parmvec -- the default initial value vector
		params  -- string containing the names of the
		           parameters

	   EG    args `"`initial'"' : `parmvec' `"`params'"'
	
	   This routine modifies the matrix `parmvec' as appropriate.
	
	*/
	
	
	local vn = _caller()
	
	args initial COLON parmvec params

	local np = colsof(`parmvec')
	if `:word count `initial'' == 1 {	/* matrix */
		capture confirm matrix `initial'
		if _rc {
			di as error "matrix `initial' not found"
			exit 480
		}
		if `=colsof(`initial')' != `np' {
			di as err "{p}initial matrix must have as many " ///
			 "columns as parameters in model{p_end}"
			exit 480
		}
		matrix `parmvec' = `initial'
		matrix colnames `parmvec' = `params'
	}
	else {				/* Must be <parm> [=] # ... */
		tokenize `initial', parse(" =")
		while "`*'" != "" {
			capture local col = colnumb(`parmvec', "`1'")
			local rc = _rc
			if `rc' | missing(`col') {
				if `vn' >= 14 {
					if !strpos("`1'",":") {
						local name `1'
						local 1 `name':_cons
						cap local col =            ///
							colnumb(`parmvec', ///
							"`1'")
						local rc = _rc
						if `rc' | missing(`col') {
							local 1 `name'
						}
					}
				}
			}	
			if `rc' | missing(`col') {
				di as err "invalid parameter `1' in from()"
				exit 480
			}
			if "`2'" == "=" {
				matrix `parmvec'[1, `col'] = `3'
				local shift 3
			}
			else {
				matrix `parmvec'[1, `col'] = `2'
				local shift 2
			}
			mac shift `shift'
		}
	}
end
exit
