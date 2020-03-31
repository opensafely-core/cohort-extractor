*! version 1.0.3   12apr2017
program _spivreg_estat
	local ZERO `0'
	version 15.0
	gettoken subcmd 0 : 0, parse(" ,")
	gettoken subcmd tmp : subcmd, parse(",")

	if (`"`subcmd'"'=="impact") {
		_spivreg_impact `0'
	}
	else if ((`"`subcmd'"'=="ic" |			///
		`"`subcmd'"' == "vce" ) &		///
		(`"`e(estimator)'"' == "ml")) {
		estat_default `ZERO'
	}
	else if ((`"`subcmd'"' == "vce" ) &		///
		(`"`e(estimator)'"' =="gs2sls")) {
		estat_default `ZERO'
	}
	else if (`"`subcmd'"' == "summarize" ) {
		_sp_estat_summarize `ZERO'
	}
	else {
		di as error "{bf:estat `subcmd'} not allowed"
		exit 321
	}
end
