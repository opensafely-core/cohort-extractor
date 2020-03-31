*! version 1.0.0  17feb2015
program putexcel_cellexp_error
	version 13
	args cell

	.putexcel_dlg.cell_error.setvalue 0

	local cell = strupper("`cell'")
	local len = length("`cell'")
	if `len' < 2 {
		.putexcel_dlg.cell_error.setvalue 1
		exit
	}

	local col = ""
	local i = 1
	while `i' <= `len' {
		local c = bsubstr("`cell'", `i', 1)
		mata:st_local("num", strofreal(ascii(st_local("c"))))

		if (`num' < 65 | `num' > 90) {
			if (`i'==1) {
				.putexcel_dlg.cell_error.setvalue 1
				exit
			}
			continue, break
		}
		else {
			local col "`col'`c'"
		}
		local i = `i' + 1
	}

	local row = strtrim(bsubstr("`cell'", `i', .))

	if "`row'" == "" {
		.putexcel_dlg.cell_error.setvalue 1
		exit
	}

	local row = real("`row'")

	if `row' == . {
		.putexcel_dlg.cell_error.setvalue 1
		exit
	}

	if `row' < 1 | `row' > 1048576 {
		.putexcel_dlg.cell_error.setvalue 1
		exit
	}

	mata:col_to_colnum()

	if `col_num' < 1 | `col_num' > 16384 {
		.putexcel_dlg.cell_error.setvalue 1
		exit
	}
end

mata:
void col_to_colnum()
{
	string scalar		c, colname
	real scalar		result
	real scalar		i

	colname = st_local("col")

	result = 0
	for (i=1;i<=bstrlen(colname);i++) {
		c = bsubstr(colname, i, 1)
		result = result * 26 + ascii(c) - ascii("A") + 1;
	}
	st_local("col_num", strofreal(result))
}

end

