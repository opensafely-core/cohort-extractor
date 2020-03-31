*! version 1.1.0  21jan2020
program pwmean
	version 12
	if replay() {
		if "`e(cmd)'" != "pwmean" {
			error 301
		}
		if _by() {
			error 190
		}
		syntax [, *]
		_get_mcompare pwmean, `options'
		if "`s(adjustall)'" != "" {
			di as err "option adjustall not allowed"
			exit 198
		}
		local mop	`"`s(method)'"'
		local options	`"`s(options)'"'
		local mvs	`"`e(mcmethod_vs)'"'
		if inlist("dunnett", "`mop'", "`mvs'") & "`mop'" != "`mvs'" {
			tempname ehold
			_est hold `ehold', restore copy
			PWmean,	`mop'
		}
		_marg_report, mcompare(`mop') `options'
		exit
	}

	Estimate `0'
end

program Estimate, eclass
	local cmdline : copy local 0
	syntax [varlist(min=1 max=1 numeric default=none)]	///
		[if] [in],					///
		over(varlist fv numeric)			///
	[	Level(cilevel)					/// diopts
		CIeffects					///
		PVeffects					///
		EFFects						///
		CIMeans						///
		GROUPs						///
		SORT						///
		POST						/// [sic]
		POSTTABLE					/// NODOC
		*						/// diopts
	]

	gettoken tok rest : over, parse("#")
	if bsubstr("`rest'",1,1) == "#" {
		di as err ///
"interactions may not be specified in the over() option"
		exit 198
	}
	if `:list sizeof over' > 8 {
		di as err "too many variables in over() option"
		exit 103
	}

	local ditype	`groups'	///
			`cimeans'	///
			`effects'	///
			`pveffects'	///
			`cieffects'

	ereturn clear
	_get_mcompare pwcompare, `options'
	if "`s(adjustall)'" != "" {
		di as err "option adjustall not allowed"
		exit 198
	}
	local method	`"`s(method)'"'
	local options	`"`s(options)'"'

	_get_diopts diopts, `options'
	local diopts	`diopts'	///
			`ditype'	///
			`sort'		///
			level(`level')

	local OVER : subinstr local over " " "#", all
	quietly regress `varlist' i.(`OVER') `if' `in'
	PWmean, `posttable' `method'
	ereturn local cmdline `"pwmean `cmdline'"'

	_marg_report, `diopts' mcompare(`method')
end

program PWmean, eclass
	syntax [, *]

	_unab *, matrix(e(b))
	local over `"`r(varlist)'"'
	local OVER : subinstr local over " " "#", all

	local depvar `"`e(depvar)'"'
	quietly					///
	pwcompare `OVER',	`options'	///
				post

	ereturn local est_cmd
	ereturn local vce
	ereturn local k_terms
	ereturn local M
	ereturn local L
	ereturn local emptycells
	ereturn local margin_method
	ereturn local est_cmdline
	ereturn hidden local terms `"`OVER'"'
	ereturn local over `"`over'"'
	ereturn local depvar "`depvar'"
	ereturn local title "Pairwise comparisons of means with equal variances"
	ereturn local cmd pwmean
end
exit
