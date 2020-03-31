*! version 1.0.0  04apr2002
program define gr_draw
	version 8

	syntax [anything(name=name)] [ , XSIZE(passthru) YSIZE(passthru)  ///
					 MARGINs(string) ]
	gr_current name : `name' 

	if `"`margins'"' != `""' {
		.`name'.style.editstyle  margin(`margins')
	}

	.`name'.drawgraph , `xsize' `ysize'

end

