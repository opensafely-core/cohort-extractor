*! version 6.0.1  09feb2015
* see comments at end of file
program define st_subid /* newvar */, rclass
	local sub "`1'"
	local id : char _dta[st_id]

	quietly { 
		sort `id' _t
		by `id': gen `c(obs_t)' `sub'=1 if _n==1
		capture by `id': assert _t0==_t[_n-1] if _n>1
		if _rc {
			by `id': replace `sub'=1 if _t0!=_t[_n-1] & _n>1
			local gaps 1
		}
		else	local gaps 0
		capture by `id': assert _d[_n-1]==0 if _n>1
		if _rc {
			by `id': replace `sub'=1 if _d[_n-1]!=0 & _n>1
			local mult 1
		}
		else	local mult 0
		by `id': replace `sub'=sum(`sub')
		sort `id' `sub' _t
	}
	ret scalar gaps = `gaps'
	ret scalar mult = `mult'

	global S_1 `return(gaps)'	/* double save */
	global S_2 `return(mult)'	/* double save */
end
exit

This routine assumes all data in memory is to be used!

The purpose of this routine is to create a subid variable so one can join
contiguous-time, single-failure records and then form constructs such as

	st_subid `subid'
	by `id' `subid': ...

Examples of records

        ----------------------------------------------------------------> time
        |-----||------||----X|                    3 records, no gap
subid=     1     1       1

        |----------|  |--------||------------X|   3 records, gap
subid=        1            2           2

        |----------|  |----------------------X|   2 records, gap
subid=        1                 2

        |---------X|------||----------X|          3 records
subid=       1        2         2

        |----------|  |-----X||------||------X|   4 records
subid=        1          2       3       3


Each subid is a 
       contiguous span of time 
       ending in a censoring or one failure


on return, the data is sorted by `id' `subid' _t
Returns:
	$S_1	0  data has no gaps
		1  data has gaps

	$S_2	0  data is single-failure data
		1  data is multiple failure (or re-entry after censoring)
