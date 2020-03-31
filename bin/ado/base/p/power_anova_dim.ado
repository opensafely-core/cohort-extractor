*! version 1.0.3  01oct2014 
program power_anova_dim  
	version 13.0
	
	gettoken subcmd 0 : 0
	`subcmd' `0'
end

program poneway, rclass 
	syntax, clsname(string) ctrlname(string) is_mat(int)
	
	local dlg .`clsname'
	local ctrlname `ctrlname'
	local ctrlv ``dlg'.main.`ctrlname'.value'
	local ncount 
	
	if `is_mat'==1 {
		if rowsof(`ctrlv') == 1 {
			local ncount = colsof(`ctrlv')
		}
		if colsof(`ctrlv') == 1 {
			local ncount = rowsof(`ctrlv')
		}
		if rowsof(`ctrlv') > 1 & colsof(`ctrlv') > 1 {
			local ncount = rowsof(`ctrlv')
		}
	}
	else {
		if strpos("`ctrlv'", "(") > 0 {
			local ncount 1
			tokenize "`ctrlv'", parse("(")
			local stok ``ncount''

			while "`stok'" != "" {
				local ncount = `ncount' + 1
				local stok ``ncount''
			}
			local ncount = ceil((`ncount'-1)/2)
		}
		else if strpos("`ctrlv'", "\") > 0 {
			local ncount 1
			tokenize "`ctrlv'", parse("\")
			local stok ``ncount''

			while "`stok'" != "" {
				local ncount = `ncount' + 1
				local stok ``ncount''
			}
			local ncount = ceil((`ncount'-1)/2)
		}
		else {
			local ncount 1
			tokenize "`ctrlv'", parse(" ")
			local stok ``ncount''

			while "`stok'" != "" {
				local ncount = `ncount' + 1
				local stok ``ncount''
			}
			local ncount = `ncount'-1
		}
	}
	
	return scalar ngcount = `ncount'
end

program ptwoway, rclass
	syntax, clsname(string) ctrlname(string) is_mat(int)

	local dlg .`clsname'
	local ctrlname `ctrlname'
	local ctrlv ``dlg'.main.`ctrlname'.value'
	local nrowcount
	local ncolcount
	
	if `is_mat'==1 {
		local nrowcount = rowsof(`ctrlv')
		local ncolcount = colsof(`ctrlv')
	}
	else {
		if strpos("`ctrlv'", "\") > 0 {
			local ncount 1
			tokenize "`ctrlv'", parse("\")
			local stok ``ncount''
			local sfirst `stok'

			while "`stok'" != "" {
				local ncount = `ncount' + 1
				local stok ``ncount''
			}
			local nrowcount = ceil((`ncount'-1)/2)
			
			local ncount 1
			tokenize "`sfirst'", parse(" ")
			local stok ``ncount'' 
			while "`stok'" != "" {
				local ncount = `ncount' + 1
				local stok ``ncount''
			}
			local ncolcount = `ncount'-1
		}
		else {
			local ncolcount 1
			tokenize "`ctrlv'", parse(" ")
			local stok ``ncolcount''

			while "`stok'" != "" {
				local ncolcount = `ncolcount' + 1
				local stok ``ncolcount''
			}
			local ncolcount = `ncolcount'-1
			local nrowcount = 1
		}
	}
	
	return scalar nrowscount = `nrowcount'
	return scalar ncolscount = `ncolcount'
end

program prepeated, rclass
	syntax, clsname(string) ctrlname(string) is_mat(int)
	
	local dlg .`clsname'
	local ctrlname `ctrlname'
	local ctrlv ``dlg'.main.`ctrlname'.value'
	local ngcount
	local nrepcount
	
	if `is_mat'==1 {
		local ngcount = rowsof(`ctrlv')
		local nrepcount = colsof(`ctrlv')
	}
	else {
		if strpos("`ctrlv'", "\") > 0 {
			local ncount 1
			tokenize "`ctrlv'", parse("\")
			local stok ``ncount''
			local sfirst `stok'

			while "`stok'" != "" {
				local ncount = `ncount' + 1
				local stok ``ncount''
			}
			local ngcount = ceil((`ncount'-1)/2)
			
			local ncount 1
			tokenize "`sfirst'", parse(" ")
			local stok ``ncount'' 
			while "`stok'" != "" {
				local ncount = `ncount' + 1
				local stok ``ncount''
			}
			local nrepcount = `ncount'-1
		}
		else {
			local nrepcount 1
			tokenize "`ctrlv'", parse(" ")
			local stok ``nrepcount''

			while "`stok'" != "" {
				local nrepcount = `nrepcount' + 1
				local stok ``nrepcount''
			}
			local nrepcount = `nrepcount'-1
			local ngcount = 1
		}
	}
	
	return scalar ngscount = `ngcount'
	return scalar nrepscount = `nrepcount'
end

program ptrend, rclass 
	syntax, clsname(string) ctrlname(string) is_mat(int)
	
	local dlg .`clsname'
	local ctrlname `ctrlname'
	local ctrlv ``dlg'.main.`ctrlname'.value'
	local ncount 0
	local nrc 0
	local nnumlist 0
	
	if `is_mat'==1 {
		capture confirm matrix `ctrlv'
		if _rc {
			local ncount = 0 
			local nrc = 1
			local nnumlist = 0
		}		
		else {
			capture _pss_chk_multilist `ctrlv', option(exposure  probabilities) range(>0 <1)
			if _rc {
				local nrc = 1
				local ncount = 0
				local nnumlist = 0
			}
			else {
				local nrc = 0
				local ncount = `s(nlevels)'
				local nnumlist = `s(nrows)'
			}
		}
	}
	else {
		capture _pss_chk_multilist `ctrlv', option(probabilities) range(>0 <1)
		if _rc {
			local nrc = 1
			local ncount = 0
			local nnumlist = 0
		}
		else {
			local nrc = 0
			local ncount = `s(nlevels)'
			if strpos("`ctrlv'", "(") > 0 {
				local nnumlist = 1
			}
			else {
				local nnumlist = 0
			}
		}		
	}
	
	return scalar ngcount = `ncount'
	return scalar ngnumlist = `nnumlist'
	return scalar ngrc = `nrc'
end

program pcmh, rclass 
	syntax, clsname(string) ctrlname(string) is_mat(int)
	
	local dlg .`clsname'
	local ctrlname `ctrlname'
	local ctrlv ``dlg'.main.`ctrlname'.value'
	local ncount 0
	local nrc 0
	
	if `is_mat'==1 {
		capture confirm matrix `ctrlv'
		if _rc {
			local ncount = 0 
			local nrc = 1
		}		
		else {
			capture _pss_chk_multilist `ctrlv', option(strata probabilities) levels(strata) range(>0 <1)
			if _rc {
				local nrc = 1
				local ncount = 0
			}
			else {
				local nrc = 0
				local ncount = `s(nlevels)'
			}
		}
	}
	else {
		capture _pss_chk_multilist `ctrlv', option(probabilities) levels(strata) range(>0 <1)
		if _rc {
			local nrc = 1
			local ncount = 0
		}
		else {
			local nrc = 0
			local ncount = `s(nlevels)'
		}		
	}
	
	return scalar ngcount = `ncount'
	return scalar ngrc = `nrc'
end
