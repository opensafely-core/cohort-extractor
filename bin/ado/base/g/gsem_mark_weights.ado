*! version 1.0.0  05feb2014
program gsem_mark_weights
	version 14
	gettoken touse weights : 0

	markout `touse' `weights'
	foreach w of local weights {
		quietly replace `touse' = 0 if `w' <= 0
	}
end
