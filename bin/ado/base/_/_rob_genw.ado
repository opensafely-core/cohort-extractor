*! version 1.0.0  02feb2008
program _rob_genw, sort
	version 10
	args wnew touse worig posts postw
	if `:length local worig' {
		local wt [iweight=`worig']
	}
	svygen post double `wnew' if `touse' `wt',	///
		posts(`posts') postw(`postw')
end
