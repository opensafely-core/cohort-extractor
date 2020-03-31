*! version 1.0.0  02may2007
program ml_dots
	version 10
	args f type

	if $ML_trace {
		if `:length local f' {
			if !missing(`f') {
				if ! `:length local type' {
					local type text
				}
			}
			global ML_ndots = $ML_ndots + 1
			else	local type error
			_dots $ML_ndots `type'
		}
		else {
			_dots $ML_ndots
			global ML_ndots 0
		}
	}

end
