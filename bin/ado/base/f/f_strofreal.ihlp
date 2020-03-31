{* *! version 1.1.3  12mar2015}{...}
    {cmd:strofreal(}{it:n}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:n} converted to a string{p_end}

{p2col:}Also see {helpb real()}.{p_end}

{p2col:}{cmd:strofreal(4)+"F"} = {cmd:"4F"}{break}
	{cmd:strofreal(1234567)} = {cmd:"1234567"}{break}
	{cmd:strofreal(12345678)} = {cmd:"1.23e+07"}{break}
	{cmd:strofreal(.)} = {cmd:"."}{p_end}
{p2col: Domain {it:n}:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}


    {cmd:strofreal(}{it:n}{cmd:,}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:n} converted to a string using the specified display
	format{p_end}

{p2col:}Also see {helpb real()}.{p_end}

{p2col:}{cmd:strofreal(4,"%9.2f")} = {cmd:"4.00"}{break}
	{cmd:strofreal(123456789,"%11.0g")} = {cmd:"123456789"}{break}
        {cmd:strofreal(123456789,"%13.0gc")} = {cmd:"123,456,789"}{break}
        {cmd:strofreal(0,"%td")} = {cmd:"01jan1960"}{break}
	{cmd:strofreal(225,"%tq")} = {cmd:"2016q2"}{break}
	{cmd:strofreal(225,"not a format")} = {cmd:""}{p_end}
{p2col: Domain {it:n}:}-8e+307 to 8e+307 or {it:missing}{p_end}
{p2col: Domain {it:s}:}strings containing {cmd:%}{it:fmt} numeric display
                       format{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
