*! version 6.0.0  24jul1998
program define st_promo
	/* promote ver. 1 to ver. 2 */
	/* dataset known to be st ver. 1 */
	confirm new var _t _t0 _d _st
	nobreak {
		char _dta[st_bt] "`_dta[st_t]'"
		char _dta[st_bt0] "`_dta[st_t0]'"
		char _dta[st_bd] "`_dta[st_d]'"
		char _dta[st_bs] "1"
		quietly {
			local type : type `_dta[st_t]'
			gen `type' _t = `_dta[st_bt]'
			compress _t
			if "`_dta[st_bt0]'"!="" {
				local type : type `_dta[st_bt0]'
				gen `type' _t0 = `_dta[st_bt0]'
				compress _t0
			}
			else	gen byte _t0 = 0
			if "`_dta[st_bd]'"!="" {
				gen byte _d = `_dta[st_bd]'!=0
			}
			else	gen byte _d = 1
			gen byte _st = 1
		}
		char _dta[st_t] "_t"
		char _dta[st_t0] "_t0"
		char _dta[st_d] "_d"
		char _dta[st_ver] 2
	}
	exit
end
