{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _coef_table" "help _coef_table"}{...}
{vieweralsosee "[P] ereturn" "help ereturn"}{...}
{viewerjumpto "Syntax" "_coef_table_header##syntax"}{...}
{viewerjumpto "Description" "_coef_table_header##description"}{...}
{viewerjumpto "Options" "_coef_table_header##options"}{...}
{viewerjumpto "Example" "_coef_table_header##example"}{...}
{title:Title}

{p2colset 5 31 33 2}{...}
{p2col:{hi:[P] _coef_table_header} {hline 2}}Automatic headers for coefficient
tables{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_coef_table_header}
	[{cmd:,}
		{opt rclass} 
		{opt noh:eader}
		{opt nomodel:test}
		{opt ti:tle(string)} 
		{opt notvar}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_coef_table_header} generates a header for a coefficient table.  It looks
at macros and scalars stored in {opt e()} for building the header.
{cmd:_coef_table_header} will automatically display a model test if
{cmd:e(df_m)} is an integer value.  {cmd:_coef_table_header} displays a
slightly more verbose header for {cmd:svy} results.


{marker options}{...}
{title:Options}

{phang}
{opt rclass} specifies that the header information is in {opt r()} instead of
{opt e()}.

{phang}
{opt noheader} causes {cmd:_coef_table_header} to exit before displaying
anything.

{phang}
{opt nomodeltest} prevents {cmd:_coef_table_header} from displaying a model
{it:F} or chi-squared test.

{phang}
{opt title(string)} specifies a title for the header.

{phang}
{opt notvar} specifies not to display time-series information in the 
header.  If {cmd:e(tvar)}, {cmd:e(tmaxs)}, and {cmd:e(tmins)} exist, then the
time-series sample range is displayed in the coefficient table header.


{marker example}{...}
{title:Example}

{pstd}{cmd:. _coef_table_header}{p_end}
