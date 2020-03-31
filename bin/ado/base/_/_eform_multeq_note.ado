*! version 1.0.0  20mar2017
program _eform_multeq_note
	args eformnote colon k_eform

	local eformlnk "{help eform_option:Estimates are transformed}"
	local efnote Note: `eformlnk' only in the first
	if (`k_eform'==1) {
		local efnote `efnote' equation.
	}
	else {
		local efnote `efnote' `k_eform' equations.
	}
	local efnote {p 0 6 2}`efnote'{p_end}
	c_local `eformnote' `efnote'
end
