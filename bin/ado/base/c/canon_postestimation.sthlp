{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog predict "dialog canon_p"}{...}
{viewerdialog estat "dialog canon_estat"}{...}
{viewerdialog screeplot "dialog screeplot"}{...}
{vieweralsosee "[MV] canon postestimation" "mansection MV canonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] canon" "help canon"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] rotatemat" "help rotatemat"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{viewerjumpto "Postestimation commands" "canon postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "canon_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "canon postestimation##syntax_predict"}{...}
{viewerjumpto "estat" "canon postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "canon postestimation##examples"}{...}
{viewerjumpto "Stored results" "canon postestimation##results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[MV] canon postestimation} {hline 2}}Postestimation tools for
canon{p_end}
{p2col:}({mansection MV canonpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after 
{cmd:canon}:

{synoptset 21}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb canon postestimation##estatcorr:estat correlations}}show
correlation matrices{p_end}
{synopt :{helpb canon postestimation##estatload:estat loadings}}show loading
matrices{p_end}
{synopt :{helpb canon postestimation##estatrota:estat rotate}}rotate raw
coefficients, standard coefficients, or loading matrices{p_end}
{synopt :{helpb canon postestimation##estatrotc:estat rotatecompare}}compare rotated and unrotated coefficients or loadings{p_end}
{synopt :{helpb screeplot}}plot canonical correlations{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 21}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_nlcom
{synopt :{helpb canon postestimation##predict:predict}}predictions,
residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV canonpostestimationRemarksandexamples:Remarks and examples}

        {mansection MV canonpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin}
{cmd:,} {it:statistic}* [{opt c:orrelation(#)}]

{synoptset 21 tabbed}{...}
{synopthdr :statistic*}
{synoptline}
{syntab :Main}
{synopt :{cmd:u}}calculate linear combination of {it:{help varlist:varlist1}}
{p_end}
{synopt :{cmd:v}}calculate linear combination of {it:{help varlist:varlist2}}
{p_end}
{synopt :{cmd:stdu}}calculate standard error of the linear combination of 
{it:{help varlist:varlist1}}{p_end}
{synopt :{cmd:stdv}}calculate standard error of the linear combination of 
{it:{help varlist:varlist2}}{p_end}
{synoptline}
{phang}* There is no default statistic; you must specify one {it:statistic} from
the list.{p_end}
{phang}These statistics are available both in and out of sample; type
{cmd:predict} {it:...} {cmd:if e(sample)} {it:...} if wanted only for the
estimation sample.{p_end}
{p2colreset}{...}


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear combinations and their standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{cmd:u} and {cmd:v} calculate the linear combinations of
{it:{help varlist:varlist1}}
and {it:varlist2}, respectively.  For the first canonical correlation, 
{cmd:u} and {cmd:v} are the linear combinations having maximal
correlation.  For the second canonical correlation, specified in {cmd:predict}
with the {cmd:correlation(2)} option, {cmd:u} and
{cmd:v} have maximal correlation subject to the constraints that {cmd:u} is
orthogonal to the {cmd:u} from the first canonical correlation,
and {cmd:v} is orthogonal to the {cmd:v} from the first canonical
correlation.  The third and higher correlations are defined similarly.
Canonical correlations may be chosen either with the {cmd:lc()} option
to {cmd:canon} or by specifying the {cmd:correlation()} option to 
{cmd:predict}. 

{phang}{cmd:stdu} and {cmd:stdv} calculate the standard errors of the
respective linear combinations.

{phang}{cmd:correlation(}{it:#}{cmd:)} specifies the canonical correlation 
for which the requested statistic is to be computed.  The default
is {cmd:correlation(1)}.  If the {cmd:lc()} option to {cmd:canon} was used to
calculate a particular canonical correlation, then only this canonical
correlation is in the estimation results.  You can obtain estimates for it by
either specifying {cmd:correlation(1)} or by omitting the {cmd:correlation()}
option.


{marker syntax_estat}{...}
{title:Syntax for estat}

{marker estatcorr}{...}
{pstd}
Display the correlation matrices

{p 8 14 2}
{cmd:estat} {opt cor:relation} [, {opth f:ormat(%fmt)}]


{marker estatload}{...}
{pstd}
Display the canonical loadings

{p 8 14 2}
{cmd:estat} {opt loa:dings} [, {opth f:ormat(%fmt)}]


{marker estatrota}{...}
{pstd}
Perform orthogonal varimax rotation 

{p 8 14 2}
{cmd:estat} {opt rot:ate} [, {opt r:awcoefs} {opt s:tdcoefs} {opt l:oadings}
{opth f:ormat(%fmt)}]


{marker estatrotc}{...}
{pstd}
Display the rotated and unrotated coefficients or loadings

{p 8 14 2}
{cmd:estat} {opt rotatec:ompare} [, {opth f:ormat(%fmt)}]


INCLUDE help menu_estat


{marker desc_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat correlations} displays the correlation matrices calculated
by {cmd:canon} for {it:{help varlist:varlist1}} and {it:varlist2} and between
the two lists.

{pstd}
{cmd:estat loadings} displays the canonical loadings computed by {cmd:canon}.

{pstd}
{cmd:estat rotate} performs orthogonal varimax rotation of the raw
coefficients, standard coefficients, or canonical loadings.
Rotation is calculated on the canonical loadings regardless of which
coefficients or loadings are actually rotated.

{pstd}
{cmd:estat rotatecompare} displays the rotated and unrotated coefficients or
loadings and the most recently rotated coefficients or loadings.  This
command may be used only if {cmd:estat rotate} has been performed first.


{marker options_estat}{...}
{title:Options for estat}

{phang} 
{opt format(%fmt)} specifies the display format for numbers in 
matrices; see {manhelp format D}.  {cmd:format(%8.4f)} is the default.

{phang}
{opt rawcoefs}, an option for {cmd:estat rotate}, requests the rotation
of raw coefficients.  It is the default.

{phang}
{opt stdcoefs}, an option for {cmd:estat rotate}, requests the rotation
of standardized coefficients.

{phang}
{opt loadings}, an option for {cmd:estat rotate}, requests the rotation
of the canonical loadings.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. canon (mpg price weight) (length trunk turn)}{p_end}

{pstd}Show loading matrices{p_end}
{phang2}{cmd:. estat loadings}{p_end}

{pstd}Show correlation matrices{p_end}
{phang2}{cmd:. estat corr}{p_end}

{pstd}First and second linear combinations of first varlist{p_end}
{phang2}{cmd:. predict u1, u corr(1)}{p_end}
{phang2}{cmd:. predict u2, u corr(2)}{p_end}

{pstd}Rotate standardized coefficients{p_end}
{phang2}{cmd:. estat rotate, stdcoefs}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat correlations} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(corr_var1)}}correlations for {it:varlist_1}{p_end}
{synopt:{cmd:r(corr_var2)}}correlations for {it:varlist_2}{p_end}
{synopt:{cmd:r(corr_mixed)}}correlations between {it:varlist_1} and {it:varlist_2}{p_end}

{pstd}
{cmd:estat loadings} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(canload11)}}canonical loadings for {it:varlist_1}{p_end}
{synopt:{cmd:r(canload22)}}canonical loadings for {it:varlist_2}{p_end}
{synopt:{cmd:r(canload21)}}correlations between {it:varlist_2} and the
canonical variates for {it:varlist_1}{p_end}
{synopt:{cmd:r(canload12)}}correlations between {it:varlist_1} and the
canonical variates for {it:varlist_2}{p_end}
{p2colreset}{...}

{pstd}
{cmd:estat rotate} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(coefficients)}}coefficients rotated{p_end}
{synopt:{cmd:r(class)}}rotation classification{p_end}
{synopt:{cmd:r(criterion)}}rotation criterion{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(AT)}}rotated coefficient matrix{p_end}
{synopt:{cmd:r(T)}}rotation matrix{p_end}
{p2colreset}{...}
