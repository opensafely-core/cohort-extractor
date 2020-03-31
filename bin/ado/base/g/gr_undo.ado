*! version 1.1.1  11jun2007
program define gr_undo , rclass
	version 8

	syntax [ , noReplay * ]


	local name "`._Gr_Global.edit_graph'"
	if ("`name'" == "")  exit				// Exit

	return scalar success = 0

	local undone `.`name'.undo.undo'		// Perform undo
	if "`undone'" != "" {
nobreak {
		_gedi cursor busy
capture noisily {
		.`name'.ClearSelection
		if "`replay'" == "" { 
			tempname undo_hold
			.`undo_hold' = .`name'.undo.ref		// hold undo
			gr_current name : `name'
			gr_replay `name' , refscheme `options'
			.`name'.undo.ref = .`undo_hold'.ref	// restore undo

			if (`"`.`name'.undo.UndoTitle'"' != `""') {
				.`name'.dirty = 1
				_gedi dirtychanged
			}
			else if (! 0`.`name'.undo.any_undos') {
				.`name'.dirty = 0
				_gedi dirtychanged
			}
		}
		.`name'.SetUndoRedoMenus
		_gedi browser reinit
		return scalar success = 1
}	// end capture noisily
		_gedi cursor standard
}	// end nobreak
	}
	else	di as text "note: nothing to undo"

end
