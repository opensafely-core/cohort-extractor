*! version 1.0.0  15oct2004
version 9.0
mata:

numeric matrix edittozerotol(numeric matrix userx, real scalar usertol) 
{
	numeric matrix	x

	if (isfleeting(userx)) {
		_edittozerotol(userx,usertol) 
		return(userx)
	}
	x = userx
	_edittozerotol(x,usertol) 
	return(x)
}

end
