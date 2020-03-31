*! version 1.0.3  06mar2017

/*
	spbalance [, balance]

	-spbalance- without -balance- (query call)
	      Errors:  3   (not data in memory)
                      >0   xtset error
                     459   xtset but timevar not set
		       0   no error
	      Returns:
		scalar r(balanced) = 1|0

	-spbalance, balance-
	      Errors: >0 all the above and more
		       0 data are now strongly balanced

	      Returns:
		scalar r(balanced) = 1|0
		scalar r(Ndropped)  # of obs dropped
		matrix T            times dropped (if Ndropped>0)

        If there ever is an -xtbalance- command, it will differ from
        -spbalance-.  -spbalance- never considers dropping a panel.
        -xtbalanceset- would need to consider that alternative. 
*/

program spbalance, rclass
	version 15

	syntax [, balance]

	if (c(k)==0 & _N==0) {
		error 3		// no data in memory
	}

	if ("`balance'" == "") {
		spbalance_query
		return add
	}
	else {
		spbalance_balance
		return add
	}
end

program spbalance_query, rclass

	get_xtset panelvar timevar balanced :
	if ("`balanced'" == "strongly balanced") {
		return scalar balanced = 1
		di as txt "  (data strongly balanced)"
		exit
		// NotReached
	}
	return scalar balanced = 0
	di as txt "  (data not strongly balanced)"
	di as txt "{p 4 4 2}"
	di as txt "Type {bf:spbalance, balance} to make the"
	di as txt "data strongly balanced by dropping"
	di as txt "observations."
        di as txt "{p_end}"
end


program spbalance_balance, rclass
	get_xtset panelvar timevar balanced :
	if ("`balanced'" == "strongly balanced") {
		return scalar balanced = 1
		return scalar Ndropped = 0
		di as txt "  (data already strongly balanced)"
		exit
		// NotReached
	}

	dropobs "`panelvar'" "`timevar'" 
	return add
	return scalar balanced = 1
end
	

program get_xtset
	args pmac tmac bmac colon nothing

	capture xtset 
	if (_rc) {
		di as err "data not {bf:xtset}"
		exit 459
	}
	local panelvar "`r(panelvar)'"
	local timevar  "`r(timevar)'"
	local balanced "`r(balanced)'"

	if ("`panelvar'"=="") {
		di as err "assertion is false"
                exit 9
		// NotReached
	}

	if ("`timevar'"=="") {
		di as err "time variable not {bf:xtset}"
		di as err "{p 4 4 2}"
                di as err "Data are {bf:xtset} on the panel variable"
		di as err "{bf:`panelvar'} only.{break}"
		di as err "Type {bf:xtset `panelvar'} {it:timevar}."
		di as err "{p_end}"
		exit 459
	}
	c_local `pmac' `panelvar'
	c_local `tmac' `timevar'
	c_local `bmac' "`balanced'"
end


program dropobs, rclass
	args panelvar timevar

	// -----------------------------------------------------------
				// mata: getdroplist does the work

	mata: getdroplist("droplist", "`panelvar'", "`timevar'")


	// -----------------------------------------------------------
				// nothing to drop 
	if ("`droplist'"=="") {
		di as txt "{p 2 2 2}
		di as txt "(data already strongly balanced; no action taken)"
                di as txt "{p_end}"
		exit
		// NotReached
	}

	// -----------------------------------------------------------
				// something to drop 
	droptimes "`droplist'" "`panelvar" "`timevar'"
	return add
end

program droptimes, rclass
	args droplist panelvar timevar

	tempvar N Ndropped vec

	di as txt "  balancing data ..."

	scalar `N' = _N 
	local Ntimes 0
	foreach t of local droplist {
		quietly drop if `timevar'==(`t')
		local ++Ntimes
	}

	scalar `Ndropped' = `N' - _N
	assert (`Ndropped')
	local firstcall 1
	foreach t of local droplist {
		if (`firstcall') {
			matrix `vec' = (`t')
			local firstcall 0 
		}
		else {
			matrix `vec' = (`vec', `t')
		}
	}
	return matrix T `vec'
	return scalar Ndropped = `Ndropped'
		
	local obs = cond(`Ndropped'==1, "observation", "observations")
	local pr  = strtrim(string(`Ndropped', "%20.0fc"))

	di as txt "{p 4 4 2}"
	di as res "  `pr'" as txt " `obs' dropped."

	local cnt : list sizeof droplist
	local verb = cond(`cnt'==1, "was", "were")

	di as txt "Dropped `verb' {bf:`timevar'} =="
	local i_dropped 0
	foreach t of local droplist {
		local ++i_dropped
		local punc = cond(`i_dropped'==`Ntimes', ".", ",")
		di as txt strtrim(string(`t', "%10.0g")) "`punc'"
	}
	di as txt "Data are now strongly balanced."
	di as txt "{p_end}"

	mata: uniqvals("`timevar'")
end

version 15
local SS string scalar
local RC real colvector
local RS real scalar

set matastrict on

mata:

/*
	The following code assumes there are no repeated values 
	of timevar within panelvar. 
*/

void getdroplist(`SS' Tmac, `SS' panelvar, `SS' timevar)
{
	`RS'  i, N_panels
	`RC'  times, uniq_times, T
	`SS'  todrop

	N_panels   = length(uniqrows(        st_data(., panelvar)))
	uniq_times =        uniqrows(times = st_data(.,  timevar))


	T = J(0, 1, 0)
	for (i=1; i<=length(uniq_times); i++) {
		if ( colsum(times :== uniq_times[i]) != N_panels) {
			T = T \ uniq_times[i]
		}
	}

	todrop = ""
	if (length(T)) { 
		T = sort(T, 1)
		for (i=1; i<=length(T); i++) {
			todrop = todrop + sprintf("%21x ", T[i])
		}
	}
	st_local(Tmac, strtrim(todrop))
}


void uniqvals(`SS' timevar)
{
	`RC'	times

	times = uniqrows(st_data(.,timevar)) 
	if (length(times)>1) return

	printf("{txt}\n") 
	printf("{p 4 4 2}")
	printf("{it:WARNING}:\n") 

	if (length(times)==1) { 
		printf("Only one time remains, namely\n") 
		printf("%s = %g.\n", timevar, times[1])
		printf("Data are now cross sectional.\n")
		printf("Type {bf: xtset, clear} so that Sp treats\n")
		printf("them that way.\n")
	}
	else {
		printf("No times remain and that means the data\n")
		printf("have zero observations.\n")
	}
	printf("Perhaps the dropped times were caused by a few\n") 
	printf("panels.  If so, and if spillover effects from and to\n") 
	printf("those panels are zero or nearly zero, you could justify\n")
        printf("omitting the panels and then balancing the data.\n")
	printf("{p_end}\n")
}
 
end
