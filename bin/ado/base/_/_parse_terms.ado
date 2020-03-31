*! version 1.0.1   13feb2012
*  programmers tool to parse terms specification

program _parse_terms, sclass
	syntax varlist, termvars(string) [ constant(varname) drop ]

	local ng = 0
	local vars `varlist'

	TermLabel `"`termvars'"'
	local term `s(term)'
	local termvars `s(termvars)'

	while(trim("`termvars'") != "") {
		local tlist
		gettoken list termvars: termvars, parse(",")
		if trim("`list'")!="" & trim("`list'")!="," {
			local `++ng'
			if ("`term'"=="") local term _term_`ng'
			local terms `terms' `term'
			local ni = 0
			local 0 `list'
			cap syntax varlist
			if _rc {
				di as err "{p}invalid varlist in terms(): " ///
				 "`list'{p_end}"	
				exit 198
			}
			foreach x of varlist `list' {
				local i = 0
				local k = 0
				foreach v of varlist `vars' {
					local `++i'
					if "`x'" == "`v'" {
						local k = `i'
						continue
					}
				}
				if `k' == 0 {
					if "`drop'" == "" {
/*****************************************************************************/
					noi di as err "{p}invalid terms() " ///
					 "specification; `x' is not an "    ///
					 "independent variable{p_end}"
					exit 198
/*****************************************************************************/
					}
				}
				else {
					local `++ni'
					local ind `ind' `k'
					local X `X' `x'
					local stripe `stripe' `term':`x'
					/* reconstruct terms in case _rmcoll */
					/* dropped some variables	     */
					if ("`drop'"!="") ///
						local tlist `tlist' `x'
				}
			}
			local nind `nind' `ni'
			if "`drop'" != "" {
/*****************************************************************************/
		if "`tlist'"!="" {
			if ("`termlist'"!="") local termlist `termlist', 
			local termlist `termlist' `term'=`tlist'
		}
		else di as txt "{p 0 7 2}note: term " abbrev("`term'",12) ///
				 " dropped{p_end}"
/*****************************************************************************/
			}
		}
		else {
			/* next term */
			TermLabel `"`termvars'"'
			local term `s(term)'
			local termvars `s(termvars)'
		}
	}
			
	local i = 0
	foreach v of varlist `vars' {
		local `++i'
		local found = 0
		if "`X'" != "" {
			foreach x of varlist `X' {
				if "`x'" == "`v'" {
					local found = 1
					continue
				}
			}
		}
		if !`found' {
			local X `X' `v'
			if ("`v'"!="`constant'") local stripe `stripe' `v':`v'
			else local stripe `stripe' _cons:_cons
		}
	}

	sreturn local ng = `ng'
	sreturn local nind `nind'
	sreturn local ind `ind'
	sreturn local terms `terms'
	sreturn local stripe `stripe'
	sreturn local varlist `X'
	if ("`drop'"!="") sreturn local termlist `termlist'
end

program TermLabel, sclass
	args termvars

	gettoken term termvars: termvars, parse("= ")
	gettoken eq termvars: termvars, parse("=")
	if "`eq'" != "=" {
		local termvars `term' `eq' `termvars'
		local term
	}
	
	sreturn local term `term'
	sreturn local termvars `termvars'
end

exit
