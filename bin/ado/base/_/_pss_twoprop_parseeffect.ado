*! version 1.0.0  07may2013
program _pss_twoprop_parseeffect
	args effect colon effspec nargs diff rdiff ratio rrisk oratio

	if (`"`effspec'"'=="") {
		if (`nargs'==2) {
			c_local `effect' diff
			exit
		}
		if (`nargs'==1) {
			if (`"`rrisk'"'!="") {
				c_local `effect' rrisk
				exit
			}
			if (`"`rdiff'"'!="") {
				c_local `effect' rdiff
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

	cap syntax [, diff ratio RDiff RRisk ORatio ]
	if (_rc) {
		di as err "{p}{bf:effect()} may contain only one of "
		di as err "{bf:oratio}, {bf:diff}, {bf:ratio}, {bf:rdiff}, or "
		di as err "{bf:rrisk}{p_end}"
		exit 198
	}
	local opts "`diff' `rdiff' `ratio' `rrisk' `oratio'"
	if (`: list sizeof opts'>1) {
		di as err "{p}{bf:effect()} may contain only one of "
		di as err "{bf:oratio}, {bf:diff}, {bf:ratio}, {bf:rdiff}, or "
		di as err "{bf:rrisk}{p_end}"
		exit 198
	}
	c_local `effect' "`diff'`ratio'`rdiff'`rrisk'`oratio'"
end
