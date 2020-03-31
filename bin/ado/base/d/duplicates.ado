*! version 1.4.6  25sep2017
program define duplicates, sortpreserve rclass
        version 8

        * identify subcommand
        gettoken cmd 0 : 0, parse(" ,") 
        local l = length("`cmd'")

        if `l' == 0 {
di "{err}subcommand needed; see help on {help duplicates##|_new:duplicates}"
 	     	exit 198
        }

        if bsubstr("report",1,max(1,`l')) == "`cmd'" {
                local cmd "report"
        }
        else if bsubstr("examples",1,max(1,`l')) == "`cmd'" {
                local cmd "examples"
        }
        else if bsubstr("list",1,max(1,`l')) == "`cmd'" {
                local cmd "list"
        }
        else if bsubstr("browse",1,max(1,`l')) == "`cmd'" {
                local cmd "browse"
                di "{p 0 0 2}As of Stata 11.0, browse is " 	///
                "no longer a valid subcommand.  {result}See "	///
                "{help duplicates##remarks:Remarks} "		///
                "under help {helpb duplicates} " 		///
                "for an explanation.{p_end}"
                exit 198
        }
        else if bsubstr("tag",1,max(1,`l')) == "`cmd'" {
                local cmd "tag"
        }
        else if "drop" == "`cmd'" {
                * OK
        }
        else {
                di "{err}illegal {cmd}duplicates {err}subcommand"
                exit 198
        }

        * check rest of syntax
        if "`cmd'" == "drop" {
                syntax [anything] [if] [in] [, force]

                if "`force'" == "" {
                	if `"`anything'"' != "" {
                		confirm variable `anything'
                        	di "{err}force option required with " /*
                        	*/ "{cmd}duplicates drop {it}varlist{rm}"
                        	exit 198
                        }
                }

                capture syntax varlist [if] [in], force

                if _rc {
                        syntax [if] [in]
                        unab varlist : _all
                        local varlist : /*
                        */ subinstr local varlist "`_sortindex'" ""
                        local vartext "{txt} all variables"
                }
                else local vartext "{res} `varlist'"
        }
        else if "`cmd'" == "tag" { 
        	syntax [varlist(default=none)] [if] [in], Generate(str) 
		
		capture confirm new variable `generate' 
		if _rc { 
			di as err "generate() must specify new variable" 
			exit _rc 
		}
		
                if "`varlist'" == "" {
                        unab varlist : _all
                        local varlist : /*
                        */ subinstr local varlist "`_sortindex'" ""
                        local vartext "{txt} all variables"
                }
                else local vartext "{res} `varlist'"
	}	
        else {
                syntax [varlist(default=none)] [if] [in] [ , * ]
                if "`varlist'" == "" {
                        unab varlist : _all
                        local varlist : /*
                        */ subinstr local varlist "`_sortindex'" ""
                        local vartext "{txt} all variables"
                }
                else local vartext "{res} `varlist'"
        }

        * duplicates with some values missing might be of interest
        marksample touse, novarlist

	* # of observations 
	qui count if `touse' 
        return scalar N = r(N)
	if r(N) == 0 {
		error 2000
	} 

        tempvar order dgroup Ngroup example freq surplus uniq

        /*
        order   1 up    _n when called
        dgroup  0       if unique on varlist (not a "duplicated" group)
                1 up    labels groups which share identical values on varlist
        Ngroup  1       if unique on varlist
                2 up    is # in each dgroup
        example 1       to show if showing examples -- and to keep if -drop-
                0       to drop if -drop-
	freq    #       # in each group
	surplus #       # of surplus observations
	uniq    1       first occurrence by varlist
        */
	
        di _n "{p 0 4}{txt}Duplicates in terms of `vartext'{p_end}"

        gen `c(obs_t)' `order' = _n
        bysort `touse' `varlist' : gen `c(obs_t)' `Ngroup' = _N
	qui if "`cmd'" == "tag" { 
		gen long `generate' = `Ngroup' - 1 if `touse' 
		compress `generate' 
		exit 0 
	} 	

	
        if "`cmd'" == "report" {
                bysort `touse' `Ngroup' : gen `c(obs_t)' `freq' = _N
                by `touse' `Ngroup' : gen `c(obs_t)' `surplus' = _N - _N / `Ngroup' 
	       	label var `Ngroup' "copies" 
       		label var `freq' "observations" 
	       	label var `surplus' "surplus" 
       		tabdisp `Ngroup' if `touse', cell(`freq' `surplus') 

                local varcount: word count `varlist'

	        qui bysort `touse' `varlist' (`order'): gen byte `uniq' = 1 ///
			if _n==1 & `touse'
                char `order'[varname] "obs:"
                qui count if `uniq'==1
                local uniqcnttol = r(N)
                return scalar unique_value = `uniqcnttol'

   	       	exit 0
        }

        bysort `touse' `varlist' (`order') : /*
       	*/ gen byte `example' = (_N > 1) * (_n == 1) * `touse'
	qui by `touse' `varlist' : gen `dgroup' = `example'[1]
        qui replace `dgroup' = `dgroup' * sum(`example')
        char `dgroup'[varname] "group:"
        sort `dgroup' `order'

	* bail out now if no duplicates 
        su `dgroup', meanonly
        if `r(max)' == 0 {
                di _n as txt "(0 observations are duplicates)"
		if "`cmd'" == "drop" {
			return scalar N_drop = 0
		}
                exit 0
        }
	
        if "`cmd'" == "examples" {
                char `order'[varname] "e.g. obs:"
                char `Ngroup'[varname] "#"
                if `r(max)' > 1 {
                        list `dgroup' `Ngroup' `order' `varlist' /*
                        */ if `example', subvarname noobs `options'
                }
                else {
                        list `Ngroup' `order' `varlist' if `example', /*
                        */ subvarname noobs `options'
                }
        }
        else if "`cmd'" == "list" {
                char `order'[varname] "obs:"
                if `r(max)' > 1 {
                        list `dgroup' `order' `varlist' if `dgroup', /*
                        */ subvarname noobs `options'
                }
                else {
                        list `order' `varlist' if `dgroup', /*
                        */ subvarname noobs `options'
                }
        }
        else if "`cmd'" == "drop" {
                di
		quietly count if !`example' & `dgroup'
		return scalar N_drop = r(N)
                noisily drop if !`example' & `dgroup'
        }
end
/* end */
