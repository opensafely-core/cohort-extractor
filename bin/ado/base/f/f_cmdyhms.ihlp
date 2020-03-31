{* *! version 1.1.1  02mar2015}{...}
    {cmd:Cmdyhms(}{it:M}{cmd:,}{it:D}{cmd:,}{it:Y}{cmd:,}{it:h}{cmd:,}{it:m}{cmd:,}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {it:e_tC} datetime (ms. with leap seconds
           since 01jan1960 00:00:00.000) corresponding to {it:M}, {it:D},
           {it:Y}, {it:h}, {it:m}, {it:s}{p_end}
{p2col: Domain {it:M}:}integers 1 to 12{p_end}
{p2col: Domain {it:D}:}integers 1 to 31{p_end}
{p2col: Domain {it:Y}:}integers 0100 to 9999 (but probably 1800 to 2100){p_end}
{p2col: Domain {it:h}:}integers 0 to 23{p_end}
{p2col: Domain {it:m}:}integers 0 to 59{p_end}
{p2col: Domain {it:s}:}reals 0.000 to 60.999{p_end}
{p2col: Range:}datetimes 01jan0100 00:00:00.000 to 31dec9999 23:59:59.999
           (integers -58,695,840,000,000 to >253,717,919,999,999) and
           {it:missing}{p_end}
{p2colreset}{...}
