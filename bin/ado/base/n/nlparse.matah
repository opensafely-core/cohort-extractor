*! version 1.0.0  30mar2018	

if "$NLPARSE_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

/* DO NOT modify this structure without updating the associated
 * C code								*/
struct nlparse_node {
	real scalar type
	real scalar val
	string scalar symb
	real scalar narg
	struct nlparse_node vector arg
}

end

global NLPARSE_MATAH_INCLUDED 1

exit
