*! version 1.0.0  03jan2005
program _prefix_saving, sclass
	version 9
	capture noisily					///
	syntax anything(id="file name" name=fname) [,	///
		DOUBle					///
		EVery(integer 0)			///
		REPLACE					///
	]
	local rc = `c(rc)'
	if !`rc' {
		if `every' < 0 {
			di as err ///
"suboption every() of the saving() option requires a positive integer"
			local rc 198
		}
		if "`replace'" == "" {
			local ss : subinstr local fname ".dta" ""
			confirm new file `"`ss'.dta"'
		}
	}
	if `rc' {
		di as err "invalid saving() option"
		exit `rc'
	}
	sreturn local filename	`"`fname'"'
	sreturn local double	`"`double'"'
	sreturn local replace	`"`replace'"'
	if `every' {
		sreturn local every every(`every')
	}
end
exit
