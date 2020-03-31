*! version 3.1.9  14dec1998
program define fit, eclass
	version 6
	local options `"Level(integer $S_level) Beta"'
	if replay() {
		if `"`e(cmd)'"'~=`"fit"' { 
			error 301
		}
		syntax [, `options']
	}
	else { 
		syntax varlist [if] [in] [aweight fweight] [, `options' *]
		cap noi qui reg `varlist' `if' `in' [`weight'`exp'], `options'
		if _rc { 
			if _rc==1 { exit 1 }
			reg `varlist' `if' `in' [`weight'`exp'], `options'
			/*NOTREACHED*/
			exit _rc 
		}
		capture local check = _b[_cons]
		if _rc { 
			di in red `"may not drop constant"'
			exit 399
		}
		tokenize `varlist'
		local i 2
		while `"``i''"'!=`""' { 
			if _b[``i'']==0 { 
				local `i' `" "' 
			}
			local i=`i'+1
		}

		est local wtype `"`weight'"'
		est local wexp  `"`exp'"'
		if 1 /* _caller()<6 */ {
			global S_E_vl `"`*'"'
			global S_E_if `"`if'"'
			global S_E_in `"`in'"'
			global S_E_wgt `"`weight'"'
			global S_E_exp `"`exp'"'
			global S_E_cmd `"fit"'
		}
		est local cmd "fit"
	}
	if `level'<10 | `level'>99 {
		local level 95
	}
	regress, level(`level') `beta'
end
