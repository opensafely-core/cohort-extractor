*! version 1.0.0  03jan2005
program _prefix_check4esample,sclass
	version 9
	capture assert e(sample) == 1
	if c(rc) {
		capture assert e(sample) == 0
		if c(rc) {
			sreturn local keep keep if e(sample)
		}
		else {
			sreturn local diwarn ///
				_resample_warn `0'
		}
	}
end
exit
