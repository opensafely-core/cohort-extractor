*! version 1.2.0  04may2011
program matrix_input__dlg
	version 9.0
	gettoken subcmd 0 : 0
	`subcmd' `0'
end

program setLayout
	syntax , clsname(string) rows(int) [cols(int -1) symmetric]

	local dlg .`clsname'
	local rmax ``dlg'.main.sp_rows.max'
	local cmax ``dlg'.main.sp_cols.max' 
	local col_value = ``dlg'.main.sp_cols.value' 
		// the actual value of the spinner
	
	if `cols' == -1 {
		local cols `rows'
	}
	
	// disable columns that are out of range
	forvalues r = `rmax'(-1)1 {
		forvalues c = `cmax'(-1)`=`cols'+1' {
			`dlg'.main.ed_r`r'c`c'.disable
		}
	}
	// disable rows that are out of range	
	forvalues c = `cmax'(-1)1 {
		forvalues r = `rmax'(-1)`=`rows'+1' {
			`dlg'.main.ed_r`r'c`c'.disable
		}
	}
	// disable upper triangle for symmetric matrices
	if "`symmetric'" != "" {
		forvalues c = 2/`cols' {
			forvalues r = 1/`=`c'-1' {
				`dlg'.main.ed_r`r'c`c'.disable
			}
		}
	}	
	
	// enable rows and columns in the specified range	
	forvalues r = 1/`rows' {
		forvalues c = 1/`cols' {
			if "`symmetric'" == "" {
				`dlg'.main.ed_r`r'c`c'.enable
			}
			else {
				if `r' >= `c' {
					`dlg'.main.ed_r`r'c`c'.enable
				}
			}
		}
	}
end

program syncUpper
	syntax , clsname(string) size(int) 
	local dlg .`clsname'
	
	forvalues r = 2/`size' {
		forvalues c = 1/`size' {
			if `r' > `c' {
				`dlg'.main.ed_r`c'c`r'.setvalue ///
					"``dlg'.main.ed_r`r'c`c'.value'"
			}
		}	
	}
end

program isChangeSyncOk
	syntax , clsname(string)
	local dlg .`clsname'
	local size ``dlg'.main.sp_rows.value'
	forvalues r = 2/`size' {
		forvalues c = 1/`size' {
			if `r' > `c' {
				local lowerVal ``dlg'.main.ed_r`r'c`c'.value'
				local upperVal ``dlg'.main.ed_r`c'c`r'.value'
				if "`lowerVal'" != "" & "`upperVal'" != "" {
					if "`lowerVal'" != "`upperVal'" {
						`dlg'.Execute "program showOverrideBox"
						exit -1
					}
				}
			}
		}	
	}	
end

program loadConstantDiag
	syntax , clsname(string) rows(int) cols(int) value(string)
	local dlg .`clsname'
	local size = max(`rows', `cols')	
	forvalues i = 1/`size' {
		`dlg'.main.ed_r`i'c`i'.setvalue "`value'"
	}
end

program loadConstantFull
	syntax , clsname(string) rows(int) cols(int) value(string)
	local dlg .`clsname'
	forvalues r = 1/`rows' {
		forvalues c = 1/`cols' {
			`dlg'.main.ed_r`r'c`c'.setvalue "`value'"
		}
	}
end

program loadMatrix
	syntax , clsname(string) matrix(string) rmax(string) cmax(string)
	local dlg .`clsname'
	
	capture confirm matrix `matrix'
	if (_rc) {
		exit
	}
	
	local rows = rowsof(`matrix')
	local cols = colsof(`matrix')
	
	`dlg'.rowCount.setvalue `rows'
	`dlg'.colCount.setvalue `cols'

	if (issymmetric(`matrix')) {
		`dlg'.main.ck_sym.seton
	}
	else {
		`dlg'.main.ck_sym.setoff
	}
	`dlg'.main.sp_rows.setvalue `rows'
	`dlg'.main.sp_cols.setvalue `cols'

/*
	forvalues r = 1/`rmax' {
		forvalues c = 1/`cmax' {
			`dlg'.main.ed_r`r'c`c'.setvalue ""
		}
	}
*/

	forvalues r = 1/`rows' {
		forvalues c = 1/`cols' {
			local value = trim("`: di %15.0g `matrix'[`r',`c']'")
			`dlg'.main.ed_r`r'c`c'.setvalue "`value'"
		}
	}
	
end

program generateValidateProgram
	syntax , clsname(string) rows(int) cols(int)
	local dlg .`clsname'
	
	`dlg'.validate.Arrdropall	
	forvalues r = 1/`rows' {
		forvalues c = 1/`cols' {
			`dlg'.validate.Arrpush  "require main.ed_r`r'c`c'"
		}
	}	
end

program generateCommand
	syntax , clsname(string) rows(int) cols(int)
	local dlg .`clsname'
	local cmdstring cmd

	forvalues r = 1/`rows' {
		if `r' > 1 {
			local command "`command'\\"
		}
		forvalues c = 1/`cols' {
			if `c' > 1 {
				local command "`command',"
			}
			local command "`command'``dlg'.main.ed_r`r'c`c'.value'"
		}
	}
	`dlg'.`cmdstring'.value = "`command'"
end
