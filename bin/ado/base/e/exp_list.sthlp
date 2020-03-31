{smcl}
{* *! version 1.1.2  11feb2011}{...}
{vieweralsosee "[U] 13 Functions and expressions" "help exp"}{...}
{viewerjumpto "Description" "exp_list##description"}{...}
{viewerjumpto "Examples" "exp_list##examples"}{...}
{title:Title}

{pstd}
{it:exp_list} {hline 2} Expression lists


{marker description}{...}
{title:Description}

{pstd}
The expressions in {it:exp_list} are assumed to conform to the following
grammar.  Note that {it:exp_list} should not be enclosed in parentheses,
though individual expressions may be.

{p2colset 9 32 36 2}{...}
{p2col :{it:exp_list} contains}{cmd:(}{it:name}{cmd::} {it:elist}{cmd:)}{p_end}
{p2col :}{it:elist}{p_end}
{p2col :}{it:eexp}{p_end}

{p2col :{it:elist} contains}{it:newvar} = {opt (exp)}{p_end}
{p2col :}{opt (exp)}{p_end}

{p2col :{it:eexp} is}{it:specname}{p_end}
{p2col :}{cmd:[}{it:eqno}{cmd:]}{it:specname}{p_end}

{p2col :{it:specname} is}{cmd:_b}{p_end}
{p2col :}{cmd:_b[]}{p_end}
{p2col :}{cmd:_se}{p_end}
{p2col :}{cmd:_se[]}{p_end}

{p2col :{it:eqno} is}{cmd:#}{it:#}{p_end}
{p2col :}{it:name}{p_end}

{pmore}
{it:exp} is a standard Stata expression; see help {help exp}.


{marker examples}{...}
{title:Examples}

    {cmd:. sysuse auto}

{cmd}{...}
    . bootstrap (location: mean=r(mean) median=r(p50))
                (scale: sd=r(sd) iqr=(r(p75)-r(p25))
                        range=(r(max)-r(min)))
                : summarize price, detail
{reset}{...}

{phang}
{cmd:. bootstrap or=(exp(_b[mpg])): logit foreign mpg weight}

{phang}
{cmd:. jackknife sd=(r(sd)) skew=(r(skewness)), rclass: summarize mpg, detail}

{phang}
{cmd:. permute price _b rmse=(e(rmse)): regress price trunk}

{phang}
{cmd:. statsby _b n=(e(N)), by(rep78 foreign): regress mpg weight}{p_end}
