{* *! version 1.1.2  21mar2018}{...}
    {cmd:nullmat(}{it:matname}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}use with the row-join ({cmd:,}) and column-join ({cmd:\})
	operators{p_end}
	
{p2col:}Consider the following code fragment, which is an attempt to create
	the vector (1,2,3,4):

                           {cmd}forvalues i = 1/4 {
		                   mat v = (v, `i')
                           }{txt}

{p2col:}The above program will not work because, the first time
	through the loop, {cmd:v} will not yet exist, and thus forming
	{cmd:(v, `i')} makes no sense.  {cmd:nullmat()} relaxes that
	restriction:

                           {cmd}forvalues i = 1/4 {
		                   mat v = (nullmat(v), `i')
                           }{txt}

{p2col:}The {cmd:nullmat()} function informs Stata that if {cmd:v}
	does not exist, the function row-join is to be generalized.  Joining
	nothing with {cmd:`i'} results in {cmd:(`i')}.  Thus the first time
	through the loop, {cmd:v} = (1) is formed.  The second time through,
	{cmd:v} does exist, so {cmd:v} = (1,2) is formed, and so on.{p_end}

{p2col:}{cmd:nullmat()} can be used only with the {cmd:,} and 
	{cmd:\} operators.{p_end}
{p2col: Domain:}matrix names, existing and nonexisting{p_end}
{p2col: Range:}matrices including null if {it:matname} does not exist{p_end}
{p2colreset}{...}
