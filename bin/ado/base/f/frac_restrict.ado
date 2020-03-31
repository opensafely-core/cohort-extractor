*! version 1.0.0  18jan2007
program frac_restrict
	version 9.2
	capture syntax varlist [if/]
	if c(rc) {
		di as err "invalid restrict() option"
		exit 198
	}
	gettoken touse restrict : varlist
	if `:list sizeof restrict' > 1 {
		di as err "invalid restrict() option"
		exit 103
	}
	if "`restrict'" == "" {
		local restrict (`if')
	}
	else {
		markout `touse' `restrict'
		if "`if'" != "" {
			local restrict (`restrict' & (`if'))
		}
	}
	replace `touse' = 0 if !`restrict'
	quietly count if `touse'
	if r(N) == 0 {
		error 2000
	}
end
exit
