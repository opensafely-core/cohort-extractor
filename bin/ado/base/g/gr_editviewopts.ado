*! version 1.0.0  17aug2002
program gr_editviewopts
	version 8

		//  Usage:  gr_editviewopts <plotregion>.<view> , <graphopts>
		// 
		//  Cute, but probably not very useful.

	gettoken view opts : 0

	gr_current name :
	local view `name'.`view'

	tempname pnm
	.`pnm' = .`.`view'.parser'.new
	.`pnm'.parse_opts `opts'
	.`pnm'.apply_edits `.`view'.objkey' 1

	_gm_log .`view' `opts'
	gr_draw
end
