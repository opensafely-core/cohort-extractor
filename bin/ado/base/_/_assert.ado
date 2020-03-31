*! version 1.0.0 20dec20032
program _assert
	version 8

	syntax anything [ , msg(str) rc(str) ]

	capture assert `anything'
	local rcc = _rc
	if `rcc' {
		if `"`msg'"' != "" {
			dis as err `"`msg'"'
		}
		else {
			dis as err `"assert failed: `anything'"'
		}

		if "`rc'" != "" {
			exit `rc'
		}
		else {
			exit `rcc'
		}
	}
end
