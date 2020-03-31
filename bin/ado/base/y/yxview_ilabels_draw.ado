*! version 1.0.0  22oct2002

// ---------------------------------------------------------------------------
//  Drawing program for the ilabels type of yxview.

program yxview_ilabels_draw

	local ptlist `"`.point_list'"'

	while `"`ptlist'"' != `""' {
		gettoken point ptlist : ptlist
		._draw_point `point'
	}
end

