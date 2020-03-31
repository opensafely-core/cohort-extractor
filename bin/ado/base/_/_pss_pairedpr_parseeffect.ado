*! version 1.0.0  20may2013
program _pss_pairedpr_parseeffect
	args effect colon effspec nargs diff ratio rrisk oratio corr solvefor 

	if (`"`effspec'"'=="") {
		if (`nargs'==2) {
			c_local `effect' diff
			exit
		}
		if (`nargs'==0) {
			if ("`solvefor'"=="esize") c_local `effect' diff
			else c_local `effect' diff
			exit
		}
		if (`nargs'==1) {
			if (`"`rrisk'"'!="") {
				c_local `effect' rrisk
				exit
			}
			if (`"`oratio'"'!="") {
				c_local `effect' oratio
				exit
			}
			if (`"`diff'"'!="") {
				c_local `effect' diff
				exit
			}
			if (`"`ratio'"'!="") {
				c_local `effect' ratio
				exit
			}
			c_local `effect' diff
			exit
		}
	}

	local 0 , `effspec'

	cap syntax [, diff ratio RRisk ORatio ]
	if (_rc) {
		di as err "{p}{bf:effect()} may contain only one of "
		di as err "{bf:oratio}, {bf:diff}, {bf:ratio}, or "
		di as err "{bf:rrisk}{p_end}"
		exit 198
	}
	local opts "`diff' `ratio' `rrisk' `oratio'"
	if (`: list sizeof opts'>1) {
		di as err "{p}{bf:effect()} may contain only one of "
		di as err "{bf:oratio}, {bf:diff}, {bf:ratio}, or "
		di as err "{bf:rrisk}{p_end}"
		exit 198
	}

	if (`"`corr'"'=="") {
		if (`"`oratio'"'!="") {
			di as err "{p}{bf:effect(oratio)} is not allowed "
			di as err "when discordant proportions "
			di as err "are specified{p_end}"
			exit 198
		}
		if (`"`rrisk'"'!="") {
			di as err "{p}{bf:effect(rrisk)} is not allowed "
			di as err "when discordant proportions "
			di as err "are specified{p_end}"
			exit 198
		}
	}

	c_local `effect' "`diff'`ratio'`rrisk'`oratio'"
end
