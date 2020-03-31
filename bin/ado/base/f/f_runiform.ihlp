{* *! version 1.1.3  02mar2015}{...}
    {cmd:runiform()}
{p2colset 8 22 22 2}{...}
{p2col: Description:}uniformly distributed random variates over the
                     interval (0,1){p_end}

{p2col:}{cmd:runiform()} can be seeded with the {cmd:set seed} command;
                  see {manhelp set_seed R:set seed}.{p_end}
{p2col: Range:}{cmd:c(epsdouble)} to 1-{cmd:c(epsdouble)}{p_end}
{p2colreset}{...}

    {cmd:runiform(}{it:a}{cmd:,}{it:b}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}uniformly distributed random variates over the
                     interval ({it:a},{it:b}){p_end}
{p2col: Domain {it:a}:}{cmd:c(mindouble)} to {cmd:c(maxdouble)}{p_end}
{p2col: Domain {it:b}:}{cmd:c(mindouble)} to {cmd:c(maxdouble)}{p_end}
{p2col: Range:}{it:a}+{cmd:c(epsdouble)} to {it:b}-{cmd:c(epsdouble)}{p_end}
{p2colreset}{...}
