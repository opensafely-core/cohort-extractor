*! version 6.1.1  30apr2013
/*
	streset
	stset, [no]show
	stset, clear

	stset time cat[, options]
*/

program define streset
	version 6, missing
	st_is 2 full
			
	capture syntax [, Show Full Past Future MI]
	if _rc==0 { 
		if ("`mi'"=="") {
			u_mi_not_mi_set streset
			local chkvars "*"
		}
		else {
			local chkvars "u_mi_check_setvars settime stset"
		}

		if "`full'"!="" | "`past'"!="" | "`future'"!="" {
			if "`past'"=="" & "`future'"=="" {
				di in red "must specify"
				di in red _col(8) ". streset, full past"
				di in red _col(8) ". streset, full future"
				di in red _col(8) ". streset, full past future"
				exit 198
			}
			Full "`chkvars'" `past' `future'
			exit
		}
		if "`show'"!="" {
			char _dta[st_show]
			exit
		}
		syntax [, noShow MI]
		if "`show'"!="" { 
			char _dta[st_show] "noshow"
			exit
		}
		if `"`_dta[st_full]'"'!="" {
			Anal "`chkvars'"
			exit
		}
	}

	if `"`_dta[st_set]'"' != "" {
		di in red `"`_dta[st_set]'"'
		exit 119
	}
	
	if "`_dta[st_full]'"!="" { 
		if _rc { 
			di in red as smcl ///
			`"after {bf:streset, full `_dta[st_full]'},"'
			di in red as smcl /*
			*/ `"you must type {bf:streset} without options first"'
			exit 198
		}
	}
	
	local shopt = cond("`_dta[st_show]'"=="", "noShow", "Show")
	syntax [if/] [fw pw iw/] [, MI /*
		*/ AFTER(string)	/*
		*/ BEFORe(string)	/*
		*/ ID(varname) 		/*
		*/ ENter(string) ENTRy(string) 	/*
		*/ EXit(string)		/*
		*/ EVER(string)		/*
		*/ Failure(string)	/*
		*/ IFopt(string)	/*
		*/ NEVER(string)	/*
		*/ Origin(string)	/*
		*/ SCale(string)	/*
		*/ noShow		/*
		*/ TIME0(string)	]

	if ("`mi'"=="") {
		u_mi_not_mi_set stset /* sic */
		local chkvars "*"
	}
	else {
		local chkvars "u_mi_check_setvars settime stset"
	}

	Get id st_id `"`id'"'
	local bt `_dta[st_bt]'
	Get time0 st_bt0 `"`time0'"'

	if `"`failure'"'=="" {
		local failure `"`_dta[st_bd]'"'
		if `"`_dta[st_ev]'"'!="" {
			local failure `"`failure'==`_dta[st_ev]'"'
		}
	}

	if `"`entry'"' != "" {
		if `"`enter'"' != "" {
			error 198
		}
		local enter `"`entry'"'
	}

	Get scale st_bs `"`scale'"'
	
	Get enter st_enter `"`enter'"'
	Get exit  st_exit `"`exit'"'
	Get origin st_orig `"`origin'"'
	Get ifexp st_ifexp `"`if'"'
	Get ifopt st_if `"`ifopt'"'
	Get ever st_ever `"`ever'"'
	Get never st_never `"`never'"'
	Get after st_after `"`after'"'
	Get before st_befor `"`before'"'

	if `"`weight'"' == "" {
		local weight `"`_dta[st_wt]'"'
		local exp `"`_dta[st_wv]'"'
	}
	Get show st_show `"`show'"'

	st_set 	set "`chkvars'" "" 	/*
		*/ "`id'" "`bt'" `"`time0'"' `"`failure'"'  `scale'	/*
		*/	`"`enter'"'  	`"`exit'"'	`"`origin'"'	/*
		*/	`"`ifexp'"'	`"`ifopt'"'	`"`ever'"'	/*
		*/	`"`never'"'	`"`after'"'	`"`before'"'	/*
		*/	"`weight'"	`"`exp'"'	"`show'"

end


program define Get 
	args lname default cnts 
	if `"`cnts'"' != "" {
		c_local `lname' `"`cnts'"'
	}
	else	c_local `lname' `"`_dta[`default']'"'
end


program define Full /* past | future | past future */
	gettoken chkvars 0 : 0
	local arg = trim(`"`0'"')
	if ("`_dta[st_id]'"=="") { 
		di in red as smcl ///
"{bf:streset, full} relevant only if {bf:id()} variable has been {bf:stset}"
		exit 198
	}
	if ("`_dta[st_full]'" != "") {
		if `"`_dta[st_full]'"' == `"`arg'"' {
			di in gr "(data already full `arg')"
			exit
		}
		di in red `"data are full `_dta[st_full]'"'
		di in red as smcl ///
		`"you must type {bf:streset} without arguments first"'
		exit 198
	}
	if (`"`_dta[st_set]'"') != "" {
		di in red `"`_dta[st_set]'"'
		exit 119
	}

	local failure `"`_dta[st_bd]'"'
	if `"`_dta[st_ev]'"'!="" {
		local failure `"`failure'==`_dta[st_ev]'"'
	}

	#delimit
	st_set set "`chkvars'" ""
		`"`_dta[st_id]'"' `"`_dta[st_bt]'"' `"`_dta[st_bt0]'"'
		`"`failure'"' `"`_dta[st_bs]'"'
		`"`_dta[st_enter]'"' `"`_dta[st_exit]'"' `"`_dta[st_orig]'"'
		`"`_dta[st_ifexp]'"' `"`_dta[st_if]'"'
		`"`_dta[st_ever]'"' `"`_dta[st_never]'"'
		`"`_dta[st_after]'"' `"`_dta[st_befor]'"'
		`"`_dta[st_wt]'"' `"`_dta[st_wv]'"'
		`"`_dta[st_show]'"'
		`"`arg'"'
	;
	#delimit cr
end


program define Anal 
	args chkvars
	if "`_dta[st_id]'"=="" { 
		di in red as smcl ///
"{bf:streset, analysis} relevant only if {bf:id()} variable has been {bf:stset}"
		exit 198
	}
	if "`_dta[st_full]'"=="" {
		di in gr "(data already analysis subsample)"
		exit
	}

	if `"`_dta[st_set]'"' != "" {
		di in red `"`_dta[st_set]'"'
		exit 119
	}


	local failure `"`_dta[st_bd]'"'
	if `"`_dta[st_ev]'"'!="" {
		local failure `"`failure'==`_dta[st_ev]'"'
	}

	#delimit
	st_set set "`chkvars'" ""
		`"`_dta[st_id]'"'
		`"`_dta[st_bt]'"'
		`"`_dta[st_bt0]'"'
		`"`failure'"'
		`"`_dta[st_bs]'"'
		`"`_dta[st_fente]'"'
		`"`_dta[st_fexit]'"'
		`"`_dta[st_forig]'"'
		`"`_dta[st_ifexp]'"'
		`"`_dta[st_fif]'"'
		`"`_dta[st_fever]'"'
		`"`_dta[st_never]'"'
		`"`_dta[st_fafter]'"'
		`"`_dta[st_fbefor]'"'
		`"`_dta[st_wt]'"'
		`"`_dta[st_wv]'"'
		`"`_dta[st_show'"'
	;
	#delimit cr
end
