*! version 1.0.0  04apr2002
program define gr_db
	version 8

	syntax [anything(name=name)]
	gr_current name : `name'  , drawifchg

	.`name'.dialog_box, name(`name') redraw apply

end

