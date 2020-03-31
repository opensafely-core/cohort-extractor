*! version 1.0.3  20dec2004
program define _get_diparmopts_8, sclass
	version 8.0
	syntax [, diparmopts(string asis)	///
		EXECute soptions bottom plus	///
		*				///
	]
	// `goptions' has global options to splice into the -diparm()- options
	local goptions `options'

	// check syntax of global options
	SpliceGlobals junk , `goptions'

	local 0 `", `diparmopts'"'
	local diparmopts
	local k 0
	syntax [, diparm(string asis) * ]
	while `"`diparm'"' != "" {
		local ++k
		SpliceGlobals diparm , diparm(`diparm')	///
			`goptions'			///
			// blank
		local diparm`k' `"`diparm'"'
		local diparmopts `"`diparmopts' diparm(`diparm')"'
		local 0 `", `options'"'
		syntax [, diparm(string asis) * ]
	}

	// check if other options should be present
	if `"`soptions'"' == "" {
		syntax [, diparm(string asis) ]
	}

	if ("`execute'" == "") {
		sreturn clear
		sreturn local options `"`options'"'
		sreturn local diparm `"`diparmopts'"'	
		exit
	}

	forval i = 1/`k' {
		if `"`diparm`i''"' == "__sep__" {
			DashLine mid 14
		}
		else _diparm `diparm`i''
	}
	if (`"`bottom'"' != "")	DashLine bot 14
	if (`"`plus'"' != "")	DashLine mid 14
end

program SpliceGlobals
	syntax name(id="macro name" name=c_diparm) [,	///
		diparm(string asis)			///
		Level(cilevel)				///
		svy Prob ci deff deft meff meft		///
	]
	local glevel `level'
	if "`svy'" != "" {
		local gsvy svy
		if "`deff'`deft'`meff'`meft'" != "" {
			if "`prob'" == "" {
				local gnoprob noprob
			}
			if "`ci'" == "" {
				local gnoci noci
			}
		}
		else {
			if "`prob'" == "" {
				if "`ci'" != "" {
					local gnoprob noprob
				}
			}
			else if "`ci'" == "" {
				local gnoci noci
			}
		}
	}
	else {
		// generate error for options that require the -svy- option
		local 0, `prob' `ci' `deff' `deft' `meff' `meft'
		syntax [, hiddenopt ]
	}

	if (`"`diparm'"' == "") exit

	local 0 `diparm'
	syntax namelist(id="eqname(s)") ///
		[, Level(string) NOProb Prob NOCI svy * ]

	if ("`namelist'" == "__sep__") exit

	if "`noci'" == "" {
		local noci `gnoci'
	}
	if "`noprob'`prob'" == "" {
		local noprob `gnoprob'
	}
	if "`svy'" == "" {
		local svy `gsvy'
	}
	if "`level'" == "" {
		local lopt level(`glevel')
	}
	else	local lopt level(`level')
	c_local `c_diparm' `namelist',	///
		`options' `svy' `noci' `noprob' `prob' `lopt'
end

// DashLine was taken from svy_dreg.ado
program DashLine
	args typ col
	if "`typ'"=="straight" {
		di in smcl as txt "{hline 78}"
		exit
	}
	confirm integer number `col'
	if "`typ'"=="top" {
		local mid "{c TT}"
	}
	else if "`typ'"=="mid" {
		local mid "{c +}"
	}
	else	loca mid "{c BT}"

	local dash1 = `col' - 1 
	local dash2 = 78 - `col'
	di in smcl as txt "{hline `dash1'}`mid'{hline `dash2'}"
end

exit
