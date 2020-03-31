*! version 1.0.0  13oct2002
program _fr_x_log_cleanup
	syntax , LOG(name) X(string)

	.`log'.Arrpush __NOLOG__ capture set obs `realN'

	.`log'.Arrpush __NOLOG__ drop `x'
	.`log'.Arrpush __NOLOG__ capture rename \`holdx' `x'
end

