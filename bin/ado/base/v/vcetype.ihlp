{* *! version 1.0.0  18mar2010}{...}
{synoptset 23 tabbed}{...}
{synopthdr:vcetype}
{synoptline}
{syntab:SE}
{synopt :{opt linear:ized}}Taylor-linearized variance estimation{p_end}
{synopt :{opt bootstrap}}bootstrap variance estimation;
	see {manhelp svy_bootstrap SVY:svy bootstrap}
{p_end}
{synopt :{opt brr}}BRR variance estimation;
	see {manhelp svy_brr SVY:svy brr}
{p_end}
{synopt :{opt jack:knife}}jackknife variance estimation;
	see {manhelp svy_jackknife SVY:svy jackknife}{p_end}
{synopt :{opt sdr}}SDR variance estimation;
	see {manhelp svy_sdr SVY:svy sdr}
{p_end}
{synoptline}
{p 4 6 2}
Specifying a {it:vcetype} overrides the default from {cmd:svyset}.
