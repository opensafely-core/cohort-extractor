*! version 1.0.0  05mar2009
/*
	Full list of characteristics and variables used

	----------------------------------------------------------
	wide:
	   chars:
		_dta[_mi_marker]    "_mi_ds_1"
		_dta[_mi_style]     "wide"
		_dta[_mi_M]         M
		_dta[_mi_ivars]
		_dta[_mi_pvars]
		_dta[_mi_rvars]
		_dta[_mi_update]
		_dta[_mi_svyset]
	   vars:
		_mi_miss            0, 1
		_#_<varname>

	----------------------------------------------------------
	mlong:
	   chars:
		_dta[_mi_marker]    "_mi_ds_1"
		_dta[_mi_style]     "mlong"
		_dta[_mi_M]         M
		_dta[_mi_N]         # of obs. in m=0
		_dta[_mi_n]	    # of obs. in marginal
		_dta[_mi_ivars]
		_dta[_mi_pvars]
		_dta[_mi_rvars]
		_dta[_mi_update]
		_dta[_mi_svyset]
	   vars:
		_mi_m               0, 1, ..., `_dta[_mi_M]'
		_mi_id              0, 1, ..., `_dta[_mi_N]'
		_mi_miss            0, 1

	----------------------------------------------------------
	flong:
	   chars:
		_dta[_mi_marker]    "_mi_ds_1"
		_dta[_mi_style]     "flong"
		_dta[_mi_M]         M
		_dta[_mi_N]         # of obs. in m=0
		_dta[_mi_ivars]
		_dta[_mi_pvars]
		_dta[_mi_rvars]
		_dta[_mi_update]
		_dta[_mi_svyset]
	   vars:
		_mi_m               0, 1, ..., `_dta[_mi_M]'
		_mi_id              0, 1, ..., `_dta[_mi_N]'
		_mi_miss            0, 1

	----------------------------------------------------------
	flongsep:
		_dta[_mi_marker]    "_mi_ds_1"
		_dta[_mi_style]     "flongsep"
		_dta[_mi_name]      base name of dataset
		_dta[_mi_M]         M
		_dta[_mi_N]         # of obs. in m=0
		_dta[_mi_ivars]
		_dta[_mi_pvars]
		_dta[_mi_rvars]
		_dta[_mi_update]
		_dta[_mi_svyset]
	   vars:
		_mi_id              0, 1, ..., `_dta[_mi_N]'
		_mi_miss            0, 1

	flongsep_sub:
	   chars:
		_dta[_mi_marker]    "_mi_ds_1"
		_dta[_mi_style]     "flongsep_sub"
		_dta[_mi_name]      base name of dataset
		_dta[_mi_m]         m, which m this is
	   vars:
		_mi_id              0, 1, ..., `_dta[_mi_N]'

	----------------------------------------------------------
*/
		
program u_mi_zap_chars
	version 11
	nobreak {
		/* ---------------- set by all styles and substyles --- */
		char _dta[_mi_marker]		// _mids_1
		char _dta[_mi_style]		// wide, mlong, ...

		/* ------------------------------ set by all styles --- */
		char _dta[_mi_M]		// M
		char _dta[_mi_ivars]		// imputed variables
		char _dta[_mi_pvars]		// passive variables
		char _dta[_mi_rvars]		// regular variables
		char _dta[_mi_update]		// time of last mi update
		char _dta[_mi_svyset]		// svyset command

		/* ------------------ set by mlong, flong, flongsep --- */
		char _dta[_mi_N]		// # of obs in m=0

		/* ----------------------------------- set my mlong --- */
		char _dta[_mi_n]		// # of obs in extra

		/* ------------------ set my flongsep, flongsep_sub --- */
		char _dta[_mi_name]

		/* ---------------------------- set my flongsep_sub --- */
		char _dta[_mi_m]

		/* ----------------------------- not currently used --- */
		/*
		char _dta[_mi_basename]		// unused
		char _dta[_mi_swapped]		// wide swapped
		*/
	}
end
