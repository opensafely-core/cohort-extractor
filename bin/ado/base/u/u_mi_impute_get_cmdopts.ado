*! version 1.0.0  30jun2009

program u_mi_impute_get_cmdopts, sclass
	version 11.0
	args method

	_get_mi_impute_`method'_opts
end

program _get_mi_impute_regress_opts, sclass
	sret local opts "NOIsily NOCONStant "
end

program _get_mi_impute_pmm_opts, sclass
	sret local opts "NOIsily NOCONStant KNN(string) PMTOLerance(string) "
end

program _get_mi_impute_logit_opts, sclass
	_maxopts
	sret local opts "NOIsily NOCONStant OFFset(varname) ASIS `s(maxopts)'"
end

program _get_mi_impute_ologit_opts, sclass
	_maxopts
	sret local opts "NOIsily OFFset(varname) `s(maxopts)'"
end

program _get_mi_impute_mlogit_opts, sclass
	_maxopts
	sret local opts "NOIsily NOCONStant Baseoutcome(passthru) `s(maxopts)'"
end

program _get_mi_impute_poisson_opts, sclass
	_maxopts
	sret local opts "NOIsily NOCONStant OFFset(varname) Exposure(varname) `s(maxopts)'"
end

program _get_mi_impute_monotone_opts, sclass
	sret local opts  "NOIsily REPORT DRYRUN VERBOSE Custom NOLEGend"
end

program _get_mi_impute_mvn_opts, sclass
	local opts  NOIsily NOCONStant BURNin(integer 100) NOLOG
	local opts `opts' BURNBetween(integer 100) PRIor(string) 
	local opts `opts' INITMcmc(string) EMONLY EMONLY1(string)
	local opts `opts' MCMCONLY SAVEWlf(string asis) SAVEPtrace(string asis)
	local opts `opts' EMLOG EMOUTput IMPLOG ALLDOTS WLFWGT(string)
	local opts `opts' SHOWITER SHOWITER1(numlist)
	local opts `opts' *
	sret local opts  "`opts'"
end

program _maxopts, sclass
	local maxopts DIFficult TECHnique(passthru) ITERate(passthru)
	local maxopts `maxopts' LOG NOLOG TRace GRADient SHOWSTEP
	local maxopts `maxopts' HESSian SHOWTOLerance TOLerance(passthru) 
	local maxopts `maxopts' LTOLerance(passthru) GTOLerance(passthru)
	local maxopts `maxopts' NRTOLerance(passthru) NONRTOLerance
	local maxopts `maxopts' FROM(passthru)

	sret local maxopts `maxopts'
end
