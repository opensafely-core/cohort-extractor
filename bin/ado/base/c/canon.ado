*! version 1.1.0  01may2009
program define canon, eclass byable(onecall)
	version 10.1 
	local caller= _caller()

	syntax [anything(everything)] [aw fw] [, STDCoef COEFMatrix STDErr *]
	local cmdline `0'

	if !replay() {
		if "`weight'" != "" {
			local wei [`weight'`exp']
		}
	}
	if _by() {
		local by "by `_byvars' :"
	}
	if `caller' <= 10 { 
		version `caller': `by' _canon `anything' `wei', `stdcoef' `coefmatrix' `options'
	}
	else {
		if "`stderr'" != "" {
			if "`coefmatrix'`stdcoef'" != "" {
				di as err "stderr may not be specified " ///
					"with coefmatrix or stdcoef"
				exit 198
			}
		}
		else if "`stdcoef'" != "" {
			if "`coefmatrix'" != "" {
				di as err "stdcoef and coefmatrix may not " ///
					"be specified together"
				exit 198
			}
		}
		else {	
			local coefmatrix coefmatrix
		}		
		version `caller': `by' _canon `anything' `wei', `coefmatrix' `stdcoef' `options'
	}
	ereturn local marginsnotok _ALL
	eret local cmdline canon `cmdline'
	_post_vce_rank
end
