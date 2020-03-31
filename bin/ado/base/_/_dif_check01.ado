*! version 1.0.0  27jul2015
program _dif_check01
	version 14
	syntax [varlist(default=none)] , touse(varname) name(string)
	foreach v in `varlist' {
		capture assert missing(`v') | inlist(`v',0,1) if `touse'
                if _rc {
di "{err}variable {bf:`v'} has invalid values;"
di "{err}`stat' requires item variables be coded 0, 1, or missing"
exit 198
                }
	}
end

