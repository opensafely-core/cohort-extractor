*! version 1.0.1  20jan2015
program mvreg_estat, rclass
	version 9

	if "`e(cmd)'" != "mvreg" {
		dis as err "mvreg estimation results not found"
		exit 301
	}

	gettoken key args : 0, parse(" ,")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
		// override default handler
		Summarize `args'
	}	
	else {
		estat_default `0'
	}
	return add
end


program Summarize
	syntax [anything(name=vlist)] [, EQuation *]

	if `"`vlist'`equation'"' != "" {
		estat_summ `0'
		exit
	}

	local ylist `e(depvar)'
	local xlist : colnames e(b)
	local xlist : list uniq xlist
	local xlist : subinstr local xlist "_cons" "", word all
	estat_summ (yvars : `ylist') (xvars : `xlist') , `options' 
end

exit
