*! version 1.0.0  04sep2007

program gr_ed_dialog_util
	version 10.0

	gettoken subcmd 0 : 0
	`subcmd' `0'	
end

program getGediMode
	version 10
	args dlgobject
	.`dlgobject'.setvalue `_gedi(mode)'
end
