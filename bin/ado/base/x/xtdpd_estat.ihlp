{* *! version 1.0.0  02oct2014}{...}
{marker syntax_estat}{...}
{marker estatabond}{marker estatsargan}{...}
{title:Syntax for estat}

{pstd}Test for autocorrelation

{p 8 16 2}
{cmd:estat} {cmdab:ab:ond} [{cmd:,} {cmdab:art:ests}{cmd:(}{it:#}{cmd:)}]


{pstd}Sargan test of overidentifying restrictions

{p 8 16 2}
{cmd:estat} {cmd:sargan}


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat abond} reports the Arellano-Bond test for serial correlation in
the first-differenced residuals.

{pstd}
{cmd:estat sargan} reports the Sargan test of the overidentifying
restrictions.


{marker option_estat_abond}{...}
{title:Option for estat abond}

{phang}
{opt artests(#)} specifies the highest order of serial correlation to be tested.
By default, the tests computed during estimation are reported.  The model
will be refit when {opt artests(#)} specifies a higher order than that
computed during the original estimation.  The model can only be refit if the
data have not changed.
{p_end}
