*! version 1.0.1  20Jan2015
program define _mgarch_dcc_estat, rclass

	version 11

	if "`e(cmd)'" != "mgarch" {
		if "`e(model)'" != "dcc" {
			error 301
		}
        }

	return clear
	gettoken cmd rest : 0 , parse(",")
	
	local lcmd = length(`"`cmd'"')
	if `"`cmd'"' == bsubstr("summarize",1,max(2,`lcmd')) {
		local 0 `"`rest'"'
		syntax [anything] [, *]
		if `"`anything'"' == "" {
			local vlist "`e(dv_eqs)' `e(indeps)'"
			local vlist : subinstr local vlist ";" "", all
			local vlist : subinstr local vlist "." "", all word
			local vlist : subinstr local vlist "_cons" "", all word
			estat_summ `vlist', `options'
		}
		else {
			estat_summ `anything', `options'
		}
        }
	else {
		estat_default `0'
        }
        return add
end
