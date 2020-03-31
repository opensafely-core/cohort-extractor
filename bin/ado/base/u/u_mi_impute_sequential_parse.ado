*! version 1.0.7  07may2019
/* 
	general parser for -chained- and -monotone- 
	Global objects:
		instances of classes for univ. methods -- __mi_impute_clname*
		variables containing expressions
		global macros MI_IMPUTE_uvinit* MI_IMPUTE_uvimp*
*/
program u_mi_impute_sequential_parse, sclass
	local version : di "version " string(_caller()) ":"
	local caller = _caller()
	version 12
	syntax [anything(equalok)] [if/] [fw aw pw iw],		///
			impobj(string) 				/// //internal
		[						///
			Custom					///
		 	DRYRUN 					///
			AUGment					///
			BOOTstrap				///
			NOIMPuted 				///
		 	REPORT 					///
		   	NOLEGend				///
		 	VERBOSE					///
			NOIsily					///
			ORDERASIS				///
			NOMONOTONE				///
			NOMONOTONECHK 				///
			SHOWCOMMAND				/// //undoc.
			NOMISSNOTE				/// //undoc.
			OMITTEDVARYOK				/// //undoc.
			internalcmd				/// //undoc.
			methodname(string)			/// //internal
			ERRMONOTONE				/// //internal
			MUSTBEORDERED				/// //internal
			NOVARSCHK				/// //internal
			MONCUSTOMOK				/// //internal
			xlistok					/// //internal
			ifgroup(string)				/// //internal
			float					/// //internal
			double					/// //internal
			IVAREXISTS				/// //internal,
								/// //intreg
		]
	opts_exclusive "`augment' `bootstrap'"
	local vartype `float'`double'
	if ("`vartype'"=="") {
		local vartype float
	}
	local augment_gl `augment'
	local noimputed_gl `noimputed'
	local bootstrap_gl `bootstrap'
	local omittedvaryok_gl `omittedvaryok'
	local internalcmd_gl `internalcmd'
	local boottype 0
	if ("`bootstrap_gl'"!="") {
		local boottype 1
	}
	local showcommand_gl `showcommand'
	if ("`custom'"!="" | "`novarschk'"!="") {
		local exprok exprok
		local novarschk novarschk
	}
	local SYNCUSTOM INCLude(string)	OMIT(string) NOIMPuted
	if ("`methodname'"=="monotone") {
		local dicustom = cond(("`custom'"==""),"default ","custom ")
		if ("`moncustomok'"=="") {
			local SYNCUSTOM
		}
	}
	if ("`custom'"!="") {
		local xlistok xlistok
	}
	local noisily_gl `noisily'
	// check options
	if (`"`anything'"'=="") {
		di as err "{bf:mi impute `methodname'}: at least one "	///
			  "imputation model must be specified"
		exit 198
	}
	if ("`dryrun'"!="" & "`verbose'"!="") {
		di as err "{bf:dryrun} and {bf:verbose} cannot be combined"
		exit 198
	}
	// global weights and 'if'
	if ("`weight'"!="") {
		local wgtexp_gl [`weight' `exp']
	}
	local if_gl `if'
	if (`"`if_gl'"'!="" & "`ifgroup'"!="") {
		local ifspec_gl (`if_gl') & (`ifgroup')
	}
	else {
		local ifspec_gl `if_gl'`ifgroup'
	}
	if (`"`ifspec_gl'"'!="") {
		local ifspec_gl if `ifspec_gl'
	}
	gettoken first kgroup : ifgroup, parse("==")
	gettoken first kgroup : kgroup, parse("==")
	if ("`kgroup'"=="") {
		local kgroup 1
	}
	if ("`report'"!="") {
		local showchk 
	}
	else {
		local showchk qui
	}
	// parse [= <indepspec>] with default specification 
	gettoken lhs xspec : anything, parse("=") bind 
	gettoken eq xspec : xspec, parse("=") 
	if (`"`xspec'"'!="" & "`novarschk'"=="") {
		if ("`custom'"!="") {
di as err "{bf:mi impute `methodname'}: invalid specification = {it:indepvars};"
di as err "{p 4 4 2}specification {bf:`eq'`xspec'} is not allowed"
di as err "when option {bf:custom} is used.  Perhaps,"
di as err "you meant to use default specification; see"
di as err "{helpb mi_impute_`methodname':mi impute `methodname'} for details."
di as err "{p_end}"
exit 198
		}
		local 0 `xspec'
		cap noi {
			syntax [varlist(fv numeric)]
			local xspec `varlist'
			unopvarlist `xspec'
			local xvars `r(varlist)' 
		}
		if _rc {
			dierreq 1 "" `"= `xspec'"'
			exit _rc
		}
	}
	//preliminary basic checks of all equations, builds imp. varlist
	gettoken spec : lhs, parse("()") match(par)
	if "`par'"!="(" {
		di as err "imputation method specification must be "	///
			  "bound in parentheses"
		exit 198
	}
	local rest `lhs'
	local haserr 0		
	local continue 1
	local i 1
	local j 1
cap noi {
	while (`continue') {
		local erreq 0
		gettoken spec rest : rest, parse("()") match(par)
		if ("`custom'"!="" & "`par'"=="") {
		      	di as err "{bf:mi impute `methodname'}: invalid " ///
					"custom specification;"
			di as err "{p 4 4 2}each method specification"
			di as err "must be bound in parentheses"
			di as err "when option {bf:custom} is used.{p_end}"
			exit 198
		}
		_parse comma eqlhs eqrhs : spec
		gettoken method eqlhs : eqlhs
		cap noi u_mi_impute_check_method method : ///
			`"`method'"' "nothing" uvonly
		if (_rc) {
			local erreq 1
			local ++haserr
			local exitrc = _rc
		}
		if ("`custom'"=="") {
			local dierr "imputation variable required"
			local dierr "at least one imputation variable required"
			local dierr "`dierr'" ": {bf:(}{it:method} ..."
			local dierr "`dierr'" "{bf:)} {it:ivar(s)}"
			gettoken ivarscurr : rest, parse("()") match(par)
			local noivar = ("`ivarscurr'"=="")+("`par'"=="(")
			local ivarscurr
			if (!`noivar') {
				gettoken ivarscurr rest : rest, ///
							parse("()") match(par)
			}
		}
		else {
			local dierr "imputation variable required: {bf:(}"
			local dierr "`dierr'" "{it:method} {it:ivar} ...{bf:)}"
			gettoken ivarscurr : eqlhs
			local noivar =	("`ivarscurr'"=="")+	///
				      	("`ivarscurr'"=="if")+	///
					(bsubstr("`ivarscurr'",1,1)=="[")
			local ivarscurr
			if (!`noivar') {
				gettoken ivarscurr eqlhs : eqlhs
			}
		}
		if `noivar' {
			di as err "`dierr'"
			local erreq 1
			local ++haserr
			local exitrc = 198
		}
		local intregrc = 0
		if ("`method'"=="intreg" & !`noivar') {
			if (`:word count `ivarscurr''>1) {
				di as err "{p 0 2}{bf:`ivarscurr'}: only one"
				di as err "new variable name is allowed with"
				di as err "the {bf:intreg} method{p_end}"
				local erreq 1
				local ++haserr
				local exitrc = 198
				local intregrc 1
			}
			else if ("`ivarexists'"=="") {
				if (`"`eqrhs'"'=="") {
					local comma ,
				}
			 `version' cap noi u_mi_impute_cmd_intreg_parse ///
					`ivarscurr' `comma'`eqrhs' 	///
					impobj(name) createivaronly `vartype'
				if _rc {
					local erreq 1
					local ++haserr
					local exitrc = 198
					local intregrc 1
				}
			}
		}
		if !`noivar' & !`intregrc' {
			cap noi u_mi_mustbe_registered_imputed 	///
						bad ivarscurr : "`ivarscurr'"
			if (_rc) {
				local erreq 1
				local ++haserr
				local exitrc = _rc
			}
		}
		local ivars `ivars' `ivarscurr'
		// check ivars are not specified more than once
		local dups : list dups ivars
		if ("`dups'"!="") {
			local uniq: list uniq dups
			local n: word count `uniq'
			di as err "{p 0 0 2}{bf:`uniq'}: duplicates found;"
			di as err "{p_end}" 
			di as err "{p 4 4 2}variables cannot be specified" 
			di as err "as imputation variables in multiple "
			di as err "equations{p_end}"
			local erreq 1
			local ++haserr
			local exitrc = 198
			local ivars : list uniq ivars
		}
		// to build FV ivarlist
		local iscat=inlist("`method'","logit","ologit","mlogit")
		_parse_asc_aug asc aug : `"`eqrhs'"'
		local is_fv = (`iscat' & "`asc'"=="")
		if (!`iscat' & "`asc'`aug'"!="") {
			if ("`asc'"!="") {
				di as err "option {bf:ascontinuous} not " ///
				  "allowed with {bf:`method'}"
			}
			if ("`aug'"!="") {
				di as err "option {bf:augment} not " ///
				  "allowed with {bf:`method'}"
			}
			local erreq 1
			local ++haserr
			local exitrc = 198
		}
		local eqspec`i' "`eqlhs'`eqrhs'"
		if ("`custom'"=="") {
			local dieqspec (`method' `eqspec`i'') `ivarscurr'
		}
		else {
			local dieqspec (`method' `ivarscurr' `eqspec`i'')
		}
		dierreq `erreq' "" `"`dieqspec'"'
		gettoken spec : rest
		if (`"`spec'"'=="") {
			local continue 0
		}
		if (!`haserr') {
			local nvars : word count `ivarscurr'
			tokenize `ivarscurr'
			forvalues k=1/`nvars' { 
				//create method-specific objects
				mata: 	///
		u_mi_get_mata_instanced_var("clname`j'", "__mi_impute_clname")
				mata: `clname`j'' = _Imp_`method'()
				local clnames `clnames' `clname`j''
				local method`j' `method'
				local methods `methods' `method`j''
				local eqinds `eqinds' `i'
				if (`is_fv') {
					local fvopivars `fvopivars' i.``k''
				}
				else {
					local fvopivars `fvopivars' ``k''
				}
				local ++j
			}
		}
		local ++i
	} //end preliminary checks
}
local rc = _rc
if `rc' {
	cap mata: mata drop `clnames'
	exit `rc'
}
	if (`haserr') { //stop if errors found
		cap mata: mata drop `clnames'
		di as err 	///
	"{bf:mi impute `methodname'}: invalid `dicustom'specification;"
		if ("`dicustom'"=="default " & "`ivars'"=="") {
			di as err "{p 4 4 2}all method specifications"
			di as err "are bound in parentheses as with"
			di as err "the custom specification.  Perhaps,"
			di as err "you meant to specify option {bf:custom}."
			di as err "If not, see default specification of"
			di as err ///
		 	 "{helpb mi_impute_`methodname':mi impute `methodname'}"
			di as err "for details.{p_end}"
			exit 198
		}
		if ("`exitrc'"=="") {
			local exitrc = 198
		}
		di as err "{p 4 4 2}see above error messages{p_end}"
		exit `exitrc'
	}
	// order <ivars>, check if they are monotone with respect to
	// global imputation sample and identify complete variables
	if ("`orderasis'"!="") { // no monotone check
		local nomonotonechk nomonotonechk
	}
	if ("`nomonotonechk'"!="") {
		local errmonotone
		local mustbeordered
	}
	tempvar touse
	mark `touse' `ifspec_gl'
	markout `touse' `ivars', sysmissok
	local style `_dta[_mi_style]'
	if ("`style'"=="mlong" | "`style'"=="flong") { // must use m0
		sort _mi_m _mi_id //make sure data are sorted before parse
		qui replace `touse' = 0 if _mi_m>0
	}
	if (`kgroup'==1) { 
		qui count if `touse'
		if (r(N)==0) {
			error 2000
		}
		else if (r(N)==1) {
			error 2001
		}
	}
	cap noi mata: `impobj'.presetup("`ivars'","`methods'","`clnames'", ///
					"`touse'",("`nomonotonechk'"==""), ///
					"`orderasis'","`nolegend'");	   ///
		      `impobj'.st_setmacros("ivarsinc", "ivarsincord",	   ///
					    "orderid", "pattern","fvopivarsord")
	local rc = _rc
	if (`rc') {
		cap mata: mata drop `clnames'
		exit `rc'
	}
	qui drop `touse'
	local ismonotone = ("`pattern'"=="monotone")
	local domonotone = (`ismonotone') & ("`nomonotone'"=="")
	if ("`errmonotone'"!="" & !`ismonotone') {
		di as err "{p 0 0 2}{bf:`ivars'}: not monotone;{p_end}" 
		di as err "{p 4 4 2}imputation variables must " /// 
		   "have a monotone-missing structure; see "	///
		   "{helpb mi_misstable:mi misstable nested}{p_end}"
		exit 459
	}
	if ("`mustbeordered'"!="" & !(`: list ivarsinc == ivarsincord')) {
		di as err "{bf:mi impute `methodname'}: incorrect " ///
			  "equation order"
		di as err "{p 4 4 2}equations must be "	    		///
			   "listed in the monotone-missing order " 	///
			   "of the imputation variables (from "		///
			   "most observed to least observed); "		///
			   "{bf:`ivarsincord'}{p_end}"
		exit 198
	}

	// check and build univariate imputation models
	`showchk' di _n as txt "Checking equations:" _n
	local haserr 0
	local j 0
	local allowed
	local incordid
	local methodsincord
	local notallowed `ivarsinc'
	tokenize `ivars'
	foreach ind in `orderid' {
		local ivar ``ind''
		local imputedlist `imputedlist' `ivar'
		local fvivar : word `ind' of `fvopivars'
		local clname `clname`ind''
		local method `method`ind''
		local eqind : word `ind' of `eqinds'
		local eqspec "`eqspec`eqind''"
		if ("`custom'"=="") {
			if (`"`xspec'"'!="") {
				local dixspec `"= `xspec'"'
			}
			local dieqspec (`method' `eqspec') `ivar' `dixspec'
		}
		else {
			local dieqspec (`method' `ivar' `eqspec')
		}

		// parse equation-specific options
		_parse comma eqlhs eqrhs : eqspec
		local 0 `eqrhs'
		cap noi syntax	[, 				///
					`SYNCUSTOM'		///
					ASContinuous 		///
					AUGment			///
					BOOTstrap		///
					NOIsily			///
					SHOWCOMMAND		/// //undoc
					NONESTEDCHK		/// //undoc.
					OMITTEDVARYOK		/// //undoc.
					internalcmd		/// //undoc.
					* 			///
				]
		if ("`bootstrap'"!="" & "`bootstrap_gl'"=="") {
			local boottype 2
		}
		if ("`methodname'"=="monotone" & "`custom'"!="") {
			local noimputed noimputed	
		}
		local rc = _rc
		if ("`noisily_gl'"!="") {
			local noisily noisily
		}
		local iscat = inlist("`method'","logit","ologit","mlogit")
		if (`iscat' & "`augment_gl'"!="") {
			local augment augment
		}
		if (`iscat' & "`internalcmd_gl'"!="") {
			local internalcmd internalcmd
		}
		if ("`bootstrap_gl'"!="") {
			local bootstrap bootstrap
		}
		if ("`omittedvaryok_gl'"!="") {
			local omittedvaryok omittedvaryok
		}
		if ("`showcommand_gl'"!="") {
			local showcommand showcommand
		}
		local mopts `augment' `bootstrap' `showcommand' `omittedvaryok'
		local mopts `mopts' `internalcmd' `options'

		// parse equation-specific LHS
		local 0 "`eqlhs'"
		cap noi syntax [anything(name=xlist equalok)] 	///
							[if/] [aw fw pw iw]
		if `rc' | _rc {
			dierreq 1 "" `"`dieqspec'"'
			local ++haserr
			local exitrc = _rc
			continue
		}
		if ("`xlistok'"=="") {
			if (`"`xlist'"'!="") {
				di as err ///
				   `"{p 0 2 2}{bf:`xlist'} not allowed{p_end}"'
				dierreq 1 "" `"`dieqspec'"'
				local ++haserr
				local exitrc = 198
				continue
			}
		}
		else {
			// handles '=' in the specification
			gettoken equal xlist : xlist, parse("=")
			if ("`equal'"!="=") {
				local xlist `equal' `xlist'
			}
		}
		if (`"`wgtexp_gl'"'!="" & "`weight'"!="") {
di as err "{bf:mi impute `methodname'}: incompatible weights"
di as err "{p 4 4 2 0}equation-specific weights,"
di as err `"{bf:[`weight' `exp']}, cannot be combined with"'
di as err `"the global weight, {bf:`wgtexp_gl'}{p_end}"'
			dierreq 1 "" `"`dieqspec'"'
			local ++haserr
			local exitrc = 198
			continue
		}
		else if ("`weight'"!="") {
di as txt "note: {bf:`weight'}s applied to the model for {bf:`ivar'}"
		}
		if (`"`mopts'"'!="") {
			local comma
			local eqrhs , `mopts'
		}
		else {
			local comma ,
			local eqrhs
		}
		local dinoi
		if ("`noisily'"!="") {
			local dinoi `comma' `noisily'
			if ("`mopts'"!="") {
				local dinoi " `dinoi'"
			}
		}
		// combine global and equation-specific 'if's
		local ifspec
		if (`"`if_gl'"'!="" & `"`if'"'!="") {
			local ifspec if (`if') & (`if_gl')
		}
		else if (`"`if_gl'`if'"'!="") {
			local ifspec if `if'`if_gl'
		}
		local wgtexp
		if ("`weight'"!="") { //to preserve default equation weights
			local toparsewgt junk `eqlhs'
			gettoken junk wgtexp : toparsewgt, parse("[]")
		}

		// --- build prediction equation w/o ivars <begin>
		local rhsterms	// unabbreviated specified RHS terms
		local rhsvars
		local currterms `xlist' `include' `xspec'
		while (`"`currterms'"'!="") { // unabbreviate RHS
			gettoken next currterms : currterms, ///
						parse("()") match(par)
			if ("`par'"!="(") { // not expression
				if ("`novarschk'"!="") { //if expr. w/o ()
					cap fvunab next : `next'
					// to display specific error msg
					cap noi u_mi_impute_parse_exp "" `next'
				}
				else {
					cap noi fvunab next : `next'
					local rhsvars `rhsvars' `next'
				}
				if _rc {
					dierreq 1 "" `"`dieqspec'"'
					local ++haserr
					local exitrc = 198
					continue
				}
				local rhsterms `rhsterms' `next'
			}
			else {
				local rhsterms `rhsterms' (`next')
				local exprok exprok
			}
		}
		// check -omit()-
		if (`"`omit'"'!="") {
			cap noi fvunab omit : `omit'
			if _rc {
				dierreq 1 "" `"`dieqspec'"'
				local ++haserr
				local exitrc = 198
				continue
			}
			local allvars `rhsterms' `fvopivars'
			local allvars : list allvars - ivar 
			local allvars : list allvars - fvivar 
			if (!`: list omit in allvars') {
				local nomit : word count `omit'
				di as err "{p}{bf:omit()}: terms not found in"
				di as err "prediction equation{p_end}"
				di as err "{p 4 4 2}You must specify terms in"
				di as err "{bf:omit()} exactly as they appear"
				di as err "in the specification of a prediction"
				di as err "equation.  " 
				di as err plural(`nomit',"Term") " {bf:`omit'}"
				di as err plural(`nomit',"is ","are ")
				di as err "not found in the prediction equation"
				di as err "for {bf:`ivar'}.  You can"
				di as err "reissue the command with"
				di as err "{bf:mi impute `methodname'}'s"
				di as err "{bf:dryrun} option and"
				di as err "without the {bf:omit()} option to"
				di as err "see specifications of prediction"
				di as err "equations.{p_end}"
				dierreq 1 "" `"`dieqspec'"'
				local ++haserr
				local exitrc = 198
				continue
			}
		}
		local rhsterms : list rhsterms - omit
		local rhsvars : list rhsvars - omit
		// check if imputed variables used as RHS unless -noimputed-
		if (`"`rhsterms'"'!="" & "`noimputed'`noimputed_gl'"=="") {
			unopvarlist `rhsvars'
			local rhsvars `r(varlist)'
			local ltmp `ivars' `fvopivars'
			local ltmp : list uniq ltmp
			local ltmp : list rhsvars & ltmp
			if (`"`ltmp'"'!="") {
				local nterms : word count `ltmp'
				di as err "{p 0 2 2}"
				di as err "{bf:`ltmp'}: imputation"
				di as err plural(`nterms',"variable") " cannot"
				di as err "be also specified as independent"
				di as err plural(`nterms',"variable") "{p_end}"
				dierreq 1 "" `"`dieqspec'"'
				local ++haserr
				local exitrc = 198
				continue
			}
		}
		if (`"`rhsterms'`noimputed'`noimputed_gl'"'=="" & `j'>0) {
			local noconsok noconsok
		}
		else {
			local noconsok
		}
		local eqlhs `rhsterms' `ifspec' `wgtexp_gl'`wgtexp' 
		// --- build prediction equation w/o ivars <end>

		// prepare for parsing
		local norhsinit norhsinit
		if (`iscat' & "`augment'`internalcmd'"!="") {
			local nofvrevar nofvrevar
		}
		else {
			local nofvrevar
		}
		local notallowed : list notallowed - ivar
		if ("`methodname'"=="monotone" & "`moncustomok'"=="") {
			local ivarsnotallowed ivarsnotallowed(`notallowed')
			local ivarsallowed ivarsallowed(`allowed')
			local allowed `allowed' `ivar'
		}
		else {
			//allow expressions of imputation variables
			local ivarexpallowed ivarexpallowed
			//remove expressions of current imputation variable
			local noivarexp noivarexp
			//remove expressions of <notallowed> variables
			local noivarsexp noivarsexp(`notallowed')
			local ivarsallowed ivarsallowed(`ivars')
			if ("`noimputed'`noimputed_gl'"!="") {
				local ivarasxvarsok ivarasxvarsok
			}
			else {
				local ivarasxvarsok
			}
		}
		if ("`nonestedchk'"=="") {
			local ivarsnested ivarsnested(`ivarsincord')
		}
		else {
			local ivarsnested
		}
		if ("`method'"=="intreg") {
			local intregopts ivarexists `vartype'
		}
		else {
			local intregopts
		}

		// parse univariate method
		u_mi_getstubname stub : "__mi_impute_expr"
		`version' cap noi `showchk' u_mi_impute_cmd_`method'_parse ///
			`ivar' `eqlhs' `comma' `eqrhs' 			///
			`noisily' impobj(`clname') `exprok'		///
			`ivarsnotallowed' `ivarsallowed' `ivarsnested' 	///
			`ivarexpallowed' `noivarexp' `noivarsexp'	///
			stub(`stub') `intregopts' `ivarasxvarsok'	///
			hasmissing ifgroup(`ifgroup') `norhsinit' `noconsok' ///
			`nonestedchk' `nofvrevar'
		local conditional `s(conditional)'
		local condvars `s(condvars)'
		local expnames `expnames' `s(expnames)'
		local eqlhs `ifspec' `wgtexp_gl'`wgtexp'
		local rc = _rc
		if `rc' {
			dierreq 1 "" `"`dieqspec'"'
			local ++haserr
			local exitrc = `rc'
			continue
		}
		if (!`: list condvars in imputedlist') {
			di as err "{p 0 0 2}"
			di as err "{bf:conditional()}: invalid order of"
			di as err "prediction equations.{p_end}"
			di as err "{p 4 4 2}When conditional variable"
			di as err "({bf:`ivar'}) contains the same number"
			di as err "of missing values as one of the conditioning"
			di as err "variables ({cmd:`condvars'}), prediction"
			di as err "equations for the conditioning variables"
			di as err "must be specified before the prediction"
			di as err "equation for the conditional"
			di as err "variable.{p_end}"
			dierreq 1 "" `"`dieqspec'"'
			local ++haserr
			local exitrc = 198
			continue
		}
		if ("`s(nomiss)'"=="nomiss") {
			//ignore complete impvars (wrt method-specific 
			//imputation sample
			dierreq 0 "`report'" `"`dieqspec'"'
			local ivarscom `ivarscom' `ivar'
			if (`caller'<12) {
				continue
			}
			if ("`methodname'"=="monotone" | `domonotone') {
				local ilist `fvivar' `ilist'
			}
			else {
				local ilist `ilist' `fvivar'
			}
			continue /* GO TO NEXT SPECIFICATION */
		}
		if ("`noisily'"!="") {
			local anynoisily noisily
		}
		local incordid `incordid' `ind' //ordered indexes of inc. vars
		local ivarsfinal `ivarsfinal' `ivar'
		local methodsincord `methodsincord' `method'
		local ++j
		local aug`j' `augment'
		local intcmd`j' `internalcmd'
		if ("`condvars'"!="") {
			local condvars`j' `condvars'
			local condinds `condinds' `j'
			if (`iscat' & "`ascontinuous'"=="") {
				local fvop`j' "i."
			}
		}
		if ("`s(initinaloop)'"!="") {
			local initinaloop initinaloop
		}
		local diuvmodel`j' `eqlhs'`eqrhs'`dinoi'
		global MI_IMPUTE_uvinit`kgroup'_`j' `"`s(cmdlineinit)'"' 
		global MI_IMPUTE_uvimp`kgroup'_`j' `"`s(cmdlineimpute)'"'

		// build appropriate RHS specifications with imputed variables
		local rhsmon`j' `s(xlistmon)' //includes only appropriate expr.
		local dirhsmon`j' `s(xspecmon)'
		local ivmonomit `ivar' `notallowed'
		local ivmonomit : list uniq ivmonomit
		if (!`domonotone') {
			local rhs`j' `s(xlist)' //includes only appropr. expr.
			local dirhs`j' `s(xspec)'
			local ivomit `ivar'
			local ivomit : list uniq ivomit
		}
		if ("`noimputed'`noimputed_gl'"=="") { 
			// add appropriate imputation variables
			local ltmp : list ilist - omit
			local rhsmon`j' `ltmp' `rhsmon`j''
			local dirhsmon`j' `ltmp' `dirhsmon`j''
			if (!`domonotone') {
				local ltmp : list fvopivarsord - fvivar
				local ltmp : list ltmp - omit
				local rhs`j' `ltmp' `rhs`j''
				local dirhs`j' `ltmp' `dirhs`j''
			}
		}
		else { // remove omitted terms
			_removefvexp rhsmon`j' : "`rhsmon`j''" "`ivmonomit'"
			_removefvexp dirhsmon`j' : "`dirhsmon`j''" "`ivmonomit'"
			if (!`domonotone') {
				_removefvexp rhs`j' : "`rhs`j''" "`ivomit'"
				_removefvexp dirhs`j' : "`dirhs`j''" "`ivomit'"
			}
		}

		// report omitted terms
		if ("`report'"!="" & `domonotone') {
			local omittedterms `s(ivarexplists)'
			local omittedterms `omittedterms' `s(ivarexplistsmon)'
			if ("`noimputed'`noimputed_gl'"!="") {
				_omittedfvexp ltmp : "`rhsterms'" "`ivmonomit'"
				local omittedterms `ltmp' `omittedterms'
			}
			local omittedterms : list uniq omittedterms
			if ("`omittedterms'"!="") {
				local nterms : word count `omittedterms'
				di as txt "{p 0 2 2}{bf:`omittedterms'}: " ///
			    plural(`nterms',"term includes","terms include") 
				di as txt " one or more imputation"
				di as txt "variables which have not yet"
				di as txt "been imputed and thus"
				di as txt "omitted from prediction"
				di as txt "equation{p_end}"
			}
		}
		else if ("`report'"!="") {
			local omittedterms `s(ivarexplists)'
			if ("`noimputed'`noimputed_gl'"!="") {
				_omittedfvexp ltmp : "`rhsterms'" "`ivomit'"
				local omittedterms `ltmp' `omittedterms'
			}
			local omittedterms : list uniq omittedterms
			if ("`omittedterms'"!="") {
				local nterms : word count `omittedterms'
				di as txt "{p 0 2 2}{bf:`omittedterms'}: " ///
			plural(`nterms',"term includes","terms include")
				di as txt " imputation variable currently being"
		 		di as txt "imputed and thus omitted from"
				di as txt "prediction equation{p_end}"
			}
		}
		if ("`methodname'"=="monotone" | `domonotone') {
			local ilist `fvivar' `ilist'
		}
		else {
			local ilist `ilist' `fvivar'
		}
		dierreq 0 "`report'" `"`dieqspec'"'
	}
	if (`haserr') { //stop if errors found
		if ("`exitrc'"=="") {
			local exitrc = 198
		}
		exit `exitrc'
	}
	local ivarsinc : list ivarsinc - ivarscom
	if ("`report'"=="") {
		u_mi_impute_note_nomiss "`ivarscom'" "`ivarsfinal'" ///
					"`nomissnote'"
	}
	local methodsinc : list methods - methodsincord // complete methods
	local methodsinc : list methods - methodsinc	// incomplete methods
							// in the orig. order
	if (`caller'<12) {
		local methods `methodsinc'
		local ivars `ivarsinc'
	}
	if ("`ivarsfinal'"=="") { //stop, if all impvars complete
		if ("`report'"!="") {
			local n : word count `ivars'
			di as txt "(imputation "			 ///
			   plural(`n', "variable is ", "variables are ") ///
			   "complete; imputing nothing)"
		}
		sret clear
		sret local uvmethodsincord	"`methodsincord'"
		sret local uvmethods		"`methods'"
		sret local nomiss		"nomiss"
		sret local expnames		"`expnames'"
		sret local ivars		"`ivars'"
		sret local ivarsinc		"`ivarsinc'"
		sret local ivarsincord		"`ivarsfinal'"
		sret local domonotone		`domonotone'
		exit
	}
	local k_eq `j'
	if (`boottype') {
		if (`k_eq'==1) local boottype 1
		mata: `impobj'.boottype = `boottype'
	}
	tokenize `ivarsfinal'
	//remove conditional vars from appropriate prediction equations
	foreach i of local condinds {
		local ispec `fvop`i''``i'' ``i''
		gettoken condvar condvars`i' : condvars`i'
		while ("`condvar'"!="") {
			local pos : list posof "`condvar'" in ivarsfinal
			//remove 'ivar' from <condvar>'s prediction equation
			local rhsmon`pos' : list rhsmon`pos' - ispec
			local dirhsmon`pos' : list dirhsmon`pos' - ispec
			if (!`domonotone') {
				local rhs`pos' : list rhs`pos' - ispec
				local dirhs`pos' : list dirhs`pos' - ispec
			}
			gettoken condvar condvars`i' : condvars`i'
		}
	}
	// pass impvar specifications
	forvalues i=1/`k_eq' {
		global MI_IMPUTE_uvinit`kgroup'_`i' `"${MI_IMPUTE_uvinit`kgroup'_`i'} "`rhs`i''" "`rhsmon`i''""'
		if ("`aug`i''`intcmd`i''"!="" & "`methodname'"=="monotone") {
			//to handle factor variables during augmented regression
			global MI_IMPUTE_uvimp`kgroup'_`i' ///
			    `"${MI_IMPUTE_uvimp`kgroup'_`i'} "`rhsmon`i''""'
		}
	}
	local dimodels Conditional models: 
	if ("`methodname'"=="chained") {
		local dispec dirhs
	}
	else {
		local dispec dirhsmon
		local dimon mon
	}
	if (`domonotone') {
		local dinoiter "; no iteration performed"
		if ("`init'"=="random") {
			di as txt "note: option {bf:init(random)} ignored"
		}	
		local init monotone
		local dispec dirhsmon
		if ("`methodname'"=="chained") {
			local dimodels Conditional models (monotone): 
		}
		local dimon mon
	}
	if ("`dryrun'"!="") {
		local dinoiter
	}
	if `ismonotone' & "`methodname'"=="chained" {
		di as txt "note: missing-value pattern is monotone`dinoiter'"
	}
	if ("`methodname'"=="monotone" & "`custom'"!="" & "`verbose'"=="") { 
		local verbose
	}
	else {
		local verbose verbose // default with chained
	}
	if ("`dryrun'"!="" | "`verbose'"!="") {
		if (`"`ifgroup'"'=="") di
		di as txt "`dimodels'"
		local hold `methodsincord'
		forvalues i=1/`k_eq' {
			local name = abbrev("``i''", 14)
			local pos  = 18 - udstrlen("`name'")
			gettoken method hold : hold
			local diuvmodel`i' `method' ``i'' ``dispec'`i'' ///
						`diuvmodel`i''
			di "{p `pos' 21 2}"
                	di as txt `"{bf:`name'}: `diuvmodel`i''"'
	                di "{p_end}"
		}
		if (`"`ifgroup'"'=="") di
	}
	sret clear 
	sret local uvmethodsincord "`methodsincord'"	//inc. methods, ordered
	sret local uvmethods	"`methods'"		//all methods, unordered
	sret local expnames	"`expnames'"
	sret local ivars	"`ivars'"
	sret local ivarsinc	"`ivarsinc'"
	sret local ivarsincord	"`ivarsfinal'"
	sret local incordid	"`incordid'"
	sret local domonotone	`domonotone'
	sret local noisily	"`anynoisily'"
	sret local initinaloop "`initinaloop'"
end

program dierreq
	args erreq report eqspec
	if (`erreq') {
		di as err "{p 1 4 2}"
		di as err "-- above applies to specification "	///
			  `"{bf:`eqspec'}"'
		di as err "{p_end}"
		di as err ""
		exit
	}
	if ("`report'"=="") exit
	di as txt "{p 1 4 2}"
	di as txt "-- above applies to specification "	///
		  `"{bf:`eqspec'}"'
	di as txt "{p_end}"
	di as txt ""
end

program _parse_asc_aug
	args asc aug colon rhs
	local 0 `rhs'
	syntax [, ASContinuous AUGment *]
	c_local `asc' "`ascontinuous'"
	c_local `aug' "`augment'"
end

/*the provided list fvmac may include expressions */
program _removefvexp
	args tomac colon fvmac tormmac
	while (`"`fvmac'"'!="") {
		gettoken vspec fvmac : fvmac, match(par)
		if ("`par'"!="") {
			local final `final' (`vspec')
			continue
		}
		qui unopvarlist `vspec'
		local var `r(varlist)' 
		if (!`: list var in tormmac') {
			local final `final' `vspec'
		}
	}
	c_local `tomac' `final'
end

program _omittedfvexp
	args tomac colon fvmac tormmac
	while (`"`fvmac'"'!="") {
		gettoken vspec fvmac : fvmac, match(par)
		if ("`par'"!="") continue
		qui unopvarlist `vspec'
		local var `r(varlist)' 
		if (`: list var in tormmac') {
			local final `final' `vspec'
		}
	}
	c_local `tomac' `final'
end
