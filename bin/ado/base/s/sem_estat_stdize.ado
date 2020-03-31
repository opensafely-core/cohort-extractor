*! version 1.0.0  29mar2011
program sem_estat_stdize, eclass
	version 12

	if "`e(cmd)'"!="sem" { 
		error 301
	}
	gettoken left 0: 0, parse(":")
	
	if `:length local 0' <=1 {
		di as err "syntax is {bf:estat stdize :} {it:command}"
		exit 198
	}

	gettoken cmdname cmd: 0, parse(" ")

	local 0 ",`cmdname'"
	syntax [, 			///
			TEst 		///
			TESTNL		///
			TESTPARM	///
			NLCOM		///
			LINCOM		///
			*		///
			]		

	if "`test'`testnl'`testparm'`nlcom'`lincom'" == "" {
		di as err "`cmdname' not allowed with estat stdize"
		exit 198
	}

	tempname est b V
	mat `b' = e(b_std)
	mat `V' = e(V_std)

	_estimates hold `est', copy restore
	ereturn repost b = `b' V = `V'

	`cmdname' `cmd'

	_estimates unhold `est'
end
exit

