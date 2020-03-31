*! version 1.0.1  01apr2005
program score
	version 9

	// Only way under old versions to tell if pca and factor were run
	// is to check if you can replay
	capture qui factor_cmd8
	if _rc == 301 {
		if "`e(cmd)'" != "" {
			local after "after `e(cmd)'"
		}
		di as err "score is not valid `after'"
		exit 301
	}

	if (_caller() >= 9) {
		if (_caller() >= 10) {
			di as err "{p}"
			di as err "score is no longer allowed after factor or"
			di as err "pca except under version control; see"
			di as err "help {help version##|_new:version}."
			di as err "To obtain score variables, use predict;"
			di as err "see help {help `e(cmd)'##|_new:predict}."
			di as err "{p_end}"

			exit 199
		}
		else {
			di as txt "{p 0 1}"
			di as txt "(Warning:"
			di as txt "score is an out-of-date command.  To obtain"
			di as txt "score variables after `e(cmd)', use predict;"
                        di as txt "see help {help `e(cmd)'##|_new:predict}."
                        di as txt "{p_end}"
		}

	}
	if (_caller() < 9) {
		score_cmd8 `0'
	}
	else {	// executed for 9 <= version < 10
		// predict now handles score after factor and pca
		predict `0'
	}
end
