*! version 1.0.0  03dec2019
program _pss_user_init
	version 16
	
	syntax [anything] , pssobj(string) [ * ]

	mata: st_local("cmd", `pssobj'.pss_cmd); ///
              st_local("twosample", strofreal(`pssobj'.twosample))

	if ("`cmd'"=="power") {
		local type "test"
	}
	else {
		local type "ci"
	}
	if (`twosample') {
		local sample "two"
	}
	else {
		local sample "one"
	}
	_pss_syntax SYNOPTS : `sample'`type'
	local 0 , `options'	
	syntax [, `SYNOPTS' * ]

	if ("`type'"=="test") {
		if ("`sample'"=="one") {
			mata: `pssobj'.init(`alpha',"`power'","`beta'","`n'")
		}
		else if ("`sample'"=="two") {
			mata: `pssobj'.init(`alpha',"`power'","`beta'", ///
				            "`n'","`n1'","`n2'","`nratio'")
		}
	}
	else {
		if (`"`width'"'=="") local width .
		if (`"`hwidth'"'=="") local hwidth .
		if ("`sample'"=="one") {
			mata: `pssobj'.init("`level'","`alpha'",`width', ///
					    `hwidth', "`n'")
		}
		else if ("`sample'"=="two") {
			mata: `pssobj'.init("`level'","`alpha'",`width', ///
				      `hwidth',"`n'","`n1'","`n2'","`nratio'")
		}
	}
end
