*! version 1.0.1  20jan2015

program _sbchkvars, sclass
	syntax varlist(ts fv), breakvars(string) [ mcons(string) ]

	local allvars `varlist'
	local model_cons `mcons'
	_parse comma brkvars brk_cons : breakvars
	gettoken lhs brk_cons : brk_cons, parse(",")
	local brk_cons = trim("`brk_cons'")
	if ("`brk_cons'"!=bsubstr("constant",1,max(4,strlen(`"`brk_cons'"'))) ///
			& "`brk_cons'"!="" ) {
		di as err "{p}option `brk_cons' not allowed{p_end}"
		exit 198
	}

/**-noconstant- in the full model and breakvars(,cons) not allowed**/
	if ("`model_cons'"!="" & "`brk_cons'"!="") {
		di as err "{p}{bf:constant} may not be specified in option"
		di as err "{bf:breakvars()} when a model with {bf:noconstant}"
		di as err "is estimated{p_end}"
		exit 198
	}
/**breakvars must be a subset of allvars**/
	if (wordcount("`brkvars'")>wordcount("`allvars'")) {
		di as err "{p}{bf:breakvars()} cannot contain more variables"
		di as err "than independent variables in the model{p_end}"
		exit 198
	}
	if ("`brkvars'"!="") {
		foreach bvar of varlist `brkvars' {
			local comvars : list varlist & bvar
			if ("`comvars'"=="") {
				di as err "{p}{bf:breakvars()} must contain"
				di as err "variables that are a subset of"
			       	di as err "independent variables in the"
				di as err "model{p_end}"
				exit 198
			}
		}
	}
	sreturn local breakvars = "`brkvars'"
	sreturn local breakcons = "`brk_cons'"

end
