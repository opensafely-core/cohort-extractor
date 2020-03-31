*! version 1.0.1  29apr2019

/*
    frlink__var <varname>

	Internal utility for -frlink-. 
	Verifies that <varname> is an -frlink- variable.

	Returns one of:

		<-syntax varname- error>
		r(!0)

		<varname> was not created by {bf:frlink}
		r(198);

		<varname> created by a newer version of -frlink-
		    Your Stata is not as up to date as it could be.
		    Type -update-.

		<no message and return code 0>

	This routine is written for version <varname>[frlink_ver]==1.
	Version refers to the names and contents of the <varname>[] 
	characteristics.   The version-1 characteristics are:

	--------------------------------------------------------------------
	<newvar>[frlink_ver]       1
	<newvar>[frlink_mtyp]     {1:1|m:1}
	<newvar>[frlink_fname1]   <current frame at time frlink issued>
	<newvar>[frlink_fname2]   <fname>
	<newvar>[frlink_vl1]      <varlist1>
	<newvar>[frlink_vl2]      <varlist2>   (might be blank)
	<newvar>[frlink_vl2p]     <varlist2> if not blank, else <varlist1>
	<newvar>[frlink_gen]      <newvar>
	<newvar>[frlink_date]     `c(current_date)' `c(current_time)'
				    -- or --
                                   "01jan1960 11:00:00" if -nodate-
				   
	<newvar>[frlink_N2]       # (# obs in <fname>)
	<newvar>[frlink_sig2]     _datasignature vl2p 
        <newvar>[frlink_FN]       `c(filename)' of <frname> (can be blank)
	<newvar>[frlink_FD]       `c(filedate)' of <frname> (can be blank)
	<newvar>[frlink_debug]    debug() options
	--------------------------------------------------------------------

	In the future, if version > 1, calling frlink__isvar will 
	automatically promote the stored characteristics to the 
	format of the latest version. 
*/

program frlink__var
	version 16

	syntax varname
	local ver ``varlist'[frlink_ver]'

	/* ------------------------------------------------------------ */
					// quick exit
	if ("`ver'"=="1") {
		exit
	}

	/* ------------------------------------------------------------ */
					// is it frlink? 

	if ("`ver'"=="") {
		di as err "`varlist' not a {bf:frlink}-created variable"
		exit 198
	}


	/* ------------------------------------------------------------ */
					// automatic promotion 
	/*
	if ("`ver'"=="1") {
		promote_1to2
	}
	if ("`ver'"=="2") {
		promote_2to3
	}
	.
	.
	*/

	/* ------------------------------------------------------------ */
					// now equal current version?

	if ("`ver'"==1) {
		exit
	}

	/* ------------------------------------------------------------ */
					// no, it is too new
					
	di as err "`varlist' was not created by {bf:frlink}"
	di as err "{p 4 4 2}"
	di as err "Your Stata is not as up to date as it" 
	di as err "could be.  Type {bf:update}."
	di as err "{p_end}\n"
	exit 610
end

/*
programs promote_1to2, promote_2to3, ..., go here.
*/
