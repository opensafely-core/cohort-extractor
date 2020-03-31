*! version 1.0.1  20jan2015

program define _sspace_estat
	version 11

	gettoken sub rest: 0, parse(" ,")

	local lsub = length("`sub'")

	if "`sub'" == bsubstr("ssdisplay",1,max(3,`lsub')) {
		/* undocumented, programmmer's tool			*/
		Display `rest'
	}
	else estat_default `0'	 
end

program Display
	syntax , [ fmt(string) ]

	if "`fmt'" != "" {
		local test: display `fmt' 3.14
	}
	mata: _sspace_estat_entry("display","`fmt'")
end
exit
