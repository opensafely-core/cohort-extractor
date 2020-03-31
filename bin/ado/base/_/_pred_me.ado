*! version 1.0.2  19mar2019
program define _pred_me /* "unique-options" <rest> */, sclass
	version 6.0, missing
	sret clear
	gettoken ouser 0 : 0 		/* user options */
	local orig `"`0'"'
	gettoken varn 0 : 0, parse(" ,[")
	gettoken nxt : 0, parse(" ,[")
	if !(`"`nxt'"'=="" | `"`nxt'"'=="if" | `"`nxt'"'=="in" /*
		*/ | `"`nxt'"'==",") {
		local typ `varn'
		gettoken varn 0 : 0, parse(" ,[")
	}
	syntax [if] [in] [, `ouser' CONStant(varname numeric) /*
		*/ Equation(string) noOFFset Outcome(string) STDDp *]
	
	/* -equation()- and -outcome()- are synonyms and cannot coexist */
	if (`"`equation'"'!="" & `"`outcome'"'!="") {
		di in smcl as err "{p}options {bf:equation()} and {bf:outcome()} "                ///
			"may not be combined{p_end}"
		exit 184
	}

	/* Exit gracefully if -stddp- used with inappropriate -equation()- */
	if ("`stddp'" != "") {
		if (`"`equation'`outcome'"'=="") {
			di in smcl as err "{p}option {bf:stddp} "            ///
				"requires that you specify two equations "   ///
				"in option {bf:equation(}{it:eqno1}{bf:,}"   ///
				"{it:eqno2}{bf:)}{p_end}"
			exit 198
		}
		else if (!ustrregexm(`"`equation'"', ",") & `"`outcome'"'=="") {
			di in smcl as err "{p}option {bf:stddp} "            ///
				"requires that you specify two equations "   ///
				"in option {bf:equation(}{it:eqno1}{bf:,}"   ///
				"{it:eqno2}{bf:)}{p_end}"
			exit 198
		}
		else if (!ustrregexm(`"`outcome'"', ",") & `"`equation'"'=="") {
			di in smcl as err "{p}option {bf:stddp} "            ///
				"requires that you specify two outcomes "    ///
				"in option {bf:outcome(}{it:out1}{bf:,}"     ///
				"{it:out2}{bf:)}{p_end}"
			exit 198
		}
	}

	if `"`outcome'"' != "" {
		local oc = `"outcome(`outcome')"'
	}
	local options `stddp' `oc' `options'
	if `"`options'"' != "" {
		/* Strip whitespace from -equation()- and -outcome()- */
		local 0 : copy local orig
		syntax [anything(name=any)] [if] [in]                        ///
			[, Equation(passthru) Outcome(passthru) *]
		local equat = usubinstr(`"`equation'"', " ", "", .)
		local outc = usubinstr(`"`outcome'"', " ", "", .)
		local new = `"`any' `if' `in', `equat' `outc' `options'"'
		
		_predict `new'
		sret local done 1
		exit
	}
	confirm new var `varn'
	sret local done 0
	sret local typ `"`typ'"'
	sret local varn `"`varn'"'
	sret local rest `"`0'"'
end
exit
