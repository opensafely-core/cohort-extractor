*! version 1.2.0  10apr2013
program _svy_ivreg_first
	version 9
        local version : di "version " string(_caller()) ":"
	syntax [, * ]
	local instd `e(instd)'
	local insts `e(insts)'

	di
	di as txt "First-stage regression"
	di as txt "{hline 23}"

	capture local xx = _b[_cons]
	if (c(rc)) local nocons noconstant

nobreak {

capture noisily break {

	tempvar doit
	quietly gen byte `doit' = e(sample)
	if `"`e(subpop)'"' != "" {
		local subopt `"subpop(`e(subpop)')"'
	}
	tempname results
	_est hold `results', restore
	foreach y of local instd {
		`version' svy linearized, `options' `subopt': ///
			regress `y' `insts' if `doit', `nocons'
	}

} // capture noisily break

	local rc = c(rc)
	_est unhold `results'

} // nobreak

	di
	exit `rc'
end
exit
