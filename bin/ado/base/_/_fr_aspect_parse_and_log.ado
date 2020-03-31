*! version 1.0.1  18nov2004
program _fr_aspect_parse_and_log

    gettoken log       0 : 0

    syntax [anything] [ , PLACEment(string asis) ]

    					// handle aspect ratio
    if `"`anything'"' != `""' {
    	local 0 `" , aspect(`anything')"'
    	syntax [, ASPECTratio(real -999)]
    	.`log'.Arrpush .style.editstyle aspect_ratio(`aspectratio') editcopy
    }

    					// handle placement
    if `"`placement'"' != `""' {
    	.`log'.Arrpush .style.editstyle aspect_pos(`placement') editcopy
    }

end
