*! version 1.0.3  29jan2015
program _fr_runlog
	version 8

	syntax name(name=cmds) [, noLOGging]

// cla `cmds'
	forvalues i = 1/0`.`cmds'.arrnels' {
// di in white `":`.`cmds'[`i']':"'

		local cmd `"`macval(.`cmds'[`i'])'"'

		gettoken do cmd1 : cmd
		if "`do'" == "LogMapping" {
			LogMapping `macval(cmd1)' `logging'
			continue				// Continue
		}

		if "`do'" == "__NOLOG__" {
			local cmd `"`macval(cmd1)'"'
			`cmd'
		}
		else if "`do'" == "__NORUN__" {
			local cmd `"`macval(cmd1)'"'
		}
		else {
			`cmd'
		}


		if "`logging'" == "" & "`do'" != "__NOLOG__" {
						// Handle mapping sersets
			gettoken target : cmd , parse(" =")
			if bsubstr(`"`target'"', 1, 9) == ".sersets[" {
				.__LOG.Arrpush `target' =		///
					.__Map.``target'.uname'.ref
			}
			else {			// Standard "push"
				.__LOG.Arrpush `macval(cmd)'
			}
		}
	}
end


program LogMapping
	args target logging

	.__LOG.Arrpush `target' = .__Map.``target'.uname'.ref
end
