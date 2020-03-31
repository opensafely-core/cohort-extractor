{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _diparm" "help _diparm"}{...}
{viewerjumpto "Syntax" "_get_diparmopts##syntax"}{...}
{viewerjumpto "Description" "_get_diparmopts##description"}{...}
{viewerjumpto "Options" "_get_diparmopts##options"}{...}
{viewerjumpto "Examples" "_get_diparmopts##examples"}{...}
{title:Title}

{pstd}
{hi:[P] _get_diparmopts} {hline 2}
Parsing and display utility


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_get_diparmopts}
	[{cmd:,}
		{opt diparmopts(diparm_options)} 
		{opt exec:ute} 
		{opt bottom}
		{opt plus}
		{it:global_diparm_options}
	]

{phang2}
{cmd:_get_diparmopts} {cmd:,} {opt soptions}
	[
		{opt diparmopts(options)} 
		{opt exec:ute} 
		{opt bottom}
		{opt plus}
		{it:global_diparm_options}
	]

{pstd}
where {it:options} is any collection of options (including
{it:diparm_options}), {it:diparm_options} contains one or more of

{phang2}
{cmd:diparm(}{it:diparm_args}{cmd:)}

{pstd}
{it:diparm_args} is either "{cmd:__sep__}" or anything allowed by the
{cmd:_diparm} (see {manhelp _diparm P}) command (except the {opt level(#)}
option), and {it:global_diparm_options} is one or more of

{phang2}
{opt level(#)}
{opt dof(#)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_get_diparmopts} is a programming tool, written to help parse and display
multiple transformations of parameter estimates using the {cmd:_diparm}
utility; see {manhelp _diparm P}.

{pstd}
{cmd:_get_diparmopts} will place the supplied {it:global_diparm_options} into
each supplied {opt diparm()} option.  This makes it easier to specify the
{opt diparm()} options without having to specify a common option throughout.
If {opt dof()} is not specified, {cmd:_get_diparmopts} will use {cmd:e(df_r)}
if it contains a positive integer value.


{marker options}{...}
{title:Options}

{phang}
{opt diparmopts(options)} contains options to be parsed.  Of
particular interest are {cmd:diparm()} options, the contents of which will be
passed on to the {cmd:_diparm} utility.

{phang}
{cmd:execute}
indicates that {cmd:_get_diparmopts} execute
{cmd:_diparm} for each {cmd:diparm()} option specified in {cmd:diparmopts()},
using the order in which they appear in {cmd:diparmopts()}.  It is possible to
place separator lines by supplying {cmd:diparm(__sep__)}.

{pmore}
By default (when {cmd:execute} is not specified), {cmd:_get_diparmopts} will
only check the syntax, returning the {cmd:diparm()} options in {cmd:s(diparm)}
and all other options in {cmd:s(options)}.

{phang}
{cmd:soptions} indicates that {cmd:_get_diparmopts} allow other options beside
{cmd:diparm()} within {cmd:diparmopts()}, and will place them in
{cmd:s(options)}.  {cmd:soptions} is ignored when the {cmd:execute} option is
supplied.

{phang}
{opt bottom} indicates that nothing more will be added to the table, so the
bottom separation line is drawn.

{phang}
{opt plus} is equivalent to placing a {cmd:diparm(__sep__)} as the last option
supplied to {opt diparmopts()}.  A bottom separation line is added to the table
with a + symbol at the position of the dividing line between variable names and
results.  This is useful if you plan on adding more output to the table.

{phang}
{it:global_diparm_options} are a subset of options allowed by {cmd:_diparm},
and when specified are added to the individually specified {opt diparm()}
options, both when parsed and executed.


{marker examples}{...}
{title:Examples}

    {cmd}. _get_diparmopts, soptions diparmopts( diparm(lnsigma)
        diparm(lnsigma, exp label("sigma")) junk )
    {txt}
    {cmd}. sreturn list

    {txt}macros:
              s(diparm) : "{res} diparm(lnsigma) diparm(lnsigma, exp label("sigma")){txt}"
             s(options) : "{res}junk{txt}"


    {cmd}. _get_diparmopts, execute diparmopts(diparm(lnsigma) diparm(lnlambda))

        {txt}/lnsigma {c |}  {res}   3          3     1.00   0.317     -2.879892    8.879892
       {txt}/lnlambda {c |}  {res}   4          4     1.00   0.317     -3.839856    11.83986
    {txt}{hline 13}{c BT}{hline 60}

    {cmd}. _get_diparmopts, execute ///
        diparmopts( diparm(lnsigma) diparm(__sep__) diparm(lnlambda) )

        {txt}/lnsigma {c |}  {res}   3          3     1.00   0.317     -2.879892    8.879892
    {txt}{hline 13}{c +}{hline 60}
       /lnlambda {c |}  {res}   4          4     1.00   0.317     -3.839856    11.83986
    {txt}{hline 13}{c BT}{hline 60}
