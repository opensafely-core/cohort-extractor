*! version 2.0.2  11mar2011

/*
	u_mi_xeq_on_tmp_flongsep [, nopreserve]: <command>

	Execute <command> on the data in memory, said data converted 
	to flongsep format, and then convert the flongsep result back to 
	the original style.

	If the data already are flongsep, a temporary copy is made and 
	later, posted.

	This routine handles issues of preserving the data in memory 
	in case of failure unless nopreserve is specified

	It is your responsibility to have already ensured the data 
	are proper.
*/

program u_mi_xeq_on_tmp_flongsep, rclass
	local version : di "version " string(_caller()) ":"
	version 11

	mata: _parse_colon("hascolon", "cmd")

	syntax [, noPREserve noREStore]

	u_mi_get_flongsep_tmpname newname : __mitmpfile
	local style "`_dta[_mi_style]'"
	local filename "`c(filename)'"
	local changed = c(changed)

	/* ------------------------------------------------------------ */
	if ("`style'"=="flongsep") { 
		local name "`_dta[_mi_name]'"
		quietly {
			if ("`preserve'"=="") {
				save "`_dta[_mi_name]'", replace
			}
			my_copy `newname'
		}
	}
	else {
		if ("`preserve'"=="") {
			preserve
			local cancel "restore, not"
		}
		qui mi convert flongsep `newname', replace clear noupdate
	}
	/* ------------------------------------------------------------ */
	ret clear
	capture noisily `version' `cmd'
	ret add
	local changed = `changed' | c(changed)
	/* ------------------------------------------------------------ */
	nobreak {
		local rc = _rc 
		/* ---------------------------------------------------- */
		if (`rc'==0) { 
			if ("`style'"=="flongsep") { 
				capture noi qui my_copy_back `name' 
				local rc = _rc
			}
			else {
				capture noi qui mi convert `style', ///
						replace clear /* noupdate */
				local rc = _rc
				if (`rc'==0) {
					`cancel'
					global S_FN "`filename'"
				}
			}
		}
		if (`rc') {
			if ("`style'"=="flongsep") { 
				if ("`preserve'"=="") { 
					capture use "`name'", clear
					if (_rc) { 
						drop _all
					}
				}
			}
		}
		/* ---------------------------------------------------- */
		mata: u_mi_flongsep_erase("`newname'", 0, 0)
		mata: (void) st_updata(`changed')
	}
	/* ------------------------------------------------------------ */
	exit `rc'
end


program my_copy
	args name 

	local M 	`_dta[_mi_M]'
	local oldname 	`_dta[_mi_name]'

	nobreak {
		quietly {
			char _dta[_mi_name] `name'
			save `name', replace

			forvalues m=1(1)`M' {
				use _`m'_`oldname', clear 
				char _dta[_mi_name] `name'
				save _`m'_`name', replace
			}
			use `name', clear 
		}
	}
end

/*
	my_copyback is currently identical to my_copy
	It is that way in case we want to change something about 
	one or the other copies.
*/

program my_copy_back
	args name

	local M 	`_dta[_mi_M]'
	local oldname 	`_dta[_mi_name]'

	nobreak {
		quietly {
			char _dta[_mi_name] `name'
			save `name', replace

			forvalues m=1(1)`M' {
				use _`m'_`oldname', clear 
				char _dta[_mi_name] `name'
				save _`m'_`name', replace
			}
			use `name', clear 
		}
	}
end
