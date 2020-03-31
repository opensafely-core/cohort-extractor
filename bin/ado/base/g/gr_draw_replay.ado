*! version 1.2.5  29nov2004
program define gr_draw_replay
	version 8

	syntax [anything(name=name)] [ , XSIZe(passthru) YSIZe(passthru)  ///
					 SCALE(passthru) MARGINs(string) * ]

	gr_current name : `name'

	if `"`options'"' != `""' {
		gr_replay `name', `options' nodraw
		gr_current name : 
	}

	if `"`margins'"' != `""' {
		.`name'.style.editstyle  margin(`margins') editcopy
	}

	.`name'.drawgraph , `xsize' `ysize' `scale'
end

