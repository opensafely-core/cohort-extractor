{smcl}
{* *! version 1.1.1  11feb2011}{...}
{findalias asfrinrange}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 11 Language syntax (the by prefix)" "help by"}{...}
{vieweralsosee "[U] 11.1.3 if range (the if qualifier)" "help if"}{...}
{viewerjumpto "Syntax" "in##syntax"}{...}
{viewerjumpto "Description" "in##description"}{...}
{viewerjumpto "Examples" "in##examples"}{...}
{title:Title}

{pstd}
{findalias frinrange}


{marker syntax}{...}
{title:Syntax}

	{it:command} {cmd:in} {it:range}

    where {it:range} is       {it:#}
			 {it:#}{cmd:/}{it:#}
			 {it:#}{cmd:/l}
			 {cmd:f/}{it:#}


{marker description}{...}
{title:Description}

{pstd}
{cmd:in} at the end of a command means that the command is to use only the
observations specified.  {cmd:in} is allowed with most Stata commands.


{marker examples}{...}
{title:Examples}

        {cmd:. sysuse auto}
        {cmd:. list price in 10}{right:(any command may be substituted for {cmd:list})  }
        {cmd:. list price in 10/20}
        {cmd:. list price in 20/l}{right:(lowercase el at end of range)             }
        {cmd:. list price in 1/10}{right:(numeric 1 at beginning of range)          }
        {cmd:. list price in f/10}{right:(f means the same as 1)                    }
        {cmd:. list price in -10/l}{right:(lowercase el at end of range)             }


{pstd}
{cmd:F} is allowed as a synonym for {cmd:f}, and {cmd:L} is allowed
as a synonym for {cmd:l}.

{pstd}
Negative numbers may be used to specify distance from the end of the data.
The last example says to list the last 10 observations and could also be
written

        {cmd:. list price in -10/-1}
