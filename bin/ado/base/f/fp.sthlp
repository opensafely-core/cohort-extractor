{smcl}
{* *! version 1.0.11  18feb2020}{...}
{viewerdialog fp "dialog fp"}{...}
{viewerdialog "fp generate" "dialog fp_generate"}{...}
{vieweralsosee "[R] fp" "mansection R fp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fp postestimation" "help fp postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mfp" "help mfp"}{...}
{viewerjumpto "Syntax" "fp##syntax"}{...}
{viewerjumpto "Menu" "fp##menu"}{...}
{viewerjumpto "Description" "fp##description"}{...}
{viewerjumpto "Links to PDF documentation" "fp##linkspdf"}{...}
{viewerjumpto "Options fp" "fp##options_fp"}{...}
{viewerjumpto "Options fp generate" "fp##options_fp_gen"}{...}
{viewerjumpto "Examples" "fp##examples"}{...}
{viewerjumpto "Stored results" "fp##results"}{...}
{p2colset 1 11 14 2}{...}
{p2col:{bf:[R] fp} {hline 2}}Fractional polynomial regression{p_end}
{p2col:}({mansection R fp:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
Estimation

{p 8 16 2}
{cmd:fp} {cmd:<}{it:term}{cmd:>} 
[{cmd:,} 
{it:{help fp##est_options:est_options}}]{cmd::}
{it:{help fp##est_cmd:est_cmd}} 

{marker est_cmd}{...}
{p 12 12 2}
{it:est_cmd} may be almost any estimation command that stores the {cmd:e(ll)}
result.  To confirm whether {cmd:fp} works with a specific {it:est_cmd}, see
the documentation for that {it:est_cmd}.

{p 12 12 2}
Instances of {cmd:<}{it:term}{cmd:>} (with the angle brackets) that occur
within {it:est_cmd} are replaced in {it:est_cmd} by a varlist containing
the fractional powers of the variable {it:term}.  These variables will be
named {it:term}{cmd:_1}, {it:term}{cmd:_2}, ....

{p 12 12 2}
{cmd:fp} performs {it:est_cmd} with this substitution, fitting a fractional
polynomial regression in {it:term}.

{p 12 12 2}
{it:est_cmd} in either this or the following syntax may not contain other
prefix commands; see {help prefix}.


{p 4 4 2}
Estimation (alternate syntax)

{p 8 16 2}
{cmd:fp} {cmd:<}{it:term}{cmd:>(}{varname}{cmd:)} [{cmd:,}
{it:{help fp##est_options:est_options}}]{cmd::}
{it:{help fp##est_cmd:est_cmd}}

{p 12 12 2}
Use this syntax to specify that fractional powers of {it:varname} are to be
calculated.  The fractional polynomial power variables will still be named
{it:term}{cmd:_1}, {it:term}{cmd:_2}, ....


{p 4 4 2}
Replay estimation results

{p 8 16 2}
{cmd:fp} [{cmd:,}
{it:{help fp##replay_options:replay_options}}]


{p 4 4 2}
Create specified fractional polynomial power variables

{p 8 27 2}
{cmd:fp} {opt gen:erate} 
{dtype} 
[{newvar} {cmd:=}]
{varname}{cmd:^}{cmd:(}{it:numlist}{cmd:)} 
{ifin}
[{cmd:,} {it:{help fp##gen_options:gen_options}}]


{marker est_options}{...}
{synoptset 20 tabbed}{...}
{synopthdr:est_options}
{synoptline}
{syntab:Main}

{syntab:{it:Search}}
{synopt :{opt pow:ers(# # ... #)}}{...}
   powers to be searched; default is {cmd:powers(-2 -1 -.5 0 .5 1 2 3)}{p_end}
{synopt :{opt dim:ension(#)}}{...}
   maximum degree of fractional polynomial; default is {cmd:dimension(2)}{p_end}

{syntab:{it:Or specify}}
{synopt :{opt fp(# # ... #)}}{...}
   use specified fractional polynomial

{syntab:{it:And then specify any of these options}}

{syntab:Options}
{synopt :{opt classic}}{...}
   perform automatic scaling and centering and omit comparison table{p_end}
{synopt :{opt replace}}{...}
   replace existing fractional polynomial power variables named
   {it:term}{cmd:_1}, {it:term}{cmd:_2}, ...{p_end}
{synopt :{opt all}}{...}
   generate {it:term}{cmd:_1}, {it:term}{cmd:_2}, ... in all observations; 
   default is in observations {cmd:if} {cmd:esample()}{p_end}
{synopt :{opt scal:e(#_a #_b)}}{...}
   use ({it:term}+{it:a})/{it:b}; default is to use variable term as is{p_end}
{synopt :{opt scal:e}}{...}
   specify {it:a} and {it:b} automatically{p_end}
{synopt :{opt cent:er(#_c)}}{...}
   report centered-on-{it:c} results; default is uncentered results{p_end}
{synopt :{opt cent:er}}{...}
   specify {it:c} to be the mean of (scaled) {it:term}{p_end}
{synopt :{opt zero}}{...}
   set {it:term}{cmd:_1}, {it:term}{cmd:_2}, ... to zero if (scaled)
   {it:term}<=0; default is to issue an error message{p_end}
{synopt :{opt catz:ero}}{...}
   same as {cmd:zero} and include {it:term}{cmd:_0}=({it:term}<=0) among 
   fractional polynomial power variables{p_end}

{syntab:Reporting}
{synopt :{it:replay_options}}{...}
   specify how results are displayed{p_end}
{synoptline}
{p2colreset}{...}


{marker replay_options}{...}
{synoptset 20 tabbed}{...}
{synopthdr:replay_options}
{synoptline}
{syntab:Reporting}
{synopt :{opt nocompare}}{...}
   do not display model-comparison test results{p_end}
{synopt:{it:reporting_options}}
   any options allowed by {it:est_cmd} for replaying estimation results{p_end}
{synoptline}


{marker gen_options}{...}
{synoptset 20 tabbed}{...}
{synopthdr:gen_options}
{synoptline}
{syntab:Main}
{synopt :{opt replace}}{...}
   replace existing fractional polynomial power variables named
   {it:term}{cmd:_1}, {it:term}{cmd:_2}, ...{p_end}
{synopt :{opt scal:e(#_a #_b)}}{...}
   use ({it:term}+{it:a})/{it:b}; default is to use variable term as is{p_end}
{synopt :{opt scal:e}}{...}
   specify {it:a} and {it:b} automatically{p_end}
{synopt :{opt cent:er(#_c)}}{...}
   report centered-on-{it:c} results; default is uncentered results{p_end}
{synopt :{opt cent:er}}{...}
   specify {it:c} to be the mean of (scaled) {it:term}{p_end}
{synopt :{opt zero}}{...}
   set {it:term}{cmd:_1}, {it:term}{cmd:_2}, ... to zero if (scaled)
   {it:term}<=0; default is to issue an error message{p_end}
{synopt :{opt catz:ero}}{...}
   same as {cmd:zero} and include {it:term}{cmd:_0}=({it:term}<=0) among 
   fractional polynomial power variables{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:fp}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
      {bf:Fractional polynomial regression}

    {title:fp generate}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
      {bf:Create fractional polynomial variables}


{marker description}{...}
{title:Description}

{pstd}
{opt fp} {cmd:<}{it:term}{cmd:>}{cmd::} {it:est_cmd} fits models with 
the "best"-fitting fractional polynomial substituted for
{cmd:<}{it:term}{cmd:>} wherever it appears in {it:est_cmd}.
{cmd:fp <weight>: regress mpg <weight> foreign} would fit a regression model
of {cmd:mpg} on a fractional polynomial in {cmd:weight} and (linear)
{cmd:foreign}.  

{pstd}
By specifying option {cmd:fp()}, you may set the exact powers to be used.
Otherwise, a search through all possible fractional polynomials up to the
degree set by {cmd:dimension()} with powers set by {cmd:powers()} is
performed.

{pstd}
{cmd:fp} without arguments redisplays the previous estimation results, just as
typing {it:est_cmd} would.  You can type either one.  {cmd:fp} will include a
fractional polynomial comparison table. 

{pstd}
{opt fp generate} creates fractional polynomial power variables for a given 
set of powers.  For instance, 
{cmd:fp <weight>: regress mpg <weight> foreign} might produce 
the fractional polynomial {cmd:weight}^(-2 -1) and store the 
{cmd:weight}^(-2) in {cmd:weight_1} and {cmd:weight}^(-1) in 
{cmd:weight_2}.  Typing {cmd:fp generate weight^(-2 -1)} would 
allow you to create the same variables in another dataset.

{pstd}
See {helpb mfp:[R] mfp} for multivariable fractional polynomial models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R fpQuickstart:Quick start}

        {mansection R fpRemarksandexamples:Remarks and examples}

        {mansection R fpMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_fp}{...}
{title:Options for fp}

{dlgtab:Model}

{phang}
{opt powers(# # ... #)} specifies that a search be performed and details about
the search provided.  {cmd:powers()} works with the {cmd:dimension()} option;
see below.  The default is {cmd:powers(-2  -1 -.5 0 .5 1 2 3)}.

{phang}
{opt dimension(#)} specifies the maximum degree of the fractional polynomial
to be searched.  The default is {cmd:dimension(2)}.

{pmore}
If the defaults for both {cmd:powers()} and {cmd:dimension()} are used,
then the fractional polynomial could be any of the following 44 possibilities:

            {it:term}^(-2)
            {it:term}^(-1)
	    .
	    .
            .
            {it:term}^(3)
            {it:term}^(-2), {it:term}^(-2)
            {it:term}^(-2), {it:term}^(-1)
            .
            .
            .
            {it:term}^(-2), {it:term}^(3)
            {it:term}^(-1), {it:term}^(-2)
            .
            .
            .
            {it:term}^(3), {it:term}^(3)
	    
{phang}
{opt fp(# # ... #)} specifies that no search be performed and that the
fractional polynomial specified be used.  {cmd:fp()} is an alternative to
{cmd:powers()} and {cmd:dimension()}.

{dlgtab:Options}

{phang}
{opt classic} performs automatic scaling and centering and omits the
comparison table.  Specifying {opt classic} is equivalent to specifying
{cmd:scale}, {cmd:center}, and {cmd:nocompare}.

{phang}
{opt replace} replaces existing fractional polynomial power variables named
{it:term}{cmd:_1}, {it:term}{cmd:_2}, ....

{phang}
{opt all} specifies that {it:term}{cmd:_1}, {it:term}{cmd:_2}, ... be filled
in for all observations in the dataset rather than just for those in
{cmd:e(sample)}.

{phang}
{opt scale(#_a #_b)} specifies that {it:term} be scaled in the way specified,
namely, that ({it:term}+{it:a})/{it:b} be calculated.  All values of the scaled
term are required to be greater than zero unless you specify options
{cmd:zero} or {cmd:catzero}.  Values should not be too large or too close to
zero, because by default, cubic powers and squared reciprocal powers will be
considered.  When {opt scale(a b)} is specified, values in the variable
{it:term} are not modified; {cmd:fp} merely remembers to scale the values
whenever powers are calculated. 

{pmore}
You will probably not use {opt scale(a b)} for values of {it:a} and {it:b} that
you create yourself, although you could.  It is usually easier just to
{cmd:generate} a scaled variable.  For instance, if {it:term} is {cmd:age}, and
{cmd:age} in your data is required to be greater than or equal to 20, you
might generate an {cmd:age5} variable, for use as {it:term}:

		. {cmd:generate age5 = (age-19)/5}

{pmore}
{opt scale(a b)} is useful when you previously fit a model using automatic
scaling (option {cmd:scale}) in one dataset and now want to create the
fractional polynomials in another.  In the first dataset, {cmd:fp} with
{cmd:scale} added {cmd:notes} to the dataset concerning the values of {it:a}
and {it:b}.  You can see them by typing 

		. {cmd:notes} 

{pmore}
You can then use {cmd:fp generate, scale(}{it:a b}{cmd:)} in the second
dataset.

{pmore}
The default is to use {it:term} as it is used in calculating fractional
powers; thus, {it:term}'s values are required to be greater than zero unless
you specify options {cmd:zero} or {cmd:catzero}.  Values should not be too
large, because by default, cubic powers will be considered.

{marker scale}{...}
{phang}
{opt scale} specifies that {it:term} be scaled to be greater than zero and not
too large in calculating fractional powers.  See
{mansection R fpRemarksandexamplesScaling:{it:Scaling}}
under {it:Remarks} of {bf:[R] fp} for more details.  When {cmd:scale} is
specified, values in the variable {it:term} are not modified; {cmd:fp} merely
remembers to scale the values whenever powers are calculated. 

{phang}
{opt center(#_c)} reports results for the fractional polynomial in (scaled)
{it:term}, centered on {it:c}.  The default is to perform no centering.

{pmore}
{it:term}^({it:p_1}, {it:p_2}, ..., {it:p_m})-{it:c}^({it:p_1}, {it:p_2},
..., {it:p_m}) is reported.  This makes the constant coefficient
(intercept) easier to interpret.  See
{mansection R fpRemarksandexamplesCentering:{it:Centering}}
under {it:Remarks} of {bf:[R] fp} for more details.

{phang}
{opt center} performs {opt center(c)}, where {it:c} is the mean of (scaled)
{it:term}.

{phang}
{opt zero} and {opt catzero} specify how nonpositive values of {it:term} are
to be handled.  By default, nonpositive values of {it:term} are not allowed,
because we will be calculating natural logarithms and fractional powers of
{it:term}.  Thus, an error message is issued.

{phang2}
{opt zero} sets the fractional polynomial value to zero for nonpositive values
of (scaled) {it:term}.

{phang2}
{opt catzero} sets the fractional polynomial value to zero for nonpositive
values of (scaled) {it:term} and includes a dummy variable indicating where
nonpositive values of (scaled) {it:term} appear in the model.

{dlgtab:Reporting}

{phang}
{opt nocompare} suppresses display of the comparison tests.

{phang}
{it:reporting_options} are any options allowed by {it:est_cmd} for replaying
estimation results.


{marker options_fp_gen}{...}
{title:Options for fp generate}

{dlgtab:Main}

{phang}
{opt replace} replaces existing fractional polynomial power variables named
{it:term}{cmd:_1}, {it:term}{cmd:_2}, ....

{phang}
{opt scale(#_a #_b)} specifies that {it:term} be scaled in the way specified,
namely, that ({it:term}+{it:a})/{it:b} be calculated.  All values of the scaled
term are required to be greater than zero unless you specify options
{cmd:zero} or {cmd:catzero}.  Values should not be too large or too close to
zero, because by default, cubic powers and squared reciprocal powers will be
considered.  When {opt scale(a b)} is specified, values in the variable
{it:term} are not modified; {cmd:fp} merely remembers to scale the values
whenever powers are calculated. 

{pmore}
You will probably not use {opt scale(a b)} for values of {it:a} and {it:b} that
you create yourself, although you could.  It is usually easier just to
{cmd:generate} a scaled variable.  For instance, if {it:term} is {cmd:age}, and
{cmd:age} in your data is required to be greater than or equal to 20, you
might generate an {cmd:age5} variable, for use as {it:term}:

		. {cmd:generate age5 = (age-19)/5}

{pmore}
{opt scale(a b)} is useful when you previously fit a model using automatic
scaling (option {cmd:scale}) in one dataset and now want to create the
fractional polynomials in another.  In the first dataset, {cmd:fp} with
{cmd:scale} added {cmd:notes} to the dataset concerning the values of {it:a}
and {it:b}.  You can see them by typing 

		. {cmd:notes} 

{pmore}
You can then use {cmd:fp generate, scale(}{it:a b}{cmd:)} in the second
dataset.

{pmore}
The default is to use {it:term} as it is used in calculating fractional
powers; thus, {it:term}'s values are required to be greater than zero unless
you specify options {cmd:zero} or {cmd:catzero}.  Values should not be too
large, because by default, cubic powers will be considered.

{marker scale}{...}
{phang}
{opt scale} specifies that {it:term} be scaled to be greater than zero and not
too large in calculating fractional powers.  See
{mansection R fpRemarksandexamplesScaling:{it:Scaling}}
under {it:Remarks} of {bf:[R] fp} for more details.  When {cmd:scale} is
specified, values in the variable {it:term} are not modified; {cmd:fp} merely
remembers to scale the values whenever powers are calculated. 

{phang}
{opt center(#_c)} reports results for the fractional polynomial in (scaled)
{it:term}, centered on {it:c}.  The default is to perform no centering.

{pmore}
{it:term}^({it:p_1}, ..., {it:p_d})-{it:c}^({it:p_1}, ..., {it:p_d}) is
reported.  This makes the constant coefficient (intercept) easier to
interpret.  See
{mansection R fpRemarksandexamplesCentering:{it:Centering}}
under {it:Remarks} of {bf:[R] fp} for more details.

{phang}
{opt center} performs {opt center(c)}, where {it:c} is the mean of (scaled)
{it:term}.

{phang}
{opt zero} and {opt catzero} specify how nonpositive values of {it:term} are
to be handled.  By default, nonpositive values of {it:term} are not allowed,
because we will be calculating natural logarithms and fractional powers of
{it:term}.  Thus, an error message is issued.

{phang2}
{opt zero} sets the fractional polynomial value to zero for nonpositive values
of (scaled) {it:term}.

{phang2}
{opt catzero} sets the fractional polynomial value to zero for nonpositive
values of (scaled) {it:term} and includes a dummy variable indicating where
nonpositive values of (scaled) {it:term} appear in the model.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse igg}{p_end}

{pstd} Fit the optimal second-degree fractional polynomial regression model {p_end}
{phang2}{cmd:. fp <age>: regress sqrtigg <age>}{p_end}

{pstd} Generate a fractional polynomial power variable, using automatic scaling
and centering{p_end}
{phang2}{cmd:. fp generate double age^(-2 2), center scale replace}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
In addition to the results that {it:est_cmd} stores, {cmd:fp} stores the following in {cmd:e()}:

{synoptset 27 tabbed}{...}
{p2col 5 27 31 2: Scalars}{p_end}
{synopt:{cmd:e(fp_dimension)}}degree of fractional polynomial{p_end}
{synopt:{cmd:e(fp_center_mean)}}value used for centering or {cmd:.}{p_end}
{synopt:{cmd:e(fp_scale_a)}}value used for scaling or {cmd:.}{p_end}
{synopt:{cmd:e(fp_scale_b)}}value used for scaling or {cmd:.}{p_end}
{synopt:{cmd:e(fp_compare_df2)}}denominator degree of freedom in F test{p_end}
{p2colreset}{...}

{synoptset 27 tabbed}{...}
{p2col 5 27 31 2: Macros}{p_end}
{synopt:{cmd:e(fp_cmd)}}{cmd:fp, search():} or {cmd:fp, powers():}{p_end}
{synopt:{cmd:e(fp_cmdline)}}full {cmd:fp} command as typed{p_end}
{synopt:{cmd:e(fp_variable)}}fractional polynomial variable{p_end}
{synopt:{cmd:e(fp_terms)}}generated {cmd:fp} variables{p_end}
{synopt:{cmd:e(fp_gen_cmdline)}}{cmd:fp generate} command to re-create {cmd:e(fp_terms)} variables{p_end}
{synopt:{cmd:e(fp_catzero)}}{cmd:catzero}, if specified{p_end}
{synopt:{cmd:e(fp_zero)}}{cmd:zero}, if specified{p_end}
{synopt:{cmd:e(fp_compare_type)}}{cmd:F} or {cmd:chi2}{p_end}
{p2colreset}{...}

{synoptset 27 tabbed}{...}
{p2col 5 27 31 2: Matrices}{p_end}
{synopt:{cmd:e(fp_fp)}}powers used in fractional polynomial{p_end}
{synopt:{cmd:e(fp_compare)}}results of model comparisons{p_end}
{synopt:{cmd:e(fp_compare_stat)}}F test statistics{p_end}
{synopt:{cmd:e(fp_compare_df1)}}numerator degree of F test{p_end}
{synopt:{cmd:e(fp_compare_fp)}}powers of comparison models{p_end}
{synopt:{cmd:e(fp_compare_length)}}encoded string for display of row titles{p_end}
{synopt:{cmd:e(fp_powers)}}powers that are searched{p_end}
{p2colreset}{...}

{pstd}
{cmd: fp generate} stores the following in {cmd:r()}:

{synoptset 27 tabbed}{...}
{p2col 5 27 31 2: Scalars}{p_end}
{synopt:{cmd:r(fp_center_mean)}}value used for centering or {cmd:.}{p_end}
{synopt:{cmd:r(fp_scale_a)}}value used for scaling or {cmd:.}{p_end}
{synopt:{cmd:r(fp_scale_b)}}value used for scaling or {cmd:.}{p_end}
{p2colreset}{...}

{synoptset 27 tabbed}{...}
{p2col 5 27 31 2: Macros}{p_end}
{synopt:{cmd:r(fp_cmdline)}}full {cmd:fp generate} command as typed{p_end}
{synopt:{cmd:r(fp_variable)}}fractional polynomial variable{p_end}
{synopt:{cmd:r(fp_terms)}}generated {cmd:fp} variables{p_end}
{synopt:{cmd:r(fp_catzero)}}{cmd:catzero}, if specified{p_end}
{synopt:{cmd:r(fp_zero)}}{cmd:zero}, if specified{p_end}
{p2colreset}{...}

{synoptset 27 tabbed}{...}
{p2col 5 27 31 2: Matrices}{p_end}
{synopt:{cmd:r(fp_fp)}}powers used in fractional polynomial{p_end}
{p2colreset}{...}
