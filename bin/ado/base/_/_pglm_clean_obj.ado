*! version 1.0.1  25feb2019
program _pglm_clean_obj
	version 16.0

	args OBJ  rc
	if (`rc') {
		cap mata: `OBJ'.remove_laout()
	}
	cap mata : rmexternal(`"`OBJ'"')
	cap matrix drop `OBJ'*
	cap drop `OBJ'*
	cap mata : st_lasso_rm_cvfile()
end
