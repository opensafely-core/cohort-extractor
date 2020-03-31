*! version 1.0.2  12apr2017
// estat impact after spxtreg

program _spxtreg_estat
	local ZERO `0'
	version 15.0
	gettoken subcmd 0 : 0, parse(" ,")
	gettoken subcmd tmp : subcmd, parse(",")
	if (`"`subcmd'"'=="impact") {
		_spxtreg_impact `0'
	}
	else if (`"`subcmd'"'=="ic" |	///
		`"`subcmd'"' == "vce" ) {
		estat_default `ZERO'
	}
	else if (`"`subcmd'"'=="summarize") {
		_sp_estat_summarize `ZERO'
	}
	else {
		di as error "{bf:estat `subcmd'} not allowed"
		exit 321
	}
end
