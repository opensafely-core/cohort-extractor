*! version 1.1.2  28jan2015  
program fvset
	version 11

	syntax [anything] [, MI *]

	if "`mi'" == "" {
		u_mi_not_mi_set fvset
	}

	gettoken sub rest : anything
	local len : length local sub
	if "`sub'" == bsubstr("base", 1, max(`len',1)) {
		SetBase `rest', `options'
		exit
	}
	if "`sub'" == bsubstr("design", 1, max(`len',1)) {
		SetDesign `rest', `options'
		exit
	}
	if "`sub'" == "clear" {
		Clear `rest', `options'
		exit
	}
	if inlist("`sub'", "", "report") {
		Report `rest', `options'
		exit
	}

	di as err "unrecognized fvset subcommand"
	exit 199
end

program SetBase
	gettoken base 0 : 0, parse(" ,")
	if `"`base'"' == "," {
		di as err "base specification required"
		exit 198
	}
	BaseSpec base : `base'
	syntax varlist [, MI]
	Set `varlist', base(`base')
end

program SetDesign
	gettoken design 0 : 0, parse(" ,")
	if `"`design'"' == "," {
		di as err "design specification required"
		exit 198
	}
	DesignSpec design : `design'
	syntax varlist [, MI]
	Set `varlist', design(`design')
end

program Clear
	syntax varlist [, MI]
	Set `varlist', clear
end

program Report, rclass
	syntax [varlist] [, Base(string) Design(string) MI]
	BaseSpec base : `base'
	DesignSpec design : `design'

	local w1 1
	local w2 1
	local w3 1
	local nbase 0
	local ndesign 0
	foreach var of local varlist {
		if bsubstr("`:type `var''",1,3) == "str" {
			continue
		}
		local usevar 1
		local bchar : char `var'[_fv_base]
		if `:length local base' {
			local usevar : list bchar == base
		}
		if `usevar' {
			local dchar : char `var'[_fv_design]
			if `:length local design' {
				local usevar : list dchar == design
			}
		}
		if `usevar' {
			local usevar = `"`bchar'`dchar'"' != ""
		}
		if !`usevar' {
			continue
		}
		local vlist `"`vlist' `var'"'
		local len : length local var
		if `len' > `w1' {
			local w1 : copy local len
		}
		local baselist `"`baselist' "`bchar'""'
		local len : length local bchar
		if `len' {
			local ++nbase
			if `len' > `w2' {
				local w2 : copy local len
			}
		}
		local designlist `"`designlist' "`dchar'""'
		local len : length local dchar
		if `len' {
			local ++ndesign
			if `len' > `w3' {
				local w3 : copy local len
			}
		}
	}
	local varlist : copy local vlist
	if !`nbase' {
		local baselist
	}
	if !`ndesign' {
		local designlist
	}
	if `nbase' == 0 & `ndesign' == 0 {
		exit
	}

	Table `varlist',	base(`baselist')	///
				design(`designlist')	///
				widths(`w1' `w2' `w3')

	return local varlist `"`:list retok varlist'"'
	return local baselist `"`:list retok baselist'"'
	return local designlist `"`:list retok designlist'"'
end

program BaseSpec
	_on_colon_parse `0'
	local c_spec `"`s(before)'"'
	local spec `"`s(after)'"'
	capture numlist "`spec'", min(1) max(1) integer range(>=0)
	if !c(rc) {
		c_local `c_spec' `spec'
		exit
	}
	local 0 `", `spec'"'
	capture				///
	syntax [,	First		///
			Last		///
			FREQuent	///
			None		///
			DEFAULT		///
	]
	if c(rc) {
		di as err "invalid base specification"
		exit 198
	}
	local spec `first' `last' `frequent' `none' `default'
	opts_exclusive "`spec'"
	c_local `c_spec' `spec'
end

program DesignSpec
	_on_colon_parse `0'
	local c_spec `"`s(before)'"'
	local 0 `", `s(after)'"'
	capture				///
	syntax [,	ASBALanced	///
			ASOBServed	///
			DEFAULT		///
	]
	if c(rc) {
		di as err "invalid design specification"
		exit 198
	}
	local spec `asbalanced' `asobserved' `default'
	opts_exclusive "`spec'"
	c_local `c_spec' `spec'
end

program Set, rclass
	syntax varlist [, Base(string) Design(string) clear]

	local varlist : list uniq varlist

	local set 0
	if `:length local base' {
		local ++set
	}
	if `:length local design' {
		local ++set
	}

	local DEFAULT default
	local nbase 0
	local ndesign 0
	foreach var of local varlist {
		if bsubstr("`:type `var''",1,3) == "str" {
			local strings `strings' `var'
		}
		else {
			if `:length local clear' {
				char `var'[_fv_base]
				char `var'[_fv_design]
			}
			if `:list base == DEFAULT' {
				char `var'[_fv_base]
			}
			else if `:length local base' {
				char `var'[_fv_base] `base'
			}
			if `:list design == DEFAULT' {
				char `var'[_fv_design]
			}
			else if `:length local design' {
				char `var'[_fv_design] `design'
			}
			local bchar : char `var'[_fv_base]
			if `:length local bchar' {
				local ++nbase
			}
			local dchar : char `var'[_fv_design]
			if `:length local dchar' {
				local ++ndesign
			}
			if `"`bchar'`dchar'"' == "" {
				continue
			}
			local vlist `"`vlist' `var'"'
			local baselist `"`baselist' "`bchar'""'
			local designlist `"`designlist' "`dchar'""'
		}
	}
	local varlist : copy local vlist
	if !`nbase' {
		local baselist
	}
	if !`ndesign' {
		local designlist
	}

	if `:length local strings' & `set' {
		di
		di as txt "{p 0 7 2}Note:  "
		di as txt "The following string variables were ignored."
		di as txt "{break}"
		di as txt "`strings'"
		di as txt "{p_end}"
	}

	if `:list sizeof baselist' == 0 & `:list sizeof designlist' == 0 {
		exit
	}

	return local varlist `"`:list retok varlist'"'
	return local baselist `"`:list retok baselist'"'
	return local designlist `"`:list retok designlist'"'
end

program Table
	syntax [varlist(default=none)],			///
		widths(numlist integer min=3 max=3 >=0)	///
		[,	BASElist(string asis)		///
			DESIGNlist(string asis)		///
		]

	local kvarlist : list sizeof varlist
	if `kvarlist' == 0 {
		exit
	}
	local kbase : list sizeof baselist
	local kdesign : list sizeof designlist
	if `kbase' == 0 & `kdesign' == 0 {
		exit
	}
	gettoken w1 widths : widths
	gettoken w2 w3 : widths
	local w3 : list retok w3
	if `w1' < 8 {
		local w1 8
	}
	if `w2' < 4 {
		local w2 4
	}
	if `w3' < 6 {
		local w3 6
	}
	local W1 = `w1' + 4
	local W2 = `w2' + 4
	local W3 = `w3'

	tempname Tab
	.`Tab' = ._tab.new, columns(3) lmargin(2)
	.`Tab'.width `W1' `W2' `W3'
	.`Tab'.titlefmt %-`w1's %-`w2's %-`w3's
	.`Tab'.strfmt %-`w1's %-`w2's %-`w3's
	.`Tab'.strcolor text result result
	di
	.`Tab'.titles "Variable" "Base" "Design"
	.`Tab'.sep
	forval i = 1/`kvarlist' {
		gettoken var varlist : varlist
		gettoken base baselist : baselist
		gettoken design designlist : designlist
		if `"`base'`design'"' == "" {
			continue
		}
		.`Tab'.row "`var'" "`base'" "`design'"
	}
	.`Tab'.sep
end

exit
