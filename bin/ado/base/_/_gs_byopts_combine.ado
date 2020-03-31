*! version 1.0.0  18aug2006

/* Example:
 *	_gs_byopts_combine byopts options : `"`options'"'
 */

program _gs_byopts_combine
	version 10.0
	args byoptMac optsMac colon options
	_parse combop byopts : options, option(BYOPts) opsin
	local 0 , `byopts'
	syntax [, BYOPts(string asis) *]
	c_local `optsMac' `"`options'"'
	c_local `byoptMac' `"`byopts'"'
end
