*! version 1.0.0  24may2007
program ml_count_eval
	version 10
	args f type
	if `:length global ML_dots' {
		$ML_dots "`f'" "`type'"
	}
end
