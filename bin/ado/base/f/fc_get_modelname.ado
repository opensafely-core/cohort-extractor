*! version 1.0.1  24feb2013

program fc_get_modelname, rclass

	version 13
	
	mata:_fc_get_modelname_wrk("name")
	
	return local modelname = "`name'"
	
end

