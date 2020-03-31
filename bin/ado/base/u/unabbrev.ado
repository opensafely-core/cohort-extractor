*! version 1.2.0  24nov1998
program define unabbrev, sclass
	version 6
	sret clear
	gettoken list1 0 : 0
	local 0 `"`list1' `0'"'
	syntax varlist [, min(string) max(string)]
	sret local varlist `varlist'
	sret local k : word count `varlist'
	global S_1 "`varlist'"
	global S_2 `s(k)'

	if "`min'"=="" & "`max'"=="" { exit }
	if "`min'" != "" {
		if `s(k)' < `min' {
			di in red "`varlist'"
			error 102
		}
	}
	if "`max'" != "" {
		if `s(k)' > `max' { 
			di in red "`varlist'"
			error 103
		}
	}
end
