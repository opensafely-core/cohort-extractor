{* *! version 1.1.3  15may2018}{...}
    {cmd:date(}{it:s1}{cmd:,}{it:s2}[{cmd:,}{it:Y}]{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the {it:e_d} date (days since 01jan1960)
           corresponding to {it:s1} based on {it:s2} and {it:Y}
           {p_end}

{p2col:}{it:s1} contains the date, recorded as a string, in virtually
       any format.  Months can be spelled out, abbreviated (to three
       characters), or indicated as numbers; years can include or exclude the
       century; blanks and punctuation are allowed.

{p2col:}{it:s2} is any permutation of {cmd:M}, {cmd:D}, and
       [{it:##}]{it:Y}, with their order defining the order that month, day,
       and year occur in {it:s1}.  {it:##}, if specified, indicates the
       default century for two-digit years in {it:s1}.  For instance,
       {it:s2}={cmd:"MD19Y"} would translate {it:s1}={cmd:"11/15/91"} as
       15nov1991.

{p2col:}{it:Y} provides an alternate way of handling two-digit years.
       When a two-digit year is encountered, the largest year, {it:topyear},
       that does not exceed {it:Y} is returned.

                            {cmd:date("1/15/08","MDY",1999)} = 15jan1908
                            {cmd:date("1/15/08","MDY",2019)} = 15jan2008

                            {cmd:date("1/15/51","MDY",2000)} = 15jan1951
                            {cmd:date("1/15/50","MDY",2000)} = 15jan1950
                            {cmd:date("1/15/49","MDY",2000)} = 15jan1949

                            {cmd:date("1/15/01","MDY",2050)} = 15jan2001
                            {cmd:date("1/15/00","MDY",2050)} = 15jan2000

{p2col:}If neither {it:##} nor {it:Y} is specified, {cmd:date()}
    returns {it:missing} when it encounters a two-digit year. See
    {help datetime translation##twodigit:{it:Working with two-digit years}} in
    {helpb datetime translation:[D] Datetime translation}
    for more information.{p_end}
{p2col: Domain {it:s1}:}strings{p_end}
{p2col: Domain {it:s2}:}strings{p_end}
{p2col: Domain {it:Y}:}integers 1000 to 9998 (but probably 2001 to 2099){p_end}
{p2col: Range:}{cmd:%td} dates 01jan0100 to 31dec9999 (integers -679,350 to
           2,936,549) or {it:missing}{p_end}
{p2colreset}{...}
