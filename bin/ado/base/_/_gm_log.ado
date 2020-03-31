*! version 1.1.3  20jun2011
program define _gm_log
	version 8

	/* log the supplied command into the lowest (rightmost) object that
	 * has a __LOG.  If any object in the object name is a named style, 
	 * the command is logged in the scheme of the lowest object having a
	 * _scheme. Recognizes T_log2scm to force logging to the scheme. 
	 * Also register the changes with the overall graphs undo manager. */

	local scheme_log `c(curscm)'				/* default */

	local undo "`._Gr_Global.edit_graph'.undo"
	local do = cond(0`.`undo'.isofclass _gm_undo', "", "*")

	local terminals "bygraph_g matrixgraph_g"	
						// do not look for logs within
	local drilling 1

	gettoken fullnm rest : 0 , parse(" ,=")

	local name  Global
	gettoken tok fullnm : fullnm , parse(" .") 
	while "`tok'" != "" {
		if "`tok'" != "." {
			local name `name'.`tok'
			local lognm `lognm'.`tok'

			if "`.`name'.__LOG.isa'" == "array" & `drilling' {
			   local log `name'.__LOG
//			   local log `.`name'.__LOG.objkey'
			   local lognm
			   if `:list posof "`.`name'.classname'" in terminals' {
				local drilling 0
			   }
			}

			if "`.`name'._scheme.__LOG.isa'"=="array" & `drilling' {
				local scheme_log `name'._scheme.__LOG
//				local scheme_log `.`name'._scheme.__LOG.objkey'
			}

			if 0`pending' {
		            if ! 0`.`name'.namedstyle' {	/* finished */
				if "`scheme_log'" == "" {
				    ScmLogErr `0'
				}
				local fn `fullnm'
				if "`fn'" != "" {
				    di as error "`fn' invalid in style edit:"
				    di as error `"`0'"'
				    exit 4099
				}

				if "`.`name'.isa'" == "" { /* pgm not attrib */
				    if "`ednm1'" == "" {
					continue, break   /* not a scheme ed */
				    }

				    local edit .`tok'`macval(rest)'
				}
				else {
				    local ednm1  `ednm'
				    local attrib `tok'
				    local edit   `"`macval(rest)'"'
				}

.`scheme_log'.Arrpush .decl_style `.`ednm1'.classname' `.`ednm1'.stylename'
						/* scheme may need to create */
.`scheme_log'.Arrpush /*
*/ .style_edit `.`ednm1'.classname' `.`ednm1'.snm' `attrib'`macval(edit)'
				`do' .`undo'.add `scheme_log' 2
window stopbox rusure "An attempt is being made to edit a scheme."	///
		      "This should not happen"				///
		      "Please report how this occurred to tech-support@stata.com"

				exit				/* EXIT */
			    }
			}

			if 0`.`name'.namedstyle' {     /* found a named style */
				if 0`pending' {
					local ednm1 `ednm'
					local attrib  `tok'
				}
				local pending 1
				local ednm   `name'
			}

		}

		gettoken tok fullnm : fullnm , parse(" .") 
	}


	if 0$T_log2scm {
		if "`scheme_log'" == "" {
			ScmLogErr `0'
		}
						/* assume remake_as_copy */
		local edit .`tok'`macval(rest)'			
.`scheme_log'.Arrpush .decl_style `.`ednm'.classname' `.`ednm'.stylename'

.`scheme_log'.Arrpush /*
*/ .style_edit `.`ednm'.classname' `.`ednm'.snm' `attrib'`macval(edit)'
		`do' .`undo'.add `scheme_log' 2
window stopbox rusure "An attempt is being made to edit a scheme."	///
		      "This should not happen"				///
		      "Please report how this occurred to tech-support@stata.com"
	}
	else {
		if "`log'" == "" {
			di as error "could not find __LOG to log:"
			di as error `"`0'"'
			exit 4099
		}

		.`log'.Arrpush `lognm'`macval(rest)'
		`do' .`undo'.add `log' 1
	}

	if 0`_gedi(recording)' {
		gettoken recname rest : 0 , parse(" ,=")
		local tok "."
		while "`tok'" == "." | "`tok'" == "Global" {
			gettoken tok recname : recname , parse(" .") 
		}
	      .`._Gr_Global.edit_graph'.recorder.Arrpush `recname'`macval(rest)'
	}


end

program define ScmLogErr
	di as error "could not find scheme to log:"
	di as error `"`0'"'
	exit 4099
end

exit

NOTE:  Cannot check if the edit is valid, do not call this program with an
       invalid editing command.

<end>
