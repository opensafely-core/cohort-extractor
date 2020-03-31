*! version 1.0.4  09sep2019
program define _dlg_tools_wrk, sclass
	version 15

	sreturn clear
	gettoken subcmd 0 : 0

	if `"`subcmd'"' == "levels" {
		dlg_tools_wrk_level `macval(0)'
	}
	else {
		exit(198)
	}
end

program dlg_tools_wrk_level, sclass
	args varname no_all
	capture confirm numeric variable `varname'
	if _rc {
//		sreturn local errmsg "string variable not allowed"
//		sreturn local errcode = 1
		exit
	}
	capture confirm double variable `varname' 
	if _rc == 0 {
		sreturn local errmsg = 1
		sreturn local errcode "double variable not allowed"
		exit
	}
	capture confirm float variable `varname' 
	if _rc == 0 {
		sreturn local errcode = 1
		sreturn local errmsg "float variable not allowed"
		exit
	}

	mata:get_levels("`varname'", "`no_all'")

	if (`un_rows' > 200) {
		sreturn local errcode = 1
		sreturn local errmsg "too many levels for categorical variable"
		exit
	}
	sreturn local errcode = 0
	sreturn local levels "`vals'"
end

version 15.0

mata:
mata set matastrict on

void get_levels(string scalar varname, string scalar no_all)
{
	real colvector		un
	string colvector	us, C
	string scalar		val

	C = ("","")
	st_view(C, ., varname,0)
	un = uniqrows(C)
	st_local("un_rows", strofreal(rows(un)))
	if (rows(un) > 200) {
		exit(0)
	}
	us = strofreal(un, "%20.0g")
	val = invtokens(us', " ")
	if (no_all == "") {
		val =  val + " (all)"
	}
	st_local("vals", val)
}

end

exit
