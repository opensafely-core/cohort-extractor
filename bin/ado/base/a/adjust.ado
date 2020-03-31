*! version 2.3.0  19feb2019  
program adjust
	version 6.0, missing

* Syntax:
* adjust [var[= #] [var[= #] ...]] [if exp] [in range] [, by(varlist)
*      generate(var [var]) {xb [se|stdf] | pr | exp} ci level(#) vertical
*      equation(##|name) nooffset replace label() selabel() cilabel() nokey 
*      noheader format(%fmt) <tabdisp options>]
*
* Where the allowed tabdisp options are: center left cellwidth(#) csepwidth(#)
* scsepwidth(#) stubwidth(#)

	/* Check the estimation command we follow */
	if "`e(cmd2)'" != "" {
		local ecmd "`e(cmd2)'"
	}
	else {
		local ecmd "`e(cmd)'"
	}

	if "`ecmd'"=="binreg" {
		local elinkt "`e(linkt)'"
	}

	CheckCmd `ecmd'
	local edvar "`e(depvar)'"
	local edcnt : word count `edvar'
	if `edcnt' > 1 {
		/* multiple depvars --- list equation instead */
		local edvar
	}

	local maxby 7    /* 7 because of tabdisp */
	#delimit ;
	syntax [anything(name=com equalok)] [if] [in] [,
		BY(varlist min=1 max=`maxby') Generate(string)
		XB Pr EXP SE STDF CI Level(cilevel) VERTical
		EQuation(string) noOFFset REPLACE LABel(string) SELABel(string)
		CILABel(string) noKEY noHEADer CENter Left Format(string)
		CELLWidth(passthru) STUBWidth(passthru) CSEPwidth(passthru)
		SCSEPwidth(passthru)
	] ;
	#delimit cr

	/* Initial marking out of the -if- and -in- */
	marksample touse

	/* Non standard parsing of the varlist */
	ParseVar `com'
	local covars "`s(vnames)'" /* Covariates to be set */
	local covals "`s(values)'" /* Values to set the covariates or "mean" */

	/* Pull all the tabdisp options into one local macro */
	local tabopts "`center' `left' `cellwid' `stubwid' `csepwid' `scsepwi'"

	/* Take care of format --- default %8.0g */
	if "`format'" == "" {
		local format "%8.0g"
	}
	quietly di `format' 0	/* an error check on the format */

	/* Check equation() option */
	CheckEq `"`equatio'"'
	local equatio "`r(eqname)'"
	if "`equatio'" != "" { local eqopt "equation(`equatio')" }

	/* Get the variable names from the estimation coef. vector */
	GetbName "`ecmd'" `"`equatio'"'
	local bnames "`r(names)'"

	/* Check that the covars are in bnames */
	CheckVar "`covars'" "`bnames'"

	/* take care of case where no -by()- was specified */
	if "`by'" == "" {
		tempvar oneby
		gen str1 `oneby' = " "
		label var `oneby' "All"
		local by `oneby'
	}

	/* Create various lists of variables */
	CheckBy `by'
	Subtract "`by'" "`covars'"
	local bynotc "`r(list)'" /* the by vars not in covars list */
	Subtract "`by'" "`bynotc'"
	local byinc "`r(list)'"  /* the by vars in the covars list */
	Subtract "`bnames'" "`covars' `by'"
	local asis "`r(list)'"   /* variables left as is */

	/* mark the variables --- -if- and -in- were marked earlier */
	markout `touse' `bnames'
	markout `touse' `by' , strok
	qui count if `touse'
	if r(N) == 0 { error 2000 }  /* need observations */

	/* Check a bunch of options and determine labels and pr command */
	CheckOpt "`xb'" "`pr'" "`exp'" "`se'" "`stdf'" "`ci'" /*
		*/ "`label'" "`selabel'" "`cilabel'" "`ecmd'" "`level'" /*
		*/ "`elinkt'"
	local esttype "`r(esttype)'"
	local errtype "`r(errtype)'"
	local prprog  "`r(prprog)'"
	local label   "`r(label)'"
	local selabel "`r(selabel)'"
	local cilabel "`r(cilabel)'"

	/* Take care of the generate() option */
	CheckGen "`generat'" "`errtype'" "`replace'"
	local ngen "`r(ngen)'"  /* number of generate variables */
	local gen1 "`r(gen1)'"  /* 1st generate var (for xb or pr) */
	local gen2 "`r(gen2)'"  /* 2nd generate var (for stdp or stdf) */

	/* preliminary set up if we are generating variables */
	if `ngen' > 0 { /* find sort order and make id -- for future merge */
		local sorted : sortedby
		tempvar id
		gen `c(obs_t)' `id' = _n
		qui compress `id'
	}

	/* make a copy of the by vars that are also covars */
	if "`asis'" != "" {
		local newby "`bynotc'"
	}
	tokenize "`byinc'"
	local i 1
	while "``i''" != "" {
		tempvar tmp`i'
		gen `tmp`i'' = ``i''
		if "`asis'" != "" {
			local newby "`newby' `tmp`i''"
		}
		local i = `i' + 1
	}

	/* cut data to the touse sample */
	preserve
	qui keep if `touse'

	/* set the covars equal to the covals */
	SetCovs "`covars'" "`covals'"
	local thevals "`r(values)'"

	/* check that if there is an offset in the model it is constant within
	   each table cell or that the -nooffset- option of -adjust- was
	   specified.
	*/
	qui sort `by'
	if "`e(offset)'" != "" & "`offset'" == "" {
		local offnam `e(offset)'
		if bsubstr("`offnam'",1,3) == "ln(" {
			local offnam=bsubstr("`offnam'",4,length("`offnam'")-4)
		}
		cap by `by': assert `offnam'==`offnam'[_n-1] if _n > 1
		if (_rc != 0) {
			di as err /*
			    */ "offset (`e(offset)') not constant within by()"
			exit 198
		}
	}

	/* get the individual predictions (and errors if required) */
	/* For this the asis variables are left completely as is while the
	   covars have been set to their mean (or other specified values). */
	
	/* `gen1', `gen2' must be the default -generate- type and 
	    intermediate computations (`xb') must be double */
	if `ngen' > 0 { /* get individual predictions */
		/* always start with xb */
		tempvar xb
		qui _predict double `xb', xb `eqopt' `offset'
		/* if -pr- or -exp- then prprog the xb values in gen1 */
		cap gen `gen1' = `xb'
		`prprog' `gen1' `xb'
		label var `gen1' "`label'"
	}
	if `ngen' > 1 { /* get individual error (stdp or stdf) */
		if "`errtype'" == "" {
			qui _predict `gen2', stdp `eqopt' `offset'
		}
		else {
			qui _predict `gen2', `errtype' `eqopt' `offset'
		}
		label var `gen2' "`selabel'"
	}


	/* Take care of asis variables. --- For the Table the asis variables
           are replaced with their mean within each cell defined by the by
           variables. */
	if "`asis'" != "" {
		qui sort `newby'
		tokenize "`asis'"
		local i 1
		while "``i''" != "" {
			/* make a copy of the asis var -- to restore later */
			tempvar asis`i'
			gen `asis`i'' = ``i''
			/* replace asis variable with mean for each by cell */
			qui by `newby' : replace ``i'' = sum(``i'')/_N
			/* _N ok here because no missing values */
			qui by `newby' : replace ``i'' = ``i''[_N]
			local i = `i' + 1
		}
	}


	/* Do predictions with all substitutions in force */
	/* We could have collapsed down to one observation per table cell
	   at this point except that we need to get the data back in good
           shape in case we are merging in generated variables later.  The
           collapsing to one observation per cell is done inside DoTable */
	tempvar myxb myse
	/* use double to obtain values used to construct the table */
	qui _predict double `myxb', xb `eqopt' `offset'    /* always use xb */
	if "`errtype'" == "" {
		qui _predict double `myse', stdp `eqopt' `offset'
	}
	else {
		qui _predict double `myse', `errtype' `eqopt' `offset'
	}


	/* restore the original asis variables */
	if "`asis'" != "" {
		tokenize "`asis'"
		local i 1
		while "``i''" != "" {
			qui replace ``i'' = `asis`i''
			qui drop `asis`i''
			local i = `i' + 1
		}
	}

	/* restore the by vars that are also covars to their original values */
	tokenize "`byinc'"
	local i 1
	while "``i''" != "" {
		qui replace ``i'' = `tmp`i''
		qui drop `tmp`i''
		local i = `i' + 1
	}

	/* display some table header info */
	if "`header'" != "noheader" {
		Header "`generat'" "`asis'" "`by'" "`covars'" "`covals'" /*
			*/ "`thevals'" "`edvar'" "`equatio'" "`ecmd'"
	}

	/* create and display the table of results */
	DoTable "`key'" "`by'" "`myxb'" "`myse'" `"`label'"' `"`selabel'"' /*
		*/ "`esttype'" "`errtype'" "`ci'" `"`cilabel'"' "`level'" /*
		*/ "`prprog'" "`vertica'" "`tabopts'" "`format'" "`replace'"

	/* Don't restore if we are replacing the data with the Table */
	if "`replace'" != "" {
		restore, not
	}
	/* If we generated vars then merge them in original sorted order */
	else if `ngen' > 0 {
		keep `id' `generat'
		sort `id'
		tempfile hold
		qui save "`hold'"
		restore, preserve
		sort `id'
		tempvar junk
		merge `id' using "`hold'" , _merge(`junk')
		drop `junk'
		if "`sorted'" != "" { sort `sorted' }
		restore, not
	}
end


* CheckBy checks the by() option variables which are passed on 
* the command line for repeats.
program CheckBy /* <byvars> */
	Repeats `*'
	if "`r(replist)'" != "" {
		di in red "`r(replist)': specified twice in the by option"
		exit 198
	}
end


* CheckCmd is passed a string which should be the name of the estimation
* command last run.  This program checks if it is empty or one of the 
* unsupported estimation commands.
program CheckCmd  /* <estcmd> */
	if "`*'"=="" {
		di in red "This command must follow an estimation command"
		exit 301
	}
	/* check if the estimation command is one of the unsupported ones */
	if "`*'"=="areg" | "`*'"=="canon" | "`*'"=="nl" | "`*'"=="pca" {
		di in red "This command currently not allowed following `*'"
		exit 301
	}

/* Why this command will not follow certain estimation commands:

areg -- the variable specified in the -absorb()- required option does not
	have it's betas computed and so that variable is not handled as we
	might think by -predict-.  If we allowed this command the results 
	produced would not be what is expected.

nl   -- not designed to work with nonlinear estimation.

pca, canon  -- not typical estimation commands.

There are others that are not allowed (such as factor) and get trapped in one
way or another along the way (usually by _predict).
*/
end


* CheckEq checks if the equation() option was given and if so if it is valid.
* Also if the person passed in the equation number instead of name we find 
* the name.  We pass back the name or null. 
program CheckEq /* <equation option> */ , rclass
	args eqarg offset

	if `"`eqarg'"'=="" { /* user didn't specify equation() option */
		tempname bmat
		mat `bmat' = e(b)
		local names : coleq `bmat' , quote
		tokenize `"`names'"'
		if `"`1'"' == "_" {  /* there are no equation names */
			ret local eqname
		}
		else { /* return 1st eq. name since user didn't specify */
			ret local eqname `"`1'"'
		}
	}
	else { /* user specified equation() option */
		tempvar tmp
		/* This _predict to see if equation() option is valid */
		qui capture _predict `tmp' in 1, equation(`eqarg')
		if _rc {
			di in red `"equation(`eqarg') invalid"'
			exit 198
		}
		if bsubstr(trim(`"`eqarg'"'),1,1) == "#" { /* specified eq. # */
			local eqnum = bsubstr(trim(`"`eqarg'"'),2,.)
			/* double check that it is one number */
			qui capture confirm integer number `eqnum'
			if _rc {
				di in red `"equation(`eqarg') invalid"'
				exit 198
			}
			/* `eqnum' has equation number --- we want the name */
			tempname bmat
			mat `bmat' = e(b)
			local names : coleq `bmat' , quote
			tokenize `"`names'"'
			local i 1
			local k 1
			while `"``i''"' != "" & `k' <= `eqnum' {
				if `k' == `eqnum' {
					ret local eqname `"``i''"'
				}
				else {
					local j = `i' + 1
					while `"``j''"' == `"``i''"' {
						local j = `j' + 1
					}
					local i = `j'
				}
				local k = `k' + 1
			}
		}
		else { /* User gave equation name */
			if index(`"`eqarg'"',",") != 0 {
				/* If more than one equation name */
				di in red `"equation(`eqarg') invalid"'
				exit 198
			}
			ret local eqname `"`eqarg'"'
		}
	}
end


* CheckGen checks the generate() vars and returns the number of vars in
* r(ngen), the first var name in r(gen1), and the second in r(gen2).
program CheckGen  /* <genvars> <etype> <replace> */ , rclass
	args genvars etype replace

	if "`replace'" != "" & "`genvars'" != "" {
		di in red "cannot specify both generate() and replace"
		exit 198
	}

	local ngen 0
	if "`genvars'" != "" {
		confirm new variable `genvars'
		local ngen : word count `genvars'
		if `ngen' > 2 {
			di in red "one or two variables allowed in generate()"
			exit 198
		}
		local gen1 : word 1 of `genvars'
		if `ngen' == 2 { local gen2 : word 2 of `genvars' }
	}

	if "`etype'" == "" & `ngen' == 2 {
		di in red "`gen2' not allowed since se or stdf not specified"
		exit 198
	}

	ret local ngen "`ngen'"
	ret local gen1 "`gen1'"
	ret local gen2 "`gen2'"
end


* CheckOpt is passed many of the options and sorts them out to determine what
* will be estimated and what the labels will be.  It checks for invalid 
* combinations of options and reports an error if found.  If the -pr- option
* is specified then CheckOpt determines if it is supported for the estimation
* command and will pass back the name of the subroutine that will compute
* probabilities given xb values.  The estimate label, error label, and conf.
* inter. label are also returned.  The estimation type "xb" or "pr" or "exp" 
* is passed back as well as the error type "stdp", "stdf", or "".

program CheckOpt, rclass
	args xb pr exp se stdf ci lab selab cilab ec lev elink

	/* Take care of the -xb-, -pr-, and -exp- options */
	if "`exp'" != "" { /* -exp- was specified */
		if "`xb'" != "" | "`pr'" != "" {
			di in red "only one of xb, pr, or exp may be specified"
			exit 198
		}
		ret local esttype "exp"
		ret local prprog "PrEXP"
	}
	else if "`pr'" != "" { /* -pr- was specified --- check if allowed */
		if "`xb'" != "" {
			di in red "only one of xb, pr, or exp may be specified"
			exit 198
		}
		#delimit ;
		if 	"`ec'" == "blogit" | "`ec'" == "clogit" |
			"`ec'" == "glogit" | "`ec'" == "logistic" |
			"`ec'" == "logit"  | "`ec'" == "svylogit" |
			"`ec'" == "xtlogit" { ;
			ret local prprog "PrLogit" ;
		} ;
		else if "`ec'" == "biprobit" | "`ec'" == "bprobit" |
			"`ec'" == "dprobit" | "`ec'" == "gprobit" |
			"`ec'" == "ivprobit" |
			"`ec'" == "probit" | "`ec'" == "svyprobit" |
			"`ec'" == "xtprobit" { ;
			ret local prprog "PrProbit" ;
		} ;
		else if "`ec'"=="binreg" {;
			if "`elink'"=="Identity"  {;
				ret local prprog "PrIdent" ;
			};
			else if "`elink'"=="Log" {;
				ret local prprog "PrEXP";
			};
			else if "`elink'"=="Logit" {;
				ret local prprog "PrLogit";
			};
			else if  "`elink'"=="Log complement" {;
				ret local prprog "PrClog";
			};
			else {;
				di as err
			 "pr option not allowed after binreg with `elink' link";
			};
		};
		else { ;
			di in red "pr option not allowed after `ec' command" ;
			exit 198 ;
		} ;
		#delimit cr
		ret local esttype "pr"
	}
	else { /* if not -pr- or -exp- then has to be -xb- */
		ret local esttype "xb"
		ret local prprog "*"   /* this comments out prprog command */
	}

	/* Take care of the -se- and -stdf- options --- default is null */
	if "`se'" != "" { /* -se- option specified */
		if "`stdf'" != "" {
			di in red "only one of `se' and `stdf' may be specified"
			exit 198
		}
		if "`return(esttype)'" != "xb" {
			di in red "se option allowed only with xb option"
			exit 198
		}
		ret local errtype "stdp"
	}
	else if "`stdf'" != "" { /* -stdf- option specified */
		if "`return(esttype)'" != "xb" {
			di in red "stdf option allowed only with xb option"
			exit 198
		}
		tempvar tmp
		/* This _predict to see if stdf option is valid */
		qui capture _predict `tmp' in 1, stdf 
		if _rc {
			di in red "stdf invalid with `ec' command"
			exit 198
		}
		ret local errtype "stdf"
	}

	/* Take care of labels */
	if `"`lab'"' != "" { /* user specified -label- */
		ret local label `"`lab'"'
	}
	else { /* use default -label- */
		if "`return(esttype)'" == "xb" {
			ret local label "Linear Prediction"
		}
		else if "`return(esttype)'" == "pr" {
			ret local label "Probability"
		}
		else if "`return(esttype)'" == "exp" {
			ret local label "exp(xb)"
		}
	}

	if `"`selab'"' != "" { /* user specified -selabel- */
		if "`return(errtype)'" == "" {
			di in red /*
			*/ "cannot specify selabel() without se or stdf option"
			exit 198
		}
		ret local selabel `"`selab'"'
	}
	else { /* use default -selabel- */
		if "`return(errtype)'" == "stdp" {
			ret local selabel "Standard Error"
		}
		else if "`return(errtype)'" == "stdf" {
			ret local selabel "Standard Error (forecast)"
		}
	}

	if "`ci'" != "" { /* confidence intervals requested */
		if `"`cilab'"' != "" { /* user specified -cilabel- */
			ret local cilabel `"`=strsubdp("`lev'")'% `cilab'"'
		}
		else { /* use default -cilabel- */
			if "`return(errtype)'" == "stdf" {
ret local cilabel `"`=strsubdp("`lev'")'% Prediction Interval"'
			}
else {	ret local cilabel `"`=strsubdp("`lev'")'% Confidence Interval"' }
		}
	}
	else { /* no confidence intervals requested */
		if `"`cilab'"' != "" {
			di in red /*
			*/ "cannot specify cilabel() without the ci option"
			exit 198
		}
	}
end


* CheckVar checks that every element of vlist is in blist -- error if not.
* It also checks that there are no repeats in vlist.
program CheckVar  /* <vlist> <blist> */
	args vlist blist

	/* check for repeats in vlist */
	Repeats `vlist'
	if "`r(replist)'" != "" {
		di in red "`r(replist)': specified twice in the varlist"
		exit 198
	}

	/* check vlist is in blist */
	Subtract "`vlist'" "`blist'"
	if "`r(list)'" != "" {
		di in red "`r(list)' -- not used in last estimation"
		exit 198
	}
end


* DispWrap displays the <first> message followed by a list of the
* <vars> = <vals>.  It keeps the output within the <width> of the display
* and each new line is indented <tab> amount.  If there are no <vals> then
* just <vars> are output.  If there are fewer <vals> then <vars> then the
* last <vars> are output without <vals>.
program DispWrap /* <width> <tab> <first> <vars> [<vals>] */
	args width tab first vars vals 
	local nvar : word count `vars'

	local used = length("`first'")
	di in gr "`first'" _c
	local i 1
	while `i' <= `nvar' {
		local avar : word `i' of `vars'
		local avar = abbrev("`avar'",12)
		local aval : word `i' of `vals'
		local aval : display `aval'
		local chunk = 1 + length("`avar'")
		if "`aval'" != "" {
			local chunk = `chunk' + 3 + length("`aval'")
		}
		if `i' != `nvar' { local chunk = `chunk' + 1 }
		if (`used'+`chunk') > `width' {
			di ""
			di _dup(`tab') " " _c
			local used = `tab' + `chunk'
		}
		else { local used = `used' + `chunk' }
		di in gr " `avar'" _c
		if "`aval'" != "" { di in gr " = `aval'" _c }
		if `i' != `nvar' { di in gr "," _c }
		local i = `i' + 1
	}
	di ""
end


* DoTable collapses the data based on the <byvars>.  It works with xb <xbvar> 
* and either stdf or stdp <evar>.  As needed it then transforms (using the
* <prg> subroutine -- if <prg> is * then no transform) the result to what the
* user requested <type> and <etype>.  <ci> tells if conf. intervals have been
* requested.  <cilab>, <lab>, and <elab> are used as labels for the confidence
* intervals, prediction, and error.  Extra tabdisp options are passed in
* <tabopts>. The program displays the created table.
program DoTable
	args key byvars xbvar evar lab elab type etype ci cilab lev prg /*
		*/ vert tabopts fmt replace

	if "`replace'" == "" {
		preserve
	}
	else { /* We are to replace data with table -- need non-tempvars */
		capture confirm new var `type'
		if _rc == 0 {
			rename `xbvar' `type'
			local xbvar "`type'"
		}
		else {
			rename `xbvar' _`type'
			local xbvar "_`type'"
		}
		if "`etype'" != "" {
			capture confirm new var `etype'
			if _rc == 0 {
				rename `evar' `etype'
				local evar "`etype'"
			}
			else {
				rename `evar' _`etype'
				local evar "_`etype'"
			}
		}
	}

	local nby : word count `byvars'

	/* collapse to one observation per cell of the table */
	sort `byvars'
	qui by `byvars' : keep if _n==1


	/* Take care of confidence interval if requested */
	if "`ci'" != "" {
		if "`replace'" != "" { /* create non-tempvars for CI */
			capture confirm new var lb ub
			if _rc == 0 {
				local lb "lb"
				local ub "ub"
			}
			else {
				local lb "_lb"
				local ub "_ub"
			}
		}
		else { /* create tempvars for CI */
			tempvar lb ub
		}
		if e(df_r) >= . { /* use invnorm() for conf. int. */
gen double `lb' = `xbvar' - invnorm((100+`lev')/200) * `evar'
gen double `ub' = `xbvar' + invnorm((100+`lev')/200) * `evar'
		}
		else { /* use invt() for conf. int. */
gen double `lb' = `xbvar' - invt(e(df_r),`lev'/100) * `evar'
gen double `ub' = `xbvar' + invt(e(df_r),`lev'/100) * `evar'
		}
		/* if pr then transform bounds */
		`prg' `lb'
		`prg' `ub'

* For -binreg- with log complement link function, switch the `lb' and `ub'
		if "`prg'"=="PrClog" {
			tempvar a
			qui gen double `a'=`lb'
			qui replace `lb'=`ub'
			qui replace `ub'=`a'
		}
		if `nby' == 1 { /* Put CI side by side for simple table */
			tempvar cilb ciub
			qui gen str1 `cilb' = ""
			qui gen str1 `ciub' = ""
			local i 1
			while `i' <= _N {
				local lbs : di `fmt' `lb'[`i']
				local ubs : di `fmt' `ub'[`i']
				qui replace `cilb' = "[" + trim("`lbs'") /*
					*/ in `i' if `lb'<. & `ub'<.
				qui replace `ciub' = trim("`ubs'") + "]" /*
					*/ in `i' if `lb'<. & `ub'<.
				local i = `i' + 1
			}
			local short3a "lb"
			local short3b "ub"
			label var `cilb' "`short3a'"
			label var `ciub' "`short3b'"
			local cell "`cilb' `ciub'"
		}
		else if "`vert'" == "" { /* no stacking of CIs */
			tempvar cis
			qui gen str1 `cis' = ""
			local i 1
			while `i' <= _N {
				local lbs : di `fmt' `lb'[`i']
				local ubs : di `fmt' `ub'[`i']
				qui replace `cis' = "[" + trim("`lbs'") + "," /*
					*/ + trim("`ubs'") + "]" in `i' /*
					*/ if `lb'<. & `ub'<.
				local i = `i' + 1
			}
			local cell "`cis'"
		}
		else { /* CIs are to be stacked */
			tempvar cilb ciub
			qui gen str1 `cilb' = ""
			qui gen str1 `ciub' = ""
			local i 1
			while `i' <= _N {
				local lbs : di `fmt' `lb'[`i']
				local ubs : di `fmt' `ub'[`i']
				qui replace `cilb' = "[" + trim("`lbs'")+"," /*
					*/ in `i' if `lb'<. & `ub'<.
				qui replace `ciub' = trim("`ubs'") + "]" /*
					*/ in `i' if `lb'<. & `ub'<.
				local i = `i' + 1
			}
			local cell "`cilb' `ciub'"
		}
	}

	/* take care of prediction --- get into display format */
	`prg' `xbvar' /* transform xbvar if -pr- or -exp- */
	tempvar sxb
	qui gen str1 `sxb' = ""
	local i 1
	while `i' <= _N {
		local tmps : di `fmt' `xbvar'[`i']
		qui replace `sxb' = trim("`tmps'") in `i' if `xbvar'<.
		local i = `i' + 1
	}
	if "`type'" == "xb" { local short1 "xb" }
	else if "`type'" == "pr" { local short1 "pr" }
	else if "`type'" == "exp" { local short1 "exp(xb)" }
	label var `sxb' "`short1'"

	/* take care of error --- get into display format */
	if "`etype'" != "" {
		tempvar sevar
		qui gen str1 `sevar' = ""
		local i 1
		while `i' <= _N {
			local tmps : di `fmt' `evar'[`i']
			qui replace `sevar' = "("+trim("`tmps'")+")" in `i' /*
				*/ if `evar'<.
			local i = `i' + 1
		}
		if "`etype'" == "stdp" { local short2 "stdp" }
		else if "`etype'" == "stdf" { local short2 "stdf" }
		label var `sevar' "`short2'"
	}

	/* finish building the cell variable list */
	local cell "`sxb' `sevar' `cell'"

	/* now we create the table */
	tokenize "`byvars'"
	if `nby' > 3 {
		tabdisp `1' `2' `3', c(`cell') by(`4' `5' `6' `7') `tabopts' 
	}
	else {
		tabdisp `1' `2' `3', c(`cell') `tabopts'
	}

	/* add key to bottom of table */
	if "`key'" != "nokey" {
		if `nby' > 1 {
			di in gr "     Key:  `lab'"
			if "`etype'" != "" { di in gr "           (`elab')" }
			if "`ci'" != "" { di in gr "           [`cilab']" }
		}
		else {
			local spot = length("`short1'")
			if "`etype'" != "" {
				local tmpsp = length("`short2'")
				if `tmpsp' > `spot' {
					local spot `tmpsp'
				}
			}
			if "`ci'" != "" {
				local tmpsp = length("[`short3a' , `short3b']")
				if `tmpsp' > `spot' {
					local spot `tmpsp'
				}
			}
			local spot = `spot' + 14
			di in gr "     Key:  `short1'" _col(`spot') "=  `lab'"
			if "`etype'" != "" {
				di in gr "           `short2'" _col(`spot') /*
					*/ "=  `elab'"
			}
			if "`ci'" != "" {
				di in gr "           [`short3a' , `short3b']" /*
					*/ _col(`spot') "=  [`cilab']"
			}
		}
	}

	if "`replace'" != "" {
		label var `xbvar' "`lab'"
		if "`etype'" != "" { label var `evar' "`elab'" }
		if "`ci'" != "" {
			label var `lb' "l.b. of `cilab'"
			label var `ub' "u.b. of `cilab'"
		}
		qui compress
	}
end


* GetbName gets the names off of the b vector deleting the _cons name and
* any other troublesome names (like _se for tobit).  The names from -[m]anova-
* are handled differently.  If the second argument is present then we restrict
* ourselves to that equation.  We return the names in r(names).
program GetbName /* <cmdname> <eqname or null> */ , rclass
	args cmdname eqname

	if "`cmdname'" == "anova" {
		local bnames "`e(varnames)'"
	}
	else if "`cmdname'" == "manova" {
		local bnames "`e(indepvars)'"
	}
	else {
		tempname b
		matrix `b' = e(b)
		if "`eqname'" != "" {
			matrix `b' = `b'[1...,`"`eqname':"']
		}
		local bnames : colnames(`b')
		/* remove troublesome names from beta vector */
		Subtract "`bnames'" "_cons _se"
		Substub "`r(list)'" "_cut"  /* remove _cut# */
		tsrevar `r(list)' , list    /* remove time-series operators */
		local bnames "`r(varlist)'"
	}
	ret local names "`bnames'"
end


* Header displays preliminary information before the table is displayed
program Header
	args genvars asis by covars covals thevals depv eqname cmd

	/*
	genvars --- names of generated variables
	asis    --- names of variables left as is
	by      --- names of the by variables
	covars  --- names of the covariates that were set
	covals  --- values covars were set to or the word "mean"
	thevals --- values covars were set to
	depv    --- name of dependent variable or empty
	eqname  --- name of equation or empty
	cmd     --- estimation command name
	*/

	local nby : word count `by'
	local ncov : word count `covars'
	local ngen : word count `genvars'
	local nasis : word count `asis'

	local width : set display linesize /* allowed width for header */
	local tab 24   /* length of header second line indenting */
	local smtab 5 /* a small tab */

	di _n in smcl in gr "{hline `width'}"

	/* Display the dependent variable name or equation name (if any) */
	if "`depv'" != "" {
		di in gr "     Dependent variable: " abbrev("`depv'",12) /*
			*/ _dup(`smtab') " " _c
		local alen = 25 + length(abbrev("`depv'",12)) + `smtab'
	}
	else {
		if "`eqname'" != "" {
			di in gr _dup(15) " " _c
			local alen 15
		}
		else {
			di in gr _dup(16) " " _c
			local alen 16
		}
	}
	if "`eqname'" != "" {
		local blen = 10 + length(abbrev("`eqname'",12))
		if `alen' + `blen' > `width' {
			di
			di in gr _dup(15) " " _c
			local alen 15
		}
		di in gr "Equation: " abbrev("`eqname'",12) _c
		local alen = `alen' + `blen'
		if `alen' + `smtab' > `width' {
			di
			di in gr _dup(16) " " _c
			local alen 16
		}
		else {
			di in gr _dup(`smtab') " " _c
			local alen = `alen' + `smtab'
		}
	}
	local blen = length("Command: `cmd'")
	if `alen' + `blen' > `width' {
		di
		di in gr _dup(16) " " _c
	}
	di in gr "Command: `cmd'" 

	/* Display generated variables (if any) */
	if `ngen' == 1 {
		DispWrap "`width'" "`tab'" "       Created variable:" /*
			*/ "`genvars'"
	}
	else if `ngen' > 1 {
		DispWrap "`width'" "`tab'" "      Created variables:" /*
			*/ "`genvars'"
	}

	/* Display as is variables (if any) */
	if `nasis' == 1 {
		DispWrap "`width'" "`tab'" "    Variable left as is:" "`asis'"
	}
	else if `nasis' > 1 {
		DispWrap "`width'" "`tab'" "   Variables left as is:" "`asis'"
	}

	/* split covars and thevals into those set to mean and other */
	local i 1
	while `i' <= `ncov' {
		local tmpval : word `i' of `covals'
		local tmpthe : word `i' of `thevals'
		local tmpvar : word `i' of `covars'
		if "`tmpval'" == "mean" {
			local mvars "`mvars' `tmpvar'"
			local mvals "`mvals' `tmpthe'"
		}
		else {
			local ovars "`ovars' `tmpvar'"
			local ovals "`ovals' `tmpthe'"
		}
		local i = `i' + 1
	}
	local nmvars : word count `mvars'
	local novars : word count `ovars'

	/* Display the covariates and values they were set to */
	if `nmvars' == 1 {
		DispWrap "`width'" "`tab'" "  Covariate set to mean:" /*
			*/ "`mvars'" "`mvals'"
	}
	else if `nmvars' > 1 {
		DispWrap "`width'" "`tab'" " Covariates set to mean:" /*
			*/ "`mvars'" "`mvals'"
	}
	if `novars' == 1 {
		DispWrap "`width'" "`tab'" " Covariate set to value:" /*
			*/ "`ovars'" "`ovals'"
	}
	else if `novars' > 1 {
		DispWrap "`width'" "`tab'" "Covariates set to value:" /*
			*/ "`ovars'" "`ovals'"
	}
	di in smcl in gr "{hline `width'}"
end


* ParseVar parses the var[= #][var[= #]...] syntax and returns the variable
* names in s(vnames) and the values (or the word "mean") in s(values).  It
* will handle the * and - expansions.
program ParseVar  /* <varlist> */ , sclass
	tokenize "`*'", parse(" =-*")
	local i 1
	while "``i''" != "" {
		if "``i''" == "=" | "``i''" == "-" | "``i''" == "*" {
			di in red "``i'' used improperly in varlist"
			exit 198
		}
		local j = `i' + 1
		if "``j''" == "*" {  /*  * expansions */
			local k = `j' + 1
			if "``k''" == "-" {  /* * expansion with - */
				local m = `k' + 1
				unab tmpvar : ``i''``j''``k''``m''
				local varlist "`varlist' `tmpvar'"
				local temp : word count `tmpvar'
				local h 1
				while `h' <= `temp' {
					local vallist "`vallist' mean"
					local h = `h' + 1
				}
				local i = `i' + 4
			}
			else {  /*  * expansion without - */
				unab tmpvar : ``i''``j''
				local varlist "`varlist' `tmpvar'"
				local temp : word count `tmpvar'
				local h 1
				while `h' <= `temp' {
					local vallist "`vallist' mean"
					local h = `h' + 1
				}
				local i = `i' + 2
			}
		}
		else if "``j''" == "-" {  /* - expansion */
			local k = `j' + 1
			unab tmpvar : ``i''``j''``k''
			local varlist "`varlist' `tmpvar'"
			local temp : word count `tmpvar'
			local h 1
			while `h' <= `temp' {
				local vallist "`vallist' mean"
				local h = `h' + 1
			}
			local i = `i' + 3
		}
		else {  /* no * or - expansion */
			unab tmpvar : ``i''
			local varlist "`varlist' `tmpvar'"
			if "``j''" == "=" {  /* var=# syntax */
				local k = `j' + 1
				if "``k''" == "-" { /* negative sign */
					local neg "-"
					local k = `k' + 1
					local i = `i' + 1
				}
				else { /* no negative sign */
					local neg
				}
				capture noi confirm number `neg'``k''
				if _rc != 0 {
					di in red /*
			*/ "only numbers allowed in var = # form of varlist"
					exit _rc
				}
				local vallist "`vallist' `neg'``k''"
				local i = `i' + 3
			}
			else {  /* no *, -, or =  */
				local vallist "`vallist' mean"
				local i = `i' + 1
			}
		}
	}
	sret local vnames "`varlist'"
	sret local values "`vallist'"
end


* Repeats checks for repeated terms in <vlist> and returns a list of the 
* repeated terms in r(replist)
program Repeats  /* <vlist> */ , rclass
	local vlen : word count `*'
	local i 1
	while `i' < `vlen' {
		local j = `i' + 1
		while `j' <= `vlen' {
			if "``i''" == "``j''" {
				local reps "`reps' ``i''"
				local j = `vlen'
			}
			local j = `j' + 1
		}
		local i = `i' + 1
	}
	ret local replist "`reps'"
end


* SetCovs sets the <vars> to equal the values in <vals> or their mean 
* if <vals> says "mean".  It returns the vals (with the means replaced
* by actual values) in r(values)
program SetCovs  /* <vars> <vals>  */ , rclass
	args covars covals
	local ncov : word count `covars'
	local i 1
	tempvar tmpmean
	gen double `tmpmean' = 0
	while `i' <= `ncov' {
		local covari : word `i' of `covars'
		local covali : word `i' of `covals'
		if "`covali'" == "mean" {
			qui replace `tmpmean' = sum(`covari')/_N
			/* divide by _N ok because dropped missing values */
			qui replace `covari' = `tmpmean'[_N]
			local amean = `tmpmean'[_N]
			local coval2 "`coval2' `amean'"
		}
		else { 
			qui replace `covari' = `covali' 
			local coval2 "`coval2' `covali'"
		}
		local i = `i' + 1
	}
	ret local values "`coval2'"
end


* Subtract removes the tokens in elist from flist and returns the 
* "cleaned" flist in r(list).
program Subtract /* <flist> <elist> */ , rclass
	args flist elist

	local nelist : word count `elist'
	tokenize `flist'

	local i 1
	while "``i''" != "" {
		local j 1
		while `j' <= `nelist' {
			local eword : word `j' of `elist'
			local j = `j' + 1
			if "`eword'" == "``i''" {
				local `i' " "
				local j = `nelist' + 1
			}
		}
		local i = `i' + 1
	}

	ret local list `*'
end


* Substub removes any tokens in flist that begin with the tokens in elist
* and returns the "cleaned" flist in r(list).
program Substub  /* <flist> <elist> */ , rclass
	args flist elist
	local nelist : word count `elist'

	tokenize "`flist'"
	local i 1
	while "``i''" != "" {
		local j 1
		while `j' <= `nelist' {
			local eword : word `j' of `elist'
			local j = `j' + 1
			if "`eword'" == bsubstr("``i''",1,length("`eword'")) {
				local `i' " "
				local j = `nelist' + 1
			}
		}
		local i = `i' + 1
	}

	ret local list `*'
end


* PrEXP replaces the variable sent in (first argument) from an xb value to an
* exp(xb) value.  Depending on the estimation model this transformation has
* different names (hazard ratio, incidence rate, count, ...).
program PrEXP
	args var xb
	if `"`xb'"' == "" {
		qui replace `var' = exp(`var')
	}
	else {
		qui replace `var' = exp(`xb')
	}
end


* PrLogit replaces the variable sent in (first argument) from an xb value to a
* probability according to the logit transformation.
program PrLogit
	args var xb
	if `"`xb'"' == "" {
		qui replace `var' = exp(`var')/(1+exp(`var'))
	}
	else {
		qui replace `var' = exp(`xb')/(1+exp(`xb'))
	}
end


* PrProbit replaces the variable sent in (first argument) from an xb value to 
* a probability according to the probit transformation.
program PrProbit
	args var xb
	if `"`xb'"' == "" {
		qui replace `var' = normprob(`var')
	}
	else {
		qui replace `var' = normprob(`xb')
	}
end


* PrClog replaces the variable sent in (first argument) from an xb value to a
* probability according to the log complement transformation
* (used in -binreg- with -hr-).
program PrClog
	args var xb
	if `"`xb'"' == "" {
		qui replace `var'=-expm1(`var')
	}
	else {
		qui replace `var'=-expm1(`xb')
	}
end


*PrIdent replaces the variable sent in (first argument) from an xb value to a
* probability according to the identical transformation
* (used in -binreg- with -rd-).
program PrIdent
/*	qui replace `1'=`1'	*/
	exit	/* do nothing	*/
end

