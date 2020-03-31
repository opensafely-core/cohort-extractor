*! version 1.0.0  08jan2019
program sqrtlasso
	version 16.0

	if (replay()) {
		Playback `0'
	}
	else {
		_sqrtlasso linear `0'
	}
end
					//----------------------------//
					// play back result
					//----------------------------//
program Playback 
	syntax [, *]

	if ("`e(cmd)'"! = "sqrtlasso") {
		di as err "results for {bf:sqrtlasso} not found"
		exit 301
	}
	else {
		_pglm_display `0'
	}
end
