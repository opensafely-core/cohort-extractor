*! version 4.3.11  10feb2020
program _coef_table, rclass
	version 11
	local vv : di "version " string(max(11,_caller())) ", missing:"
	if (!c(noisily) & c(coeftabresults) == "off") {
		exit
	}
	_check_eclass
	syntax [, BMATrix(passthru) VMATrix(passthru) * ]
	if "`e(b)'" == "" & "`e(V)'" == "" & "`bmatrix'`vmatrix'"=="" {
		exit
	}
	local mc_cmds contrast margins pwcompare pwmean
	local cmd "`e(cmd)'"
	local keepmc : list cmd in mc_cmds
	if inlist("`cmd'", "pwcompare", "pwmean") {
		local groups GROUPS
	}
	if "`cmd'" == "regress" {
		local beta Beta
	}
	if "`cmd'" == "gsem" {
		local fvignore fvignore(int 0)
		local flignore flignore
	}
	if "`cmd'" == "sem" {
		local standardized STANDARDIZED
		local showginvariant SHOWGINVariant
		local nolabel NOLABel LABel NOFVLABel FVLABel
		local nofootnote NOFOOTnote
		local wrap wrap(numlist max=1) fvwrap(passthru)
	}
	if "`e(mi)'"=="mi" {
		local dftable		DFTable
		local dfonly		DFONLY
		local noclustreport	NOCLUSTReport
		local pisematrix	PISEMATrix(string)
	}
	syntax [,				/// computation options
		cmdextras			/// NOT DOCUMENTED
		BMATrix(string)			///
		VMATrix(string)			///
		EMATrix(string)			///
		DFMATrix(string)		///
		EQMATrix(string)		///
		ROWMATrix(string)		/// NOT DOCUMENTED 
		CIMATrix(string)		/// NOT DOCUMENTED
		ROWCFormat(string)		/// NOT DOCUMENTED
		ROWPFormat(string)		/// NOT DOCUMENTED
		ROWSFormat(string)		/// NOT DOCUMENTED
		NOROWCI				/// NOT DOCUMENTED
		MMATrix(string)			/// NOT DOCUMENTED -pwcompare-
		MVMATrix(string)		/// NOT DOCUMENTED -pwcompare-
		MEMATrix(string)		/// NOT DOCUMENTED -pwcompare-
		BSTDMATrix(string)		/// NOT DOCUMENTED -sem-
		CNSMATrix(string)		///
		PCLASSMATrix(string)		/// NOT DOCUMENTED -sem-
		Level(cilevel)			///
		prefix(name)			/// NOT DOCUMENTED
		suffix(name)			/// NOT DOCUMENTED
		OFFSETlist(string asis)		/// NOT DOCUMENTED
						/// report options
		`beta'				/// table type
		`standardized'			/// table type
		NOCI				/// table type
		NOPValues			/// table type
		`dftable'			/// table type
		`dfonly'			/// table type
		dfci				/// table type
		DFPValues			/// table type
		dfmissing			/// NOT DOCUMENTED
		`groups'			/// table type
		COEFLegend			/// table type
		selegend			/// table type
		`fvignore'			/// NOT DOCUMENTED -gsem-
		`flignore'			/// NOT DOCUMENTED -gsem-
		`showginvariant'		/// NOT DOCUMENTED -sem-
		`nolabel'			/// NOT DOCUMENTED -sem-
		`nofootnote'			/// NOT DOCUMENTED -sem-
		`wrap'				/// NOT DOCUMENTED -sem-
		sort				///
		`pisematrix'			/// NOT DOCUMENTED -mi-
		depname(string)			/// NOT DOCUMENTED
		COEFTitle(string)		///
		coeftitle2(string)		/// NOT DOCUMENTED
		ptitle(string)			///
		cititle(string)			///
		NOMCLEGend			/// NOT DOCUMENTED
		noCNSReport			///
		FULLCNSReport			///
		`noclustreport'			/// NOT DOCUMENTED -mi-
		cformat(passthru)		///
		sformat(passthru)		///
		pformat(passthru)		///
		NOFirst				///
		First				///
		SHOWEQns			/// IGNORED
		neq(integer -1)			///
		NODIPARM			/// NOT DOCUMENTED
		NOTEST				///
		SEParator(integer 0)		///
		NOSKIP				///
		OFFSETONLY1			///
		PLus				///
		NOEQCHECK			/// used by -mi estimate-
		EFORMALL			/// NOT DOCUMENTED
		CITYPE(string)			/// NOT DOCUMENTED
		eqselect(string)		/// NOT DOCUMENTED
		*				/// -eform/diparm- options
	]

	if "`wrap'" != "" {
		opts_exclusive `"wrap(`wrap') `fvwrap'"'
		local fvwrap fvwrap(`wrap')
	}
	if "`nolabel'`label'" != "" {
		opts_exclusive "`nolabel' `label'"
		opts_exclusive "`nofvlabel' `fvlabel'"
		opts_exclusive "`nolabel' `fvlabel'"
		opts_exclusive "`nofvlabel' `label'"
		if "`nolabel'" != "" {
			local fvlabel nofvlabel
		}
		else {
			local fvlabel fvlabel
		}
	}
	else	local fvlabel `nofvlabel' `fvlabel'

	local type	`coeflegend'	///
			`selegend'	///
					 // blank
	opts_exclusive "`type' `standardized'"
	if (`"`rowmatrix'"'=="" & "`norowci'"!="") {
		di as err "{bf:norowci} requires {bf:rowmatrix()}"
		exit 198
	}
	if ("`dftable'"!="" & "`norowci'"!="") {
		di as err "{bf:norowci} is not allowed with {bf:`dftable'}"
		exit 198
	}
	if ("`dfonly'"!="" & "`norowci'"!="") {
		di as err "{bf:norowci} is not allowed with {bf:`dfonly'}"
		exit 198
	}
	if ("`noci'"!="" & "`norowci'"!="") {
		di as err "{bf:norowci} is not allowed with {bf:`noci'}"
		exit 198
	}
	if "`standardized'" != "" & "`bstdmatrix'" != "" {
		local beta beta
		local standardized
	}
	if `:length local type' == 0 {
		local type	`beta'		///
				`noci'		///
				`nopvalues'	///
				`dftable'	///
				`dfonly'	///
				`groups'	///
				`dfci'		///
				`dfpvalues'	///
					 	// blank
	}
	opts_exclusive "`type'"
	opts_exclusive "`first' `nofirst'"
	opts_exclusive "`first' `showeqns'"
	local cnsreport `cnsreport' `fullcnsreport'
	opts_exclusive "`cnsreport'"
	if `"`showeqns'"' != "" {
		local nofirst nofirst
	}

	if `"`ematrix'`noeqcheck'"' == "" {
		if `"`e(error)'"' == "matrix" {
			local ematrix e(error)
		}
	}

	_get_mcompare, `options'
	local method	`"`s(method)'"'
	local all	`"`s(adjustall)'"'
	local options	`"`s(options)'"'
	if "`method'" != "noadjust" {
		local keepmc 1
	}
	opts_exclusive "`all' `groups'"
	if "`method'" == "dunnett" {
		opts_exclusive "`method' `groups'"
	}
	_get_diopts diopts options, `options' `fvwrap' `fvlabel'
	local legend coeflegend selegend
	local legend : list legend & diopts
	local diopts : list diopts - legend
	local lstretch lstretch nolstretch
	local lstretch : list lstretch & diopts
	local diopts : list diopts - lstretch
	local markdown markdown
	local markdown : list markdown & diopts 
	local diopts : list diopts - markdown

	_get_diopts ignore, `diopts' `cformat' `sformat' `pformat'
	local cformat `"`s(cformat)'"'
	local sformat `"`s(sformat)'"'
	local pformat `"`s(pformat)'"'

	// parse `options' for -eform()- and friends
	_get_eformopts , eformopts(`options') allowed(__all__) soptions
	if inlist("`bmatrix'", "", "e(b)") & "`e(k_eform)'" == "0" {
		local eform
	}
	else local eform	`"`s(str)'"'
	local eform_cons_ti `"`s(eform_cons_ti)'"'
	if ("`e(consonly)'"!="1" | `"`eform_cons_ti'"'=="") {
		local eformdi `"`s(str)'"'
	}
	else {
		local eformdi `"`eform_cons_ti'"'
	}
	local coefttl = cond(`"`eform'"'==`""', `"`coeftitle'"', `"`eformdi'"')
	local options	`"`s(options)'"'

	// `options' should only contain -diparm()- options
	_get_diparmopts, diparmopts(`options') level(`level')
	// ignore -diparm()- options; but checked for valid syntax anyway
	local NODIPARM : length local nodiparm
	if `NODIPARM' {
		local options
	}

	local GTOPTS parse(":") bind quotes
	local k 0
	if !`NODIPARM' {
		if `"`e(diparm)'"' != "" {
			local i 0
			local diparm `"`e(diparm)'"'
		}
		else if `"`e(diparm1)'"' != "" {
			local i 1
			local diparm `"`e(diparm1)'"'
		}
		while `:length local diparm' {
			gettoken diparm rest : diparm, `GTOPTS'
			while `:length local rest' {
				local ++k
				local diparm`k' : copy local diparm
				gettoken COLON rest : rest, `GTOPTS'
				gettoken diparm rest : rest, `GTOPTS'
			}
			local ++k
			local diparm`k' : copy local diparm
			local ++i
			local diparm `"`e(diparm`i')'"'
		}
	}
	if `:length local options' {
		local 0 `", `options'"'
		syntax [, diparm(string asis) *]
		if `k' & `:length local diparm' {
			local ++k
			local diparm`k' __sep__
		}
		while `:length local diparm' {
			gettoken diparm rest : diparm, `GTOPTS'
			while `:length local rest' {
				local ++k
				local diparm`k' : copy local diparm
				gettoken COLON rest : rest, `GTOPTS'
				gettoken diparm rest : rest, `GTOPTS'
			}
			local ++k
			local diparm`k' : copy local diparm
			local 0 `", `options'"'
			syntax [, diparm(string asis) *]
		}
	}

	if "`markdown'" != "" {
		local lsize = c(linesize)
		set linesize 255
	}
	`vv' mata: _coef_table()
	if "`markdown'" != "" {
		set linesize `lsize'
	}

	if "`eqselect'" == "" {
	    if "`eformdi'"!="" & ("`e(cmd)'"!="gnbreg" | "`e(prefix)'"=="svy") {
		local k_eform `e(k_eform)'
		if ("`k_eform'"=="") {
			local k_eform = 1
		}
		local k_eq `e(k_eq)'
		if ("`k_eq'"=="") {
			local k_eq = 1
		}
		if (`k_eform'<`k_eq' & `k_eform') {
			if ("`e(cmd2)'" == "stintreg" | ///
			    "`e(cmd2)'" == "streg") & ///
			   ("`e(cmd)'" == "weibull" | ///
			    "`e(cmd)'" == "gompertz") {
				
			}
			else {
				_eform_multeq_note efnote : `k_eform'
				di as txt "`efnote'"
			}
		}
	    }
	    if (`"`eformdi'"'!="" & "`e(noconstant)'"=="0" & ///
		`"`eform_cons_ti'"'!="" & "`e(consonly)'"!="1") {
                if ("`e(cmd)'"=="asclogit"      | ///
                    "`e(cmd)'"=="cmclogit"      | ///
                    "`e(cmd)'"=="cmmixlogit"    | ///
                    "`e(cmd)'"=="cmxtmixlogit" ) {
                        local asvar = `"`e(ranvars)'`e(fixvars)'`e(indvars)'"' != ""
                        if `"`e(casevars)'"' != "" & `asvar' {
                local note1 "Exponentiated coefficients represent odds ratios for "
                local note2 "alternative-specific variables (first equation) and "
                local note3 "{help j_cmrisk##|_new:relative-risk ratios} "
                local note4 "for case-specific variables."
                di as txt "{p 0 6 2}Note: `note1'`note2'`note3'`note4'{p_end}"
                        }
                }
		if "`eform_cons_ti'" == "Inc. Rate" {
			local eform_cons_note "incidence rate"
		}
		else if "`eform_cons_ti'" == "Rel. Risk" {
			local eform_cons_note "relative risk"
		}
		else if "`eform_cons_ti'" == "Health" {
			local eform_cons_note ///
				"health (probability of no disease)"
		}
		else {
			local eform_cons_note = strlower(`"`eform_cons_ti'"')
		}
		local eform_cons_note "baseline `eform_cons_note'"
		if ("`e(cmd2)'"=="") {
			local cmd `e(cmd)'
		}
		else {
			local cmd `e(cmd2)'
		}
		local f2 = udsubstr("`cmd'",1,2)
		local is_re = ("`f2'"=="xt" | "`f2'"=="me")
		if `is_re' {
			local extranote " (conditional on zero random effects)"
		}
		di as txt "{p 0 6 2}Note: {res:_cons} estimates " ///
			  "`eform_cons_note'`extranote'" _c
                if ("`e(cmd)'"=="mlogit"        | ///
                    "`e(cmd)'"=="asclogit"      | ///
                    "`e(cmd)'"=="cmclogit"      | ///
                    "`e(cmd)'"=="cmmixlogit"    | ///
                    "`e(cmd)'"=="cmxtmixlogit" ) {
			di as txt " for each outcome" _c
		}
		di as txt ".{p_end}"
	    }
	}
	return add
	if !`keepmc' {
		return local mcmethod
		return local mctitle
	}
end

exit

NOTES:

Secret options:

	cmdextras	-- specifies that -_coef_table- employ special replay
			   code developed for the command named in -e(cmd)-

-_coef_table- looks at the following scalars to determine which equations are
put in the table of results, and how they are put there:

	e(k_eq)		-- total number of equations, missing value implies 1
	e(k_aux)	-- number of ancillary parameters (each an equation)
	e(k_extra)	-- extra equations
	e(k_eform)	-- the first e(k_eform) equations' coefficients will
			   be exponentiated when an 'eform' type option is
			   specified; default is 1

