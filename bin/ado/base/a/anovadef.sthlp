{smcl}
{* *! version 1.0.4  09feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{vieweralsosee "[P] anova_terms" "help anova_terms"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{viewerjumpto "Syntax" "anovadef##syntax"}{...}
{viewerjumpto "Description" "anovadef##description"}{...}
{viewerjumpto "Options" "anovadef##options"}{...}
{viewerjumpto "Remarks" "anovadef##remarks"}{...}
{title:Title}

{p 4 22 2}
{hi:[P] anovadef} {hline 2} anova and manova term definition
programming command


{marker syntax}{...}
{title:Syntax}

	{cmd:anovadef} [{cmd:,} {cmd:alt} | {cmdab:showord:er}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:anovadef} returns in {hi:r()} a labeling of the coefficients from the
last {helpb anova} or {helpb manova}.  It numbers the returned values in the
same order they are presented in the {hi:e(b)} and {hi:e(V)} matrices from the
{cmd:anova} or {cmd:manova}.  This is helpful since the order of the
coefficients in {hi:e(b)} or in {hi:e(V)} is not always the same as the order
specified in the {cmd:anova} or {cmd:manova} command, and when the {cmd:anova}
or {cmd:manova} was run under {helpb version} less than 11, the matrix row and
column names are not meaningful.

{pstd}
For {cmd:manova}, the labeling for one equation is returned.  This same
labeling applies to each of the equations.  The equation names are already
attached to the {hi:e(b)} and {hi:e(V)} matrices, and so {cmd:anovadef}
does not return them.


{marker options}{...}
{title:Options}

{phang}
{cmd:alt} specifies an alternate way of returning the labeling information;
see remarks below.

{phang}
{cmd:showorder} specifies that instead of executing silently, {cmd:anovadef}
is to display the design matrix column definitions and not return results in
{cmd:r()}.  {cmd:showorder} may not be specified with {cmd:alt}.


{marker remarks}{...}
{title:Remarks}

{pstd}
After the following {helpb anova}

{phang2}{cmd:. version 10: anova wei len rep*for len*for for rep*len rep rep*len*for*gea,} {cmd:cont(gea len)}

{pstd}
{cmd:anovadef} without the {cmd:alt} option

	{cmd:. anovadef}

{pstd}
produces results named {hi:r(tid}{it:#}{hi:)} where {it:#} goes from 1 to
the number of elements in {hi:e(b)}.  {hi:tid} stands for "term id".

{pstd}
Here are a few of the {hi:r()} items produced with the example above:

{p 8 19 2}{hi:r(tid1)}{space 5}: "1"{p_end}
{p 8 19 2}{hi:r(tid2)}{space 5}: "length"{p_end}
{p 8 19 2}{hi:r(tid3)}{space 5}: "(foreign==0)"{p_end}
{p 8 19 2}{hi:r(tid4)}{space 5}: "(foreign==1)"{p_end}
{p 8 19 2}{hi:r(tid5)}{space 5}: "(rep78==1)"{p_end}
{p 8 19 2}{hi:r(tid6)}{space 5}: "(rep78==2)"{p_end}
{p 8 19 2}{hi:r(tid7)}{space 5}: "(rep78==3)"{p_end}
{p 8 19 2}{hi:r(tid8)}{space 5}: "(rep78==4)"{p_end}
{p 8 19 2}{hi:r(tid9)}{space 5}: "(rep78==5)"{p_end}
{p 8 19 2}{hi:r(tid10)}{space 4}: "(rep78==1)*(foreign==0)"{p_end}
{p 8 19 2}{hi:r(tid11)}{space 4}: "(rep78==2)*(foreign==0)"{p_end}
{p 8 19 2}{hi:r(tid12)}{space 4}: "(rep78==3)*(foreign==0)"{p_end}
	...
{p 8 19 2}{hi:r(tid29)}{space 4}: "(rep78==4)*length*(foreign==0)*gear_ratio"{p_end}
{p 8 19 2}{hi:r(tid30)}{space 4}: "(rep78==4)*length*(foreign==1)*gear_ratio"{p_end}
{p 8 19 2}{hi:r(tid31)}{space 4}: "(rep78==5)*length*(foreign==0)*gear_ratio"{p_end}
{p 8 19 2}{hi:r(tid32)}{space 4}: "(rep78==5)*length*(foreign==1)*gear_ratio"

{pstd}
{hi:r(tid1)} corresponds to the constant and is simply "1".
This is how {cmd:anovadef} indicates the constant.

{pstd}
{cmd:anovadef} with the {cmd:alt} option

	{cmd:. anovadef, alt}

{pstd}
produces results named {hi:r(tn}{it:#}{hi:)} and {hi:r(tl}{it:#}{hi:)}
where {it:#} goes from 1 to the number of elements in {hi:e(b)}.  {hi:tn}
stands for "term names" and {hi:tl} stands for "term levels".

{pstd}
Here are a few of the {hi:r()} items produced with the example above:

{p 8 19 2}{hi:r(tn1)}{space 2}: "1"{p_end}
{p 8 19 2}{hi:r(tl1)}{space 2}: "c"{p_end}
{p 8 19 2}{hi:r(tn2)}{space 2}: "length"{p_end}
{p 8 19 2}{hi:r(tl2)}{space 2}: "c"{p_end}
{p 8 19 2}{hi:r(tn3)}{space 2}: "foreign"{p_end}
{p 8 19 2}{hi:r(tl3)}{space 2}: "0"{p_end}
{p 8 19 2}{hi:r(tn4)}{space 2}: "foreign"{p_end}
{p 8 19 2}{hi:r(tl4)}{space 2}: "1"{p_end}
{p 8 19 2}{hi:r(tn5)}{space 2}: "rep78"{p_end}
{p 8 19 2}{hi:r(tl5)}{space 2}: "1"{p_end}
{p 8 19 2}{hi:r(tn6)}{space 2}: "rep78"{p_end}
{p 8 19 2}{hi:r(tl6)}{space 2}: "2"{p_end}
{p 8 19 2}{hi:r(tn7)}{space 2}: "rep78"{p_end}
{p 8 19 2}{hi:r(tl7)}{space 2}: "3"{p_end}
{p 8 19 2}{hi:r(tn8)}{space 2}: "rep78"{p_end}
{p 8 19 2}{hi:r(tl8)}{space 2}: "4"{p_end}
{p 8 19 2}{hi:r(tn9)}{space 2}: "rep78"{p_end}
{p 8 19 2}{hi:r(tl9)}{space 2}: "5"{p_end}
{p 8 19 2}{hi:r(tn10)} : "rep78 foreign"{p_end}
{p 8 19 2}{hi:r(tl10)} : "1 0"{p_end}
{p 8 19 2}{hi:r(tn11)} : "rep78 foreign"{p_end}
{p 8 19 2}{hi:r(tl11)} : "2 0"{p_end}
{p 8 19 2}{hi:r(tn12)} : "rep78 foreign"{p_end}
{p 8 19 2}{hi:r(tl12)} : "3 0"{p_end}
	...
{p 8 19 2}{hi:r(tn29)} : "rep78 length foreign gear_ratio"{p_end}
{p 8 19 2}{hi:r(tl29)} : "4 c 0 c"{p_end}
{p 8 19 2}{hi:r(tn30)} : "rep78 length foreign gear_ratio"{p_end}
{p 8 19 2}{hi:r(tl30)} : "4 c 1 c"{p_end}
{p 8 19 2}{hi:r(tn31)} : "rep78 length foreign gear_ratio"{p_end}
{p 8 19 2}{hi:r(tl31)} : "5 c 0 c"{p_end}
{p 8 19 2}{hi:r(tn32)} : "rep78 length foreign gear_ratio"{p_end}
{p 8 19 2}{hi:r(tl32)} : "5 c 1 c"

{pstd}
A {hi:"c"} indicates that the corresponding term is a continuous variable.
A number indicates that it is a categorical variable.


{pstd}
{cmd:anovadef} with the {cmd:showorder} option displays the following output.

{cmd}    . anovadef, showorder

     Order of columns in the design matrix
	  1: _cons
	  2: length
	  3: (foreign==0)
	  4: (foreign==1)
	  5: (rep78==1)
	  6: (rep78==2)
	  7: (rep78==3)
	  8: (rep78==4)
	  9: (rep78==5)
	 10: (rep78==1)*(foreign==0)
	 11: (rep78==2)*(foreign==0)
	 12: (rep78==3)*(foreign==0)
	 13: (rep78==3)*(foreign==1)
	 14: (rep78==4)*(foreign==0)
	 15: (rep78==4)*(foreign==1)
	 16: (rep78==5)*(foreign==0)
	 17: (rep78==5)*(foreign==1)
	 18: (rep78==1)*length
	 19: (rep78==2)*length
	 20: (rep78==3)*length
	 21: (rep78==4)*length
	 22: (rep78==5)*length
	 23: length*(foreign==0)
	 24: length*(foreign==1)
	 25: (rep78==1)*length*(foreign==0)*gear_ratio
	 26: (rep78==2)*length*(foreign==0)*gear_ratio
	 27: (rep78==3)*length*(foreign==0)*gear_ratio
	 28: (rep78==3)*length*(foreign==1)*gear_ratio
	 29: (rep78==4)*length*(foreign==0)*gear_ratio
	 30: (rep78==4)*length*(foreign==1)*gear_ratio
	 31: (rep78==5)*length*(foreign==0)*gear_ratio
	 32: (rep78==5)*length*(foreign==1)*gear_ratio{txt}
