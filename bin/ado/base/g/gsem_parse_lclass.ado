*! version 1.0.0  05feb2017
* NOTE: This program is a subroutine of -gsem_parse- and -gsem_lcspecs-.
program gsem_parse_lclass
	version 15
	syntax [, LCLASS(string) *]
	while "`lclass'" != "" {
		LClass `lclass'
		local lcvars `lcvars' `s(var)'
		local lcnlevs `lcnlevs' `s(nlevs)'
		local lcbases `lcbases' `s(base)'

		local 0 `", `options'"'
		syntax [, LCLASS(string) *]
	}

	c_local lcvars	`lcvars'
	c_local lcnlevs	`lcnlevs'
	c_local lcbases	`lcbases'
	c_local options	`"`options'"'
end

program LClass, sclass
	local syntax anything(id="latent class variable") [, base(int 1)]
	capture syntax `syntax'
	if c(rc) | `:list sizeof anything' > 2 {
		di as err "invalid {bf:lclass()} option"
		syntax `syntax'
		exit 198
	}
	gettoken var nlevs : anything
	local nlevs : list retok nlevs

	capture confirm name `var'
	if c(rc) {
		di as err "invalid {bf:lclass()} option;"
		if "`var'" == "" {
			local FOUND "nothing"
		}
		else {
			local FOUND "'`var''"
		}
		di as err "`FOUND' found where name expected"
		exit 198
	}

	capture {
		confirm integer number `nlevs'
		assert `nlevs' > 0
	}
	if c(rc) {
		di as err "invalid {bf:lclass()} option;"
		if "`nlevs'" == "" {
			local FOUND "nothing"
		}
		else {
			local FOUND "'`nlevs''"
		}
		di as err "`FOUND' found where positive integer expected"
		exit 198
	}
	if `base' < 1 | `base' > `nlevs' {
		di as err "invalid {bf:lclass()} option;"
		di as err "base level must be between 1 and `nlevs'"
		exit 198
	}

	sreturn local var	"`var'"
	sreturn local nlevs	"`nlevs'"
	sreturn local base	"`base'"
end

exit
