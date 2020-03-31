*! version 1.0.1  24feb2017
program __sp_parse_id , sclass
	syntax [, id(string)]

	if (`"`id'"'=="") {
		vsp_validate noshapefile
		local id `r(sp_idvar)'
	}

	sret local id `id'
end
