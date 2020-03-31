*! version 1.0.0  11sep2014

program define _tebalance_cmd_generate, sclass
	version 14.0
	args stub

	local cmdline `"`e(cmdline)'"'
	gettoken cmd cmdline : cmdline
	gettoken subcmd cmdline : cmdline

	_teffects_parse_canonicalize `e(subcmd)' : `cmdline'

	local omodel `"`s(eqn_1)'"'
	local tmodel `"`s(eqn_2)'"'
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local wt `"`s(wt)'"'
	local options `"`s(options)'"'

	local cmdline `"`e(cmd)' `e(subcmd)' (`omodel') (`tmodel')"'
	local cmdline `"`cmdline' `if' `in' `wt', `options' generate(`stub')"'

	sreturn local cmdline `"`cmdline'"'
end

exit
