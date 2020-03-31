*! version 1.1.0  10apr2007

/* Either DIALOGCLSname or DIALOGname must be specified. DIALOGCLSname is now
 * the preferred method as it makes no assumptions about the underlying
 * class name of the dialog. DIALOGname should only be specified in old code.
 */

program define _get_irf

	version 9
	
	syntax , CONTROLnames(string)					///
		[	DIALOGCLSname(string) DIALOGname(string)	///
			IRFVALues(string) IRFAPPENDS BUSYflag(string) 	///
		]

	if `"`dialogclsname'"' == "" & `"`dialogname'"' == "" {
		exit 198
	}

	local irffile `"$S_vrffile"'

	if `"`irffile'"' != "" {
		preserve
		use `"`irffile'"' , clear

		// get a list of irf names
		local irflist : char _dta[irfnames]		
	}	
	
	if `"`dialogclsname'"' != "" {
		local dialog ".`dialogclsname'"
	}
	else {
		local dialog ".`dialogname'_dlg"
	}
	
	if "`.`dialog'.isa'" != "class" {
		display "`dialog'"  `.`dialog'.isa'"
		display as error "Invalid dialog name specified"
		exit 198
	}
	
	if "``dialog'.`busyflag'.classname'" == "d_boolean" {
		`dialog'.`busyflag'.settrue
	}
	
	if "`irfappends'" == "" { // non appendable irfname control
		// add the names to the dialog controls
		local n : word count `controlnames'
		forvalues i = 1/`n' {
			local control : word `i' of `controlnames'
			local irfvalue : word `i' of `irfvalues'
			.list = .dynamic_list_control.new, dlgclsname(`dialog') control(`control')
			.list.setList, newlist("`irflist'") value("`irfvalue'")
		}
	}
	else {
		// single appendable irfname control
		foreach control of local controlnames {
			.list = .dynamic_list_control.new, dlgclsname(`dialog') control(`control')
			.list.setList, newlist("`irflist'") value("`irfvalues'")
		}
	}
	
	// Create an instance of an irf_result_list and attach it to the dialog
	local type "``dialog'.irfListi.isa'"
	local type "``dialog'.irfListr.isa'"
	if "`type'" == "" {
		`dialog'.Declare .irfListi = .irf_result_list.new 	
		`dialog'.Declare .irfListr = .irf_result_list.new 	
	}
	`dialog'.irfListi.clear
	`dialog'.irfListr.clear
	
	foreach irf of local irflist {
		local vars : char _dta[`irf'_order]
		local evar : char _dta[`irf'_exog]
		`dialog'.irfListr.addIrfResult, irfname(`irf') irfvars("`vars'")
		if "`evar'" != "none" {
			`dialog'.irfListi.addIrfResult, irfname(`irf') irfvars("`vars' `evar'")
		}
		else {
			`dialog'.irfListi.addIrfResult, irfname(`irf') irfvars("`vars'")
		}	
	}
	
	// Print the list (DEBUGGING)
	//`dialog'.irfListi.print
	//`dialog'.irfListr.print

	if "``dialog'.`busyflag'.classname'" == "d_boolean" {
		`dialog'.`busyflag'.setfalse
	}
end
exit
