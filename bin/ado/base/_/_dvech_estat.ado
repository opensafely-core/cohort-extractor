*! version 1.0.2  20jan2015
program define _dvech_estat, rclass

	version 11

	if "`e(cmd)'" != "dvech" {
                error 301
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
