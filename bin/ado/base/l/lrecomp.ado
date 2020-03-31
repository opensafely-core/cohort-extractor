*! version 1.0.1  13sep2000
program define lrecomp
	version 6
	tempname lre min

	scalar `min' = 100
	if "`3'" != "" {
		di
	}
	local col 20
	local i 1
	while `"``i''"'!="" {
		if `"``i''"' != "()" {
			local x `"``i''"'
			local i = `i' + 1
			if `"``i''"'=="" {
				di in red "comparison value not found"
				exit 198
			}
			local c `"``i''"'

			if (`x') == (`c') {
				di in gr "`x'" in ye _col(`col') /*
				*/ "<exactly equal>"
				scalar `min' = min(`min',15)
			}
			else if (`x')==. {
				di in gr "`x'" in ye _col(`col') "<missing>"
				scalar `min' = 0 
			}
			else {
				if (`c') == 0 {
					scalar `lre' = max(0, /*
					*/ -log10(abs((`x')-(`c'))))
				}
				else {
					scalar `lre' = max(0, /*
					*/ -log10(abs(((`x')-(`c'))/(`c'))))
				}
				di in gr "`x'" in ye _col(`col') %5.1f `lre'
				scalar `min' = min(`min', `lre')
			}
		}
		else {
			di in smcl in gr "{hline `col'}{hline 5}"
			di in gr "min" _col(`col') in ye %5.1f `min'
			di
			scalar `min' = 100
		}
		local i = `i' + 1
	}
end
