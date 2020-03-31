{smcl}
{* *! version 1.0.5  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _predict" "help _predict"}{...}
{vieweralsosee "[R] predict" "help predict"}{...}
{viewerjumpto "Example" "_pred_se##example"}{...}
{viewerjumpto "Description" "_pred_se##description"}{...}
{title:Title}

{p 4 22 2}
{hi:[P] _pred_se} {hline 2} Subroutine for programming single-equation
extensions to predict


{marker example}{...}
{title:Example}

	{cmd:program define} {it:estimator}{cmd:, eclass}
		{it:...}
		{cmd:ereturn local predict "}{it:estimator_p}{cmd:"}
		{it:...}
	{cmd:end}

	{it:...}

	{cmd:program define} {it:estimator_p}
		{cmd:local myopts "}{it:new_predict_options}{cmd:"}
		{cmd:_pred_se "`myopts'" `0'}
		{cmd:if `s(done)' {c -(} exit {c )-}}
		{cmd:local vtyp `s(typ)'}
		{cmd:local varn `s(varn)'}
		{cmd:local 0    `"`s(rest)'"'}
		{cmd:syntax [if] [in] [, `myopts' noOFFset]}
		{it:...}
	{cmd:end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_pred_se} is a subroutine to assist programmers in implementing
additions to {cmd:predict} following a single-equation estimation command or,
more correctly, what appears to the user to be a single-equation estimation
command even if, in the implementation, you used multiple equations to handle
ancillary parameters.

{pstd}
This is necessary only if you want to add features to {cmd:predict}
following your estimation command.  If all you want are the standard
{cmd:predict} features -- see {manhelp predict R} -- there is nothing
you need to do; do not even define {cmd:e(predict)} in your estimation
command.

{pstd}
If you do wish to add features, then your estimation command must set the
name of your prediction routine in {cmd:e(predict)}.  We recommend that if
your estimation command is {it:X}, you name your prediction routine
{it:X}{cmd:_p}, truncating the {it:X} name if needed to fit within the program
naming limit.  For instance, if the estimation command were named
{hi:ematreg}, we recommend that the corresponding prediction routine be named
{hi:ematreg_p}.  At the appropriate place in the code for ematreg.ado,
include

{phang2}{cmd:ereturn local predict "ematreg_p"}

{pstd}
Above we show the outline for ematreg_p.ado.

{pstd}
{cmd:_pred_se} will handle the standard cases.  The "{it:...}" in your
prediction program is responsible for handling the default case when no
options are specified and the special case when one of the new options stored
in {cmd:`myopts'} is specified.

{pstd}
Here is how we would fill in the dots if the {cmd:predict} options we were
adding were {cmd:pr}, {cmd:rratio}, {cmd:distance}, and
{cmd:dfbeta(}{it:varname}{cmd:)} so that, following estimation, the syntax of
{cmd:predict} would be

{p 8 16 2}{cmd:predict} [{it:type}] {it:newvarname} [{cmd:if} {it:exp}]
	[{cmd:in} {it:range}] [{cmd:,} {cmd:pr} {cmdab:r:ratio}
	{cmdab:d:istance} {cmdab:dfb:eta:(}{it:varname}{cmd:)}
	{cmdab:i:ndex} {cmd:xb} {cmd:stdp} {cmdab:nooff:set} ]

{pstd}
with {cmd:pr} the default.  Note that {cmd:index}, {cmd:xb}, and {cmd:stdp}
are the standard {cmd:predict} options; our program need only be concerned with
providing code to handle the {cmd:pr}, {cmd:rratio}, {cmd:distance}, and
{cmd:dfbeta()} options.

    Our program is

	{cmd:program define} {it:...}
		{cmd:version {ccl stata_version}}
		{cmd:local myopts "PR Rratio Distance DFBeta(varname)"}
		{cmd:_pred_se "`myopts'" `0'}
		{cmd:if `s(done)' {c -(} exit {c )-}}
		{cmd:local vtyp `s(typ)'}
		{cmd:local varn `s(varn)'}
		{cmd:local 0    `"`s(rest)'"'}
		{cmd:syntax [if] [in] [, `myopts' noOFFset]}

				{txt:/* concatenate switch options together */}
		{cmd:local type "`pr'`rratio'`distanc'"}

				{txt:/* quickly process default case        */}
		{cmd:if ("`type'"=="" | "`type'"=="pr") & "`dfbeta'"=="" {c -(}}
			{cmd:if "`type'"=="" {c -(}}
				{cmd:di in gr "(option pr assumed)"}
			{cmd:{c )-}}
			{cmd:tempvar t}
			{cmd:qui _predict double `t' `if' `in', `offset'}
			{it:...}
			{cmd:gen `vtyp' `varn' =} {it:...} {cmd:`if' `in'}
			{cmd:label var `varn' "Probability of positive outcome"}
			{cmd:exit}
		{cmd:{c )-}}

				{txt:/* mark sample                         */}
		{cmd:marksample touse}

				{txt:/* handle options that take argument, if}
				   {txt:any; we have one such option        */}
		{cmd:if "`dfbeta'" != "" {c -(}}
			{cmd:if "`type'" != "" {c -(} error 198 {c )-}}
			{it:...}
			{cmd:exit}
		{cmd:{c )-}}

				{txt:/* handle switch options               */}
				{txt:/* first do the ones that work both    */}
				{txt:/* in and out-of-sample.               */}
		{cmd:if "`type'"=="rratio" {c -(}}
			{cmd:tempvar t} {it:...}
			{cmd:qui _predict double `t' if `touse',  stdp `offset'}
			{it:...}
			{cmd:gen `vtyp' `varn' =} {it:...} {cmd:if `touse'}
			{cmd:label var `varn' "R-metric ratio"}
			{cmd:exit}
		{cmd:{c )-}}

				{txt:/* then handle the options that only   */}
				{txt:/* make sense when used with the       */}
				{txt:/* estimation subsample                */}

		{cmd:qui replace `touse'=0 if ~e(sample)}

		{cmd:if "`typ'"=="distance" {c -(}}  {txt:/* restricted to e(sample)     */}
			{cmd:tempvar r t} {it:...}
			{cmd:qui predict double `r' if `touse', rratio `offset'}
			{cmd:qui _predict double `t' if `touse', stdp `offset'}
			{it:...}
			{cmd:gen `vtyp' `varn' =} {it:...} {cmd:if `touse'}
			{cmd:label var `varn' "Distance from centroids"}
			{cmd:exit}
		{cmd:{c )-}}

		{cmd:error 198}
	{cmd:end}

{pstd}
In reviewing this program, please note the following:

{phang2}1.  All intermediate calculations are made using {help double}s.

{phang2}2.  {helpb _predict} is used to assist in the calculations.

{phang2}3.  We call {cmd:predict} itself, and thus recursively call our
program, in implementing option {cmd:distance}.

{phang2}4.  Caution is exercised to ensure that the {cmd:nooffset}
option is handled correctly (or rather, that offsets, if they exist, are
handled correctly).

{phang2}5.  Caution is exercised to ensure that the user sees the message
"___ missing values generated" if any of the predictions are missing.
This we accomplish by ending each calculation with a {helpb generate}.

{phang2}6.  The new variable is labeled after creation.
{p_end}
