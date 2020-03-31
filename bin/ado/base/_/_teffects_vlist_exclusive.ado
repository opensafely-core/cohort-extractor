*! version 1.0.1  14may2013

program define _teffects_vlist_exclusive
	syntax, vlist1(varlist numeric fv) wh1(string) ///
		vlist2(varlist numeric fv) wh2(string)

	/* loop through expressions using -gettoken, bind-		*/
	/* macrolist does not work for factor variable notation		*/
	while strlen("`vlist1'") {
		local xlist2 `vlist2'
		gettoken var1 vlist1 : vlist1, bind
		while strlen("`xlist2'") {
			gettoken var2 xlist2 : xlist2, bind
			if "`var1'" == "`var2'" {
				di as err "{p}variable {bf:`var1'} is in "  ///
				 "both `wh1' and `wh2'; this is " ///
				 "not allowed{p_end}"
				exit 198
			}
		}
	}
end

exit
