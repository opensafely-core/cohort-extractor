*! version 1.0.0  15apr2002
program define _gr_common_axes
	syntax anything(name=gphlist id="graph list") [, Xaxis Yaxis ]

	capture noisily {

		global T_xaxis
		global T_yaxis
		tempname plreg
		.`plreg' = .plotregion.new, style(scheme)
		global T_plreg `plreg'

		foreach graph of local gphlist {
			.`graph'._gr_axes_wrk
		}

		if "$T_xaxis" != "" {
			.$T_xaxis.set_ticks
		}
		if "$T_yaxis" != "" {
			.$T_yaxis.set_ticks
		}

		capture mac drop T_plreg
		capture mac drop T_yaxis
		capture mac drop T_xaxis

	}
end
