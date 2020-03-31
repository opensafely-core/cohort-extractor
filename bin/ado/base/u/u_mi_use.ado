*! version 1.0.0  20mar2009

/*
	u_mi_use `"`macname'"' <use syntax>
                  \         \
		   must use compound quotes, and no colon

	See u_mi_save.ado
*/

program u_mi_use 
	version 11
	gettoken info        0 : 0
	gettoken s_fn     info : info
	gettoken s_fndate info : info
	gettoken changed  info : info
	nobreak {
		quietly use `0'
		global S_FN     "`s_fn'"
		global S_FNDATE "`s_fndate'"
		mata: st_updata(`changed')
	}
end
