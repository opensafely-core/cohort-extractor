*! version 1.0.0  28apr2011
program _ms_put_omit, sclass
        args vn
        _ms_parse_parts `vn'
	if r(type) =="variable" {
		local name `r(name)'
		local ovar o.`name'
	}
        if r(type) == "factor" {
                if !r(base) {
	        	local name `r(name)'
                    	if "`r(ts_op)'" != "" {
                        	local name `r(ts_op)'.`name'
                    	} 	
			local ovar `r(level)'o.`name'
                }
		else {
			local ovar `vn'
		}
        }
        else if r(type) == "interaction" {
                local k = r(k_names)

                forval i = 1/`k' {
                        local name = r(name`i')
                        if "`r(ts_op`i')'" != "" {
                                local name `r(ts_op`i')'.`name'
                        }
                        if "`r(level`i')'" != "" {
                                if r(base`i') {
                                        local name `r(level`i')'b.`name'
                                }
                                else {
                                        local name `r(level`i')'o.`name'
                                }
                        }
                        else {
                                local name o.`name'
                        }
                        local spec `spec'`sharp'`name'
                        local sharp "#"
                }
                local ovar `spec'
				
        }
	_msparse `ovar'
	sreturn local ospec `r(stripe)'
end
