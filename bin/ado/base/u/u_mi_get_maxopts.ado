*! version 1.0.0  04feb2011
program u_mi_get_maxopts
	version 12
	args out1 out2 colon opts
	local maxopts DIFficult TECHnique(passthru) ITERate(passthru)
	local maxopts `maxopts' LOG NOLOG TRace GRADient SHOWSTEP
	local maxopts `maxopts' HESSian SHOWTOLerance TOLerance(passthru) 
	local maxopts `maxopts' LTOLerance(passthru) GTOLerance(passthru)
	local maxopts `maxopts' NRTOLerance(passthru) NONRTOLerance
	local maxopts `maxopts' FROM(passthru)
	local 0 , `opts'
	syntax [, `maxopts' * ]
	local maxopts : list opts - options
	c_local `out1' `"`maxopts'"'
	c_local `out2' `"`options'"'
end
