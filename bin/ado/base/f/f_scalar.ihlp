{* *! version 1.1.1  02mar2015}{...}
    {cmd:scalar(}{it:exp}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}restricts name interpretation to scalars
	and matrices{p_end}

{p2col:}Names in expressions can refer to names of variables in the
	dataset, names of matrices, or names of scalars.  Matrices and scalars
	can have the same names as variables in the dataset.  If names
	conflict, Stata assumes that you are referring to the name of the
	variable in the dataset.{p_end}

{p2col:}{helpb matrix()} and {cmd:scalar()} explicitly state that
	you are referring to matrices and scalars.  {cmd:matrix()} and
	{cmd:scalar()} are the same function; scalars and matrices may not
	have the same names and so cannot be confused.  Typing {cmd:scalar(x)}
	makes it clear that you are referring to the scalar or matrix named
	{cmd:x} and not the variable named {cmd:x}, should there happen to be
	a variable of that name.{p_end}
{p2col: Domain:}any valid expression{p_end}
{p2col: Range:}evaluation of {it:exp}{p_end}
{p2colreset}{...}
