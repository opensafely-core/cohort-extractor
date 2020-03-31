*! version 2.0.5  14feb2003
program define svytest
	/* version statement intentionally omitted */

	// parse off specifications till comma
	// multiple specs are necessarily parenthesized.
	//
	// -anything- cannot be used due to possible syntax of test
	//   test exp=exp

	gettoken tok : 0, parse(" (,")
	if `"`tok'"' == "(" {  		/* eqns within parens */

		while `"`tok'"' == "(" {
			gettoken tok 0 : 0, parse(" (,") match(paren)
			local eqns `"`eqns' `"`tok'"'"'
			gettoken tok : 0, parse(" (,")
		}
		if `"`tok'"' != "," & `"`tok'"' != "" {
			di as err `"`tok' found; "(", "," or nothing expected"'
			exit 198
		}
	}
	else {                 	/* eqn without parens */

		while `"`tok'"' != "" & `"`tok'"' != "," {
			gettoken tok 0 : 0, parse(" ,")
			local eqns `"`eqns' `tok'"'
			gettoken tok : 0, parse(" ,")
		}
		local eqns `"`eqns'"'
	}

	syntax [, noADJust noSVYadjust BONferroni * ]
	if `"`adjust'`svyadjust'"' != "" {
		local adjust nosvyadjust
	}
	if `"`bonferroni'"' != "" {
		local mtest mtest(bonferroni)
	}
	if `"`eqns'"' != "" {
		capture unabbrev `eqns'
		if _rc==0 {
			local eqns `s(varlist)'
		}
	}
	test `eqns' , `adjust' `mtest' `options'

	/* Double saves. */

	global S_1 `r(df)'
	global S_2 `r(df_r)'
	global S_3 `r(F)'
end
