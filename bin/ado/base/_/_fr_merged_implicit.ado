*! version 1.0.0  07oct2002
program _fr_merged_implicit , rclass
	gettoken log   0 : 0
	gettoken optnm 0 : 0
	gettoken do    0 : 0

	local opt = lower("`optnm'")

	syntax [ , `optnm'(string asis) * ]

	while `"``opt''"' != `""' {
		local curdo : subinstr local do "X" `"``opt''"' , all

		.`log'.Arrpush `curdo'
		
		local 0 `", `options'"'
		syntax [ , `optnm'(string asis) * ]
	}

	return local rest `"`options'"'
	
end
