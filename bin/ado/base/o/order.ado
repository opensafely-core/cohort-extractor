*! version 1.0.2  16feb2009
program order
	version 11
	if (_caller()<11) {
		_order `macval(0)'
		exit
	}
	syntax varlist[, Before(varname) After(varname) first last ///
			SEQuential ALPHAbetic]
	if (`"`before'"' == "" & `"`after'"' == "" & "`first'" == "" & ///
			"`last'" == "" & "`alphabetic'" == "" & ///
			"`sequential'" == "") {
		_order `macval(0)'
		exit
	}

	/* before() error checking */
	if (`"`before'"' != "" & `"`after'"' != "") {
		dis as error "before() may not be combined with after()"
		exit 198
	}
	if (`"`before'"' != "" & `"`first'"' != "") {
		dis as error "before() may not be combined with first()"
		exit 198
	}
	if (`"`before'"' != "" & `"`last'"' != "") {
		dis as error "before() may not be combined with last()"
		exit 198
	}

	/* after() error checking */
	if (`"`after'"' != "" & `"`before'"' != "") {
		dis as error "after() may not be combined with before()"
		exit 198
	}
	if (`"`after'"' != "" & `"`first'"' != "") {
		dis as error "after() may not be combined with first()"
		exit 198
	}
	if (`"`after'"' != "" & `"`last'"' != "") {
		dis as error "after() may not be combined with last()"
		exit 198
	}

	/* first/last error checking */
	if ("`first'" != "" & "`last'" != "") {
		dis as error "first may not be combined with last"
		exit 198
	}

	/* sequential error checking */
	if ("`sequential'" != "" & "`alphabetic'" != "") {
		dis as error "sequential may not be combined with alphabetic"
		exit 198
	}

	if ("`first'" != "") {
		if "`alphabetic'" != "" {
			local varlist : list sort varlist
		}
		if "`sequential'" != "" {
			aorder `varlist'
		}
		else { 
			_order `varlist'
		}
	}
	if ("`last'" != "") {
		unab vlist : _all
		local list : list vlist - varlist
		if "`alphabetic'" != "" {
			local varlist : list sort varlist
		}
		if "`sequential'" != "" {
			preserve
			keep `varlist'
			aorder `varlist'
			unab varlist : _all
			restore
		}
		_order `list' `varlist'
		
	}
	if (`"`before'"' != "") {
		local test : list before in varlist
		if `test' {
			dis as err "varname specified in before() may not" ///
			" be in varlist"
			exit 198
		}
		if "`alphabetic'" != "" {
			local varlist : list sort varlist
		}
		if "`sequential'" != "" {
			preserve
			keep `varlist'
			aorder `varlist'
			unab varlist : _all
			restore
		}
		unab vlist : _all
		local vlist : list vlist - varlist
		local var_num : list posof "`before'" in vlist
		local var_num = `var_num' - 1
		local fvar : word 1 of `vlist'
		capture local lvar : word `var_num' of `vlist'
		if _rc {
			_order `varlist'
			exit
		}
		unab nlist : `fvar'-`lvar'
		local nlist : list nlist - varlist
		_order `nlist' `varlist'
	}
	if (`"`after'"' != "") {
		local test : list after in varlist
		if `test' {
			dis as err "varname specified in after() may not" ///
			" be in varlist"
			exit 198
		}
		if "`alphabetic'" != "" {
			local varlist : list sort varlist
		}
		if "`sequential'" != "" {
			preserve
			keep `varlist'
			aorder `varlist'
			unab varlist : _all
			restore
		}
		unab vlist : _all
		local vlist : list vlist - varlist
		local var_num : list posof "`after'" in vlist
		local fvar : word 1 of `vlist'
		local lvar : word `var_num' of `vlist'
		unab nlist : `fvar'-`lvar'
		local nlist : list nlist - varlist
		_order `nlist' `varlist'
	}
	if ("`alphabetic'" != "" & `"`before'"' == "" & `"`after'"' == "" & ///
	"`first'" == "" & "`last'" == "") {
		local vlist : list sort varlist
		_order `vlist'
	}
	if ("`sequential'" != "" & `"`before'"' == "" & `"`after'"' == "" & ///
	"`first'" == "" & "`last'" == "") {
		aorder `varlist'
	}
end

