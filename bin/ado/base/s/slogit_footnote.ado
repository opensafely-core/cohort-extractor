*! version 1.0.0  26sep2005
program slogit_footnote
	version 9.1
	local i = `e(i_base)'
	if (wordcount("`e(out`i')'") > 1) ///
		local base `""`=abbrev("`e(out`i')'",17)'""'
	else	local base `"`=abbrev(`"`e(out`i')'"',17)'"'
        di in gr `"{p}(`e(depvar)'=`base' is the base outcome){p_end}"'
end
