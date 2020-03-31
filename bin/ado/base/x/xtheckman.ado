*! version 1.0.0  22feb2019
program xtheckman, eclass byable(onecall) properties(xtbs)
	version 16.0
	if _by() {
                local BY `"by `_byvars'`_byrc0':"'
	}	
	`BY' _vce_parserun xtheckman, panel jkopts(eclass) noeqlist: `0'
        if "`s(exit)'" != "" {
                ereturn local cmdline `"xtheckman `0'"'
		ereturn local predict xtheckman_p
		ereturn local marginsok default xb XBsel Pr(passthru) 	///
					e(passthru) YStar(passthru) 	///
					YCond PSel
		ereturn hidden scalar n_quad3 = e(n_quad3)
		ereturn hidden scalar n_quad = e(n_quad)
                exit
        }
        if replay() {
		if "`e(cmd)'" != "xtheckman" {
			error 301
		}
		else {
			Display `0'
                }
		exit
	}
	local orig0 `0'
	ParseHeckman `0'
	local 0 `r(r0)'
	capture noisily `BY' _eregress `0'
        if _rc {
                local myrc = _rc
                exit `myrc'
        }
	else {
		ereturn local cmdline `"xtheckman `orig0'"'
		ereturn local predict xtheckman_p
		ereturn local marginsok default xb XBsel Pr(passthru) 	///
					e(passthru) YStar(passthru) 	///
					YCond PSel
		ereturn hidden scalar n_quad3 = e(n_quad3)
		ereturn hidden scalar n_quad = e(n_quad)
	}	
end

program Display
        syntax, [*]
	_prefix_display, `options'
end

program ParseDisallowed, 
	syntax [, 	ENDOGenous(string) 	/*
		*/	ENTreat(string) 	/*
		*/	EXTreat(string) 	/*
		*/ 	TOBITSELect(string) *]
	if "`endogenous'" != "" {
		di as error "option {bf:endogenous()} not allowed"
		exit 198
	}
	if "`entreat'" != "" {
		di as error "option {bf:entreat()} not allowed"
		exit 198
	}
	if "`extreat'" != "" {
		di as error "option {bf:extreat()} not allowed"
		exit 198
	}
	if "`tobitselect'" != "" {
		di as error "option {bf:tobitselect()} not allowed"
		exit 198
	}
end

program ParseHeckman, rclass
	syntax varlist(fv numeric ts) [if] [in], 		/*
			*/ SELect(passthru)			/*
			*/ [ 					/*
			*/ INTPoints(string)			/*
			*/ INTMethod(string)			/*
			*/ *]
	version 16.0
	if `"`intpoints'"' != "" {
		capture confirm integer number `intpoints'
		local rc = _rc
		capture assert `intpoints' > 1 & `intpoints' < 129
		local rc = `rc' | _rc
		if (`rc') {
			di as error "{bf:intpoints()} must be "	///
					"an integer between 2"	///
					" and 128"
			exit 198
		}
		local reintpoints reintpoints(`intpoints')
	}
	if `"`intmethod'"' != "" {
		local len = ustrlen(`"`intmethod'"')
		if "`intmethod'"!=bsubstr("ghermite",1,max(2,`len')) &	///
			"`intmethod'"!=bsubstr("mvaghermite",1,max(3,`len')) {
			di as err "{p 0 4 2}{bf:intmethod()} must be one of "
			di as err "{bf:ghermite} or {bf:mvaghermite}{p_end}"
			exit 198
		}
		local reintmethod reintmethod(`intmethod')
	}
	ParseDisallowed, `options'
	local r0 `varlist' `if' `in', `select'  ///
		`options' `reintpoints' `reintmethod' ///
		htitle("Random-effects regression with selection") re
	return local r0 `r0'
end	
exit
