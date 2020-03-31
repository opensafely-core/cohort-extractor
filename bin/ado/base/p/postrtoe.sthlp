{smcl}
{* *! version 1.0.4  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "postrtoe##syntax"}{...}
{viewerjumpto "Description" "postrtoe##description"}{...}
{viewerjumpto "Options" "postrtoe##options"}{...}
{viewerjumpto "Remarks" "postrtoe##remarks"}{...}
{viewerjumpto "Examples" "postrtoe##examples"}{...}
{title:Title}

{p 4 18 2}
{hi:[P] postrtoe} {hline 2} Post results stored in r() as e()


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}{cmd:postrtoe} [{it:prefix}] [{cmd:,} options] 

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent :{cmd:{ul:mac}ro(}{it:namelist}|{cmd:_all)}}post only macros 
specified in {it:namelist} or all macros{p_end}
{p2coldent :{cmd:{ul:mat}rix(}{it:namelist}|{cmd:_all)}}post only matrices 
specified in {it:namelist} or all matrices{p_end}
{p2coldent :{cmd:{ul:sca}lar(}{it:namelist}|{cmd:_all)}}post only scalars 
specified in {it:namelist} or all scalars{p_end}
{p2coldent :{opt nocle:ar}}do not clear current {cmd:e()} stored results{p_end}
{p2coldent :{opt ren:ame}}use the names obtained from the specified {it:b} 
matrix as the labels for both the {cmd:b} and {cmd:V} estimation 
matrices{p_end}
{p2coldent :{opt res:ize}}replace {cmd:e(b)}, {cmd:e(V)}, and {cmd:e(Cns)} 
with their {cmd:r()} equivalents even if {cmd:e()} and {cmd:r()} results are 
not conformable{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:postrtoe} clears the contents of {cmd:e()} and copies results from 
{cmd:r()} to {cmd:e()}.

{pstd}
You may prefix stored results with {it:prefix}; the maximum length of
{it:prefix} is 10 characters.


{marker options}{...}
{title:Options}

{phang}
{cmd:macro(}{it:namelist}|{cmd:_all)} specifies macros to be posted into 
{cmd:e()}; for example, {cmd: macro(cmdline)} will move {cmd:r(cmdline)} into 
{cmd:e(cmdline)}.  The default is to move all the available macros.

{phang}
{cmd:matrix(}{it:namelist}|{cmd:_all)} specifies matrices to be posted into 
{cmd:e()}; for example, {cmd: matrix(C)} will move {cmd:r(C)} into {cmd:e(C)}.
The default is to move all the available matrices.

{phang}
{cmd:scalar(}{it:namelist}|{cmd:_all)} specifies scalars to be posted into 
{cmd:e()}; for example, {cmd: scalar(width)} will move {cmd:r(width)} into 
{cmd:e(width)}.  The default is to move all the available scalars.

{phang}
Note: {cmd:macro()}, {cmd:matrix()}, and {cmd:scalar()} are exclusive; if you 
specify {cmd:scalar(N)}, only {cmd:r(N)} will be moved into {cmd:e(N)}.  
If you want to move all the macros and matrices alongside {cmd:r(N)}, you 
must type {cmd:scalar(N)} {cmd:matrix(_all)} {cmd: macro(_all)}.

{phang}
{opt noclear} tells Stata not to clear {cmd:e()}.  Entries in {cmd:r()} will
replace identically named entries in {cmd:e()}; otherwise, {cmd:r()} 
entries will be appended to the {cmd:e()} list.

{phang}
{opt rename} works only if {cmd:noclear} is specified and {it:prefix} is not 
specified.  If this is the case, {cmd:rename} tells Stata to use the names 
obtained from the specified {it:b} matrix as the labels for both the {cmd:b} 
and {cmd:V} estimation matrices.  These labels are subsequently used in the 
output produced by {helpb ereturn display}.

{phang}
{opt resize} replaces the current {cmd:e(b)}, {cmd:e(V)}, and {cmd:e(Cns)}
results with
their {cmd:r()} equivalents, if they exist, even if {cmd:e()} and {cmd:r()} 
results are not conformable.  
However, the new set of results must be conformable with each other.  For 
example, if both {cmd:e(b)} and {cmd:e(V)} exist, you may not specify 
{cmd:postrtoe, noclear mat(b) resize}; you must type {cmd:mat(b V)}.  
{cmd:resize} is not allowed with the {cmd:e()} list returned by {helpb regress}
or {helpb anova}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Because {cmd:postrtoe} recasts {cmd:r()} results as {cmd:e()}, the command will 
add {cmd:e(properties)} to the macro list when appropriate.


{marker examples}{...}
{title:Examples}

{pstd}Clear {cmd:e()} returned by {cmd:regress} and move {cmd:r(N)} 
returned by {cmd:count} into {cmd:e(N)}{p_end}

{phang2}{cmd:. regress price mpg}{p_end}
{phang2}{cmd:. count if foreign==1}{p_end}
{phang2}{cmd:. postrtoe}{p_end}

{pstd}Clear {cmd:e()} returned by {cmd:regress} and move {cmd:r(N)} 
returned by {cmd:count} into {cmd:e(cnt_N)}{p_end}

{phang2}{cmd:. regress price mpg}{p_end}
{phang2}{cmd:. count if foreign==1}{p_end}
{phang2}{cmd:. postrtoe cnt_}{p_end}

{pstd}Replace {cmd:e(N)} returned by {cmd:regress} with the contents of 
{cmd:r(N)} returned by {cmd:count}{p_end}

{phang2}{cmd:. regress price mpg}{p_end}
{phang2}{cmd:. count if foreign==1}{p_end}
{phang2}{cmd:. postrtoe, noclear} {space 2}{p_end}

{pstd}Recast {cmd:r(N)} returned by {cmd:count} as {cmd:e(rep3_N)} and add 
{cmd:e(rep3_N)} to {cmd:e()} list returned by {cmd:regress}{p_end}

{phang2}{cmd:. regress price mpg}{p_end}
{phang2}{cmd:. count if rep78==3}{p_end}
{phang2}{cmd:. postrtoe rep3_, noclear}{p_end}

{pstd}Replace {cmd:b} and {cmd:V} matrices returned by {cmd:poisson} with 
{cmd:b} and {cmd:V} matrices returned by {cmd:margins}{p_end}

{phang2}{cmd:. poisson mpg i.rep78 weight price}{p_end}
{phang2}{cmd:. margins rep78}{p_end}
{phang2}{cmd:. postrtoe, mat(b V) noclear resize}{p_end}
