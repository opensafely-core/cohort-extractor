*! version 1.0.0  15apr2002
program define _gr_linkstyles
	version 8

	syntax [anything(name=name)] [, Class(string) style(string) ]

	gr_current name : `name'

	global T_linkstyle

	capture noisily {
		.`name'._gr_link_wrk `class' `style'
	}

	capture mac drop T_linkstyle

end

