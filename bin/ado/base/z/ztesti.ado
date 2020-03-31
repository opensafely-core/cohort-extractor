*! version 1.0.1  03mar2017
program ztesti, rclass
	version 14
	syntax [anything] ///
	[, mm(passthru) k(passthru) mm1(passthru) k1(passthru)  ///
	mm2(passthru) k2(passthru) cvcluster1(passthru) cvcluster2(passthru) ///
	cvcluster(passthru) rho(passthru) rho1(passthru) rho2(passthru) ///
	idname(passthru) *]
	
	if (`"`options'"'!="") {
		local 0 `anything',  `options'
	}
	else {
		local 0 `anything'
	}

/* Parse. */

	gettoken 1 0 : 0 , parse(" ,")
	gettoken 2 0 : 0 , parse(" ,")
	gettoken 3 0 : 0 , parse(" ,")
	gettoken 4 0 : 0 , parse(" ,")
	gettoken 5 : 0 , parse(" ,")

	if "`5'"=="" | "`5'"=="," { /* Do one-sample test */

		local args1 "`1' `2' `3' `4'"
		syntax [, Xname(string) Yname(string) Level(cilevel)]

/* call _ttest check ztest ...*/
                _ttest check ztest one `args1' /* check numbers */

                OneTest `args1' `level' `"`xname'"', ///
			`mm' `k' `cvcluster' `rho' `idname'
		ret add

                exit
        }

/* Here only if two-sample test. */

	gettoken 5 0 : 0 , parse(" ,")
	gettoken 6 0 : 0 , parse(" ,")
	gettoken 7 : 0 , parse(" ,")
	if ("`7'"!="" & "`7'"!=",") {
		version 15:di as err "{p 0 0 2} either four arguments"/*
		*/" for a one-sample test or six arguments for a"/*
		*/" two-sample test must be specified{p_end}"
		exit 198
	}
	
	local arg1 "`1' `2' `3'"
        local arg2 "`4' `5' `6'"

	syntax [, Xname(string) Yname(string) Level(cilevel)]

        _ttest check ztest first  `arg1' /* check numbers */
        _ttest check ztest second `arg2' /* check numbers */

        TwoTest `arg1' `arg2' `level' `"`xname'"' `"`yname'"', ///
		`mm1' `mm2' `k1' `k2' `cvcluster1' `cvcluster2' `rho1' `rho2' ///
		`idname'
	ret add
end

program define OneTest, rclass
	args n m s m0 level xname
	syntax [anything][, k(string) mm(string) cvcluster(string) ///
		rho(string) idname(string)]
/* Compute statistics. */

	tempname z se adjusts p pl pr q
	scalar `z' = (`m' - `m0')*sqrt(`n')/`s'
	scalar `se' = `s'/sqrt(`n')
	if ("`mm'"!="") {	
		scalar `adjusts' = 1+(`mm'-1)*`rho'+`mm'*`cvcluster'^2*`rho'
		scalar `z'    = `z'/sqrt(`adjusts')
		scalar `se'   = `se'*sqrt(`adjusts')	
	}	
	scalar `p' = 2 - 2*normal(abs(`z'))
	if `z' < 0 {
		scalar `pl' = `p'/2
		scalar `pr' = 1 - `pl'
	}
	else {
		scalar `pr' = `p'/2
		scalar `pl' = 1 - `pr'
	}

/* Display table of mean, std err, etc. */

	if ("`mm'"=="") {
		di _n in gr "One-sample z test"
	}	
	else {
		di _n in gr "One-sample z test" ///
			in gr _col(49) "Number of clusters = " in ye %9.0fc `k'      
		di in gr "Cluster variable: " in ye "`idname'" _c
		if (`cvcluster'==0) {
			di in gr _col(49) "Cluster size       = " ///
				in ye %9.0gc `mm'   
		}
		else {
			di in gr _col(49) "Avg. cluster size  = " ///
				in ye %9.2fc `mm'
			di in gr _col(49) "CV cluster size    = " ///
				in ye %9.4f `cvcluster'
		}
		di in gr _col(49) "Intraclass corr.   = " in ye %9.4f `rho' 
	}	

	_ttest header `level' `"`xname'"'

	if `"`xname'"'=="" {
		local xname "x" 
	}

	if ("`mm'"=="") {
		_ttest table `level' `"`xname'"' `n' `m' `s' 1
	}
	else {
		_ttest table `level' `"`xname'"' `n' `m' `s' 2 `se'
	}
	_ttest botline

/* Display Ho. */

	if length("`m0'") > 8 {
		local m0 : di %8.0g `m0'
		local m0 = trim("`m0'")
	}

	
	di as txt "    mean = mean(" as res `"`xname'"' as txt ")" ///
		_col(67) as txt "z = " as res %8.4f `z'

	di as txt "Ho: mean = " as res `"`m0'"' _col(50) as txt

/* Display Ha. */

	local p1 : di %6.4f `pl'
        local p2 : di %6.4f `p'
        local p3 : di %6.4f `pr'
	

        di
        _ttest center2 "Ha: mean < @`m0'@"  /*
	*/             "Ha: mean != @`m0'@" /*
	*/             "Ha: mean > @`m0'@"

	_ttest center2 "Pr(Z < z) = @`p1'@"   /*
	*/             "Pr(|Z| > |z|) = @`p2'@" /*
	*/             "Pr(Z > z) = @`p3'@"

	/* double save in S_# and r() */
	
		
	if ("`mm'"!="") {
		ret scalar CV_cluster = `cvcluster'
		ret hidden scalar DE	= 1+(`mm'-1)*`rho'
		ret scalar rho = `rho'
		ret scalar M = `mm'
		ret scalar K = `k'
	}

	scalar `q' =  invnormal((100+`level')/200)
	ret scalar level = `level'
	ret scalar p_u  = `pr'
	ret scalar p    = `p'
	ret scalar p_l  = `pl'
	ret scalar z    = `z'

	ret scalar lb = `m' - `q'*(`se')
	ret scalar ub = `m' + `q'*(`se')
	ret scalar se = `se'
	ret scalar sd = `s'
	ret scalar mu = `m'
	ret scalar N  = `n'
	ret hidden scalar sd_1 = `s'
	ret hidden scalar mu_1 = `m'
	ret hidden scalar N_1  = `n'
	
	
end	

program define TwoTest, rclass
	args n1 m1 s1 n2 m2 s2 level xname yname 
	syntax [anything][, k1(string) k2(string) mm1(string) mm2(string) ///
	cvcluster1(string) cvcluster2(string) rho1(string) ///
	rho2(string) idname(string)]

/* Compute statistics. */

	tempname se z se1 se2 p pl pr q adjusts1 adjusts2
	scalar `se' = sqrt((`s1')^2/`n1' + (`s2')^2/`n2')
	scalar `z'  = (`m1'-`m2')/`se'
	scalar `se1' = (`s1')/sqrt(`n1')
	scalar `se2' = (`s2')/sqrt(`n2')
	if ("`mm1'"!="") {
		scalar `adjusts1' = 1+(`mm1'-1)*`rho1'+`mm1'*`cvcluster1'^2*`rho1'
		scalar `adjusts2' = 1+(`mm2'-1)*`rho2'+`mm2'*`cvcluster2'^2*`rho2'
		scalar `se' = sqrt((`s1')^2*`adjusts1'/`n1' + ///
			(`s2')^2*`adjusts2'/`n2')
		scalar `z'  = (`m1'-`m2')/`se'	
		scalar `se1' = sqrt((`s1')^2*`adjusts1'/`n1')
		scalar `se2' = sqrt((`s2')^2*`adjusts2'/`n2')
	}
	
	scalar `p' = 2 - 2*normal(abs(`z'))
	if `z' < 0 {
		scalar `pl' = `p'/2
		scalar `pr' = 1 - `pl'
	}
	else {
		scalar `pr' = `p'/2
		scalar `pl' = 1 - `pr'
	}

/* Display table of mean, std err, etc. */

	if ("`mm1'"=="") {
		di _n in gr "Two-sample z test"
	}	
	else {
		local c1 3
		di _n in gr "Two-sample z test"
		di in gr "Cluster variable: " in ye "`idname'" _n
		di in gr "Group: " in ye "`xname'" _c
		di in gr _col(47) "Group: " in ye "`yname'"
		di in gr _col(`c1') "Number of clusters = " in ye %9.0fc `k1' _c
		di in gr _col(49) "Number of clusters = " in ye %9.0fc `k2'
		if (`cvcluster1'==0) {
			di in gr _col(`c1') "Cluster size       = " ///
				in ye %9.0gc `mm1' _c
		}
		else {
			di in gr _col(`c1') "Avg. cluster size  = " ///
				in ye %9.2fc `mm1' _c
		}	
		if (`cvcluster2'==0) {
			di in gr _col(49) "Cluster size       = " ///
			   in ye %9.0gc `mm2' 
		}
		else {
		    di in gr _col(49) "Avg. cluster size  = " in ye %9.2fc `mm2'
		}
		if (`cvcluster1'!=0 | `cvcluster2'!=0) {
			di in gr _col(`c1') "CV cluster size    = "/* 
			*/ in ye %9.4f `cvcluster1' _c
			di in gr _col(49) "CV cluster size    = "/*
			*/ in ye %9.4f `cvcluster2'
		}	
	        di in gr _col(`c1') "Intraclass corr.   = " in ye %9.4f `rho1' _c
		di in gr _col(49) "Intraclass corr.   = " in ye %9.4f `rho2' 
		di	 
	}	

	_ttest header `level' `"`xname'"'

	if `"`xname'"'=="" {
		local xname "x"
	}
	if `"`yname'"'=="" {
		local yname "y" 
	}
	if ("`mm1'"=="") {
		_ttest table `level' `"`xname'"' `n1' `m1' `s1' 1
		_ttest table `level' `"`yname'"' `n2' `m2' `s2' 1
	}
	else {
		_ttest table `level' `"`xname'"' `n1' `m1' `s1' 2  `se1'	
		_ttest table `level' `"`yname'"' `n2' `m2' `s2' 2  `se2'	
	}
	_ttest divline

/* Display difference. */

	_ttest dtable `level' "diff" . `m1'-`m2' `se' . 1

	_ttest botline

	
/* Display error messages. */


/* Display Ho. */

	di as txt _col(5) "diff = mean(" as res abbrev(`"`xname'"',16) ///
		as txt ") - mean(" as res abbrev(`"`yname'"',16) ///
		as txt ")" _col(67) ///
		as txt "z = " as res %8.4f `z'
	di as txt "Ho: diff = 0"

/* Display Ha. */

	local p1 : di %6.4f `pl'
        local p2 : di %6.4f `p'
        local p3 : di %6.4f `pr'

        di
        _ttest center2 "Ha: diff < 0" "Ha: diff != 0" "Ha: diff > 0"

	_ttest center2 "Pr(Z < z) = @`p1'@"   /*
	*/             "Pr(|Z| > |z|) = @`p2'@" /*
	*/             "Pr(Z > z) = @`p3'@"

	/* save r() */
	scalar `q' =  invnormal((100+`level')/200)
	if ("`mm1'"!="") {
		ret scalar CV_cluster2 = `cvcluster2'
		ret scalar CV_cluster1 = `cvcluster1'
		ret hidden scalar DE2	= 1+(`mm2'-1)*`rho2'
		ret hidden scalar DE1	= 1+(`mm1'-1)*`rho1'
		ret scalar rho2 = `rho2'
		ret scalar rho1 = `rho1'
		if (`rho1'==`rho2') {
			ret scalar rho = `rho1'
		}	
		ret scalar M2 = `mm2'
		ret scalar M1 = `mm1'
		ret scalar K2 = `k2'
		ret scalar K1 = `k1'
	}
	ret scalar level = `level'
	ret scalar p_u  = `pr'
	ret scalar p    = `p'
        ret scalar p_l  = `pl'
	ret scalar z    = `z'
   
	ret scalar ub_diff = `m1' - `m2' + `q'*(`se')
	ret scalar lb_diff = `m1' - `m2' - `q'*(`se')
	ret scalar ub2 = `m2' + `q'*(`se2')
	ret scalar lb2 = `m2' - `q'*(`se2')
	ret scalar ub1 = `m1' + `q'*(`se1')
	ret scalar lb1 = `m1' - `q'*(`se1')
	ret scalar se_diff   = `se'
	ret scalar se2 = `se2'
	ret scalar se1 = `se1'
	ret hidden scalar se   = `se'
	if (`s1'==`s2') {
			ret scalar sd = `s1'
	}
	ret hidden scalar sd_2 = `s2'
        ret hidden scalar sd_1 = `s1'
        ret scalar sd1 = `s1'
	ret scalar sd2 = `s2'
	ret scalar mu_diff = `m1' - `m2'
        ret scalar mu1 = `m1'
        ret scalar mu2 = `m2'
	ret scalar N2  = `n2'
        ret scalar N1  = `n1'
	ret hidden scalar mu_1 = `m1'
        ret hidden scalar mu_2 = `m2'
	ret hidden scalar N_2  = `n2'
        ret hidden scalar N_1  = `n1'


end

