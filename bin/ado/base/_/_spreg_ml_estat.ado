*! version 1.0.1  16jan2017
program _spreg_ml_estat
	local ZERO `0'
	version 15.0
	gettoken subcmd 0 : 0, parse(" ,")
	gettoken subcmd tmp : subcmd, parse(",")

	if (`"`subcmd'"'=="impact") {
		_spivreg_impact `0'
	}
	else if ((`"`subcmd'"'=="ic" |			///
		`"`subcmd'"' == "vce" |			///
		`"`subcmd'"' == "summarize") &		///
		(`"`e(estimator)'"' == "ml")) {
		estat_default `ZERO'
	}
	else if ((`"`subcmd'"' == "vce" |		///
		`"`subcmd'"' == "summarize") &		///
		(`"`e(estimator)'"' =="gs2sls")) {
		estat_default `ZERO'
	}
	else {
		di as error "{bf:estat `subcmd'} not allowed"
		exit 321
	}
end
