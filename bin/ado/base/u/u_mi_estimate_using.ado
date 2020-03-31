*! version 1.0.1  29apr2011

program u_mi_estimate_using, eclass
	version 11

	gettoken miest 0 : 0
	check_class_exists `miest'
	
	local cmdline : copy local 0

	syntax [anything(name=exprlist id="expression list")] using/ [, * ]
	local estfile `"`using'"'
	local opts `options'

	u_mi_estimate_check_using `"`estfile'"' "" "norestore"
	local Nest = `s(N_est)'
	local M_max = `Nest'-1
	local fname	`"`s(fname)'"'
	local m_mi	"`s(m_mi)'"	// saved imputation numbers
	local cmdname 	"`s(cmdname)'"
	local command	`e(cmdline)'
	local k_eq `e(k_eq_model_mi)'
	local esampvary `e(esampvary_mi)'
	if ("`esampvary'"=="1") {
		local esampvaryflag esampvaryflag
	}
	local number `s(firstm)'

	// check expressions -- need e(b) in memory
	qui estimates use `"`estfile'"', number(`number')
	// parse expressions and eform_opts
	// Note: common to -mi estimate-
	tempname mi_expr
        .`mi_expr'    = .u_mi_expr_parser.new, stub(_mi_) cmdname("`cmdname'")
        .`mi_expr'.parse `exprlist', `opts'
	local k_exp	= r(k_exp)
	local eform	`r(eform)'
	local efopt 	`r(efopt)'
	if ("`eform'"=="") {
		local eform `efopt'
	}
	local opts	`r(options)'
	if (`k_exp') {
	        .`mi_expr'.build_nlcom
		local nlcom `"`s(nlcom)'"'
	}
	cap .`mi_expr'.chk_exprs
	if (_rc!=498) { // stop if syntax error
		.`mi_expr'.chk_exprs
		/*NOTREACHED*/
	}
	local command `e(cmdline)'

	//check all allowed options w/o eform_opts
	local 0 , `opts'
	u_mi_estimate_get_commonopts "`cmdname'" "usingspec"
	local syntax_opts `s(common_opts)'
	syntax	[,				///
			`syntax_opts'		/// // common to -mi estimate-
						/// // plus -using- opts
			*			/// factor rep. opts
		]
	if ("`errorok'"!="") {
		local errok errok
	}
	// -cmdok-, and -esampvaryok- are implied
	local cmdok cmdok
	local esampvaryok esampvaryok
	// check factor-related estimation options
	_get_diopts diopts rest, `options'
	if (`"`rest'"'!="") {
		di as err `"option {bf:`rest'} not allowed"'
		exit 198
	}

	if ("`showimputations'"!="") {
		local diimps = subinstr("`m_mi'", " ", ",", .)
		di as txt "(note: `fname' contains {it:m}=`diimps')"
	}
	if ("`trace'"!="") {
		local noisily noisily
	}
	if ("`replay'"!="") {
		local noisily noisily
	}
	if ("`noisily'"!="") {
		local dots 
	}

	// check options and build macro estimations
	u_mi_estimate_chk_commonopts ,  implist(`m_mi') cmd(`cmdname') ///
					usingspec `opts'
	local diopts `diopts' `s(diopts)'
	local diopts `diopts' `eform'
	if ("`estimations'"=="") {
		local estimations `s(estimations)'
	}
	local M : list sizeof estimations

	if ("`cmdlegend'"!="") {
		di as txt _n `"{p 2 13 2}command: {cmd:`command'}{p_end}"'
	}

	if (`k_exp' & "`dots'"!="") {
		di
                di as txt "Imputations ({res:`M'}):"
                u_mi_dots, title(estimating transformations) indent(2)
	}

	// perform MI analysis
        .`mi_expr'.post_legend	"_mi"	// post expressions
	mata: `miest'.init0(`M',`k_exp',`level',`esampvary')
	// note: .combine() uses -_estimates- to restore current e()
	mata: `miest'.combine(`"`estfile'"', `"`nlcom'"', `"`estimations'"')
	mata: `miest'.analyze()

	// compute Monte Carlo estimates using jackknife method
	if ("`mcerror'"!="") {
		mata: `miest'.jknife(`"`eform'"')
	}

	// load back mi results
	qui estimates use `"`estfile'"', number(`Nest')
	mata: `miest'.post()		// replace -mi- e() results
	_ms_build_info e(b_mi)
	eret local cmdline_mi `"mi estimate`cmdline'"'

	// display results
	mi estimate , `diopts' `esampvaryflag'
	
end

program check_class_exists
	args miest

	mata : st_local("empty",strofreal((findexternal("`miest'") == NULL)))
	if (`empty') {
		di as err "{bf:mi estimate} internal error:  "	///
		   "{bf:_Mi_Combine} class instance {bf:`miest'} not found"
                exit 111
        }
end

exit
