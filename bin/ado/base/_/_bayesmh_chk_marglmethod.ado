*! version 1.0.0  12mar2015
program _bayesmh_chk_marglmethod
	args method title eresult colon methodopt 

	local 0 , `methodopt' 
	syntax [, LMETropolis HMEAN * ]

	if ("`options'"!="") {
		di as err "option {bf:marglmethod()}: method " ///
			  `"{bf:`options'} not allowed"'
		exit 198
	}
	cap noi opts_exclusive "`lmetropolis' `hmean'"
	if _rc {
		di as err "in option {bf:marglmethod()}"
		exit _rc
	}
	local mllmethod "`lmetropolis'`hmean'"
	if ("`lmetropolis'`hmean'"=="") {
		local mllname "Laplace-Metropolis"
		local mlleresult lml_lm
		local mllmethod "lmetropolis"
	}
	else if `"`lmetropolis'"' == "lmetropolis" {
		local mllname "Laplace-Metropolis"
		local mlleresult lml_lm
	}
	else if `"`hmean'"' == "hmean" {
		local mllname "harmonic-mean"
		local mlleresult lml_h
	}
	c_local `method'  "`mllmethod'"
	c_local `title'   "`mllname'"
	c_local `eresult' "`mlleresult'"
end
