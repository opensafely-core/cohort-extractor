*! version 5.0.1  02jul1996
program define zt_is_5
	version 6	/* sic */
	if `"`_dta[_dta]'"' == "st" & `"`_dta[st_ver]'"'=="" {
		exit
	}
	if `"`_dta[_dta]'"' != "st" {
		di in red "data not st " _c
		if "`set'"!="" {
			di in red "(the data is marked as being `set' data)"
		}
		else	di
		exit 119
	}
	di in red "Data are st/Stata 6 and not st/Stata 5."
	di in red "You are running the old Stata 5 version of st."
	di in red /*
	*/ "We provide it so that researchers may reproduce old analyses."
	di in red "If you do not mean to be running the old system, type"
	di in red _n _col(8) ". version 6" _n
	di in red "if you do mean to be running the old system, type"
	di in red _n _col(8) ". version 5" _n _col(8) /*
	*/ "stset ..." _col(40) "fill in the dots with old syntax)" _n
	di in red "When you are done, type" 
	di in red _n _col(8) ". version 6"
	exit 119
end
