*! version 1.0.0  12jan2009
program append 
	version 11

	if (_caller() < 11) {
		local version : di "version " string(_caller()) ":"
		`version' _append `0'
		exit
	}

	syntax [anything(everything)] [,		///
		  GENerate(name)			///
		  *					///
		]

	gettoken using filenames : anything

	if (`"`using'"' != "using") {
		di as err "using required"
		exit 100
	}

	if (`"`filenames'"' == "") {
		di as err "invalid file specification"
		exit 198
	}

	foreach filename of local filenames {
		capture quietly describe using `"`filename'"'
		if (_rc) {
			di as err `"file `filename' not found"'
			exit 601
		}
	}

	if ("`generate'" != "") { 
		confirm new var `generate'
		local filenum 0
		gen byte `generate' = `filenum'
		local ++filenum
		local filenumpos = _N + 1
	}

	foreach filename of local filenames {
		capture noisily _append using `"`filename'"', `options'
		if _rc {
			if ("`generate'" != "") {
				capture quietly drop if `generate' > 0
				capture quietly drop `generate'
			}
			exit _rc
		}

		if ("`generate'" != "") {
			quietly replace `generate' = `filenum' in `filenumpos'/L
			local ++filenum
			local filenumpos = _N + 1
		}
	}
end

