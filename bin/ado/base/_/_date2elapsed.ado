*! version 1.1.3  13feb2015
program _date2elapsed, sclass
	version 8.1
	syntax [, format(string) datelist(string asis) DIsplay ]

	if bsubstr("`format'",1,2) == "%d" | bsubstr("`format'",1,3) == "%-d" {
		local fmt d
	}
	else if bsubstr("`format'",1,3) == "%-t" {
		local fmt = bsubstr("`format'",4,1)
	}
	else	local fmt = bsubstr("`format'",3,1)
	if !inlist("`fmt'","d","w","m","q","h","y") {
		sreturn clear
		sreturn local args `"`datelist'"'
		sreturn local orig `"`datelist'"'
		exit
	}


	// Translate all dates to Stata's elapsed time values
	while `"`datelist'"' != "" {
		gettoken arg datelist : datelist ,		///
			qed(qed) parse(" ,/()") match(par)
		if `qed' {
			local orig `"`orig' `"`arg'"'"'
		}
		else	local orig `orig' `arg'
		if "`arg'" == "," {
			continue
		}
		else if "`par'" == "(" {
			gettoken tok tok2 : arg, parse("()") match(par2)
			if "`tok2'" == "" {
				capture confirm integer `arg'
				if c(rc) & "`format'" != "" {
					Evaluate `fmt' `"`arg'"'
					local args `"`args' `r(date)'"'
				}
				else	local args `"`args' (`arg')"'
			}
			else {
				gettoken tok2 tok3 : tok2,	///
					parse("()") match(par2)
				capture {
					confirm integer number `tok2'
					_confirm_number_or_date (`tok')
					_confirm_number_or_date (`tok3')
				}
				if ! c(rc) {
					Evaluate `fmt' `"`tok'"'
					local tok `r(date)'
					Evaluate `fmt' `"`tok3'"'
					local tok3 `r(date)'
					numlist `"`tok'(`tok2')`tok3'"'
					local args `"`args' `r(numlist)'"'
				}
				else	local args `"`args' (`arg')"'
			}
		}
		else if `qed' {
			local args `"`args' `"`arg'"'"'
		}
		else {
			if "`format'" != "" {
				Evaluate `fmt' `arg'
				local arg `r(date)'
			}
			local args `"`args' `arg'"'
		}
	}

	sreturn clear
	sreturn local fmt `"`fmt'"'
	sreturn local args `"`:list retok args'"'
	sreturn local orig `"`:list retok orig'"'

	if "`display'" != "" {
		di as txt "fmt  = |" as res `"`s(fmt)'"'  as txt "|"
		di as txt "args = |" as res `"`s(args)'"' as txt "|"
		di as txt "orig = |" as res `"`s(orig)'"' as txt "|"
	}
end

// syntax: Evaluate <format_unit> <date_string>
// 
// Use the function associated with the <format_unit> to convert <date_string>
// to a Stata elapsed time value.  The <format_unit> functions are:
//
// 	d() w() m() q() h() y()

program Evaluate, rclass
	args format date
	capture {
		local val = `format'(`date')
		confirm integer number `val'
	}
	if !c(rc) local date `val'
	return local date `date'
end

exit
