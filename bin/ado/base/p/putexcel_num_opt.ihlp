{* *! version 1.0.3  10may2019}{...}
{marker nformat}{...}
{phang}
{opt nformat(excelnfmt)} changes the numeric format of a cell range.  Codes
for commonly used formats are shown in the table of numeric formats in the
{help putexcel##formats:{it:Appendix}}.  However, any valid Excel format is
permitted.  Formats are formed from combinations of the following symbols.

                                                   Cell      Fmt      Cell
     Symbol        Description                    value     code  displays
    {hline}
     {cmd:0}             Digit placeholder (add zeros)   8.9      {cmd:#.00}      8.90
     {cmd:#}             Digit placeholder (no zeros)    8.9      {cmd:#.##}       8.9
     {cmd:?}             Digit placeholder (add space)   8.9      {cmd:0.0?}       8.9
     {cmd:.}             Decimal point
     {cmd:%}             Percentage                       .1         {cmd:%}       10%
     {cmd:,}             Thousands separator	       10000     {cmd:#,###}    10,000
     {cmd:E- E+ e- e+}   Scientific format          12200000  {cmd:0.00E+00}  1.22E+07
     {cmd:$-+/():space}  Display the symbol               12     {cmd:(000)}     (012)
     {cmd:\}             Escape character                  3      {cmd:0\!}         3!
     {cmd:*}             Repeat character                  3        {cmd:3*}    3xxxxx
                          (fill in cell width)                         
     {cmd:_}             Skip width of next character   -1.2      {cmd:_0.0}       1.2
     {cmd:"text"}        Display text in quotes         1.23  {cmd:0.00 "a"}    1.23 a
     {cmd:@}             Text placeholder                  b   {cmd:"a"@"c"}       abc
    {hline}

{pmore}
Formats that contain spaces must be enclosed in double quotes.
