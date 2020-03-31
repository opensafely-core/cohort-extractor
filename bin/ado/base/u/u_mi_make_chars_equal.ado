*! version 1.1.0  09jun2011

/*
	u_mi_make_chars_equal

	Make characteristics the same across variables (and datasets 
	in flongsep case)
*/

program u_mi_make_chars_equal
	version 11

	make_chars_equal_`_dta[_mi_style]'
end

program make_chars_equal_wide
	mata: make_chars_equal_wide(`_dta[_mi_M]')
end

program make_char_equal_mlong
	exit
end

program make_char_equal_flong
	exit
end

program make_chars_equal_flongsep
	local M    `_dta[_mi_M]'
	local name `_dta[_mi_name]'
	if (`M'==0) {
		exit
	}
	local var
	capture noisily {
		mata: u_mi_get_mata_instanced_var("var", "_mi_chars")
		mata: u_mi_cpchars_get(`var')
		qui save `name', replace
		forvalues m=1(1)`M' {
			qui use _`m'_`name'
			mata: u_mi_cpchars_put(`var', 2)
			qui save _`m'_`name', replace
		}
		qui use `name'
	}
	nobreak {
		local rc = _rc
		capture mata: mata drop `var'
	}
	exit `rc'
end


version 11

mata:
void make_chars_equal_wide(real scalar M)
{
	real scalar		i, j, m, N
	string scalar		varname
	string rowvector	vars
	string colvector	ch_names, ch_cnts
	string colvector	names_to_kill

	if (M==0) return
	vars = tokens( st_global("_dta[_mi_ivars]") + " " + 
		       st_global("_dta[_mi_pvars]") )

	for (i=1; i<=cols(vars); i++) {
		ch_names = st_dir("char", vars[i], "*")
		ch_cnts  = J(N=rows(ch_names), 1, "")
		for (j=1; j<=N; j++) {
			ch_cnts[j] = st_global(
					sprintf("%s[%s]", vars[i], ch_names[j]))
		}
		for (m=1; m<=M; m++) { 
			varname = sprintf("_%g_%s", m, vars[i])
			names_to_kill = st_dir("char", varname, "*")
			for (j=1; j<=rows(names_to_kill); j++) {
				st_global(
				   sprintf("%s[%s]", varname, names_to_kill[j]),
				   "")
			}
			for (j=1; j<=N; j++) {
				st_global(
				    sprintf("%s[%s]", varname, ch_names[j]),
				    ch_cnts[j])
			}
		}
	}
}
end
