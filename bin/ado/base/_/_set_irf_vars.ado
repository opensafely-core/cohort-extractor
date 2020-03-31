*! version 1.1.1  13feb2012

/* Either DIALOGCLSname or DIALOGname must be specified. DIALOGCLSname is now
 * the preferred method as it makes no assumptions about the underlying
 * class name of the dialog. DIALOGname should only be specified in old code.
 */
program define _set_irf_vars

	version 9
	
	syntax ,   IMPULSEtarget(string)  /// Name of impulse target
		   RESPONSEtarget(string) /// Name of response target
		   BUSYflag(string)	  /// Flag created by the caller
		[  DIALOGname(string)	  /// Name of the dialog
		   DIALOGCLSname(string)  /// Name of dialog class
		   IMPULSEVALue(string)   /// Currently selected value
		   RESPONSEVALue(string)  /// Currently selected value
		   LISTcontrol(string)	  /// Name of dialog control
		   IRFNAMEs(string)	  /// An alternative to getting the 
		   			  ///    value from the LISTcontrol
		]

	if `"`dialogclsname'"' == "" & `"`dialogname'"' == "" {
		exit 198
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
	.`dialog'.`busyflag'.settrue	
	   
	// handle list of irf names (could be one or more)
	local irfnames : list uniq irfnames
	
	foreach irf_name of local irfnames {	   
		// get the list of vars for an irf name
	        local vars "`vars' `.`dialog'.irfListi.getIrfVarsByName, name(`irf_name')'"
	}
	local vars : list uniq vars
	.list = .dynamic_list_control.new, dlgclsname(`dialog') control(`impulsetarget')
	.list.setList, newlist("`vars'") value("`impulsevalue'")
	
	local vars
	foreach irf_name of local irfnames {	   
		// get the list of vars for an irf name
	        local vars "`vars' `.`dialog'.irfListr.getIrfVarsByName, name(`irf_name')'"
	}
	local vars : list uniq vars
	.list = .dynamic_list_control.new,  dlgclsname(`dialog') control(`responsetarget')
	.list.setList, newlist("`vars'") value("`responsevalue'")	
	
	.`dialog'.`busyflag'.setfalse
end
exit
