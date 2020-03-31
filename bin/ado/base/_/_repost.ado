*! version 1.2.0  20jun2011
/* _repost newcmd depv

   Purpose:
     Some internal commands do not allow -repost-.  _repost copies the
     "visible" elements into a new estimation result.

   You have to specify a new command name so not to confuse post
   estimation commands that may refer to hidden structures.

   If you specify a depv argument, it is passed to -est post- as the
   depname.
*/
program define _repost, eclass
	version 8

	args newcmd depv
	confirm name `newcmd'

	local cmd    `e(cmd)'
	local cmd2   `e(cmd2)'
	local depvar `e(depvar)'

	local functions : e(functions)
	if "`functions'" != "sample" {
		di as err "unable to repost e(functions) other than e(sample)"
		exit 198
	}
	tempvar touse
	gen byte `touse' = e(sample)

	tempname b V
	mat `b' = e(b)
	mat `V' = e(V)

	_e2r, xmacros(cmd cmd2 depvar) xmatrices(b V)

	// repost the estimation results

	if "`depv'" != "" {
		local depn depname(`depv')
	}
	else if "`depvar'" != "" {
		local depn depname(`depvar')
	}
	ereturn clear
	if `:length local macro_wtype' {
		local wgt "[`macro_wtype'`macro_wexp']"
	}
	ereturn post `b' `V' `wgt', esample(`touse') `depn'

	_r2e

	ereturn local old_cmd  `cmd'
	ereturn local old_cmd2 `cmd2'
	ereturn local cmd      `newcmd'
end
exit
