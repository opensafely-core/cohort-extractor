*! version 1.0.0  03feb2017
program _sp_xtstrbal
	syntax , panelvar(string)	///
		timevar(string)		///
		touse(string) 

	_xtstrbal `panelvar' `timevar' `touse'
	local strbal `r(strbal)'

	if (`"`strbal'"'=="no") {
		di as err "data are not strongly balanced"
		exit 459
	}
end
