*! version 1.1.5  06jan2020
program _get_eformopts, sclass
	version 8.0
	syntax [, eformopts(string asis) soptions ALLOWed(string) ]
	local 0 , `eformopts'

	// hold all other options in `opts'
	// NOTE: additions to 'EFALL' should also be made in
	// _check_eformopts.ado
	local EFALL NOHR hr NOSHR shr or IRr RRr tr TRatio
	if "`soptions'" != "" {
		syntax [, EForm1(passthru) EForm `EFALL' * ]
		local opts `"`options'"'
		local 0 , `eform1' `eform' `nohr' `hr' `noshr' `shr' ///
			  `or' `irr' `rrr' `tr' `tratio'
	}

	if "`allowed'" == "__all__" {
		local allowed `EFALL'
	}
	foreach ef of local allowed {
		capture confirm name `ef'
		if _rc {
			di as err "`ef' is not a valid name"
			exit 198
		}
		local efopts `efopts' `=lower("`ef'")'
	}
	local efopts : list uniq efopts
	syntax [, EForm1(string) EForm `allowed' ]

	foreach ef of local efopts {
		local eform `eform' ``ef''
	}
	
	     if `"`eform1'"'=="Odds Ratio" local eform_cons_ti = "Odds"
	else if `"`eform1'"'=="Haz. Ratio" local eform_cons_ti="Hazard"
	else if `"`eform1'"'=="Time Ratio" local eform_cons_ti = "Time"
	else if `"`eform1'"'=="IRR" local eform_cons_ti = "Inc. Rate"
	else if `"`eform1'"'=="Risk Ratio" local eform_cons_ti = "Risk"
	else if `"`eform1'"'=="Hlth Ratio" local eform_cons_ti="Health"
		
	local k : list sizeof eform
	if `k' {
		opts_exclusive "`eform'"
		if `:length local eform1' {
			opts_exclusive "eform() `eform'"
		}
	}
	if `k' {
		if ("`eform'"=="eform") local eform1 = "exp(b)"
		else if ("`eform'"=="hr")	{
			local eform1 = "Haz. Ratio"
			local eform_cons_ti = "Hazard"
		}	
		else if ("`eform'"=="shr")	{
			local eform1 = "SHR"
			local eform_cons_ti = "Subhazard"
		}	
		else if ("`eform'"=="tr")	{
			local eform1 = "Time Ratio"
			local eform_cons_ti = "Time"
		}	
		else if ("`eform'"=="tratio")	{
			local eform1 = "Time Ratio"
			local eform_cons_ti = "Time"
		}
		else if ("`eform'"=="or")	{
			local eform1 = "Odds Ratio"
                        if ("`e(cmd)'"=="asclogit"      | ///
                            "`e(cmd)'"=="cmclogit"      | ///
                            "`e(cmd)'"=="cmmixlogit"    | ///
                            "`e(cmd)'"=="cmxtmixlogit" ) {
                                local eform_cons_ti = "Rel. Risk"
                        }
                        else {
                                local eform_cons_ti = "Odds"
                        }
		}
		else if ("`eform'"=="irr")	{
			local eform1 = "IRR"
			local eform_cons_ti = "Inc. Rate"
		}
		else if ("`eform'"=="rrr")	{
			local eform1 = "RRR"
			local eform_cons_ti = "Rel. Risk"
		}	
		else if ("`eform'"!="nohr") & ("`eform'"!="noshr") {
			local eform1 = upper("`eform'")
		}
	}
	sreturn clear
	sreturn local options `"`opts'"'
	sreturn local opt `eform'
	sreturn local str `eform1'
	if `"`eform1'"' != "" {
		sreturn local eform eform(`"`eform1'"')
	}
	else	sreturn local eform ""
	sreturn local eform_cons_ti `eform_cons_ti' 
end

exit
