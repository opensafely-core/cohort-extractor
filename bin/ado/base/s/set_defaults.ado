*! version 1.3.7  16dec2019
program set_defaults
	version 12			// sic, run only on version 12+
	version 8			// sic, written in version 8
	cap noi syntax anything(name=sub id="set category") [, PERManently]
	if _rc {
		local rc = _rc 
		if _rc==100 {
			cap noi Errmsg
		}
		exit `rc'
	}

	local l = length("`sub'")

	if "`sub'"==bsubstr("memory",1,max(3,`l')) {
		Set_memory, `permanently'
	}
	else if "`sub'"==bsubstr("output",1,max(3,`l')) {
		Set_output, `permanently'
	}
	else if "`sub'"==bsubstr("interface",1,max(5,`l')) {
		Set_interface, `permanently'
	}
	else if "`sub'"==bsubstr("graphics",1,max(2,`l')) {
		Set_graphics, `permanently'
	}
	else if "`sub'"==bsubstr("efficiency",1,max(3,`l')) {
		Set_efficiency, `permanently'
	}
	else if "`sub'"==bsubstr("network",1,max(3,`l')) {
		Set_network, `permanently'
	}
	else if "`sub'"==bsubstr("update",1,max(2,`l')) {
		if `"`c(os)'"' != "Unix" {
			Set_update, `permanently'
		}
		else {
			di as err "-set_defaults update- not allowed on Unix"
			exit 198
		}
	}
	else if "`sub'"=="trace" {
		Set_trace, `permanently'
	}
	else if "`sub'"=="mata" {
		Set_mata, `permanently'
	}
	else if "`sub'"=="unicode" {
		Set_unicode, `permanently'
	}
	else if "`sub'"==bsubstr("other",1,max(3,`l')) {
		Set_other, `permanently'
	}
	else if "`sub'"=="_all" {
		Set_memory, `permanently'		// must be first
		Set_output, `permanently'
		Set_interface, `permanently'
		Set_graphics, `permanently'
		Set_efficiency, `permanently'
		Set_network, `permanently'
		if `"`c(os)'"' != "Unix" {
			Set_update, `permanently'
		}
		Set_trace, `permanently'
		Set_mata, `permanently'
		Set_unicode, `permanently'
		Set_other, `permanently'
	}
	else if ("`sub'"=="java" | "`sub'"=="python") {
		Errmsg2 "`sub'"
	}
	else 	Errmsg "`sub'"

	if "`permanently'" != "" { 
		di as txt "(preferences set and recorded)"
	}
	else {
		di as txt "(preferences reset)"
	}
end

program Errmsg
	args sub
	di as err "{p 4 4 2}"
	if (`"`sub'"' == "") { 
		di as err "Nothing was found where"
	}
	else {
		di as err `"{bf:`sub'} found where"
	}
	di as err "{bf:memory}, {bf:output}, {bf:interface}, {bf:graphics},"
	di as err "{bf:efficiency}, {bf:network}, {bf:update},"
	di as err "{bf:trace}, {bf:mata}, {bf:unicode},"
	di as err "{bf:other}, or {bf:_all} expected."
	di as err "{p_end}"
	exit 198
end

program Errmsg2
	args sub
	di as err "{p}"
	di as err `"{bf:`sub'} system parameters may not be used with"'
	di as err "{bf:set_defaults}"
	di as err "{p_end}"
	exit 198
end
		

program Set_memory
	syntax [, PERManently]

	if c(flavor)=="Small" {
		di as txt ///
		"(there are no settable memory settings in `c(flavor)' Stata)"
	}
	else {
		if c(SE) {
			Setcmd "maxvar 5000" `permanently'
		}
		Setcmd "matsize 400" `permanently'
		MemSetcmd "niceness 5" `permanently'
		MemSetcmd "min_memory 0" `permanently'
		MemSetcmd "max_memory ." `permanently'
		if (c(bit)==32) {
			MemSetcmd "segmentsize 16m" `permanently'
		}
		else {
			MemSetcmd "segmentsize 32m" `permanently'
		}
	}
end



program MemSetcmd
	args setargs perm
	if ("`perm'"=="") {
		di as txt `"-> set `setargs'"'
		cap set `setargs'
		local rc = _rc 
		if (!(`rc'==0 | `rc'==791)) {
			qui set `setargs'
			local rc 0
		}
	}
	else {
		di as txt `"-> set `setargs', permanently"'
		cap set `setargs', permanently
		local rc = _rc
		if (!(`rc'==0 | `rc'==791)) {
			qui set `setargs', permanently
			local rc 0
		}
	}
	if (`rc'==791) {
		di as res ///
		"   (system administrator will not allow changing this setting)"
	}
end
		

program Setcmd 
	args setargs perm
	if "`perm'"=="" {
		di as txt `"-> set `setargs'"'
		qui set `setargs'
	}
	else {
		di as txt `"-> set `setargs', permanently"'
		qui set `setargs', permanently
	}
end


program Set_output
	syntax [, PERManently]

	Setcmd "more on" `permanently'
	Setcmd "rmsg off" `permanently'
	Setcmd "dp period" `permanently'
	di as txt "-> (linesize left at current value)"
	di as txt "-> (pagesize left at current value)"
	Setcmd "level 95" `permanently'
	Setcmd "clevel 95" `permanently'
	Setcmd "showbaselevels" `permanently'
	Setcmd "showemptycells" `permanently'
	Setcmd "showomitted" `permanently'
	Setcmd "fvlabel on" `permanently'
	Setcmd "fvwrap 1" `permanently'
	Setcmd "fvwrapon word" `permanently'
	Setcmd "lstretch" `permanently'
	Setcmd "cformat" `permanently'
	Setcmd "pformat" `permanently'
	Setcmd "sformat" `permanently'
	Setcmd "coeftabresults on" `permanently'
	Setcmd "logtype smcl" `permanently'
end

program Set_interface
	syntax [, PERManently]

	if "`c(os)'" == "Windows" {
		Setcmd "dockable on" `permanently'
		Setcmd "dockingguides on" `permanently'
		Setcmd "floatresults off" 
		Setcmd "floatwindows off" 
		Setcmd "locksplitters off" `permanently'
		Setcmd "persistfv off"
		Setcmd "persistvtopic off"
		Setcmd "xptheme on" `permanently'
		Setcmd "smalldlg off" `permanently'
	}
	Setcmd "linegap 1" /* has no permanently option */
	Setcmd "scrollbufsize 200000" /* has no permanently option */
	Setcmd "reventries 5000" `permanently'
	Setcmd "maxdb 50" `permanently'
end

program Set_graphics
	syntax [, PERManently]

	if "`c(console)'"=="console" {
		Setcmd "graphics off"
	}
	else	Setcmd "graphics on"
	Setcmd "scheme s2color" `permanently'
	Setcmd "printcolor automatic" `permanently'
	Setcmd "copycolor automatic" `permanently'
end

		
program Set_efficiency
	syntax [, PERManently]
	Setcmd "adosize 1000" `permanently'
end

program Set_network
	syntax [, PERManently]
	Setcmd "checksum off" `permanently'
	Setcmd "timeout1 30" `permanently'
	Setcmd "timeout2 180" `permanently'
	Setcmd "netdebug off" `permanently'

	Setcmd "httpproxy off"
	Setcmd `"httpproxyhost """'
	Setcmd `"httpproxyport 8080"'

	Setcmd "httpproxyauth off"
	Setcmd `"httpproxyuser """'
	Setcmd `"httpproxypw """'
end

program Set_update
	syntax [, PERManently]
	Setcmd "update_query on" /* no permanent option */
	Setcmd "update_interval 7" /* no permanent option */
	Setcmd "update_prompt on" /* no permanent option */
end

program Set_trace
	syntax [, PERManently]
	Setcmd "trace off" 
	Setcmd "tracedepth 32000"
	Setcmd "traceexpand on" `permanently'
	Setcmd "tracesep on" `permanently'
	Setcmd "traceindent on" `permanently'
	Setcmd "tracenumber off" `permanently'
	Setcmd `"tracehilite """' /* no permanent option */
end

program Set_mata
	syntax [, PERManently]
	Setcmd "matastrict off" `permanently' 
	Setcmd "matalnum off" /* no permanent option */
	Setcmd "mataoptimize on" /* no permanent option */
	Setcmd "matafavor space" `permanently'
	Setcmd "matacache 2000" `permanently'
	Setcmd `"matalibs """' /* no permanent option */
	Setcmd "matamofirst off" `permanently'
end

program Set_unicode
	syntax [, PERManently]
	Setcmd "locale_ui default" /* no permanent option */
	Setcmd "locale_functions default" `permanently'
end

program Set_other
	syntax [, PERManently]
	Setcmd "type float" `permanently'
	Setcmd "maxiter default" `permanently'
	Setcmd "searchdefault all" `permanently'
	di as txt "-> (seed left at current value)"
	Setcmd "varabbrev on" `permanently'
end

exit
