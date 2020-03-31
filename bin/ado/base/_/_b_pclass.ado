*! version 1.0.0  06apr2016
program _b_pclass
	version 15
	args c_value COLON key

	_on_colon_parse `0'
	local c_value	`"`s(before)'"'
	local key	`"`s(after)'"'
	confirm name `c_value'

	mata: st_b_pclass("`:list retok key'")
	c_local `c_value' `value'
end

mata:

void st_b_pclass(string scalar key)
{
	class _b_pclass	scalar	b
	real		scalar	value

	value = b.value(key)
	if (missing(value)) {
		errprintf("invalid parameter class;\n")
		errprintf("%s is not a valid parameter class\n", key)
		exit(198)
	}
	st_local("value", strofreal(value))
}

end
