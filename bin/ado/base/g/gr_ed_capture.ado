*! version 1.0.0  01feb2007


program gr_ed_capture
	syntax , command(string asis) [clsrc(string)]
	capture `command'
	local rc `c(rc)'
	if `rc' {
		if `"`clsrc'"' != "" {
			.`clsrc' = `rc'
		}
		exit `rc'
	}
end
