*! version 1.0.0  20mar2009

/*
	u_mi_save <macname> : <save syntax>

	u_mi_use `"`macname'"' <use syntax>
                  \         \
		   must use compound quotes, and no colon

                 
	See separate ado-file for code for -u_mi_use-.

	Purpose:
		To save in a temporary file, and later reload, 
		and have the filename, date, c(changed) restored.
*/

program u_mi_save
	version 11
	gettoken macname 0 : 0, parse (" :")
	gettoken colon   0 : 0, parse (" :")
	c_local `macname' `""$S_FN" "$S_FNDATE" "`c(changed)'""'
	quietly save `0'
end
