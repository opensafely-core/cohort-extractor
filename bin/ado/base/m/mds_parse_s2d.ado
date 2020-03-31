*! version 1.0.0  15mar2007
program mds_parse_s2d, sclass
	version 10

	local 0 `", `0'"'
	capture syntax [, ONEminus STandard ]
	if _rc {
		dis as err "option s2d() invalid"
		exit 198
	}

	local opts `oneminus' `standard'
	opts_exclusive `"`opts'"' s2d

	if "`opts'" == "" {
		local opts standard
	}	

	sreturn clear
	sreturn local s2d `opts'
end
exit
