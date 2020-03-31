*! version 1.0.1  02may2007
program _stata_internalerror
	version 8

	gettoken cmd msg : 0

	if `"`cmd'"' != "" {
		dis as err `"an internal error occurred in `cmd'"'
	}
	else {
		dis as err "an internal error occurred"
	}

	if `"`msg'"' == "" {
		dis as err "no additional information is available"
	}
	else {
		dis as err `"message: `msg'"'
	}

	dis as err `"please report this error to StataCorp (techsuppport@stata.com)"'
	exit 9999
end
