*! version 1.0.1  08mar2011
program ml_p_allowmissscores 
	// defaults to always using missing for scores now
	// this is used in rocreg
        version 9
        syntax [anything] [if] [in] [, SCores * ]
        if `"`scores'"' != "" {
                if `"`e(opt)'"' == "ml" {
                        ml score `0' missing
                }
                else {
                        mopt score `0' missing
                }
                exit
        }
        _predict `0'
end
exit
