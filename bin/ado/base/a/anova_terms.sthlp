{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[P] anovadef" "help anovadef"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{viewerjumpto "Syntax" "anova_terms##syntax"}{...}
{viewerjumpto "Description" "anova_terms##description"}{...}
{viewerjumpto "Examples" "anova_terms##examples"}{...}
{title:Title}

{p 4 25 2}
{hi:[P] anova_terms} {hline 2} anova and manova terms
programming command


{marker syntax}{...}
{title:Syntax}

	{cmd:anova_terms}


{marker description}{...}
{title:Description}

{pstd}
Warning: This command is probably only useful to you if you are dealing with
{helpb anova} or {helpb manova} results produced with {helpb version} set to
less than 11.


{pstd}
{cmd:anova_terms} returns in {hi:r(rhs)} a list of the right-hand-side (rhs)
variables and terms, in {hi:r(continuous)} a list of
which rhs variables are continuous,
and in {hi:r(opts)} a list that contains the {cmd:noconstant} and
{cmd:cont()} options if they apply to the current {cmd:anova} or {cmd:manova}
estimation.  ({cmd:cont()} is only returned in {hi:r(opts)} if the {cmd:anova}
or {cmd:manova} results were produced with {cmd:version} set to less than 11.)

{pstd}
See {helpb anovadef} for a command that returns more detail for each
term of the model.


{marker examples}{...}
{title:Examples}

{phang}
{cmd:. version 10: anova y a b a*b c d a*c b*c a*d b*d, cont(c d) noconstant}
{p_end}
    {cmd:. anova_terms}
    {cmd:. return list}

    {txt}macros:
		   r(rhs) : "{res}a b c d a*b a*c b*c a*d b*d{txt}"
		  r(opts) : "{res}noconstant cont(c d){txt}"
	    r(continuous) : "{res}c d{txt}"


    {cmd:. version 10: manova y1 y2 = a b c a*c b*c, cont(c)}
    {cmd:. anova_terms}
    {cmd:. return list}

    {txt}macros:
		   r(rhs) : "{res}a b c a*c b*c{txt}"
		  r(opts) : "{res}cont(c){txt}"
	    r(continuous) : "{res}c{txt}"
