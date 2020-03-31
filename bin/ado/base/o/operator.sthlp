{smcl}
{* *! version 1.1.4  20sep2014}{...}
{findalias asfroperators}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FN] Functions by category" "help functions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] egen" "help egen"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{viewerjumpto "Syntax" "operator##syntax"}{...}
{viewerjumpto "Examples" "operator##examples"}{...}
{title:Title}

{pstd}
{findalias froperators}


{marker syntax}{...}
{title:Syntax}

					   {col 58}Relational
	 Arithmetic       {col 34}Logical   {col 53}(numeric and string)
    {hline 20}{col 30}{hline 18}{col 53}{hline 21}
     {cmd:+}   addition      {col 34}{cmd:&}   and{col 56}{cmd:>}   greater than
     {cmd:-}   subtraction   {col 34}{cmd:|}   or {col 56}{cmd:<}   less than
     {cmd:*}   multiplication{col 34}{cmd:!}   not{col 56}{cmd:>=}  > or equal
     {cmd:/}   division      {col 34}{cmd:~}   not{col 56}{cmd:<=}  < or equal
     {cmd:^}   power                              {col 56}{cmd:==}  equal
     {cmd:-}   negation				  {col 56}{cmd:!=}  not equal
     {cmd:+}   string concatenation               {col 56}{cmd:~=}  not equal

{pstd}A double equal sign ({cmd:==}) is used for equality testing.

{pstd}
The order of evaluation (from first to last) of all operators is {cmd:!} (or
{cmd:~}), {cmd:^}, {cmd:-} (negation), {cmd:/}, {cmd:*}, {cmd:-}
(subtraction), {cmd:+}, {cmd:!=} (or {cmd:~=}), {cmd:>}, {cmd:<}, {cmd:<=},
{cmd:>=}, {cmd:==}, {cmd:&}, and {cmd:|}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. generate weight2 = weight^2}{p_end}
{phang}{cmd:. count if rep78 > 4}{p_end}
{phang}{cmd:. count if rep78 > 4 & weight < 3000}{p_end}
{phang}{cmd:. list make if rep78 == 5 | mpg > 25}{p_end}
