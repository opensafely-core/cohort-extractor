*! version 1.0.2  29jan2015
*  clears all r_* field in e()
program _rotate_clear, eclass
	version 8

	syntax

	foreach m in `:e(macros)' `:e(scalars)' `:e(matrices)' {
		if bsubstr("`m'",1,2) == "r_" {
			local to_drop `to_drop' e(`m')
		}
	}

	if "`to_drop'" != "" {
		mata: Dropthemnow("`to_drop'")
	}
end

mata:
void function Dropthemnow( string scalar _s )
{
	real scalar   i
	string matrix s

	if (_s != "") {
		s = tokens(_s)
		for (i=1; i<=cols(s); i++) {
			st_global(s[i], "")
		}
	}
}
end

exit
