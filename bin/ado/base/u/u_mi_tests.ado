*! version 1.1.0  04jul2011

program u_mi_tests, rclass
	local version : di "version " string(_caller()) ":"
	version 11

	args test speclist

	if ("`test'"=="testtransform") {
		local ADDOPTS NOLEGend
		local structtype "Q"
		local transf transf
	}
	else {
		local ADDOPTS CONStant
		local structtype "b"
	}
	
	local 0 `speclist'
	syntax anything(name=speclist id="specification list") , 	///
						[ 			///
							NOSMALL 	///
							UFMITest 	///
							`ADDOPTS'	///
						]
	if (strpos(`"`speclist'"', "=")) {
		di as err "=exp not allowed"
		exit 101
	}
	// display note
	if ("`ufmitest'"=="") {
		di as txt 	///
		   "note: assuming equal fractions of missing information"
	}
	// display legend	
	if ("`test'"=="testtransform" & "`nolegend'"=="") { 
						// for -mi testtransform-
		di
		u_mi_trcoef_legend `"`speclist'"'
	}
	local clname
	cap noi {
		mata: u_mi_get_mata_instanced_var("clname", "_MI_TEST")
		mata: `clname' = _Mi_Test()
		`version' mata: `clname'.init("`structtype'") 

		_postbV, `ufmitest' `transf'
		qui test `speclist', `constant'
		// save dropped constraints
		local drop = r(drop)
		local i = 1
		while (r(dropped_`i')!=.) {
			local dropped `dropped' `r(dropped_`i')'
			local ++i
		}
		local ndrop = `i'-1
		// obtain test matrix
		tempname Rr
		mat `Rr' = get(Rr)
		local ncols = colsof(`Rr')-1
		mat `Rr' = `Rr'[1...,1..`ncols']
		// perform MI test
		mata: _Mi_Combine::_mitest_compute(`clname'.S,  ///
						   `clname'.T,	///
						   st_matrix("`Rr'"))
		mata: _Mi_Combine::_mitest_post(`clname'.T, "e", "_mi")
		local df   = e(df_m_mi)
		local df_r = e(df_r_mi)
		local F	   = e(F_mi)
		local p	   = e(p_mi)

		// display test results
		test `testlist', notest `constant'
		ret clear
		if (`drop') {
			tokenize `dropped'
			forvalues i=1/`ndrop' {
				di as txt "       Constraint ``i'' dropped"
				ret scalar dropped_`i' = ``i''
			}
		}
		local dfm_l : di %3.0f `df'
		local dfm_l2: di %6.1f `df_r'
		if (missing(`df_r') & !missing(`p')) {
			local Fout  ///
				"{help mi_missingdf##|_new:F(`dfm_l',`dfm_l2')}"
		}
		else {
			local Fout F(`dfm_l',`dfm_l2')
		}
		di
		di as txt ///
		   `"       `Fout' ="' ///
		   as res %8.2f `F'
		di as txt _col(13) "Prob > F =" as res %10.4f `p'

		ret scalar drop	= `drop'
		ret scalar p	= `p'
		ret scalar F	= `F'
		ret scalar df_r	= `df_r'
		ret scalar df	= `df'	
	}

	nobreak {
		local rc = _rc
		cap mata: mata drop `clname'
	}
	exit `rc'
end


program _postbV, eclass
	syntax [, ufmitest transf ]

	tempname b V
	if "`transf'"!="" {
		local Q _Q
		mat `b' = e(b_Q_mi)
		mat `V' = e(V_Q_mi)
	}
	else if "`e(Cns_mi)'"=="matrix" {
		tempname C
		mat `C' = e(Cns_mi)
		local Cns `C'
	}
	if "`ufmitest'"!="" {
		mat `b' = e(b`Q'_mi)
		mat `V' = e(V`Q'_mi)
	}
	else {
		mat `b' = e(b`Q'_mi)
		mat `V' = e(W`Q'_mi)
	}
	eret post `b' `V' `Cns'
end

local SS		string				scalar
local MISTRUCT          struct _mistats_struct          scalar
local MITEST            struct _mitest_struct           scalar

mata:

class _Mi_Test {

    public:
	`MISTRUCT'	S
	`MITEST'	T

    public:
	void init()
}

void _Mi_Test::init(`SS' structtype)
{
	S	= _Mi_Combine::_mistats_init_on_replay(structtype)
	S.caller = callersversion()
	S.nosmall   = (st_local("nosmall")!="")
	T.is_equal  = (st_local("ufmitest")=="")
}
end

exit
