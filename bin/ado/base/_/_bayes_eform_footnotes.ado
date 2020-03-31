*! version 1.0.1  22mar2017
program _bayes_eform_footnotes, sclass

	args eformopts

	//footnotes
	local footnotes

	local allowed eform
	if "`e(cmd)'" == "logit" | "`e(cmd)'" == "binreg" | ///
		"`e(cmd)'" == "ologit" | "`e(cmd)'" == "clogit" | ///
		"`e(cmd)'" == "fracreg" | "`e(cmd)'" == "meglm" | /// 
		"`e(cmd)'" == "melogit" | "`e(cmd)'" == "meologit"  {
		local allowed `allowed' or
	}
	if "`e(cmd)'" == "mlogit" {
		local allowed `allowed' rrr
	}
	if "`e(cmd)'" == "nbreg" | "`e(cmd)'" == "poisson" | ///
		"`e(cmd)'" == "tnbreg" | "`e(cmd)'" == "tpoisson" | ///
		"`e(cmd)'" == "zinb" | "`e(cmd)'" == "zip" | ///
		"`e(cmd)'" == "mepoisson" {
		local allowed `allowed' irr
	}
	if "`e(cmd)'" == "streg" | "`e(cmd)'" == "mestreg" {
		local allowed `allowed' tr tratio
	}
	if "`e(cmd)'" == "binreg" {
		if "`s(opt)'" == "hr" {
			local eformstr "Hlth Ratio"
			local eformopts "eform(Hlth Ratio)"
		}
		if "`s(opt)'" == "rrr" {
			local eformstr "Risk Ratio"
			local eformopts "eform(Risk Ratio)"
		}
	}

	// parse `options' for -eform()- and friends
	capture _get_eformopts , eformopts(`eformopts') allowed(`allowed')
	if _rc == 0 {
		if "`e(k_eform)'" == "0" {
			local eform
		}
		else {
			local eform `"`s(str)'"'
		}
		if "`eform'" == "" {
			local eform eform
		}
	}
	else {
		local eform `eformopts'
	}

	local eform_cons_ti `"`s(eform_cons_ti)'"'
	if ("`e(consonly)'"!="1" | `"`eform_cons_ti'"'=="") {
		local eformdi `"`s(str)'"'
	}
	else {
		local eformdi `"`eform_cons_ti'"'
	}
	local coefttl = cond(`"`eform'"'==`""', `"`coeftitle'"', `"`eformdi'"')

	if "`eformdi'"!="" {
		local k_eform `e(k_eform)'
		if ("`k_eform'"=="") {
			local k_eform = 1
		}
		local k_eq `e(k_eq)'
		if ("`k_eq'"=="") {
			local k_eq = 1
		}
		if (`k_eform'<`k_eq' & `k_eform') {
			_eform_multeq_note efnote : `k_eform'
			local footnotes "`footnotes'`efnote'"
               	}
        }        
	if (`"`eformdi'"'!="" & "`e(noconstant)'"=="0" & ///
                `"`eform_cons_ti'"'!="" & "`e(consonly)'"!="1") {
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
		local footnotes "`footnotes'{p 0 6 2}Note: {res:_cons} estimates `eform_cons_note'`extranote'"
                if ("`e(cmd)'"=="mlogit" | "`e(cmd)'"=="asclogit") {
			local footnotes "`footnotes' for each outcome"
                }
		local footnotes "`footnotes'.{p_end}"
        }

	sreturn local footnotes = `"`footnotes'"'
end
