*! version 1.0.0  29oct2014
program define _stteffects_error_msg
	version 14.0

	syntax, cmd(string) case(integer) [ model(string) rc(string) ///
		extra(string) ]

	if "`cmd'"=="aipw" | "`cmd'"=="ipwra" | "`cmd'"=="ipw" {
		local vlist " varlist"
	}

	if `case' == 1 {
		local k : word count `extra'
		if ("`extra'"!="one" | `k'>1) local s "s are"
		else local s " is"

		di as err "{p}`extra' model specification`s' missing{p_end}"	
	}
	else if `case' == 2 {
		di as err "{p}only `extra' model specifications may be " ///
		 "specified{p_end}"
	}
	else if `case' == 3 {
		di as err "{p}`model' model is misspecified{p_end}"
	}
	if ("`rc'"=="") local rc = 198

	di as txt "{phang}An outline of the syntax is:{p_end}"
	di as txt "{phang}{helpb stteffects `cmd'}" _c
	if "`cmd'" != "ipw" {
		 di as txt " {bf:(}{it:outcome_model}{bf:)}" _c
	}
	 di as txt " {bf:(}{it:treatment_variable`vlist'}{bf:)}" _c
	if "`cmd'"!="ra" & "`cmd'"!="ipw" {
		if "`cmd'" == "ipwra" {
			di as txt " [" _c
		}
	 	di as txt " {bf:(}{it:censoring_model}{bf:)}" _c
		if "`cmd'" == "ipwra" {
			di as txt " ]"
		}
	}
	di as txt "{p_end}"

	exit `rc'
end

exit
