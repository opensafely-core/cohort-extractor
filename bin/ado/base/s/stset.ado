*! version 6.1.2  08may2009
/*
	stset
	stset, [no]show
	stset, clear

	stset time cat[, options]
*/

program define stset, sort
	version 6, missing

	if _caller()<6 {
		ztset_5 `0'
		exit
	}

	if replay() {					/* sic */
		syntax [, CLEAR NOShow Show MI]
		if ("`mi'"=="") {
			u_mi_not_mi_set stset
			local chkvars "*"
		}
		else {
			local chkvars "u_mi_check_setvars settime stset"
		}

		st_is 2 full
		if ("`clear'"=="" & "`show'"=="" & "`noshow'"=="") {
			streset, `mi'
			exit
		}
		if "`clear'" != "" {
			st_set clear "`chkvars'"
			exit
		}
		if ("`show'"!="" & "`noshow'"!="") {
			di as smcl as err ///
			"may not specify both {bf:show} and {bf:nowshow}"
			exit 198
		}
		if ("`show'"!="") {
			char _dta[st_show] 
		}
		else	char _dta[st_show] "noshow"
		exit
	}

	syntax varlist(numeric max=2) [if/] [fw pw iw/] [, /*
		*/ AFTER(string)	/*
		*/ BEFORe(string)	/*
		*/ ENter(string) ENTRy(string) 	/*
		*/ EXit(string)		/*
		*/ EVER(string)		/*
		*/ Failure(string)	/*
		*/ ID(varname) 		/*
		*/ IFopt(string)	/*
		*/ MI			/*
		*/ NEVER(string)	/*
		*/ Origin(string)	/*
		*/ SCale(real 1)	/*
		*/ noShow		/*
		*/ TIME0(string) ]

	if ("`mi'"=="") {
		u_mi_not_mi_set stset
		local chkvars "*"
	}
	else {
		local chkvars "u_mi_check_setvars settime stset"
	}

	`chkvars' `varlist'

	tokenize `varlist'
	if "`2'"!="" {
		if `"`failure'"' != "" {
			di in red "may not mix old and new syntax"
			di in red "may not specify two variables and failure()"
			exit 198
		}
		local failure "`2'"
	}

	if `"`entry'"' != "" { 
		if `"`enter'"'!="" {
			error 198
		}
		local enter `"`entry'"'
	}

	st_set 	set "`chkvars'" "nocmd" /*
		         id    bt     bt0       fail        bs
		*/ 	"`id'" "`1'" `"`time0'"' "`failure'"  `scale'	/*

			     		enter		exit
		*/	           	`"`enter'"'	`"`exit'"'	/*

			origin
		*/	`"`origin'"'					/*

			ifexp		if		ever
		*/	`"`if'"'	`"`ifopt'"'	`"`ever'"'	/*

			never		after		before
		*/	`"`never'"'	`"`after'"'	`"`before'"'	/*

			wt		wv		show
		*/	"`weight'"	`"`exp'"'	"`show'"

end
