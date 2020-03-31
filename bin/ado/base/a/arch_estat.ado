*! version 1.1.1  20jan2015
program arch_estat, rclass
	version 9

	if "`e(cmd)'" != "arch" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
		ArchSumm `rest'
	}
	else {
		estat_default `0'
	}

	return add
end

program ArchSumm, rclass
	// handle the varlist since some non varnames on the e(b) matrix stripe

	syntax [anything(name=eqlist)] [, *]

	if "`eqlist'" == "" {
		local eqlist "(depvar:`e(depvar)')"
		local token : rowfullnames e(V)

		gettoken next token : token
		while (index("`next'","ARCH") != 1 & ///
		       index("`next'","ARMA") != 1 & ///
		       index("`next'","SIGMA2") != 1) {
			if index("`next'",":_cons") != length("`next'") - 5 {
				local eqlist "`eqlist' (`next')"
			}
			gettoken next token : token
		}
	}

	estat_summ `eqlist', `options'

	return add
end
