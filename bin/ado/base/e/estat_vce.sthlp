{smcl}
{* *! version 1.0.6  14may2018}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[R] estat vce" "mansection R estatvce"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat" "help estat"}{...}
{vieweralsosee "[R] estat ic" "help estat ic"}{...}
{vieweralsosee "[R] estat summarize" "help estat summarize"}{...}
{viewerjumpto "Syntax" "estat vce##syntax"}{...}
{viewerjumpto "Menu for estat" "estat vce##menu_estat"}{...}
{viewerjumpto "Description" "estat vce##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_vce##linkspdf"}{...}
{viewerjumpto "Options" "estat vce##options_estat_vce"}{...}
{viewerjumpto "Example" "estat vce##example"}{...}
{viewerjumpto "Stored results" "estat vce##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] estat vce} {hline 2}}Display covariance matrix estimates{p_end}
{p2col:}({mansection R estatvce:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

        {cmd:estat} {cmd:vce} [{cmd:,} {it:estat_vce_options}]

{marker estat_vce_options}{...}
{synoptset 21}{...}
{p2coldent:{it:estat_vce_options}}Description{p_end}
{synoptline}
{synopt:{opt cov:ariance}}display as covariance matrix; the default{p_end}
{synopt:{opt c:orrelation}}display as correlation matrix{p_end}
{synopt:{opt eq:uation(spec)}}display only specified equations{p_end}
{synopt:{opt b:lock}}display submatrices by equation{p_end}
{synopt:{opt d:iag}}display submatrices by equation; diagonal blocks
only{p_end}
{synopt:{opth f:ormat(%fmt)}}display format for covariances and
correlations{p_end}
{synopt:{opt nolin:es}}suppress lines between equations{p_end}
{synopt :{it:{help estat_vce##display_options:display_options}}}control 
           display of omitted variables and base and empty cells{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{opt estat vce} displays the covariance or correlation matrix of the parameter
estimates of the previous model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estatvceQuickstart:Quick start}

        {mansection R estatvceRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_estat_vce}{...}
{title:Options}

{phang}
{opt covariance} displays the matrix as a variance{c -}covariance matrix; this
is the default.

{phang}
{opt correlation} displays the matrix as a correlation matrix rather than a
variance-covariance matrix.  {opt rho} is a synonym.

{phang}
{opt equation(spec)} selects part of the VCE to be displayed.  If {it:spec} is 
{it:eqlist}, the VCE for the listed equations is displayed.  If {it:spec} is 
{it:eqlist1} {cmd:\} {it:eqlist2}, the part of the VCE associated with the
equations in {it:eqlist1} (rowwise) and {it:eqlist2} (columnwise) is
displayed.  If {it:spec} is {cmd:*}, all equations are displayed.
{opt equation()} implies {opt block} if {opt diag} is not specified.

{phang}
{opt block} displays the submatrices pertaining to distinct equations
separately.

{phang}
{opt diag} displays the diagonal submatrices pertaining to distinct equations
separately.

{phang}
{opth format(%fmt)} specifies the number format for displaying the elements of
the matrix.  The default is {cmd:format(%10.0g)} for covariances and
{cmd:format(%8.4f)} for correlations.  See {findalias frformats} for more
information.  

{phang}
{opt nolines} suppresses lines between equations.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse klein}{p_end}
{phang2}{cmd:. reg3 (consump wagep wageg) (wagep consump govt capital)}{p_end}

{pstd}Display VCE for each equation separately, using {cmd:%7.2f} format{p_end}
{phang2}{cmd:. estat vce, block format(%7.2f)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat vce} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(V)}}VCE or correlation matrix{p_end}
{p2colreset}{...}
