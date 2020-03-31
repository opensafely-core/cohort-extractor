*! version 1.1.0  13oct2015
/*
	u_mi_impute_check_method <mac> : <method> <errout> <uvonly>

	checks <method> and returns unabbreviated name in <mac>
	The allowed methods are
		reg:ress
		pmm
		logi:t
		olog:it
		mlog:it
		poisson
		nbreg
		intreg
		truncreg
	and when <uvonly> is empty
		mon:otone
		chain:ed
		mvn

	User-defined methods are also allowed:
		<usermethod> defined by mi_impute_cmd_<usermethod>.ado

*/
program u_mi_impute_check_method
	version 12
	args mac colon method errout uvonly

	global MI_IMPUTE_user 0
	local l = strlen("`method'")

	if ("`method'"==bsubstr("regress",1,max(3,`l'))) {
		c_local `mac' "regress"
		exit
	}
	if ("`method'"=="pmm") {
		c_local `mac' "pmm"
		exit
	}
	if ("`method'"==bsubstr("logit",1,max(4,`l'))) {
		c_local `mac' "logit"
		exit
	}
	if ("`method'"==bsubstr("mlogit",1,max(4,`l'))) {
		c_local `mac' "mlogit"
		exit
	}
	if ("`method'"==bsubstr("ologit",1,max(4,`l'))) {
		c_local `mac' "ologit"
		exit
	}
	if ("`method'"=="poisson") {
		c_local `mac' "poisson"
		exit
	}
	if ("`method'"=="nbreg") {
		c_local `mac' "nbreg"
		exit
	}
	if ("`method'"=="intreg") {
		c_local `mac' "intreg"
		exit
	}
	if ("`method'"=="truncreg") {
		c_local `mac' "truncreg"
		exit
	}
	if ("`uvonly'"=="" & "`method'"==bsubstr("monotone",1,max(3,`l'))) {
		c_local `mac' "monotone"
		exit
	}
	if ("`uvonly'"=="" & "`method'"==bsubstr("chained",1,max(5,`l'))) {
		c_local `mac' "chained"
		exit
	}
	if ("`uvonly'"=="" & "`method'"=="mvn") {
		c_local `mac' "mvn"
		exit
	}
	if ("`errout'"=="") {
		local errout "{bf:mi impute}: "
	}
	else if ("`errout'"=="nothing") {
		local errout
	}
	else {
		local errout "{bf:`errout'}: "
	}
	if ("`method'"=="") {
		di as err `"`errout'imputation method must be specified"'
		exit 198
	}
	else {
		if ("`uvonly'"!="") {   // user-defined methods not allowed
					// within monotone and chained methods
di as err `"`errout'invalid imputation method {bf:`method'}"'
exit 198
		}
		cap qui findfile u_mi_impute_cmd_`method'.ado //official methods
		if _rc { // user-defined methods
			cap qui findfile mi_impute_cmd_`method'.ado
			if _rc {
di as err `"{bf:mi impute}: invalid method {bf:`method'}"'
di as err `"{p 4 4 2}Method {bf:`method'} is not one of the"'
di as err "officially supported {bf:mi impute}"
di as err "{help mi_impute##methods:methods}.  If you are adding a new"
di as err "user-defined method to {bf:mi impute}, you need to create a parser"
di as err `"named {bf:mi_impute_cmd_`method'_parse.ado} and an imputer"'
di as err `"named {bf:mi_impute_cmd_`method'.ado}; see"'
di as err "{help mi_impute_usermethod:mi impute {it:usermethod}}"
di as err "for details.{p_end}"
exit 198
			}
			cap noi qui findfile mi_impute_cmd_`method'_parse.ado
			if _rc {
di as err "{p 4 4 2}To add a new user-defined method to {bf:mi impute},"
di as err "you must create a {help mi_impute_usermethod##parser:parser} named"
di as err `"{bf:mi_impute_cmd_`method'_parse.ado}.{p_end}"'
exit 198
			}
		}
		global MI_IMPUTE_user 1
		global MI_IMPUTE_user_method "`method'"
	}
end
