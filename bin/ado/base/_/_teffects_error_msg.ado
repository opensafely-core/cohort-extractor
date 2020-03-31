*! version 1.0.0  14may2013
program define _teffects_error_msg
	version 13

	syntax, cmd(string) case(string) [ rc(string) ]

	if "`rc'" == "" {
		local rc = 198
	}

	if ("`cmd'" == "aipw" | "`cmd'" == "ipwra") {
		local vlist1 " varlist"
		local vlist2 " varlist"
	}
	else if ("`cmd'" == "ra" | "`cmd'" == "nnmatch") {
		local vlist1 " varlist"
		local vlist2 ""
	}
	else if ("`cmd'" == "ipw" | "`cmd'" == "psmatch") {
		local vlist1 ""
		local vlist2 " varlist"
	}

	if ("`case'" == "1" ) {
display as err "{p}treatment-model specification is missing{p_end}"	
display as txt "{phang}An outline of the syntax is{p_end}"
display as txt "{phang}{helpb teffects `cmd'} "			///
    "{bf:(}{it:outcome_variable`vlist1'}{bf:)} "		///
    "{bf:(}{it:treatment_variable`vlist2'}{bf:)} {p_end}"
exit `rc'
	}
	else if ("`case'" == "2" ) {
display as err "{p}only two model specifications may be specified{p_end}"	
display as txt "{phang}An outline of the syntax is{p_end}"
display as txt "{phang}{helpb teffects `cmd'} "			///
    "{bf:(}{it:treatment_variable`vlist2'}{bf:)} {p_end}"
exit `rc'
	}
	else if ("`case'" == "3" ) {
display as err "{p}too many variables in treatment-model specification{p_end}"	
display as txt "{phang}An outline of the syntax is{p_end}"
display as txt "{phang}{helpb teffects `cmd'} "			///
    "{bf:(}{it:outcome_variable`vlist1'}{bf:)} "		///
    "{bf:(}{it:treatment_variable`vlist2'}{bf:)} {p_end}"
exit `rc'
	}
	else if ("`case'" == "4" ) {
display as err "{p}too many variables in outcome-model specification{p_end}"	
display as txt "{phang}An outline of the syntax is{p_end}"
display as txt "{phang}{helpb teffects `cmd'} "			///
    "{bf:(}{it:outcome_variable`vlist1'}{bf:)} "		///
    "{bf:(}{it:treatment_variable`vlist2'}{bf:)} {p_end}"
exit `rc'
	}
	else if ("`case'" == "5" ) {
display as txt "{phang}The treatment-model is misspecified.{p_end}"	
display as txt "{phang}An outline of the syntax is{p_end}"
display as txt "{phang}{helpb teffects `cmd'} "			///
    "{bf:(}{it:outcome_variable`vlist1'}{bf:)} "		///
    "{bf:(}{it:treatment_variable`vlist2'}{bf:)} {p_end}"
exit `rc'
	}
	else if ("`case'" == "6" ) {
display as txt "{phang}There are too many variables in the "	///
	"treatment-model specification.{p_end}"	
display as txt "{phang}An outline of the syntax is{p_end}"
display as txt "{phang}{helpb teffects `cmd'} "			///
    "{bf:(}{it:outcome_variable`vlist1'}{bf:)} "		///
    "{bf:(}{it:treatment_variable`vlist2'}{bf:)} {p_end}"
exit `rc'
	}
	else if ("`case'" == "7" ) {
display as txt "{phang}The outcome-model is misspecified.{p_end}"	
display as txt "{phang}An outline of the syntax is{p_end}"
display as txt "{phang}{helpb teffects `cmd'} "			///
    "{bf:(}{it:outcome_variable`vlist1'}{bf:)} "		///
    "{bf:(}{it:treatment_variable`vlist2'}{bf:)}{p_end}"
exit `rc'
	}
	else {			// should not be here
		exit 498
	}

end

