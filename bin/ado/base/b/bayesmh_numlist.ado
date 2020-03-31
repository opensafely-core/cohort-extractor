*! version 1.0.0  11mar2015
program bayesmh_numlist
	version 14.0
	gettoken subcmd 0 : 0
	`subcmd' `0'
end

program setLayout
	syntax , clsname(string) dims(int)

	local dlg .`clsname'
	local rmax 12
	local cmax 12
	local row_value = int(`dims'/`cmax')
	local col_value = mod(`dims', `rmax') 
	
	if `row_value' > `rmax' {
		local row_value `rmax'
	}
	
	if `col_value' == 0 {
		local col_value `cmax'
	}
	else {
		local row_value = `row_value' + 1
	}
	
	// disable columns that are out of range
	forvalues r = `rmax'(-1)`=`row_value'+1' {
		forvalues c = `cmax'(-1)1 {
			`dlg'.main.ed_r`r'c`c'.disable
		}
	}
	
	// disable rows that are out of range	
	forvalues c = `cmax'(-1)`=`col_value'+1' {
		`dlg'.main.ed_r`row_value'c`c'.disable
	}
end

program generateCommand
	syntax , clsname(string) dims(int)
	local dlg .`clsname'
	local cmdstring cmd
	
	local rmax 12
	local cmax 12
	local row_value = int(`dims'/`cmax')
	local col_value = mod(`dims', `rmax') 
	
	if `row_value' > `rmax' {
		local row_value `rmax'
	}
	
	if `col_value' == 0 {
		local col_value `cmax'
	}
	else {
		local row_value = `row_value' + 1
	}
	
	if `col_value' == `cmax' {
		forvalues r = 1/`row_value' {
			forvalues c = 1/`col_value' {
				local command ///
"`command'``dlg'.main.ed_r`r'c`c'.value'"
				if `c' != `col_value' {
					local command "`command',"
				}
			}
		}	
	}
	else {
		if `row_value' == 1 {
			forvalues c = 1/`col_value' {
				local tmp "``dlg'.main.ed_r1c`c'.value'"
				if "`tmp'" != "" {
					local command ///
"`command'``dlg'.main.ed_r1c`c'.value'"
				}
				else {
					local command "`command'."
				}
				if `c' != `col_value' {
					local command "`command',"
				}
			}
		}
		else {
			forvalues r = 1/`=`row_value'-1' {
				forvalues c = 1/`cmax' {
					local tmp "``dlg'.main.ed_r1c`c'.value'"
					if "`tmp'" != "" {
						local command ///
"`command'``dlg'.main.ed_r1c`c'.value'"
					}
					else {
						local command "`command'."
					}
					if `c' != `cmax' {
						local command "`command',"
					}
				}
			}
			forvalues c = 1/`col_value' {
				local tmp "``dlg'.main.ed_r1c`c'.value'"
				if "`tmp'" != "" {
					local command ///
"`command'``dlg'.main.ed_r1c`c'.value'"
				}
				else {
					local command "`command'."
				}
				if `c' != `col_value' {
					local command "`command',"
				}
			}			
		}
	}

	`dlg'.`cmdstring'.value = "`command'"
end

