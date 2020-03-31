*! version 1.0.5  03may2019
/* 
	parses univariate imputation methods
	global objects:
		creates new variables containing expressions --
		  __mi_impute_expr* (if no names given ) 
*/
program u_mi_impute_cmd__uvmethod_parse, sclass
	version 12
	syntax [anything(equalok)] [if] [aw fw pw iw],	///
			impobj(string)			/// //internal
			method(string)			/// //internal
		[					/// 
			NOCONStant			///
			NOIsily				///
			BOOTstrap			///
			CONDitional(string asis)	///
			NOLEGend			///
			NOCMDLEGend			/// //undoc.
			SHOWCOMMAND			/// //undoc.
			omittedvaryok			/// //undoc.
			NONESTEDCHK			/// //undoc.
			cmd(string)			/// //internal
			cmdname(string)			/// //internal
			cmdopts(string)			/// //internal 
			STUB(name)			/// //internal 
			EXPROK				/// //internal
			IVARSNOTALLOWED(varlist)	/// //internal
			IVARSALLOWED(varlist)		/// //internal
 			IVARSNESTED(varlist)		/// //internal
			NOIVARSEXP(varlist)		/// //internal
			NOIVAREXP			/// //internal
			IVAREXPALLOWED			/// //internal
			HASMISSING			/// //internal
			NOMISSNOTE			/// //internal
			depvars(string)			/// //internal
			ifgroup(string)			/// //internal
			ivarasxvarsok			/// //internal
			NORHSINIT			/// //internal
			NOCONSOK			/// //internal
			internalcmd			/// //internal
		]
	if ("`indent'"=="") {
		local indent 0 4 2
	}
	if ("`errindent'"=="") {
		local errindent 0 4 2
	}
	if ("`cmdname'"=="") {
		local cmdname `method'
	}
	if ("`cmd'"=="") {
		local cmd `cmdname'
	}
	local wtype "`weight'"
	if ("`wtype'"=="iweight") & ///
	   ("`method'"=="regress" | "`method'"=="pmm") {
		local wtype fweight
	}
	if ("`wtype'"=="fweight") {
		tempvar wgt
		qui gen double `wgt'`exp'
	}
	if ("`bootstrap'"!="" & "`weight'"!="") {
		di as err "{p 0 0 2}{bf:mi impute `method'}: {bf:bootstrap}"
		di as err "is not allowed in combination with weights{p_end}"
		exit 198
	}
	local ivarsnotallowed `ivarsnotallowed' `depvars'
	// parse and check <ivars>
	gettoken ivars aftereq: anything, parse("=")
	gettoken eq xspec: aftereq, parse("=")
	if ("`eq'"=="") {
		gettoken ivars xspec: ivars
	}
	u_mi_impute_check_ivars ivars : "`ivars'" "1"
	// -noconstant-
	if ("`xspec'`noconsok'"=="" & "`noconstant'"!="") {
		di as err as smcl "{p `errindent'}{bf:noconstant} is " 	///
				  "not allowed without independent "	///
				  "variables{p_end}"
		exit 198
	}
	// 'touse' marks missing-value (imputation) sample
	tempvar touse
	mark `touse' `if' `in'
	markout `touse' `ivars', sysmissok
	local style `_dta[_mi_style]'
	if ("`style'"=="mlong" | "`style'"=="flong") { // must use m0
		sort _mi_m _mi_id // make sure data are sorted before parse
		qui replace `touse' = 0 if _mi_m>0
	}
	if ("`ifgroup'"!="") {
		qui replace `touse'=0 if !(`ifgroup') & `touse'
	}
	// check <xspec>
	local k_exp 0
	if ("`exprok'"!="") {
		if ("`ivarexpallowed'"=="") {
			local ivarsnotallowed `ivarsnotallowed' `ivars'
		}
		if ("`noivarexp'`noivarsexp'"!="") {
			local ivarsexpnames ivarsexpnames(`ivars' `noivarsexp')
		}
		if ("`stub'"=="") {
			u_mi_getstubname stub : "__mi_impute_expr"
		}
		u_mi_impute_parse_exp_ivars `xspec', 			///
				stub(`stub')				///
				ivarsallowed(`ivarsallowed')		///
				ivarsnotallowed(`ivarsnotallowed')	///
				`ivarsexpnames'
		local k_exp	`r(k_exp)'
		local xvars 	`r(xvars)'	// unabbr.
		local expnames 	`r(expnames)'
		local xlist 	`r(xlist)'	// resulting unabbr. <xlist>
		local xlistmon	`xlist'
		local xspecmon	`xspec'
		if (`k_exp' > 0) { // generate expressions
			if ("`noivarexp'"!="") {
				local ivexpnames "`r(`ivars'_expnames)'"
				local ivexplists "`r(`ivars'_explists)'"
				local xlist : list xlist - ivexpnames
				local xspec : list xspec - ivexplists
				local expnames : list expnames - ivexpnames
			}
			local xlistmon `xlist'
			local xspecmon `xspec'
			local expnamesmon `expnames'
			if ("`noivarsexp'"!="") {
				local ivexpnamesmon "`r(iv_expnames)'"
				local ivexplistsmon "`r(iv_explists)'"
				local xlistmon : list xlistmon - ivexpnamesmon
				local xspecmon : list xspecmon - ivexplistsmon
				local expnamesmon : ///
					list expnamesmon - ivexpnamesmon
			}
			tokenize `expnames'
			local k_exp : word count `expnames'
			forvalues i=1/`k_exp' {
				qui gen double ``i'' = `r(``i''_exp)' if `touse'
				// label variable ``i'' `"`r(``i''_exp)'"'
				char ``i''[_mi_expr] `r(``i''_exp)'
			}
		}
	}
	else if (`"`xspec'"'!="") {
		_chk_ts `xspec'
		fvunab xvars : `xspec'
		local xlist `xvars'
		unopvarlist `xvars'
		local xvars `r(varlist)'
		confirm numeric variable `xvars'
		local xspec `xlist'
		local xspecmon `xlist'
		local xlistmon `xlist'
	}
	// check if imputed vars are used as regressors
	local bad : list ivars & xvars
	if ("`bad'"!="" & "`ivarasxvarsok'"=="") {
		local n : word count `bad'
		di as err "{p `errindent'}"			///
			  "{bf:`bad'}: imputation "		///
			  plural(`n',"variable")		///
			  " cannot be also specified as independent " 	///
			  plural(`n',"variable") "{p_end}"
		exit 198
	}
	else if ("`bad'"!="") { 
		local xlist : list xlist - ivars
		local xlistmon : list xlistmon - ivars
	}
	// check if any not-allowed-imp. vars are used as regressors
	local bad : list ivarsnotallowed & xvars
	if ("`bad'"!="") {
		local n : word count `bad'
		di as err "{p 0 4 2}" plural(`n',"variable") 
		di as err " {bf:`bad'} used to model"
		di as err "{bf:`ivars'} and " plural(`n',"has","have")
		di as err "at least as many missing values as"
		di as err "{bf:`ivars'}; this is not allowed{p_end}"
		exit 198
	}
	// check if any registered imp. vars are used as regressors
	local imputed	`_dta[_mi_ivars]'
	local tochk : list imputed - ivars
	local tochk : list tochk - ivarsallowed
	local bad : list tochk & xvars
	if ("`bad'"!="") {
		local n1: word count `bad'
		local n2: word count `ivars'
		di as txt "{p 0 6 2}note: " plural(`n1',"variable") 	/// 
			  " {bf:`bad'} registered as "		///
			  "imputed and used to model "		///
			  plural(`n2',"variable") 		///
			  " {bf:`ivars'}; this may cause "	///
			  "some observations to be omitted "  	///
			  "from the estimation and may lead "	///
			  "to missing imputed values{p_end}"	
	}
	// further checks require `touse' identifying missing-value sample
	// handle -conditional()-
	tempvar tousecond
	qui gen byte `tousecond' = `touse'
	if (`"`conditional'"'!="") {
		if (bsubstr(`"`conditional'"',1,3)=="if ") {
			gettoken condif conditional : conditional
		}
		local conditional = trim(`"`conditional'"')
		// identify if imp. var is used in -conditional()-
		local imputedrest : list imputed - ivarsnested
		local imputedrest : list imputedrest - ivars
		u_mi_impute_check_condexp condvars : ///
			`"`conditional'"' "`ivars' `ivarsnested' `imputedrest'"
		if ("`condvars'"!="") {
			local ipos : list posof "`ivars'" in condvars
			if (`ipos') {
				di as err "{p `errindent'}"
				di as err "{bf:conditional()}: imputation"
				di as err "variable {bf:`ivars'}"
				di as err "cannot be used in expression "
				di as err `"({bf:`conditional'}){p_end}"'
				exit 198
			}
		}
		if ("`condvars'"!="" & "`nonestedchk'"=="") {
			//checks if nested within imputation sample
			local erreq 0
			foreach condvar in `condvars' { 
				qui mi misstable nested `condvar' `ivars' ///
								if `touse'
				local K = r(K)
				qui count if `condvar'==.
				local N_mis = r(N)
				qui count if `ivars'==.
				if (`K'>1 | `N_mis'>r(N)) {
					if (!`erreq') {
						di as err "{p 0 0 2}"
						di as err ///
				"{bf:conditional()}: conditioning variables"
						di as err "not nested;{p_end}"
					}
					if (`: list condvar in imputedrest') {
di as err "{p 4 4 2}"
di as err "conditioning variable"
di as err "{bf:`condvar'} is registered as imputed and is not nested"
di as err  "within {bf:`ivars'}{p_end}"
					}
					else {
di as err "{p 4 4 2}"
di as err "conditioning variable"
di as err "{bf:`condvar'} is not nested"
di as err  "within {bf:`ivars'}{p_end}"
					}
					local ++erreq
				}
			}
			if (`erreq') {
				exit 459
			}
		}
		qui summ `ivars' if !(`conditional') & `touse', meanonly
		if (r(max)>r(min)) {
			di as err "{p 0 0 2}"
			di as err "{bf:conditional()}: imputation"
			di as err "variable not constant outside"
			di as err "conditional sample;{p_end}"
			di as err "{p 4 4 2}{bf:`ivars'} is not constant"
			di as err "outside the subset identified by"
			di as err `"{bf:(`conditional')} within the"'
			di as err `"imputation sample{p_end}"'
			exit 459
		}
		local cond = 1
		local condval = r(min)
		local N_outcond = r(N)
		if (`"`if'"'!="") {
                        local ifcond `if' & `conditional'
                }
                else {
                        local ifcond if `conditional'
                }
		qui replace `tousecond'=0 if !(`conditional')
	}
	else {
		local cond = 0
		local condval = .
		local N_outcond = 0
		local ifcond `if'
	}
	qui count if `tousecond'
	local Nobs = r(N)
	if (`Nobs'==0) {
		error 2000
	}
	// sets imputation sample
	if ("`method'"=="intreg") {
		local setdepvars `", "`depvars'""'
	}
	local omittedvaryok omittedvaryok //intended
	mata:	`impobj'.haslegend = ("`nolegend'"=="");	///
		`impobj'.setmissingsample("`ivars'", "`touse'",	///
					"`wtype'","`wgt'" `setdepvars',	///
					("`omittedvaryok'"!=""),	///
					`cond',`condval')
	// check if <ivars> have missing
	qui u_mi_ivars_musthave_missing nbadvars bad : ///
				"`ivars'" "`touse'" "nomissok" "`indent'"
	local ivarsinc : list ivars - bad
	local ivarscmsg hasmissing
	if (`nbadvars'==1) {
		if ("`hasmissing'"=="") {
			local ivarscmsg
		}
		local nomiss nomiss
	}
	else {
		if (`Nobs'==1) {
			error 2001
		}
	}
	u_mi_impute_note_nomiss "`bad'" "`ivarscmsg'" "`nomissnote'"
	if ("`method'"=="logit" & "`nomiss'"=="") {
		qui summ `ivars' if `tousecond', meanonly
		if (r(min)!=0 | r(min)==r(max)) {
			di as err "outcome does not vary; remember:"
			di as err _col(35) "0 = negative outcome,"
			di as err _col(9) ///
				"all other nonmissing values = positive outcome"
			exit 2000
		}
	}
	if ("`nomiss'"=="" & `"`conditional'"'!="" & `N_outcond'==0) {
		di as err "{p 0 0 2}"
		di as err "{bf:conditional()}: no complete observations"
		di as err "outside conditional sample;{p_end}"
		di as err "{p 4 4 2}imputation variable contains"
		di as err "only missing values outside"
		di as err "the conditional sample.  This is not"
		di as err "allowed.  The imputation variable must"
		di as err "contain at least one nonmissing value"
		di as err "outside the conditional sample.{p_end}"
		exit 459
	}

	sret clear
	sret local nomiss	"`nomiss'"
	sret local conditional	`"`conditional'"'
	sret local xeqmethod	"_uvmethod"
	sret local xspec	"`xspec'"	// RHS specification w/o
						// expressions of <ivar>,
						// if -noivarexp-
	sret local xlist	"`xlist'"	// same as 'xspec' but
						// with actual variable names
						// substituted for expressions
	sret local xspecmon	"`xspecmon'"	// RHS specification w/o
						// expressions of `noivarsexp'
	sret local xlistmon	"`xlistmon'"	// same as 'xspecmon' but
						// with actual variable names
						// substituted for expressions
	sret local expnames	"`expnames'"	// generated expression 
						// variable names
	sret local expnamesmon	"`expnamesmon'"	// expression variable names
						// used for monotone imputation
	sret local ivars	"`ivars'"
	sret local ivarsinc	"`ivarsinc'"
	sret local condvars	"`condvars'"	// conditioning variables
	sret local ivarexpnames "`ivexpnames'"
	sret local ivarexpnamesmon "`ivexpnamesmon'"
	sret local ivarexplists "`ivexplists'"
	sret local ivarexplistsmon "`ivexplistsmon'"

	if ("`depvars'"=="") {
		local depvars `ivarsinc'
	}
	if ("`norhsinit'"!="") {
		local xlist
	}
	if (inlist("`method'","logit","ologit","mlogit") & ///
	    "`internalcmd'"!="") {
		local cmd _`cmd'
		di as txt "note: internal command `cmd' used for estimation"
	}
	else if ("`internalcmd'"!="") {
		di as err "{bf:internalcmd} is only allowed with logit, " ///
			  "ologit, and mlogit imputation methods"
		exit 198
	}
	sret local cmdlineinit `""`impobj'" "`method'" "`cmdname'" "`cmd'" "`ivarsinc'" "`depvars'" "`xlist'" `"`if'"' `"`ifcond'"' `"`conditional'"' "`ifgroup'" "`weight'" `"`exp'"' "`expnames'" "`expnamesmon'" "`noconstant'" "`bootstrap'" "`noisily'" "`showcommand'" `"`cmdopts'"' "`nocmdlegend'""'

	sret local cmdlineimpute `""`impobj'" "`method'" "`ivarsinc'" `"`if'"' `"`ifcond'"' `"`conditional'"' "`condval'" "`ifgroup'" "`expnames'" "`bootstrap'""'
	if ("`bootstrap'"!="") {
		sret local initinaloop initinaloop
	}

end

program _chk_ts
	syntax [varlist(default=none fv)]
end

/*
IVARSNOTALLOWED(varlist)-- <varlist> or its expressions (if -exprok-) not 
                           allowed in RHS because contain at least as many
                           missing values as <ivar>
ivarasxvarsok		-- <ivar> is allowed in RHS 
IVARSALLOWED(varlist)	-- no note about possible missing values is reported 
                           for registered imputed or passive variables in
                           <varlist> and their expressions
EXPROK 			-- allows expressions in RHS except expressions of
			-- <ivar> and <ivarsnotallowed>
IVAREXPALLOWED		-- allows expressions of all variables, including
			  <ivar> and <ivarsnotallowed> in RHS
NOIVAREXP		-- to determine expressions of <ivar> in RHS 
NOIVARSEXP(varlist)	-- to determine expressions of <varlist> in RHS
IVARSNESTED(varlist)	-- <varlist> must be nested within <ivar> in inc. obs.
NORHSINIT 		-- do not store 'xspec' in s(cmdlineinit)
HASMISSING 		-- for note about soft missing values
NOMISSNOTE 		-- no note about no soft missing values
depvars(string) 	-- for multiple dependent variables 
ifgroup(string) 	-- specific by() group
*/
