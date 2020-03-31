{* *! version 1.1.3  12mar2015}{...}
    {cmd:cond(}{it:x}{cmd:,}{it:a}{cmd:,}{it:b}[{cmd:,}{it:c}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:a} if
	{it:x} is true and nonmissing, {it:b} if {it:x} is false, and {it:c} if
	{it:x} is {it:missing}; {it:a} if {it:c} is not specified and {it:x}
	evaluates to {it:missing}{p_end}

{p2col:}Note that expressions such as {it:x}>2 will never evaluate to
{it:missing}.{p_end}

{p2col:}{cmd:cond(x>2,50,70)} returns {cmd:50} if
		     {cmd:x} > {cmd:2} (includes
                     {cmd:x} {ul:>} {cmd:.}){p_end}
{p2col:}{cmd:cond(x>2,50,70)} returns {cmd:70} if
		     {cmd:x} {ul:<} {cmd:2}{p_end}

{p2col:}If you need a case for missing values in the above examples, try{p_end}

{p2col:}{cmd:cond(missing(x), ., cond(x>2,50,70))} returns {cmd:.} if
		     {cmd:x} is {it:missing}, returns {cmd:50} if {cmd:x} >
		     {cmd:2}, and returns {cmd:70} if
		     {cmd:x} {ul:<} {cmd:2}{p_end}

{p2col: }If the first argument is a scalar that may contain a missing value
or a variable containing missing values, the fourth argument has an
effect.{p_end}

{p2col:}{cmd:cond(wage,1,0,.)} returns {cmd:1} if {cmd:wage} is not
zero and not missing{p_end}
{p2col:}{cmd:cond(wage,1,0,.)} returns {cmd:0} if {cmd:wage} is
zero{p_end}
{p2col:}{cmd:cond(wage,1,0,.)} returns {cmd:.} if {cmd:wage} is
{it:missing}{p_end}

{p2col: }Caution: If the first argument to {cmd:cond()} is a logical
expression, that is, {cmd:cond(x>2,50,70,.)}, the fourth argument is never
reached.{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307 or {it:missing}; 0 means false,
                 otherwise interpreted as true{p_end}
{p2col: Domain {it:a}:}numbers and strings{p_end}
{p2col: Domain {it:b}:}numbers if {it:a} is a number; strings if {it:a} is a
                   string{p_end}
{p2col: Domain {it:c}:}numbers if {it:a} is a number; strings if {it:a} is a
                   string{p_end}
{p2col: Range:}{it:a}, {it:b}, and {it:c}{p_end}
{p2colreset}{...}
