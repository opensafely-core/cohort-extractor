{* *! version 1.1.1  02mar2015}{...}
    {cmd:Clock(}{it:s1}{cmd:,}{it:s2}[{cmd:,}{it:Y}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {it:e_tC} datetime (ms. with leap seconds
           since 01jan1960 00:00:00.000) corresponding to {it:s1} based on
           {it:s2} and {it:Y}{p_end}

{p2col:}Function {cmd:Clock()} works the same as function
            {cmd:clock()} except that {cmd:Clock()} returns a leap
            second-adjusted {cmd:%tC} value rather than an unadjusted
            {cmd:%tc} value.  Use {cmd:Clock()} only if original time values
            have been adjusted for leap seconds.{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:s2}:}strings{p_end}
{p2col: Domain {it:Y}:}integers 1000 to 9998 (but probably 2001 to 2099){p_end}
{p2col: Range:}datetimes 01jan0100 00:00:00.000 to 31dec9999 23:59:59.999
           (integers -58,695,840,000,000 to >253,717,919,999,999) and
           {it:missing}{p_end}
{p2colreset}{...}

    {cmd:clock(}{it:s1}{cmd:,}{it:s2}[{cmd:,}{it:Y}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {it:e_tc} datetime (ms. since 01jan1960
           00:00:00.000) corresponding to {it:s1} based on {it:s2} and {it:Y}
           {p_end}

{p2col:}{it:s1} contains the date, time, or both, recorded as a
           string, in virtually any format. Months can be spelled out,
           abbreviated (to three characters), or indicated as numbers; years
           can include or exclude the century; blanks and punctuation are
           allowed.

{p2col:}{it:s2} is any permutation of {cmd:M}, {cmd:D},
    [{it:##}]{cmd:Y}, {cmd:h}, {cmd:m}, and {cmd:s}, with their order defining
    the order that month, day, year, hour, minute,
    and second occur (and whether they
    occur) in {it:s1}.  {it:##}, if specified, indicates the default
    century for two-digit years in {it:s1}.
    For instance, {it:s2} = {cmd:"MD19Y hm"}
    would translate {it:s1} = {cmd:"11/15/91 21:14"} as
    15nov1991 21:14.  The space in {cmd:"MD19Y hm"}
    was not significant and the string would
    have translated just as well with {cmd:"MD19Yhm"}.

{p2col:}{it:Y} provides an alternate way of handling two-digit years.
    {it:Y} specifies the largest year that is to be returned when a two-digit 
    year is encountered; see {helpb date()}.
    If neither {it:##} nor {it:Y} is specified, {cmd:clock()} returns
    {it:missing} when it encounters a two-digit year.{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:s2}:}strings{p_end}
{p2col: Domain {it:Y}:}integers 1000 to 9998 (but probably 2001 to 2099){p_end}
{p2col: Range:}datetimes 01jan0100 00:00:00.000 to 31dec9999 23:59:59.999
           (integers -58,695,840,000,000 to 253,717,919,999,999) and
           {it:missing}{p_end}
{p2colreset}{...}
