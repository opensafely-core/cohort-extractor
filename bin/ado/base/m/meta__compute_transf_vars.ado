*! version 1.0.0  07jan2020
program define meta__compute_transf_vars
	version 16
	syntax [, eslbl(string) fn(string) touse(string) fnlbl(string) ///
		Level(cilevel)]
	
	// local glbl_eslab : char _dta[_meta_eslabel]
	local glbl_eslab `"`eslbl'"'
	if missing(`"`fnlbl'"') local transformed "transformed"
	else local glbl_eslab ""
	
	cap drop _meta_*_transf
	qui gen double _meta_es_transf = ///
			`=subinstr("`fn'", "@", "_meta_es",.)' if `touse'
	
	
	qui gen double _meta_cil_transf = ///
		`=subinstr("`fn'", "@", "_meta_cil",.)' if `touse'
	qui gen double _meta_ciu_transf = ///
		`=subinstr("`fn'", "@", "_meta_ciu",.)' if `touse'
		
	cap assert _meta_cil_transf <= _meta_ciu_transf
		
	if _rc {
		cap assert _meta_ciu_transf <= _meta_cil_transf
		if _rc {
			drop _meta_*_transf
			di as err "{p}transformation in option " 	///
				  "{bf:transform()} is not a monotone " ///
				  "function{p_end}"
			exit 198 
		}
		else {
			tempvar tmpci
			clonevar `tmpci' = _meta_cil_transf if `touse'
			qui replace _meta_cil_transf = _meta_ciu_transf /// 
				if `touse'
			qui replace _meta_ciu_transf = `tmpci'
			c_local flip flip
		}
	}
	
	
	local es_lbl = ustrlower(`"`transformed' `glbl_eslab'`fnlbl'"')
	local cil_lbl `"`level'% lower CI limit for `es_lbl'"'
	local ciu_lbl "`level'% upper CI limit for `es_lbl'"	
	qui label var _meta_cil_transf `"`: list retokenize cil_lbl'"'
	qui label var _meta_ciu_transf `"`: list retokenize ciu_lbl'"'

	local es_lbl = usubinstr(`"`es_lbl'"', ustrword(`"`es_lbl'"', 1), ///
		ustrtitle(ustrword(`"`es_lbl'"', 1)), .)
	label var _meta_es_transf `"`: list retokenize es_lbl'"'
end
