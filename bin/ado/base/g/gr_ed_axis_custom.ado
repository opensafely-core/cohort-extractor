*! version 1.0.4  01jun2013

program gr_ed_axis_custom
	version 10.0

	gettoken subcmd 0 : 0
	`subcmd' `0'	
end

program buildList
	args dlg editobj axisStyle
	.`dlg'.tick_list.Arrdropall
	.`dlg'.tick_value_list.Arrdropall
	
	local size 0
	capture local size = `.`editobj'.`axisStyle'.dlg_tickpos.arrnels'
	forvalues i = 1/`size' {
		/* Store in dlg STRING object to make use of numeric to 
		 * string formatting...
		 */
		.`dlg'.tmp.setvalue class 	///
			.`editobj'.`axisStyle'.dlg_tickpos[`i']

		local row `.`dlg'.tmp.value'
		local row `row' (`.`editobj'.`axisStyle'.dlg_ticklabel[`i']')

		local tickstyle `.`editobj'.`axisStyle'.dlg_tickstyle[`i']'
		.`dlg'.tick_value_list.Arrpush `"`i'"'
		if `"`tickstyle'"' != "default" {	
			local row `row' *
		}
		if `.`editobj'.`axisStyle'.dlg_isrule[`i']' == 1 {
			local row `row' +
		}
		.`dlg'.tick_list.Arrpush `"`row'"'
	}
end


program storeNumberofElements
	// Utility routine for dialog to store the length of the array
	args parent editobj axisStyle dlg target
	.`dlg'.`target'.setvalue `.`editobj'.`axisStyle'.dlg_tickpos.arrnels'
end

program deleteIndex
	args dlg editobj axisStyle index
	_gm_dlg_edits, object(`editobj') 	///
		cmd(_gm_edit .`editobj'.`axisStyle'.delete_tick `index')
	buildList `dlg' `editobj' `axisStyle'
	.`dlg'.main.lb_ticks.repopulate
end

program validateValue
	args dlg editobj axisStyle axis value

	if (`.`editobj'.isofclass plotregion') {
		forvalues i = 1/`.`editobj'.axes.arrnels' {
			local key `.`editobj'.axes[`i']'
			local pos_style `.`key'.position.stylename'
			if (`"`axis'"' == "yaxis") {
				if (`"`pos_style'"' == "left" | 	///
					`"`pos_style'"' == "right") 	///
				{
					// found an yaxis
					local editobj `key'
					continue, break
				}
			}
			else {
				if (`"`pos_style'"' == "above" | 	///
					`"`pos_style'"' == "below") 	///
				{
					// found an xaxis
					local editobj `key'
					continue, break
				}
			}
		}
		if `"`axisStyle'"' == "" {
			local axisStyle `.`editobj'.dlg_major'
		}
	}
	

	local fmt `.`editobj'.`axisStyle'.label_format'
	_date2elapsed, format(`fmt') datelist(`value')
	local orig `"`s(orig)'"'
	local 0 `",  range(`s(args)')"'
	if "`fmt'" == "" {
		capture syntax [ , Range(numlist missingok max=100 sort) * ]
		if c(rc) {
			exit 121
		}
	}
	else {
		local tfmt `s(fmt)'
		capture syntax [ , Range(numlist missingok max=100 sort) * ]
		if c(rc) {
			exit 121
		}
	}
end

program searchForIndex
	/* Attempt to get the index for a value since
	 * the index can be different after an edit occurs.
	 * (i.e. the axis ticks are not sorted)
	 */
	args dlg editobj axisStyle value index indexobj

	if (reldif(`value',`.`editobj'.`axisStyle'.dlg_tickpos[`index']') <1e-5){
		// is the value where we think is should be ?
		.`dlg'.`indexobj' = `index'
	}
	else {
		// search for the first occurrence
		local result 0
		local size 0
		capture local size = `.`editobj'.`axisStyle'.dlg_tickpos.arrnels'
		forvalues i = 1/`size' {
			if (reldif(`value',`.`editobj'.`axisStyle'.dlg_tickpos[`i']') <1e-5){
				local result `i'
				continue, break
			}
		}
		.`dlg'.`indexobj' = `result'
	}
end
