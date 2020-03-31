*! version 1.1.0  16nov2006
program _fr_declare_date_line
	version 9.2
	gettoken ord     0 : 0
	gettoken axnm    0 : 0
	gettoken plreg   0 : 0
	gettoken styopt zlist : 0

	local name `axnm'
	if ("`plreg'" != "") local name "`name'.`plreg'"

	.`name'.get_time_format
	local tfmt `r(fmt)'
	_date2elapsed, format(`tfmt') datelist(`zlist')
	local zlist `"`s(args)'"'

	foreach z of local zlist {
		.`name'.declare_xyline				 ///
			.gridline_g.new `z' , ordinate(`ord')	 ///
			plotregion(`.`name'.objkey')		 ///
			`styopt' datesok
	}
end
