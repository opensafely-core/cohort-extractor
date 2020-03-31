*! version 1.0.1  01feb2012

// ---------------------------------------------------------------------------
//  Dialog launcher for graphics editing.

program gr_ed_db
	version 10

	args editobj j

	global T_drawobj `.objkey'

	local dialog  "gr_ed_`.`editobj'.dialog'"

	if "`dialog'" == "" {			// no programmable dialog
		.`editobj'.dialog_box , name(`editobj') apply
		exit
	}

	GetLauncher launcher : `editobj'	// Check for custom launcher

	if ("`launcher'" == "") {
		if 0`j' {
		      if ("`dialog'" == "gr_ed_connected" | 		///
		          "`dialog'" == "gr_ed_dot")			///
				local dialog "gr_ed_scatter"
		}
		capture _gedi showdialog  `dialog' `"`editobj'"' `j'
if ("$grdebug"!="") di in white `"capture _gedi showdialog  `dialog' `"`editobj'"' `j'"'
	}
	else {
		gr_ini_`launcher' `editobj' `dialog'
	}

	if _rc {
		.`editobj'.dialog_box , name(`editobj') apply
	}
end

program GetLauncher
	args launcher colon editobj
	local 0 ", `.`editobj'.dialog'"

	syntax [, FAKEOPTA FAKEOPTB *]

	c_local `launcher' "`fakeopta'`fakeoptb'"
end
