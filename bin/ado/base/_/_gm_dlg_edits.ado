*! version 1.1.0  16jan2019

program _gm_dlg_edits
	version 10

nobreak {
	_gedi cursor busy

capture noisily {

if ("$grdebugdlg"!="") di in white `"_gm_dlg_edits `0'"'

	// Process an edit or series of edits, typically initiated by a dialog.

					// loop, allowing pre edit operations
	local prolog "anything"
	while `"`prolog'"' != `""' {
		syntax [, prolog(string asis) * ]

		local 0 `", `options'"'

		`prolog'
	}

					// loop, allowing options more than once
	local drawopt  NODRAW
	local style    anything

	if `"`style'`set'`cmd'`_macval(setstrarray)'"' != `""' {
		.`._Gr_Global.edit_graph'.dirty = 1
		_gedi dirtychanged
		local our_set = ! 0`.`._Gr_Global.edit_graph'.undo.in_set'
		if  (`our_set')  .`._Gr_Global.edit_graph'.UndoBegin
	}

	while `"`style'`set'`cmd'`_macval(setstrarray)'"' != `""' {
		syntax [, OBJECTtoed(string asis)			///
			  style(string asis)				///
			  set(string asis)				///
			  cmd(string asis)				///
			  setstrarray(string asis)			///
			  gridedit(string asis)				///
			  jindex(integer 0) `drawopt' * ]
		if (`jindex')  local j `jindex'

		local 0 `", `options'"'

		if `"`object'"' == `""' {
			local object `objecttoed'
		}
		
		if `"`object'"' == "" {
			local object `._Gr_Global.edit_object'
		}

		._Gr_Global.dlg_edit_object = "`object'" // Others may use

		if ("`nodraw'" != "")  local drawopt

		if (! (0`j')) {
			local j `.`object'.SelectedCustomIndex'
		}

		if `"`style'"' != `""' {		// handle a style
		    local protonm "`._Gr_Global.prototypename `object''"
		    if "`protonm'" != "" {
			.`object'.style.editstyle `style' editcopy	///
				section(`protonm')
		    }
		    else {
			if 0`j' {				// Custom obs
			   _gm_edit .`object'.EditCustomStyle ,		///
				    j(`j') style(`style')
			}
			else {					// Standard
			   _gm_edit .`object'.style.editstyle `style' editcopy
			}
		    }
		}

// <--------------------------
if `"`set'"' != `""' {			// handle a setting

		gettoken target setting : set
		local setting `setting'			// sic
		local attrib `object'.`target'

		if 0`j' {				// Make custom obj
		    _gm_edit .`object'.SetCustom , j(`j') target(`target')  ///
		    	     attrib(`attrib') setting(`setting')
		}
		else {
		    capture .`object'._set_`target' `setting'
		    if ! _rc {
			_gm_log .`object'._set_`target' `setting'
		    }
		    else {
			if "`.`attrib'.isa'" == "string" {
			    _gm_edit .`attrib' = `"`setting'"'
			}
			else if "`.`attrib'.isa'" == "double" {
			    _gm_edit .`attrib' = `setting'
			}
			else if "`.`attrib'.isa'" == "class" {
			    if `.`attrib'.isofclass code' {
				_gm_edit .`attrib'.set, codename(`"`setting'"')
			    }
			    else if `.`attrib'.isofclass style' {
			    	capture confirm number `setting'
				if _rc {
				   _gm_edit .`attrib'.setstyle, style(`setting')
				}
				else {
			   	   _gm_edit .`attrib'.editstyle `setting'  ///
					editcopy
				}
				if "`target'" == "draw_view" {
				    local hset = "`setting'" == "no"
				    _gedi browser modify `object' hide `hset'
				}
			    }
			}
		    }
		}
}
// -------------------------->

		if `"`cmd'"' != `""' {			// handle a command
			`cmd'			// assumes cmd logs itself
		}

							// handle a text array
		if `:list sizeof setstrarray' {	
			gettoken array text : setstrarray
			local text : subinstr local text " " ""

			local array `object'.`array'

			_gm_edit .`array' = {}

			while `:list sizeof text' {
			    local wastext `"`macval(text)'"'
			    gettoken el text : text, qed(quoted)
			    if `quoted' {
				_gm_edit .`array'.Arrpush `"`macval(el)'"'
			    }
			    else {
				_gm_edit .`array'.Arrpush `macval(wastext)'
					continue, break
			    }
			}

		}

		if `"`gridedit'"' != `""' {		// handle a grid edit
		    if (0`.`._Gr_Global.gridnm'.isofclass grid') {
			gettoken exp_cont rest : gridedit
			_gm_edit .`._Gr_Global.gridnm'.`exp_cont'	///
				`._Gr_Global.gridobj' `rest'
		    }
		}

	}

	if 0`.`._Gr_Global.edit_graph'.isofclass fpgraph_g' {
		// NOTE: If we allow graph combine, VLW believes we will
		// need to loop over the edited object, first taking the
		// whole, then trimming one object (.a.object) off the
		// right and continuing to ask if we have a _plot.  If
		// we ever find one we would apply .set_sposition and
		// .set_graph to that object.

		_gm_edit .`._Gr_Global.edit_graph'.set_spositions
		_gm_edit .`._Gr_Global.edit_graph'.set_graphwidth
	}

	if  (`our_set' | 0`.`._Gr_Global.edit_graph'.undo.end_soon')	///
		.`._Gr_Global.edit_graph'.UndoEnd `object'

	if ("`nodraw'" == "") {
		_gedi extent "" "" 0 0 0 0
		graph display
		._Gr_Global.grid_ed_object = ""
		.`._Gr_Global.current_graph'._set_gedi_properties
		_gedi show
	}

					// loop, allowing post edit operations
	local epilog "anything"
	while `"`epilog'"' != `""' {
		syntax [, epilog(string asis) * ]

		local 0 `", `options'"'

		`epilog'
	}

}	// end capture noisily

	_gedi cursor standard

}	// end nobreak

	syntax [, FAKE_OPT_FOR_BETTER_MSG ]
	
end
