*! version 1.0.0  16jun2011

/*
	public utilities for Stata's -ssd- command

	Copyright (c) 2011 by StataCorp, LLP
*/

set matastrict on

version 12

local RS	real scalar
local RM	real matrix
local RR	real rowvector
local RC	real colvector
local SS	string scalar
local SR	string rowvector
local SC	string colvector

local boolean	real scalar
local True	(1)
local False	(0)

local Code	real scalar


local	n_sysvars	2
local	K		`"(strtoreal(st_global("_dta[ssd_K]"))-`n_sysvars')"'
local	G		`"(strtoreal(st_global("_dta[ssd_G]")))"'

local   firstvar 	= (`n_sysvars' + 1)
local	lastvar		`"(`firstvar'+`K'-1)"'
local	n_per_group	`"(strtoreal(st_global("_dta[ssd_n]")))"'


mata:

/* --------------------------------------------------------------------	*/
					/* Access to ssd "constants"	*/

/*
	K = ssd_K() returns real scalar number of variables; vectors will 
	      be 1xK, matrices KxK.

	G = ssd_G() returns number of groups.  G==1 means no groups.

	Other ssd "constants" are provided via macros, 
		`n_sysvars'
		`firstvar'
		`lastvar'
		`n_per_group'
*/

`RS' ssd_K() return(`K')

`RS' ssd_G() return(`G')


/* --------------------------------------------------------------------	*/
					/* get and put for ssd.ado	*/

/*
	ssd_get*() and ssd_put_*() routines are for use by ssd.ado.
	They deal with one group at a time only.

	Definitions:
		N	number of observations in a group. 
		means	1xK
		VS	variances or standard deviations; 1xK
		CC	Covariances or correlations, KxK
*/


`RS' ssd_get_N(`RS' g)
{
	`SS'	s

	s = st_global(ssd_N_name(g))
	return(s=="0" ? . : strtoreal(s))
}


void ssd_get_raw_means(`RS' g, `SS' status, `RV' means)
{
	means  = st_data(ssd_baseobs(g)+1, `firstvar'..`lastvar')
	status = (st_global(ssd_hasM_name(g))=="0" ? "" : "means")
}

void ssd_put_means(`RS' g, `RV' means)
{
	st_store(ssd_baseobs(g)+1, `firstvar'..`lastvar', means)
	st_global(ssd_hasM_name(g), "1")
}

void ssd_get_raw_VS(`RS' g, `SS' status, `RV' vs)
{
	vs     = st_data(ssd_baseobs(g)+2, `firstvar'..`lastvar')
	status = (st_global(ssd_hasVS_name(g))=="1" ?
			st_global(ssd_VS_name(g)) : "")
}

void ssd_put_VS(`RS' g, `SS' typ, `RV' vs)
{
	assert(typ=="var" | typ=="cov")

	vs     = st_store(ssd_baseobs(g)+2, `firstvar'..`lastvar', vs)
	st_global(ssd_hasVS_name(g), "1")
	st_global(ssd_VS_name(g),    typ)
}

void ssd_put_Var(`RS' g, `RV' Var) ssd_put_VS(g, "var", Var)
void ssd_put_Sd( `RS' g, `RV' Sd ) ssd_put_VS(g, "sd",  Sd)


void ssd_get_raw_CC(`RS' g, `SS' status, `RM' CC)
{
	`RS'	fo, lo

	fo = ssd_baseobs(g) + 3
	lo = fo + `K' - 1

	CC = st_data((fo, lo), `firstvar'..`lastvar')
	status = (st_global(ssd_hasCC_name(g))=="1" ?
			st_global(ssd_CC_name(g)) : "")
	

}

void ssd_put_CC(`RS' g, `SS' typ, `RM' CC)
{
	`RS'	fo, lo

	assert(typ=="cov" | typ=="corr")

	fo = ssd_baseobs(g) + 3
	lo = fo + `K' - 1

	st_store((fo, lo), `firstvar'..`lastvar', CC)
	st_global(ssd_hasCC_name(g), "1")
	st_global(ssd_CC_name(g), typ)

	if (typ=="cov") ssd_put_Var(g, diagonal(CC)')
}

void ssd_put_Cov(`RS' g, `RM' Cov) ssd_put_CC(g, "cov", Cov)

void ssd_put_Corr(`RS' g, `RM' Corr) ssd_put_CC(g, "corr", Corr)

					/* get and put for ssd.ado	*/
/* --------------------------------------------------------------------	*/


/* --------------------------------------------------------------------	*/
					/* other routines for ssd.ado	*/
					/* ssd_assert_ssd()		*/

/*
	ssd_assert_ssd()
*/

void ssd_assert_ssd()
{
	/* ------------------------------------------------------------ */
					/* data are ssd			*/

	if (st_global("_dta[ssd_marker]")!="SSD") {
		errprintf(
		  "data in memory are not summary statistics data (SSD)\n")
		exit(459)
		/*NOTREACHED*/
	}
	if (st_global("_dta[ssd_version]")!="1") {
		errprintf("unknown SSD format\n")
		errprintf("{p 4 4 2}\n")
		errprintf("This summary statistics data (SSD) were created\n")
		errprintf("by a newer version of Stata than you are currently\n")
		errprintf("using.  This older Stata does not know how to\n")
		errprintf("interpret the more modern format of these data\n")
		errprintf("{p_end}\n")
		exit(459)
		/*NOTREACHED*/
	}

	(void) ssd_data_corrupt(`True')		// assert data not corrupt
}


/*	____
	code = ssd_data_corrupt(iserror)
				-------

	Determine wither known to be SSD is corrupt.
	Returns:
		0	not corrupt
		1	corrupt and perhaps fixable
		2	not fixable

	if iserror, however, error message displayed and routine 
	does not return.

	A dataset is corrupt and perhaps fixable if variables or 
	observations need to be dropped.  

	The following problems are fixed by this routine and thus 
	not considered corruption:

	    1.  It orders variables 
	    2.  It renames _dta[ssd_groupvar] if necessary
	    3.  It renames first var to be _type if necessary
	    4.  It puts the observations in the required order
*/


`Code' ssd_data_corrupt(`boolean' iserror)
{
	`RS'		N_desired, N
	`RS'		k_desired, k
	`RS'		i, pos
	`boolean'	out_of_order

	if ((N=st_nobs()) != (N_desired = `n_per_group'*`G')) {
		if (iserror) {
			ssd_corrupt_error_1(N_desired, N, "observations")
			/*NOTREACHED*/
		}
		return(N_desired > N ? 2 : 1)
	}
	
	if ((k=st_nvar()) != (k_desired = `K' + `n_sysvars')) {
		if (iserror) {
			ssd_corrupt_error_1(k_desired, k, "variables")
			/*NOTREACHED*/
		}
		return(k_desired > k ? 2 : 1)
	}

	out_of_order = `False'
	for(i=1; i<=k; i++) {
		pos = strtoreal(st_global(sprintf("%s[ssd_pos]", st_varname(i))))
		if (pos!=i) {
			out_of_order = `True'
			if (pos<1 | pos>k) {
				if (iserror) {
					ssd_corrupt_error_2()
					/*NOTREACHED*/
				}
				return(2)
			}
		}
	}
	if (out_of_order) ssd_corrupt_fix_order()

	if (st_varname(1)!=st_global("_dta[ssd_groupvar]")) {
		st_global("_dta[ssd_groupvar]", st_varname(1))
	}

	if (st_varname(2)!="_type") {
		st_varrename(st_varname(2), "_type")
	}

	stata(sprintf("sort %s _type", st_varname(1)))
	return(0)
}

void ssd_corrupt_fix_order()
{
	`RS'	i, k
	`SR'	varnames
	`RC'	varpos, o
	`SC'	varnames_c 

	varnames = st_varname((1..st_nvar()))
	k        = length(varnames)
	varpos   = J(k, 1, .)
	for (i=1; i<=k; i++) {
		varpos[i] = strtoreal(st_global(
				sprintf("%s[ssd_pos]", st_varname(i)) ))
		assert(varpos[i]>=1 & varpos[i]<=k)
	}
	if (rows(uniqrows(varpos))!=k) {
		ssd_corrupt_error_2()
		/*NOTREACHED*/
	}

	o = order(varpos, 1)
	_collate(varnames_c = varnames', o)
	stata(sprintf("order %s", invtokens(varnames_c')))
}
	


/*static*/ void ssd_corrupt_error_1(`RS' desired, `RS' actual, `SS' what)
{
	errprintf("SSD corrupt\n")
	errprintf("{p 4 4 2}\n")
	errprintf("The summary statistics data should have\n")
	errprintf("%g %s, not %g.\n", desired, what, actual)
	if (desired > actual) {
		errprintf("Perhaps you have inadvertently dropped\n")
		errprintf("some %s.\n", what)
	}
	else {
		errprintf("The data may be fixable; type\n")
		errprintf("{bf:ssd repair}.\n")
	}
	errprintf("{p_end}\n")
	exit(459)
	/*NOTREACHED*/
}
	
/*static*/void ssd_corrupt_error_2()
{
	errprintf("SSD corrupt\n")
	errprintf("{p 4 4 2}\n")
	errprintf("The summary statistics data has been modified.\n")
	errprintf("It cannot be fixed.\n")
	errprintf("{p_end}\n")
	exit(459)
	/*NOTREACHED*/
}

					/* ssd_assert_ssd()		*/
/* --------------------------------------------------------------------	*/
					/* other routines for ssd.ado	*/


/*	_________
	truefalse = ssd_check_completeness(glist, todo)
					   -----  ----

	Verifies that data are complete.
	todo:
		"error"		issue error message and abort if incomplete
		"warn"		issue warning message if incomplete
		""		issue no messages.
*/

`boolean' ssd_check_completeness(`RR' userglist, `SS' todo)
{
	`boolean'	iscomplete, thisbad
	`RS'		i, G, g
	`RR'		badlist
	`RR'		glist

	glist = u_ssd_fix_glist(userglist)
	G = ssd_G()

	/* ------------------------------------------------------------ */
	iscomplete = `True'
	badlist = J(1, 0, .)
	for (i=1; i<=length(glist); i++) {
		g = glist[i]
		thisbad = `False' 
		if (st_global(ssd_hasCC_name(g))=="0") thisbad = `True'
		if (ssd_get_N(g)==.) thisbad = `True'
		if (thisbad) {
			iscomplete = `False'
			badlist    = badlist, g
		}
	}

	/* ------------------------------------------------------------ */
	if (todo=="" | iscomplete) return(iscomplete)

	/* ------------------------------------------------------------ */
	if (todo=="error") {
		errprintf("summary statistics data are incomplete\n")
		errprintf("{p 4 4 2}\n")
	}
	else {
		printf("{txt}\n")
		printf("  warning: summary statistics data incomplete\n")
		printf("{p 4 4 2}\n")
	}

	/* ------------------------------------------------------------ */
	if (G==1) {
		printf("Number of observations or covariances (correlations)\n")
		printf("are undefined.\n")
		printf("Use {bf:ssd set} to define them.\n")
		printf("{p_end}\n")
		if (todo=="error") exit(459)
		return(`False')
	}

	/* ------------------------------------------------------------ */
	if (G==length(badlist)) {
		printf("Number of observations or covariances (correlations)\n")
		printf("are undefined in every group.\n")
		printf("Use {bf:ssd set} {it:#} to define them.\n")
		printf("{p_end}\n")
		if (todo=="error") exit(459)
		return(`False')
	}
		
	/* ------------------------------------------------------------ */
	printf("Number of observations or covariances (correlations)\n")
	printf("are undefined for\n")
	if (length(badlist)==1) {
		printf("group %g.\n", badlist[1])
	}
	else if (length(badlist)==2) {
		printf("groups %g or %g.\n", badlist[1], badlist[2])
	}
	else {
		for (i=1; i<length(badlist); i++) printf("%g,\n", badlist[i])
		printf("or %g.\n", badlist[length(badlist)])
	}
	printf("Use {bf:ssd set} {it:#} to define them.\n")
	printf("{p_end}\n")

	/* ------------------------------------------------------------ */

	if (todo=="error") exit(459)
	return(`False')
}



/*
	truefalse = ssd_any_means_avbl(glist)
	truefalse = ssd_all_means_avbl(glist)

	truefalse = ssd_any_covariances(glist)
	truefalse = ssd_all_covariances(glist)

	    Whether any of specified groups have means or covariances.
	    Whether all of specified groups have means or covariances.
	    grouplist may be specified to mean all groups
*/

/*static*/ `boolean' ssd_covariances_avbl(`RS' g)
{
	if (st_global(ssd_hasCC_name(g))=="0")   return(`False')
	if (st_global(ssd_CC_name(g))   =="cov") return(`True')
	if (st_global(ssd_hasVS_name(g))=="0")   return(`False')
	return(`True')
}



`boolean' ssd_any_means_avbl(`RR' userglist)
{
	`RS' 		glist, i

	glist = u_ssd_fix_glist(userglist)
	
	for (i=1; i<=length(glist); i++) {
		if (st_global(ssd_hasM_name(glist[i]))=="1") return(`True')
	}
	return(`False')
}

`boolean' ssd_all_means_avbl(`RR' userglist)
{
	`RS' 		glist, i

	glist = u_ssd_fix_glist(userglist)
	
	for (i=1; i<=length(glist); i++) {
		if (st_global(ssd_hasM_name(glist[i]))=="0") return(`False')
	}
	return(`True')
}

`boolean' ssd_any_covariances_avbl(`RR' userglist)
{
	`RS' 		glist, i

	glist = u_ssd_fix_glist(userglist)
	
	for (i=1; i<=length(glist); i++) {
		if (ssd_covariances_avbl(glist[i])) return(`True')
	}
	return(`False')
}

`boolean' ssd_all_covariances_avbl(`RR' userglist)
{
	`RS' 		glist, i

	glist = u_ssd_fix_glist(userglist)
	
	for (i=1; i<=length(glist); i++) {
		if (!ssd_covariances_avbl(glist[i])) return(`False')
	}
	return(`True')
}

					/* other routines for ssd.ado	*/
/* --------------------------------------------------------------------	*/


/* --------------------------------------------------------------------	*/
					/* routines for statistical use	*/

/*	_________
	truefalse = whether_ssd()

            If is ssd data, but corrupt, routine issues error message and
            never returns.
*/

`boolean' whether_ssd()
{
	if (st_global("_dta[ssd_marker]")!="SSD") return(`False')
	ssd_assert_ssd()
	return(`True')
}


/*
	(void) ssd_validate(glist)

	    Verifies ssd for statistical use.  Issues Stata error messages
	    if data fails to validate.  It is assumed that the caller has 
	    already run whether_ssd().
*/

void ssd_validate(`RR' glist)
{
	(void) ssd_check_completeness(glist, "error")
	if (ssd_all_covariances_avbl(glist) & ssd_all_means_avbl(glist)) {
		return 
	}
	if (length(glist)==1) return
	errprintf("cannot pool groups\n")
	errprintf("{p 4 4 2}\n")
	errprintf("There is insufficient information in the\n")
	errprintf("summary statistics data to combine across\n")
	errprintf("groups.  To combine data across groups,\n")
	errprintf("for each group we need either\n") 
	errprintf("(1) means and covariances, or (2)\n")
	errprintf("means, variances or standard deviations, and\n")
	errprintf("correlations.  Some or all of your groups\n")
	errprintf("do not provide that information.\n")
	errprintf("{p_end}\n")
	exit(459)
	/*NOTREACHED*/
}


`SR' ssd_variable_names()
{
	return(st_varname(`firstvar'..`lastvar'))
}

void ssd_ss(`RR' userglist, N, means, cov)
{
	`RS'	K, i, g
	`RS'	N_g
	`RR'	glist, means_g, means2, meansdif
	`RM'	cov_g
	`SS'	status

	glist = u_ssd_fix_glist(userglist)

	if (length(glist)==1) {
		ssd_ss_u(glist[1], N, means, cov)
		return
	}
	assert (ssd_all_covariances_avbl(glist) &
		ssd_all_means_avbl(glist))

	K     = ssd_K()
	N     = 0 
	means = J(1, K, 0)
	for (i=1; i<=length(glist); i++) {
		g   = glist[i]
		N_g = ssd_get_N(g)
		pragma unset means_g
		pragma unset status
		ssd_get_raw_means(g, status, means_g)
		means = means + N_g:*means_g
		N     = N + N_g 
	}
	means = means :/ N

	cov = means2 = J(K, K, 0)
	for (i=1; i<=length(glist); i++) {
		g = glist[i]
		pragma unset cov_g
		ssd_ss_u(g, N_g, means_g, cov_g)
		cov = cov + (N_g-1):*cov_g 
		meansdif = means_g - means 
		means2 = means2 + N_g:*(meansdif'meansdif)
	}
	cov = (cov + means2):/(N-1)
}
			
	
/*static*/ void ssd_ss_u(`RS' g, N, means, cov)
{
	`RS'	K, i, j
	`RR'	sd 
	`SS'	CCstatus, Mstatus, VSstatus

	K = ssd_K()
	
	N = ssd_get_N(g)

	pragma unset Mstatus
	ssd_get_raw_means(g, Mstatus, means)
	if (Mstatus == "")  means = J(1, cols(means), 0)

	pragma unset CCstatus
	ssd_get_raw_CC(g, CCstatus, cov)
	if (CCstatus=="cov") return

	pragma unset VSstatus
	pragma unset sd
	ssd_get_raw_VS(g, VSstatus, sd)
	if (VSstatus=="") return
	if (VSstatus=="var") sd = sqrt(sd)

	for (i=1; i<=K; i++) {
		for (j=1; j<=i; j++) {
			cov[i,j] = cov[j,i] = cov[i,j]*sd[i]*sd[j]
		}
	}
}

					/* routines for statistical use	*/
/* --------------------------------------------------------------------	*/




/* -------------------------------------------------------------------- */
				/* internal (static) routines		*/


`RS' ssd_baseobs(`RS' g) return((g-1)*`n_per_group')

`SS' ssd_hasM_name(`RS' g) return(sprintf("_dta[ssd_hasM%g]", g))

`SS' ssd_hasVS_name(`RS' g) return(sprintf("_dta[ssd_hasVS%g]", g))
`SS' ssd_VS_name(   `RS' g) return(sprintf("_dta[ssd_VS%g]", g))

`SS' ssd_hasCC_name(`RS' g) return(sprintf("_dta[ssd_hasCC%g]", g))
`SS' ssd_CC_name(   `RS' g) return(sprintf("_dta[ssd_CC%g]", g))
`SS' ssd_N_name(    `RS' g) return(sprintf("_dta[ssd_N%g]", g))


`RR' u_ssd_fix_glist(`RR' userglist)
{
	`RR'		glist
	`RS'		G, i, j
	`boolean'	hasmissing

	G = ssd_G()
	hasmissing = `False'
	glist = J(1, length(userglist), .)
	j = 0
	for (i=1; i<=length(userglist); i++) {
		if (userglist[i]==.) {
			hasmissing = `True'
		}
		else 	glist[++j] = userglist[i]
	}
	if (j==0) glist = J(1, 0, .)
	else	  glist = glist[|1\(j)|]
	if (hasmissing) glist = glist, (1..G)

	glist = uniqrows(glist')'
	if (sum(glist:<1) | sum(glist:>G)) {
		errprintf("group values out of range\n") 
		errprintf("{p 4 4 2}\n")
		errprintf("Group values 1 through %g\n", G)
		errprintf("are currently defined in the\n")
		errprintf("summary statistics data.\n")
		errprintf("{p_end}\n") 
		exit(198)
		/*NOTREACHED*/
	}
	return(glist)
}

				/* internal (static) routines		*/
/* -------------------------------------------------------------------- */
end
