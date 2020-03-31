*! version 1.0.0  31jul2010
program _check_numeric_vtype
	version 12
	args vtype

	if !inlist(`"`vtype'"', "byte", "int", "long", "float", "double") {
		dis as err `"`vtype' invalid numeric variable type"'
		exit 198
	}
end
