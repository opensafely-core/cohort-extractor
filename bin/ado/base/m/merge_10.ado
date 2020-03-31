*! version 2.1.5  02jan2008
program merge_10
	version 9.1

	gettoken first 0: 0

	while (`"`first'"' != "using" & `"`first'"' != "") {
		local vlist "`vlist' `first'"
		gettoken first 0: 0
	}

	if "`vlist'" != "" {
		unab vlist : `vlist'
		foreach var of local vlist {
			capture confirm variable `var'
			if _rc {
				di as err "variable `var' not found"
				exit 111
			}
		}
	}

	if (`"`first'"' != "using") {
		di as err "using required"
		exit 100
	}
	else {
		syntax anything(id="filelist") [,		///
			_merge(string)				///
			noSummary				///
			UNIQue					///
			UNIQMaster				///
			UNIQUSing				///
			sort *]
	}

	if ("`_merge'" != "") {
		capture confirm new variable `_merge'
		if _rc {
			di as err `"`_merge' invalid name"'
			exit 198
		}
		local _mergeoption "_merge(`_merge')"
	}
	else {
		local _mergeoption "_merge(_merge)"
		local _merge "_merge"
	}

	if "`sort'" != "" {
		if "`vlist'" == "" {
		    di as err "match variables required with sort option"
		    exit 198
		}
		if "`uniqmaster'" == "" & "`uniqusing'" == ""  {
			local unique unique
		}
	}
	local uniqopts `unique' `uniqmaster' `uniqusing'

	if "`vlist'" == "" {
		if "`uniqmaster'" != "" {
		    di as err "match variables required with uniqmaster option"
		    exit 198
		}
		
		if "`uniqusing'" != "" {
		    di as err "match variables required with uniqusing option"
		    exit 198
		}
		
		if "`unique'" != "" {
		    di as err "match variables required with unique option"
		    exit 198
		}
		
	}

	local wordct : word count `anything'
	if (`wordct' == 1) {
		if ("`summary'" != "") {
		  di as txt "note: nosummary ignored when only one using " _c
		  di as txt "file is specified"
		}

		local resort 0
		if "`sort'" != "" {
			/* check/sort master data */
			local sortedby : sortedby
			if index("`sortedby'", "`vlist'") != 1 {
				sort `vlist'
			}

			/* check/sort using data */
			qui desc using `anything', varlist
			if index("`r(sortlist)'", "`vlist'") != 1 {
				tempfile mergesort
				preserve
					use `anything', clear
					sort `vlist'
					qui save `"`mergesort'"'
					local resort 1
				restore
			}
		}

		if `resort' == 1 {
			_merge `vlist' using `"`mergesort'"', ///
				`_mergeoption' `uniqopts' msginit `options'
		}
		else {
			_merge `vlist' using `anything', ///
				`_mergeoption' `uniqopts' msginit `options'
		}
	}
	else {
		if (index("`options'","update") > 0) {
			di as err ///
				"update not allowed with multiple using files"
			exit 198
		}

		if "`sort'" != "" {
			/* check/sort master data */
			local sortedby : sortedby
			if index("`sortedby'", "`vlist'") != 1 {
				sort `vlist'
			}
		}
			
		tempvar merge
		gen `merge' = 0

		local i 1
		local using_file_num 1
		foreach file in `anything' {
			if `"`vlist'"' != "" & `i' > 1 {
				sort `vlist'
			}

			local resort 0
			if "`sort'" != "" {
				/* check/sort using data */
				qui desc using "`file'", varlist
				if index("`r(sortlist)'", "`vlist'") != 1 {
					tempfile mergesort
					preserve
						use "`file'", clear
						sort `vlist'
						qui save `"`mergesort'"', replace
						local resort 1
					restore
				}
			}

			if `resort' == 1 {
				if `using_file_num' == 1 {
					_merge `vlist' using `"`mergesort'"', ///
						`_mergeoption' `uniqopts'   ///
						msginit `options'
				}
				else {
					_merge `vlist' using `"`mergesort'"', ///
						`_mergeoption' `uniqopts'   ///
						`options'
				}
			}
			else {
				if `using_file_num' == 1 {
					_merge `vlist' using "`file'", ///
						`_mergeoption' `uniqopts'  ///
						msginit `options'
				}
				else {
					_merge `vlist' using "`file'", ///
						`_mergeoption' `uniqopts' ///
						`options'
				}
			}
			qui replace `merge' = `_merge' ///
				if `_merge' > `merge' | `merge' >= .
			if ("`summary'" == "") {
				rename `_merge' `_merge'`i'
				label variable `_merge'`i' ///
					`"_merge representing `file'"'
			}
			else {
				drop `_merge'
			}
			local ++i
			local ++using_file_num
		}

		gen byte `_merge' = `merge'
		drop `merge'

		if ("`summary'" == "") {
			qui recode `_merge'?* (1 .=0) (2/5=1)
		}
	}
end

