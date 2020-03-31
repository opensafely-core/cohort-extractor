*! version 1.0.0  12jul2018

program meta__validate_level, sclass
	version 16
	args cilevel
	
	sreturn clear
	local 0, level(`cilevel')
	syntax [, level(cilevel)]
	
	sreturn local mylev `level'
end
