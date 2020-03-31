*! version 1.1.1  13sep2017
program estat_esize
	if _caller() <= 15 {
		estat_esize_13 `0'
		exit
	}
	Esize `0'
end

program Esize, rclass
	version 15
	syntax , [EPSilon OMega Level(cilevel)]

	opts_exclusive "`epsilon' `omega'"

	if !inlist("`e(cmd)'", "regress", "anova") {
		di as error ///
		"{bf:estat esize} only works after {bf:anova} and {bf:regress}"
		error 321
	}

	if floor(real(`"`level'"')) < 50 {
		di as error ///
"{bf:level()} must be between 50 and 99.99 inclusive for {bf:estat} {bf:esize}"
		exit 198
	}

	if "`e(cmd)'" == "regress" & "`e(vce)'" != "ols" {
		di as error "{bf:estat esize} only works with {bf:vce(ols)}"
		exit 198
	}

	tempname LastEstimates
	_estimates hold `LastEstimates', copy restore

	if e(cmd) == "regress" {
		Reg2Anova
	}

	tempname esize
	Calc `esize' `level'
	if `"`epsilon'`omega'"' == "" {
		DispEta `esize' `level'
	}
	else {
		DispAlt `esize' `level' `epsilon' `omega'
	}
	return add
	return scalar level = `level'
	return matrix esize `esize'
end

program Reg2Anova
	local TempList : colnames e(b)
	foreach TempWord of local TempList {
		gettoken left TempVar: TempWord, parse(" .")
		local TempVar = 			///
			cond(`"`TempVar'"'!="", 	///
			`"`TempVar'"', `"`left'"')
		gettoken TempVar right: TempVar, parse(" #")
		local TempVar = subinstr(`"`TempVar'"',"."," ",.)
		local TempVar = subinstr(`"`TempVar'"',"_cons","",.)
		local NewList `"`NewList' `TempVar'"'
	}
	local NewList : list uniq NewList
	local NewList `"`e(depvar)' `NewList'"'
	foreach TempVar of local NewList {
		capture confirm variable `TempVar'
		if _rc != 0 {
			gen `TempVar' = .
			local ToRemoveList `"`ToRemoveList' `TempVar'"'
		}
	}
	tempname regress_rss
	scalar `regress_rss' = e(rss)
	quietly _reg_to_anova `if' `in' [`weight'`exp'], `opts' buildit
	if reldif(e(rss),`regress_rss') > 1e-7 {
		di as error ///
		    "data may have changed since you ran {bf:regress}"
		error 459
	}
	foreach TempVar of local ToRemoveList {
		capture confirm variable `TempVar'
		if c(rc) == 0 {
			drop `TempVar'
		}
	}
end

program Calc
	args esize level

	// DEFINE TEMPORARY SCALARS
	tempname Eta2 F NumDF DenDF LowerEta2 UpperEta2
	tempname alpha AlphaLower AlphaUpper
	tempname Eps2
	tempname Omega2
	tempname LambdaLower LambdaUpper
	tempname OutputWidth regress_rss
	tempname b b_pos b_term_size

	scalar `AlphaLower' = (`level'+100)/200
	scalar `AlphaUpper' = 1 - ((`level'+100)/200)

	scalar `NumDF' = e(df_m)
	scalar `DenDF' = e(df_r)
	scalar `F' = e(F)

	scalar `Eta2' = `F'/(`F'+`DenDF'/`NumDF')
	scalar `LambdaLower' = npnF(`NumDF',`DenDF',`F',`AlphaLower')
	scalar `LowerEta2' = `LambdaLower'/ (`LambdaLower'+`NumDF'+`DenDF'+1)
	scalar `LambdaUpper' = npnF(`NumDF',`DenDF',`F',`AlphaUpper')
	scalar `UpperEta2' = `LambdaUpper'/ (`LambdaUpper'+`NumDF'+`DenDF'+1)
	scalar `Eps2' = `Eta2'-(`NumDF'/`DenDF')*(1-`Eta2')
	scalar `Omega2' = (`F'-1)/(`F'+(`DenDF'+1)/`NumDF')

	matrix `esize' =	`Eta2', 	/// 1
				`LowerEta2', 	/// 2
				`UpperEta2', 	/// 3
				`Eps2',		/// 4
				`Omega2',	/// 5
				`NumDF', 	/// 6
				`DenDF', 	/// 7
				`F'		 // 8

	local RowNames "Model"
	matrix `b' = e(b)
	mata: st_matrix("`b_term_size'", st_matrixcolstripe_term_size("`b'")')
	local dim = colsof(`b_term_size')
	local pos = 1
	forval i = 1/`dim' {
		matrix `b_pos' = `b'[1,`pos'..`pos']
		local TempSource : colname `b_pos'
		if "`TempSource'" == "_cons" {
			continue, break
		}
		else if strpos("`TempSource'","|")==0 {
			scalar `NumDF' = e(df_`i')
			scalar `F' = e(F_`i')
			if `"`e(errorterm_`i')'"' != "" {
				scalar `DenDF' = e(dfdenom_`i')
			}
			else {
				scalar `DenDF' = e(df_r)
			}

			scalar `Eta2'=`NumDF'*`F'/(`NumDF'*`F'+`DenDF')
			scalar `LambdaLower' = ///
				npnF(`NumDF',`DenDF',`F',`AlphaLower')
			scalar `LowerEta2' = ///
				`LambdaLower'/		///
				(`LambdaLower'+`NumDF'+`DenDF'+1)
			scalar `LambdaUpper' = ///
				npnF(`NumDF',`DenDF',`F',`AlphaUpper')
			scalar `UpperEta2' = ///
				`LambdaUpper'/		///
				(`LambdaUpper'+`NumDF'+`DenDF'+1)

			scalar `Eps2' = `Eta2'-(`NumDF'/`DenDF')*(1-`Eta2')
			scalar `Omega2' = (`F'-1)/(`F'+(`DenDF'+1)/`NumDF')

			matrix `esize' =	`esize' \ 	///
						`Eta2', 	/// 1
						`LowerEta2', 	/// 2
						`UpperEta2', 	/// 3
						`Eps2', 	/// 4
						`Omega2', 	/// 5
						`NumDF', 	/// 6
						`DenDF', 	/// 7
						`F'		 // 8
		}
		else {
			matrix `esize' = `esize' \ J(1,8,0)
		}
		local RowNames "`RowNames' `TempSource'"
		local pos = `pos' + `b_term_size'[1,`i']
	}

	matrix rownames `esize' = `RowNames'
	matrix colnames `esize' =	eta2		/// 1
					lb_eta2		/// 2
					ub_eta2		/// 3
					epsilon2	/// 4
					omega2		/// 5
					df_num		/// 6
					df_den		/// 7
					F		 // 8
end

program DispEta
	args esize level

	disp _newline as text "Effect sizes for linear models" _newline

	local TableLabel "Eta-Squared"

	local RowCount = rowsof(`esize')
	local rownames: rownames `esize'

	local OutputWidth = 20
	forvalues i = 1/`RowCount' {
		local RowName: word `i' of `rownames'
		local OutputWidth = max(`OutputWidth', length("`RowName'"))
	}
	local OutputWidth = min(`OutputWidth', c(linesize)-56)

	local c2width : length local TableLabel
	local c2width = max(`c2width'+2, 11)
	local c2pad = ceil((`c2width' - 9)/2)
	tempname mytab
        .`mytab' = ._tab.new, col(5) lmargin(0) puttab(`mytab')
        .`mytab'.width    `OutputWidth'   |`c2width'  7  12    12
        .`mytab'.titlefmt  .       .   . %24s   .
        .`mytab'.pad       . `c2pad'   1  3     3
        .`mytab'.numfmt    . %9.0g %5.0g %9.0g %9.0g
	.`mytab'.strcolor result  .  .  .  .
        .`mytab'.strfmt    %`--OutputWidth's  .  .  .  .
        .`mytab'.strcolor   text  .  .  .  .
	.`mytab'.sep, top
	.`mytab'.titles "Source"    	               		/// 1
                        "`TableLabel'"                 		/// 2
			"df"					/// 3
                        "[`level'% Conf. Interval]" ""  	//  4 5
	mata: st_put_tab_reset_cspans("`mytab'", "1 1 2 0")
	.`mytab'.sep, middle
	forvalues i = 1(1)`RowCount' {
		local RowName: word `i' of `rownames'
		if strpos("`RowName'","|")==0 {
			_ms_display, el(`i') first allbase row	///
				width(`OutputWidth') nolevel 	///
				vsquish novbar matrix(`esize')
			.`mytab'.row    "" 			///
				`esize'[`i',1]			///
				`esize'[`i',6]			///
				`esize'[`i',2] 			///
				`esize'[`i',3]
		}
		if `i'==1 {
			.`mytab'.row    "" "" "" "" ""
		}
		if strpos("`RowName'","|")>0 {
			_ms_display, el(`i') first allbase row	///
				width(`OutputWidth') nolevel 	///
				vsquish novbar matrix(`esize')
			.`mytab'.row    "" "" "" "" ""
			.`mytab'.sep, middle
		}
	}
	.`mytab'.sep, bottom
	.`mytab'.post_results
	if `RowCount' > 2 {
		di as txt "{p 0 6 2}"
		di as txt ///
"Note: `TableLabel' values for individual model terms are partial."
		di as txt "{p_end}"
	}
end

program DispAlt
	args esize level type

	disp _newline as text "Effect sizes for linear models" _newline

	local col = cond("`type'" == "epsilon", 4, 5)

	local type = strproper("`type'")
	local TableLabel "`type'-Squared"

	local RowCount = rowsof(`esize')
	local rownames: rownames `esize'

	local OutputWidth = 20
	forvalues i = 1/`RowCount' {
		local RowName: word `i' of `rownames'
		local OutputWidth = max(`OutputWidth', length("`RowName'"))
	}
	local OutputWidth = min(`OutputWidth', c(linesize)-56)

	local c2width : length local TableLabel
	local c2width = max(`c2width'+2, 11)
	local c2pad = ceil((`c2width' - 9)/2)
	tempname mytab
        .`mytab' = ._tab.new, col(3) lmargin(0) puttab(`mytab')
        .`mytab'.width    `OutputWidth'   |`c2width'  7
        .`mytab'.titlefmt  .       . %7s 
        .`mytab'.pad       . `c2pad'   2
        .`mytab'.numfmt    . %9.0g %5.0g
	.`mytab'.strcolor result  .  .
        .`mytab'.strfmt    %`--OutputWidth's  .  .
        .`mytab'.strcolor   text  .  .
	.`mytab'.sep, top
	.`mytab'.titles "Source"    	               		/// 1
                        "`TableLabel'"                 		/// 2
			"df"					 // 3
	.`mytab'.sep, middle
	forvalues i = 1(1)`RowCount' {
		local RowName: word `i' of `rownames'
		if strpos("`RowName'","|")==0 {
			_ms_display, el(`i') first allbase row	///
				width(`OutputWidth') nolevel 	///
				vsquish novbar matrix(`esize')
			.`mytab'.row    "" 			///
				`esize'[`i',`col']		///
				`esize'[`i',6]
		}
		if `i'==1 {
			.`mytab'.row    "" "" ""
		}
		if strpos("`RowName'","|")>0 {
			_ms_display, el(`i') first allbase row	///
				width(`OutputWidth') nolevel 	///
				vsquish novbar matrix(`esize')
			.`mytab'.row    "" "" ""
			.`mytab'.sep, middle
		}
	}
	.`mytab'.sep, bottom
	.`mytab'.post_results
	if `RowCount' > 2 {
		di as txt "{p 0 6 2}"
		di as txt ///
"Note: `TableLabel' values for individual model terms are partial."
		di as txt "{p_end}"
	}
end

exit
