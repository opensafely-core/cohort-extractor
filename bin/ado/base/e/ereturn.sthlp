{smcl}
{* *! version 1.3.5  14may2018}{...}
{viewerdialog "ereturn list" "dialog return_list"}{...}
{vieweralsosee "[P] ereturn" "mansection P ereturn"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _estimates" "help _estimates"}{...}
{vieweralsosee "[P] return" "help return"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (estimation)" "help estcom"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (postestimation)" "help postest"}{...}
{viewerjumpto "Syntax" "ereturn##syntax"}{...}
{viewerjumpto "Description" "ereturn##description"}{...}
{viewerjumpto "Links to PDF documentation" "ereturn##linkspdf"}{...}
{viewerjumpto "Options" "ereturn##options"}{...}
{viewerjumpto "Examples" "ereturn##examples"}{...}
{viewerjumpto "Stored results" "ereturn##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] ereturn} {hline 2}}Post the estimation results{p_end}
{p2col:}({mansection P ereturn:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Set macro returned by estimation command

	{cmdab:eret:urn} {cmdab:loc:al} {it:name ...}{right:(see {manhelp macro P})  }


    Set scalar returned by estimation command

{p 8 16 2}{cmdab:eret:urn} {cmdab:sca:lar} {it:name} {cmd:=} {it:{help exp}}


    Set matrix returned by estimation command

{p 8 16 2}{cmdab:eret:urn} {cmdab:mat:rix} {it:name} [{cmd:=}] {it:matname}
	[{cmd:,} {cmd:copy}]


    Clear e() stored results

{p 8 16 2}{cmdab:eret:urn clear}


    List e() stored results

{p 8 16 2}{cmdab:eret:urn} {cmdab:li:st} [{cmd:,} {cmd:all}]


    Store coefficient vector and variance-covariance matrix into e()

{p 8 16 2}{cmdab:eret:urn post} [{it:b} [{it:V} [{it:Cns}]]]
[{it:{help ereturn##weight:weight}}]
[{cmd:,}
{cmdab:dep:name:(}{it:{help strings:string}}{cmd:)} {cmdab:o:bs:(}{it:#}{cmd:)}
{cmdab:d:of:(}{it:#}{cmd:)} {cmdab:e:sample:(}{varname}{cmd:)}
{cmdab:prop:erties:(}{it:{help strings:string}}{cmd:)}
{opt buildfv:info}
{opt findomitted}]


    Change coefficient vector and variance-covariance matrix

{p 8 16 2}{cmdab:eret:urn repost} [{cmd:b =} {it:b}] [{cmd:V =} {it:V}]
[{cmd:Cns =} {it:Cns}]
[{it:{help ereturn##weight:weight}}]
[{cmd:,} {cmdab:e:sample:(}{varname}{cmd:)}
{cmdab:prop:erties:(}{it:{help strings:string}}{cmd:)}
{opt buildfv:info}
{opt findomitted}
{cmdab:ren:ame}
{opt resize}]


    Display coefficient table

{p 8 16 2}{cmdab:eret:urn} {cmdab:di:splay} [{cmd:,}
{cmdab:ef:orm:(}{it:{help strings:string}}{cmd:)} {cmdab:f:irst}
{cmd:neq(}{it:#}{cmd:)}
{cmdab:pl:us} {cmdab:l:evel:(}{it:#}{cmd:)}
{it:{help ereturn##display_options:display_options}}]


{pstd}
where {it:name} is the name of the macro, scalar, or matrix that will be
returned in {hi:e(}{it:name}{hi:)} by the estimation program; {it:matname} is
the name of an existing matrix; {it:b} is a 1 x p coefficient vector
(matrix); {it:V} is a p x p covariance matrix; and {it:Cns} is a c x (p+1)
constraint matrix.

{marker weight}{...}
{pstd}
{cmd:fweight}s, {cmd:aweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:ereturn local}, {cmd:ereturn scalar}, and {cmd:ereturn matrix} set
{hi:e()} macros, scalars, and matrices other than {cmd:b}, {cmd:V}, and
{cmd:Cns} returned by estimation commands.  See
{manhelp return P} for more discussion on returning results.

{pstd}
{cmd:ereturn clear} clears the {hi:e()} stored results.

{pstd}
{cmd:ereturn list} lists the names and values of the macros
and scalars stored in {cmd:e()}, and the names and sizes of the matrices
stored in {cmd:e()} by the last estimation command.

{pstd}
{cmd:ereturn post} clears all existing e-class results and stores the 
coefficient vector ({cmd:b}), variance-covariance matrix ({cmd:V}),
and constraint matrix ({cmd:Cns}) in Stata's system areas, making
available all the postestimation features described in 
{help postest}.  {cmd:b}, {cmd:V}, and {cmd:Cns} are optional for
{cmd:ereturn post}; some commands (such as {helpb factor}) do not have a
{cmd:b}, {cmd:V}, or {cmd:Cns} but do set the estimation sample,
{cmd:e(sample)}, and properties, {cmd:e(properties)}.  You must use
{cmd:ereturn} {cmd:post} before setting other {cmd:e()} macros, scalars, and
matrices.

{pstd}
{cmd:ereturn repost} changes the {cmd:b}, {cmd:V}, or {cmd:Cns} matrix (allowed
only after estimation commands that posted their results with
{cmd:ereturn post}) or changes the declared estimation sample or
{cmd:e(properties)}.  The specified matrices cease to exist after {cmd:post} or
{cmd:repost}; they are moved into Stata's system areas.  The resulting {cmd:b},
{cmd:V}, and {cmd:Cns} matrices in Stata's system areas can be retrieved by
reference to {hi:e(b)}, {hi:e(V)}, and {hi:e(Cns)}.  {cmd:ereturn post} and
{cmd:repost} deal with only the coefficient and variance-covariance matrices,
whereas {cmd:ereturn matrix} is used to store other matrices associated with
the estimation command.

{pstd}
{cmd:ereturn display} displays or redisplays the coefficient table
corresponding to results that have been previously posted using
{cmd:ereturn post} or {cmd:repost}.

{pstd}
For a discussion of posting results with constraint matrices ({it:Cns} in the
syntax diagram above), see {manhelp makecns P}, but only after reading this
entry.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P ereturnRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:copy} specified with {cmd:ereturn matrix} indicates that the matrix is
to be copied; that is, the original matrix should be left in place.

{phang}
{cmd:all} specifies that hidden and historical stored results be listed along
with the usual stored results.  This option is seldom used.  See
{mansection P returnRemarksandexamplesUsinghiddenandhistoricalstoredresults:{it:Using hidden and historical stored results}}
and
{mansection P returnRemarksandexamplesProgramminghiddenandhistoricalstoredresults:{it:Programming hidden and historical stored results}}
under {it:Remarks and examples} of {bf:[P] return} for more information.
These sections are written in terms of {cmd:return list}, but everything said
there applies equally to {cmd:ereturn list}.

{phang}
{cmd:depname(}{it:{help strings:string}}{cmd:)} specified with
{cmd:ereturn post}
supplies a name that should be that of the dependent variable but can be
anything; that name is stored and added to the appropriate place on the output
whenever {cmd:ereturn display} is executed.

{phang}
{cmd:obs(}{it:#}{cmd:)} specified with {cmd:ereturn post} supplies
the number of observations on which the estimation was performed; that number
is stored in {hi:e(N)}.

{phang}
{cmd:dof(}{it:#}{cmd:)} specified with {cmd:ereturn post} supplies
the number of (denominator) degrees of freedom that is to be used with t and F
statistics and is stored in {hi:e(df_r)}.  This number is used in
calculating significance levels and confidence intervals by
{cmd:ereturn display} and by subsequent {cmd:test} commands performed on the
posted results.  If the option is not specified, normal (Z) and chi-squared
statistics are used.

{phang}
{cmd:esample(}{varname}{cmd:)} specified with {cmd:ereturn post}
or {cmd:ereturn repost} gives the name of the 0/1 variable indicating the
observations involved in the estimation.  The variable is removed from the
dataset but is available for use as {hi:e(sample)}; see
{findalias frsamp}.  If the {cmd:esample()}
option is not specified with {cmd:ereturn post}, it is set to all zeros
(meaning no estimation sample).  See {manhelp mark P} for details of the
{cmd:marksample} command that can help create {it:varname}.

{phang}
{cmd:properties(}{it:{help strings:string}}{cmd:)} specified with
{cmd:ereturn post} or
{cmd:ereturn repost} sets the {cmd:e(properties)} macro.  By default,
{cmd:e(properties)} is set to {cmd:b V} if {cmd:properties()} is not
specified.

{phang}
{opt buildfvinfo}
specified with {cmd:ereturn post} and {cmd:ereturn repost}
computes the {cmd:H} matrix that postestimation commands
{helpb contrast},
{helpb margins}, and
{helpb pwcompare} use for determining estimable functions.

{phang}
{opt findomitted}
specified with {cmd:ereturn post} and {cmd:ereturn repost}
adds the omit operator {cmd:o.} to variables in the column
names corresponding to zero-valued diagonal elements of {cmd:e(V)}.
This option is generally unnecessary but is useful when {helpb _rmcoll}
is not used before estimation.

{phang}
{cmd:rename} is allowed only with the {cmd:b =} {it:b} syntax of
{cmd:ereturn repost} and tells Stata to use the names obtained from the
specified {it:b} matrix as the labels for both the {cmd:b} and {cmd:V}
estimation matrices.  These labels are subsequently used in the output
produced by {cmd:ereturn display}.

{phang}
{cmd:resize} is allowed only with {cmd:ereturn repost} and tells Stata
that the replacements {cmd:b}, {cmd:V}, and {cmd:Cns} have a different number
of elements than the originals.  This option implies {cmd:rename}.

{phang}
{cmd:eform(}{it:{help strings:string}}{cmd:)} specified with
{cmd:ereturn display}
indicates that the exponentiated form of the coefficients is to be output and
reporting of the constant is to be suppressed.  {it:string} is used to label
the exponentiated coefficients; see {manhelpi eform_option R}.

{phang}
{cmd:first} requests that Stata display only the first equation and
make it appear as if only one equation were estimated.

{phang}
{cmd:neq(}{it:#}{cmd:)} requests that Stata display only the first
{it:#} equations and make it appear as if only {it:#} equations were
estimated.

{phang}
{cmd:plus} changes the bottom separation line produced by
{cmd:ereturn display} to have a {hi:+} symbol at the position of the
dividing line between variable names and results.  This is useful if you plan
on adding more output to the table.

{phang}
{cmd:level(}{it:#}{cmd:)}, an option of {cmd:ereturn display},
specifies the confidence level, as a percentage, of confidence intervals
for the estimated parameters; see {manhelp level R}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}
See {manlink P ereturn} for the general 
{mansection P ereturnRemarksandexamplesoutline_estcmd:outline} of
an estimation command program and for examples of {cmd:ereturn post},
{cmd:repost}, and {cmd:display}.  Within such a program you could store
{hi:e()} results using something like

{tab}{it:...}
{phang2}{cmd:ereturn local depvar "`depname'"}{p_end}
{phang2}{cmd:ereturn scalar N = `nobs'}{p_end}
{phang2}{cmd:ereturn matrix lambda lam}{p_end}
{phang2}{cmd:ereturn local cmd "myestcmd"}{p_end}
{tab}{it:...}

{pstd}The user of an estimation command would type

{phang2}{cmd:. ereturn list}

{pstd}to see what was returned from an estimation command.

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress weight length displ}

{pstd}List stored results{p_end}
{phang2}{cmd:. ereturn list}

{pstd}Access individual {cmd:e()} results{p_end}
{phang2}{cmd:. display "the adjusted R-squared is: `e(r2_a)'}{p_end}
{phang2}{cmd:. display "the residual sum-of-squares is: `e(r22)'}{p_end}
{phang2}{cmd:. matrix list e(V)}{p_end}
{phang2}{cmd:. matrix list e(b)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ereturn} {cmd:post} stores the following in {cmd:e()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_r)}}degrees of freedom, if specified{p_end}

{p2col 5 16 20 2: Macros}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(properties)}}estimation properties; typically {cmd:b V}{p_end}

{p2col 5 16 20 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{pstd}
{cmd:ereturn} {cmd:repost} stores the following in {cmd:e()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Macros}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(properties)}}estimation properties; typically {cmd:b V}{p_end}

{p2col 5 16 20 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{pstd}
With {cmd:ereturn post}, all previously
stored estimation results -- {cmd:e()} items -- are removed.
{cmd:ereturn repost},
however, does not remove previously stored estimation results.
{cmd:ereturn clear} removes the current {cmd:e()} results.
{p_end}


{pstd}
{cmd:ereturn} {cmd:display} stores the following in {cmd:r()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Scalars}{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}

{p2col 5 16 20 2: Macros}{p_end}
{synopt:{cmd:r(label}{it:#}{cmd:)}}label on the {it:#}th coefficient,
        such as {cmd:(base)}, {cmd:(omitted)}, {cmd:(empty)}, or
        {cmd:(constrained)}{p_end}
{synopt:{cmd:r(table)}}information from the coefficient table (see below){p_end}
{p2colreset}{...}


{pstd}
{cmd:r(table)} contains the following information for each coefficient:

{synoptset 16 tabbed}{...}
{synopt:{cmd:b}}coefficient value{p_end}
{synopt:{cmd:se}}standard error{p_end}
{synopt:{cmd:t/z}}test statistic for coefficient{p_end}
{synopt:{cmd:pvalue}}observed significance level for {cmd:t/z}{p_end}
{synopt:{cmd:ll}}lower limit of confidence interval{p_end}
{synopt:{cmd:ul}}upper limit of confidence interval{p_end}
{synopt:{cmd:df}}degrees of freedom associated with coefficient{p_end}
{synopt:{cmd:crit}}critical value associated with {cmd:t/z}{p_end}
{synopt:{cmd:eform}}indicator for exponentiated coefficients{p_end}
{p2colreset}{...}
