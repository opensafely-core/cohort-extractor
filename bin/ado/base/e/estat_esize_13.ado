*! version 1.0.5  19dec2014

program estat_esize_13, rclass
	version 13
	syntax , [OMega Level(cilevel)]
	
	if !inlist(e(cmd),"regress","anova") {
		di as error ///
		"{bf:estat esize} only works after {bf:anova} and {bf:regress}"
		error 321	
	}
	
	if "`level'"=="" {
		local level=c(level)
	}
	
	if floor(real(`"`level'"')) < 50 {
		di as error ///
		"{bf:level()} must be between 50 and 99.99 inclusive for estat esize"
		exit 198
	}
	
	if e(cmd) == "regress" {
		if e(vce) != "ols" {
			di as error "{bf:estat esize} only works with {bf:vce(ols)}"
			exit 198
		}
	}
	
	tempname LastEstimates
	_estimates hold `LastEstimates', copy restore
	
	// DEFINE TEMPORARY SCALARS
	tempname regress_rss

	// CHECK TO SEE IF -regress- WAS THE LAST COMMAND
	// =====================================================================
	if e(cmd) == "regress" {
		// -_reg_to_anova- NEEDS THE VARIABLES TO EXIST IN THE DATASET
		// 	BUT DOES NOT USE THEM IN THE CALCULATIONS
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
		scalar `regress_rss' = e(rss)
		quietly _reg_to_anova `if' `in' [`weight'`exp'], `opts' buildit
		if reldif(e(rss),`regress_rss') > 1e-7 {
			di as error ///
			    "data may have changed since you ran {bf:regress}"
			error 198
		}
		// REMOVE ONLY THE "ARTIFICIAL" VARIABLES
		foreach TempVar of local ToRemoveList {
			capture confirm variable `TempVar'
			if c(rc) == 0 {
				drop `TempVar'
			}
		}
	}

	// CALCULATIONS BASED ON ANOVA OUTPUT
	estat_esize_calc, level(`level') `omega'
	
	// DISPLAY OUTPUT
	estat_esize_disp, level(`level') `omega'
	return add
end


program estat_esize_calc, rclass
	syntax , [OMega Level(cilevel)]

	// DEFINE TEMPORARY SCALARS
	tempname ModelEta2 F NumDF DenDF LowerEta2 UpperEta2 Eta2 
	tempname alpha AlphaLower AlphaUpper
	tempname ModelOmega2 Omega2 LowerOmega2 UpperOmega2
	tempname LambdaLower LambdaUpper 
	tempname OutputWidth regress_rss mesize
	tempname b b_pos b_term_size


	scalar `AlphaLower' = (`level'+100)/200
	scalar `AlphaUpper' = 1 - ((`level'+100)/200)

	scalar `NumDF' = e(df_m)
	scalar `DenDF' = e(df_r)
	scalar `F' = e(F)

	scalar `ModelEta2'=`NumDF'*`F'/(`NumDF'*`F'+`DenDF')
	scalar `LambdaLower' = npnF(`NumDF',`DenDF',`F',`AlphaLower')
	scalar `LowerEta2' = `LambdaLower'/ (`LambdaLower'+`NumDF'+`DenDF'+1)
	scalar `LambdaUpper' = npnF(`NumDF',`DenDF',`F',`AlphaUpper')
	scalar `UpperEta2' = `LambdaUpper'/ (`LambdaUpper'+`NumDF'+`DenDF'+1)
	// CALCULATE OMEGA-SQUARED FOR THE ENTIRE MODEL
	// THE EQUATION FOR OMEGA-SQUARED COMES FROM SMITHSON (2001):
	//	EQUATION (7) ON PAGE 615 IS SUBSTITUTED FOR R2 IN 
	//	EQUATION (12) ON PAGE 619 
	scalar `ModelOmega2' = max(0,	///
		`ModelEta2'-(`NumDF'/`DenDF')*(1-`ModelEta2'))
	scalar `LowerOmega2' = `LowerEta2'-(`NumDF'/`DenDF')*(1-`LowerEta2')
	if !missing(`LowerOmega2') {
		scalar `LowerOmega2' = max(0, `LowerOmega2')
	}
	scalar `UpperOmega2' = `UpperEta2'-(`NumDF'/`DenDF')*(1-`UpperEta2')
	if !missing(`UpperOmega2') {
		scalar `UpperOmega2' = min(1, `UpperOmega2')
	}
		
	matrix `mesize' = (	`ModelEta2', 	///
				`LowerEta2', 	///
				`UpperEta2', 	///
				`ModelOmega2', 	///
				`LowerOmega2', 	///
				`UpperOmega2', 	///
				`NumDF', 	///
				`DenDF', 	///
				`F')

	local RowNames "Model"
	matrix `b' = e(b)
	mata : st_matrix("`b_term_size'", st_matrixcolstripe_term_size("`b'")')
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
				
				// CALCULATE PARTIAL OMEGA-SQUARED
				scalar `Omega2' = ///
				    max(0,`Eta2'-(`NumDF'/`DenDF')*(1-`Eta2'))
				scalar `LowerOmega2' = ///
					`LowerEta2'-(`NumDF'/	///
					`DenDF')*(1-`LowerEta2')
				if !missing(`LowerOmega2') {
					scalar `LowerOmega2' = ///
						max(0, `LowerOmega2')
				}
				scalar `UpperOmega2' = ///
					`UpperEta2'-(`NumDF'/	///
					`DenDF')*(1-`UpperEta2')
				if !missing(`UpperOmega2') {
					scalar `UpperOmega2' = ///
						min(1, `UpperOmega2')
				}
				matrix `mesize' = (	`mesize' \ 	///
							`Eta2', 	///
							`LowerEta2', 	///
							`UpperEta2', 	///
							`Omega2', 	///
							`LowerOmega2', 	///
							`UpperOmega2', 	///
							`NumDF', 	///
							`DenDF', 	///
							`F')
			}
			else {
				matrix `mesize' = ///
					(`mesize' \ 0, 0, 0, 0, 0, 0, 0, 0, 0)
			}
			local RowNames "`RowNames' `TempSource'"
			local pos = `pos' + `b_term_size'[1,`i']
		}

	matrix rownames `mesize' = `RowNames'
	matrix colnames `mesize' = eta2 lb_eta2 ub_eta2 	///
				   omega2 lb_omega2 ub_omega2 	///
				   df_num df_den F
	return matrix esize = `mesize'
end




program estat_esize_disp, rclass
	syntax , [OMega Level(cilevel)]

	disp _newline as text "Effect sizes for linear models" _newline
	if "`omega'" == "" {
		local TableLabel "Eta-Squared"
	}
	else {
		local TableLabel "Omega-Squared"
	}
	tempname mytab esize
	matrix `esize' = r(esize)
	local RowCount = rowsof(`esize')
	local rownames: rownames `esize'

	local OutputWidth = 20
	// DETERMINE THE LONGEST ROWNAME
	forvalues i = 1(1)`RowCount' {
		local RowName: word `i' of `rownames'
		local OutputWidth = max(`OutputWidth', length("`RowName'"))
	}
	local OutputWidth = min(`OutputWidth', c(linesize)-56)
	
        .`mytab' = ._tab.new, col(5) lmargin(0)
        .`mytab'.width    `OutputWidth'   |15  7  12    12
        .`mytab'.titlefmt  .     .   . %24s   .
        .`mytab'.pad       .     2   1  3     3
        .`mytab'.numfmt    . %9.0g %5.0g %9.0g %9.0g
	.`mytab'.strcolor result  .  .  .  .
        .`mytab'.strfmt    %`--OutputWidth's  .  .  .  .
        .`mytab'.strcolor   text  .  .  .  .
	.`mytab'.sep, top
	.`mytab'.titles "Source"    	               		/// 1
                        "`TableLabel'"                 		/// 2
			"df"					///  3
                        "[`level'% Conf. Interval]" ""  	//  4 5
	.`mytab'.sep, middle
	forvalues i = 1(1)`RowCount' {
		local RowName: word `i' of `rownames'
		if "`omega'" != "" & strpos("`RowName'","|")==0{
			_ms_display, el(`i') first allbase row	///
				width(`OutputWidth') nolevel 	///
				vsquish novbar matrix(`esize') 
			.`mytab'.row    ""	 		///
				`esize'[`i',4]			///
				`esize'[`i',7]			///
				`esize'[`i',5] 			///
				`esize'[`i',6]
		}
		else if strpos("`RowName'","|")==0 {
			_ms_display, el(`i') first allbase row	///
				width(`OutputWidth') nolevel 	///
				vsquish novbar matrix(`esize')
			.`mytab'.row    "" 			///
				`esize'[`i',1]			///
				`esize'[`i',7]			///
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
	
	return scalar level = `level'
	return matrix esize = `esize', copy
end




