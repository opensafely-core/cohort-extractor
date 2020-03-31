*! version 1.0.0  21may2011
program sem_parse_method, sclass
	sreturn clear
	capture syntax [, ml mlmv adf]
	local rc = _rc
	if `rc' {
		dis as err "invalid method() option;"
		syntax [, ml mlmv adf]
		exit `rc'
	}
	local method `ml' `mlmv' `adf'
	opts_exclusive "`method'" method
	if "`method'" == "" {
		local method ml
	}
	sreturn local method `method'
end
exit
