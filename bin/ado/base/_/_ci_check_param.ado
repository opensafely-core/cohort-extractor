*! version 1.0.0  06oct2015
program _ci_check_param
	version 14
	args pname colon param cmdname
	
	local l = strlen(`"`param'"')
	
	if (`"`param'"'=="") {
		di as err "{p}you must specify one of {bf:means},"
		di as err "{bf:proportions}, or {bf:variances}{p_end}"
		exit 198
	} 
	else if (`"`param'"'==bsubstr("variances", 1, max(3,`l'))) {
		c_local `pname' "variances"
		exit
	}
	else if (`"`param'"'==bsubstr("proportions", 1, max(4,`l'))) {
		c_local `pname' "proportions"
		exit
	}
	else if (`"`param'"'==bsubstr("means", 1, max(4,`l'))) {
		c_local `pname' "means"
		exit
	}
	else {
		di as err "{p}you must specify one of {bf:means},"
		di as err "{bf:proportions}, or {bf:variances}"
		di as err "following {bf:`cmdname'}{p_end}"
		exit 198	
	}
end
