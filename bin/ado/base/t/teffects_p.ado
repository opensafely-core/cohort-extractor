*! version 1.0.0  20dec2012

program define teffects_p
	version 13

	if "`e(cmd)'" != "teffects" {
		di as err "{help teffects##|_new:teffects} estimation " ///
		 "results not found"
		exit 301
	}
	if "`e(subcmd)'" == "nnmatch" {
		_teffects_match_p `0'
	}
	else if "`e(subcmd)'" == "psmatch" {
		_teffects_match_p `0'
	}
	else if "`e(subcmd)'"=="ra" {
		_teffects_ra_p `0'
	}
	else if "`e(subcmd)'"=="ipw" {
		_teffects_ipw_p `0'
	}
	else if "`e(subcmd)'"=="ipwra" {
		_teffects_ipwra_p `0'
	}
	else if "`e(subcmd)'"=="aipw" {
		_teffects_ipwra_p `0'
	}
	else {
		di as err "{help teffects##|_new:teffects} estimation " ///
		 "results not found"
		exit 301
	}
end
exit
