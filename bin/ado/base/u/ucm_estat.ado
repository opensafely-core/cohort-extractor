*! version 1.0.2  20jan2015
* svn:LF

program define ucm_estat
	version 11

	if "`e(cmd)'" != "ucm" {
		di as err "{help ucm##|_new:ucm} estimation results " ///
		 "not found"
		exit 301
	}
	gettoken sub rest: 0, parse(" ,")
	local lsub = length("`sub'")

	if "`sub'" == bsubstr("period",1,max(3,`lsub')) {
		/* display frequency/periods				*/
		CyclePeriod `rest'
	}
	else _sspace_estat `0'
end

program ParseLevel, sclass
	syntax, Level(cilevel)

	sreturn local level `level'
end

program CyclePeriod, rclass
	syntax [, Level(cilevel) cformat(passthru) ]
	/* undocumented: cformat()					*/

	tempname G V T f p d b vf vd vp l z bmat vmat
	tempname flb fub plb pub dlb dub

	mat `G' = e(gamma)
	mat `V' = e(V)

	if ("`border'"=="") local border border(top bottom)
	if ("`left'"!="") local lopt left(`left')

	local i = 0
	local c = 0
	local k = colsof(`G')
	mat `b' = e(b)
	local ll : subinstr local level "." "_", all
	local llb `ll'% lb
	local lub `ll'% ub
	scalar `l' = (100-`level')/200
	scalar `z' = abs(invnorm(`l'))
	while (`++i' < `k') {
		if `G'[1,`i'] == 9 {
			scalar `f' = `b'[1,`i']
			scalar `vf' = sqrt(`V'[`i',`i'])
			scalar `flb' = `f'-`z'*`vf'
			scalar `fub' = `f'+`z'*`vf'
			scalar `p' = 2*c(pi)/`f'
			scalar `vp' = 2*c(pi)*`vf'/`f'/`f'
			scalar `plb' = `p'-`z'*`vp'
			scalar `pub' = `p'+`z'*`vp'
			scalar `d' = `b'[1,`++i']
			scalar `vd' = sqrt(`V'[`i',`i'])
			scalar `dlb' = `d'-`z'*`vd'
			scalar `dub' = `d'+`z'*`vd'
			mat `bmat' = (`p',`f',`d')
			mat `vmat' = (`vp',`vf',`vd')
			mat `T' = (`p',`vp', `plb', `pub' \ ///
				   `f',`vf', `flb', `fub' \ ///
				   `d',`vd', `dlb', `dub' )
			mat rownames `T' = period frequency damping
			mat colnames `T' = "coef" "stderr" "`llb'" "`lub'"
			Display, bmatrix(`T') level(`level') `cformat' ///
				name(cycle`++c')

			return matrix cycle`c' = `T'
		}
	}
	if `c' == 0 {
		di as err "there are no cycles in the model"
		exit 322
	}
	if e(tdelta) > 1 {
		di as txt "Note: Time units are in `e(tdeltas)'."
	}
	else if "`e(tunit)'" != "" {
		if ("`left'"=="") local left = 0

		di as txt _skip(`left') "Note: Cycle time unit is `e(tunit)'."
	}
end

program Display
	syntax, BMATrix(string) level(string) name(string) [ cformat(string) ]

	_get_diopts diopts, `options'

	tempname T es se lb ub

	local cfmt `cformat'
	if ("`cfmt'"=="") local cfmt `c(cformat)'
	if ("`cfmt'"=="") local cfmt %9.0g

	local ci `"[`=strsubdp("`level'")'% Conf. Interval]"'

	.`T' = ._tab.new, columns(5) lmargin(0) 
	// column      1       2         3        4         5
	.`T'.width    13     |11        12       12        12
	.`T'.titlefmt  .    %11s      %12s      %24s        .
	.`T'.strfmt    .    %11s      %12s        .         .
	.`T'.pad       .      2         2         3         3
	.`T'.numfmt    .  "`cfmt'"  "`cfmt'"  "`cfmt'"  "`cfmt'"
	.`T'.strcolor  .   result        .         .         .

	di
	.`T'.sep, top
	.`T'.titlefmt  %12s . . . .
	.`T'.titles "`name'" "Coef." "Std. Err." "`ci'" ""
	.`T'.sep
	local what : rownames `bmatrix'
	forvalues i=1/3 {
		scalar `es' = `bmatrix'[`i',1]
		scalar `se' = `bmatrix'[`i',2]
		scalar `lb' = `bmatrix'[`i',3]
		scalar `ub' = `bmatrix'[`i',4]
		local wi : word `i' of `what'
		.`T'.row "`wi'" `es' `se' `lb' `ub'

	}
	.`T'.sep, bottom
end

exit
