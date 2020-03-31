*! version 1.1.1  20jan2015
program mlexp_estat
	version 12
	
	if "`e(cmd)'" != "mlexp" {
		exit 301
	}
	
	gettoken sub rest: 0, parse(" ,")

	local lsub = length("`sub'")
	if "`sub'" == bsubstr("summarize",1,max(2,`lsub')) {
		mlexp_summ `rest'
	}
	else estat_default `0'
end

program mlexp_summ

	if "`e(rhs)'" == "" {
		di in smcl as error ///
"must specify {opt variables()} with {cmd:mlexp} in order " _c
		di in smcl as error "to use {cmd:estat summarize} afterwards"
		exit 321
	}
	
	estat_summ `e(rhs)' `0'

end

