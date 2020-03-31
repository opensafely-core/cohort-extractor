*! version 1.0.1  01jun2013
program test_syntax_wrk_dlg
	version 12
	args syntax dlgname

	local eqnames_value ///
		`"`.`dlgname'.main.cb_eqnames.value':"'
	local len = length("`eqnames_value'")
	local eqnames_ivars_list_name ///
		`"`.`dlgname'.main.cb_eqnames_ivars.contents'"'
	local ivars_list_name ///
		`"`.`dlgname'.main.cb_ivars.contents'"'
	local coeff_list_name ///
		`"`.`dlgname'.main.cb_coef.contents'"'

	local max `.`dlgname'.`eqnames_ivars_list_name'.arrnels'
	if ("`max'" == "") {
		exit
	}
	`.`dlgname'.`coeff_list_name'.Arrdropall'
	if (`syntax' == 3) {
		local j = 1
		forvalues i = 1/`max' {
			local eqnames_ivars_list_value			///
				"`.`dlgname'.`eqnames_ivars_list_name'[`i']'" 
			local eqname =					///
				substr("`eqnames_ivars_list_value'", 1, `len')
			if "`eqname'" == "`eqnames_value'" {
				.`dlgname'.`coeff_list_name'[`j'] =	///
subinstr("`.`dlgname'.`eqnames_ivars_list_name'[`i']'", "`eqname'", "", 1)
				local ++j
			}
		}
	}
	if (`syntax' == 4) {
		forvalues i = 1/`max' {
			local ivars_list_value				///
				"`.`dlgname'.`ivars_list_name'[`i']'" 
			local ivars_str "`ivars_str' `ivars_list_value'"
		}
		local dups : list dups ivars_str
		local uniq : list uniq dups

		local eqlist `"`.`dlgname'.main.ed_eqlist.value'"'
		local list : subinstr local eqlist "=" "", all
		local j = 1
		foreach coef of local uniq {
			local add = 1
			foreach eqname of local list {
				local eqname_ivar "`eqname':`coef'"
local find = `.`dlgname'.`eqnames_ivars_list_name'.arrindexof "`eqname_ivar'"'
				if `find' == 0 {
					local add = 0 
					break
				}
			}
			if `add' == 1 {
				.`dlgname'.`coeff_list_name'[`j'] = "`coef'"
				local ++j
			}
		}
	}
end


