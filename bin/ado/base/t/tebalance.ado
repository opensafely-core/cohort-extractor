*! version 1.0.1  30jan2015

program define tebalance, rclass
	version 14.0

	if "`e(cmd)'"!="teffects" & "`e(cmd)'"!="stteffects" {
		di as err "{bf:teffects} or {bf:stteffects} estimation " ///
		 "results not found"
		exit 322
	}
	if "`e(subcmd)'"=="ra" | "`e(subcmd)'"=="wra" {
		di as err "{p}{bf:tebalance} is not allowed after " ///
		 "{bf:teffects `e(subcmd)'}{p_end}"
		exit 322
	}

	gettoken proc rest : 0, parse(" ,")

	local match = ("`e(subcmd)'"=="nnmatch" | "`e(subcmd)'"=="psmatch")
	if `match' {
		/* cannot change estimation sample			*/
		checkestimationsample
	}
	local l = strlen("`proc'")
	if bsubstr("summarize",1,min(9,max(`l',3))) == "`proc'" {
		_tebalance_summarize `rest'
	}
	else if bsubstr("density",1,min(7,max(`l',3))) == "`proc'" {
		_tebalance_density `rest'
	}
	else if "box" == "`proc'" {
		if !`match' {
			di as err "{p}{bf:tebalance box} is not allowed " ///
			 "after {bf:`e(cmd)' `e(subcmd)'}{p_end}"
			exit 322
		}
		_tebalance_boxplot `rest'
	}
	else if bsubstr("overid",1,min(6,max(`l',4))) == "`proc'" {
		if `match' {
			di as err "{p}{bf:tebalance overid} is not allowed " ///
			 "after {bf:`e(cmd)' `e(subcmd)'}{p_end}"
			exit 322
		}
		_tebalance_overid `rest'
	}
	else {
		di as err "{p}{bf:tebalance `proc'} is invalid{p_end}"
		exit 198
	}
	return add
end

exit
