*! version 1.0.4  06jul2015

program _teffects_parse_canonicalize, sclass
	version 13

	_on_colon_parse `0'
	local cmd "`s(before)'"
	local 0 `"`s(after)'"'
	if `:list sizeof cmd' > 1 {
		local st : word 1 of `cmd'
		local cmd : word 2 of `cmd'
	}
	local cmd : list retokenize cmd

	sreturn clear

	syntax anything(id="`st'teffects `cmd' specification" name=teffects) ///
		[if][in] [fw iw pw], [ * ]

	local tmp : subinstr local teffects "|" "|", all count(local vert)
	if `vert' {
		di as err "{p}invalid {bf:`st'teffects `cmd'} " ///
		 "specification; delimiter {bf:|} is not allowed{p_end}"
		exit 198
	}

	local owep `weight'`exp'
	if ("`owep'" != "") {
		local owep [`owep']
	}
	local 0 `teffects' `if' `in' `owep', `options'

	local tmp : subinstr local teffects "(" "(", all count(local left)
	local tmp : subinstr local teffects ")" ")", all count(local right)

	_parse expand eqn op : 0, gweight

	_parse canonicalize canon : eqn op

	local canon : list retokenize canon
	if `eqn_n' == 1 {
		local canon (`canon')
	}
	
	sreturn local options `"`op_op'"'
	sreturn local wt `"`op_wt'"'
	sreturn local if `"`op_if'"'
	sreturn local in `"`op_in'"'
	local k = 0
	forvalues i=`eqn_n'(-1)1 {
		local eqn_`i' : list retokenize eqn_`i'
		local tmp : subinstr local eqn_`i' "(" "(", all ///
			count(local ki)
		local k = `k' + `ki'+1

		sreturn local eqn_`i' `"`eqn_`i''"'
	}
	if `left'!= `k' | `right'!=`k' {
		di as err "{p}invalid {bf:`st'teffects `cmd'} "           ///
		 "specification; the model specifications should be "     ///
		 "enclosed in parentheses, or you are missing the comma " ///
		 "preceding the options{p_end}"
		exit 198
	}
	sreturn local eqn_n = `eqn_n'
	sreturn local teffects `"`canon'"'
end
exit
