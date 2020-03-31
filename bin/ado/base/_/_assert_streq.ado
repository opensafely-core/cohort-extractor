*! version 1.0.1
* asserts that two strings are equal
program define _assert_streq
	version 10
	args s1 s2

	local tmp : subinstr local s1 `"`s2'"' "", word all count(local nch)
	if `nch' != 1 | `"`tmp'"' != "" {
		di _n as err "assert failed -- strings are not equal"
		di _n as txt `"  str1: |{res:`s1'}|"'
		di _n as txt `"  str2: |{res:`s2'}|"' _n
		exit 7
	}
end
exit
