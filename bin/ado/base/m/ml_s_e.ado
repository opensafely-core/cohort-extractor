*! version 6.0.0  09jan1998
program define ml_s_e
	version 6

	/*  Double save ml S_E_ macros for backward compatibility when
	 *  ml programs are converted from version 5 to version 6 ml. */

	global S_E_cmd  = e(cmd)
	*global S_E_tdf = e(tdf)        /* not supported under ml 6.0 */
	global S_E_ttl  = e(title)
	global S_E_depv = e(depvar)
	global S_E_nobs = e(N)
	global S_E_chi2 = e(chi2)
	global S_E_mdf  = e(df_m)
	global S_E_ll   = e(ll)
	global S_E_ll0  = e(ll_0)
	global S_E_pr2  = 1 - e(ll) / e(ll_0)

end
