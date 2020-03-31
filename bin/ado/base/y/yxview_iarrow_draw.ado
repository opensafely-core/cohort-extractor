*! version 1.0.0  22oct2002

// ---------------------------------------------------------------------------
//  Drawing program for the ilabels type of yxview.

//  WIP, just draws labeled points for now, on its way to becoming arrows.

program yxview_arrow_draw

	local ptlist `"`.point_list'"'

	while `"`ptlist'"' != `""' {
		gettoken point ptlist : ptlist
		._draw_point `point'
	}
end

