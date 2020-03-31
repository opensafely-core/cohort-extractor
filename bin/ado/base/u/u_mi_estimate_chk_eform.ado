*! version 1.0.1  22jan2015
program u_mi_estimate_chk_eform
	version 12

	syntax name(id="command name" name=cmdname) [, * ]

	if (`"`options'"'=="") exit
	if (!inlist("`cmdname'","binreg","streg")) exit

	_eform_`cmdname', `options'
end

program _eform_binreg
	syntax [, OR RR HR RD * ]	

	local binopt
	local bineform
	if ("`or'"!="") {
		local binopt or
		local bineform "eform(Odds Ratio)"
	}
	else if ("`rr'"!="") {
		local binopt rr
		local bineform "eform(Risk Ratio)"
	}
	else if ("`hr'"!="") {
		local binopt hr
		local bineform "eform(HR)"
	}
	else if ("`rd'"!="") {
		local binopt rd
		local bineform "eform(Risk Diff.)"
	}
	_binreg_error "`binopt'" "`bineform'"
end

program _eform_streg
	syntax [, TR * ]
	_streg_error "`tr'" "eform(Time Ratio)"
end

program _binreg_error
	args opt eform

	if ("`opt'"=="") exit

	di as err "{p 0 2 2}{bf:mi estimate: binreg}: option {bf:`opt'}"
	di as err "not allowed;{p_end}"
	di as err "{p 4 4 4}{bf:`opt'} is not allowed with {bf:mi estimate}"
	di as err "because it is {bf:binreg}'s model option.  Use option"
	di as err "{bf:`opt'} with {bf:binreg} and option {bf:`eform'} with"
	di as err "{bf:mi estimate} to get the appropriate exponentiated"
	di as err "coefficients.{p_end}"
	exit 198
end

program _streg_error
	args opt eform

	if ("`opt'"=="") exit

	di as err "{p 0 2 2}{bf:mi estimate: streg}: option {bf:`opt'}"
	di as err "not allowed{p_end}"
        di as err "{p 4 4 4}Use option {bf:`eform'} with {bf:mi estimate} to"
	di as err "get time ratios.  Remember to use option {bf:time} with"
	di as err "{bf:streg} for exponential and Weibull models to fit"
	di as err "the model in the accelerated failure-time metric.{p_end}"
	exit 198
end
