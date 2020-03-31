*! version 1.2.2  13jan1999
program define _crcmeq
	version 6
	gettoken cmd 0 : 0

	#delimit ;
	syntax [, noRMDUP noRMCOLL noIF noIN INS HET SEL INF
		ALPHA(string) WEIGHT(string) TOUSE(string) ] ;
	#delimit cr

	local earg "noCONstant nc OFFset(string) off" 
	if "`ins'"     != "" { local rarg "`rarg' INSTrument ins" }
	if "`het'"     != "" { local rarg "`rarg' HETeros het"    }
	if "`sel'"     != "" { local rarg "`rarg' SELection sel"  }
	if "`inf'"     != "" { local rarg "`rarg' INFlation inf"  }
	if "``alpha''" != "" { local rarg "`rarg' `alpha' alp"    }
	if "`rarg'"    != "" { local rarg "roles(`rarg')"         }
	meqparse `"`cmd'"', `rarg' eqopts(`earg')

	if "`weight'" != "" {
		local weight "[`weight'/]"
	}

	if "`if'"=="" { local ifstr "[if]" }
	if "`in'"=="" { local instr "[in]" }

	#delimit ;
	syntax  `ifstr' `instr' `weight' [, ROBust CLuster(string)
		SCore(string) FROM(string) *] ;
	#delimit cr

	mlopts mlopts opts , `options' 

	if "`cluster'" != "" {
		unabbrev `cluster', max(1)
		local cluster "`s(varlist)'"
		local clopt   "cluster(`cluster')"
		local robust  "robust"
	}
	if "`weight'"=="pweight" { local robust "robust" }

	if "`touse'" == "" { local use "*" }
	`use' mark `touse' `if' `in'
	`use' markout `touse' `cluster', strok

	if "`touse'" != "" {
		local i 1
		while `i' <= `e_n' {
			markout `touse' `e_y`i'' `e_x`i'' `off`i''
			local i = `i'+1
		}
	}
	if "`rmcoll'" == "" & "`touse'" != "" {
		local i 1
		while `i' <= `e_n' {
			_rmcoll `e_x`i'' if `touse', `nc`i''
			local i = `i'+1
		}
	}
	if "`score'" != "" {
		local n : word count `score'
		c_local nscores `"`n'"'
		local i 1
		while `i' <= `n' {
			local sss : word `i' of `score'
			confirm new var `sss'
			local i = `i'+1
		}
		c_local scvar "`score'"
	}


	/* Save macros */
	c_local inx	`"`in'"'
	c_local ifx	`"`if'"'
	c_local robust "`robust'"
	c_local opts   "`options'"
	c_local from	"`from'"
	if "`weight'" != "" {	/* local left alone otherwise, important */
		c_local wtexp	`"`exp'"'
		c_local wtype	`"`weight'"'
		c_local wgt	`"[`weight'=`exp']"'
		local wtexp	"[`weight'=`exp']"
	}
	if "`cluster'" != "" {	/* local left alone otherwise, important */
		c_local clvar	`"`cluster'"'
		c_local clopt	`"cluster(`cluster')"'
	}
	local i 1
	while `i' <= `e_n' {
		if "`off`i''" != "" {
			c_local off`i'	"`off`i''"
			c_local offo`i'	"offset(`off`i'')"
		}
		c_local dep`i'	`"`e_y`i''"'
		c_local ind`i'	`"`e_x`i''"'
		c_local role`i'	`"`e_ro`i''"'
		c_local ref`i'	`"`e_re`i''"'
		c_local nc`i'	`"`nc`i''"'
		c_local eqn`i'	`"`e_`i''"'
		local i = `i'+1 
	}
	c_local e_neq = `e_n'
end
