*! version 1.2.0 27apr2009
program define _resample_warn
	args caller command

	gettoken cmd : command
di in smcl as txt ""
di `"{p 0 10 2} Warning:  Because {cmd:`cmd'} is not an estimation command "' _c
di `"or does not set {cmd:e(sample)}, "' _c
di `"{cmd:`caller'} has no way to determine which observations are used "' _c
di `"in calculating the statistics and so assumes that all observations "' _c
di `"are used.  This means that no observations will be excluded from the "' _c
di `"resampling because of missing values or other reasons.{p_end}"' _n

di `"{p 10 10 2} If the assumption is not true, press Break, save the "' _c
di `"data, and drop the observations that are to be excluded. "'
di `"Be sure that the dataset in memory contains only the relevant data."' _c
di `"{p_end}"'

end
exit
