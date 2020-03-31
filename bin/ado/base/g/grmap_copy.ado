*! version 1.0.0  20mar2017
program grmap_copy
	version 15

	local flist	italy-capitals.dta ///
			italy-highlights.dta ///
			italy-lakes.dta ///
			italy-outlinecoordinates.dta ///
			italy-outlinedata.dta ///
			italy-regionscoordinates.dta ///
			italy-regionsdata.dta ///
			italy-rivers.dta
	preserve
	foreach f of local flist {
		webuse `f'
		save `f'
	}
end
