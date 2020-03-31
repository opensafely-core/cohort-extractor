{smcl}
{* *! version 1.3.12  18sep2018}{...}
{vieweralsosee "[P] program properties" "mansection P programproperties"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "[R] nestreg" "help nestreg"}{...}
{vieweralsosee "[R] stepwise" "help stepwise"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{viewerjumpto "Description" "program_properties##description"}{...}
{viewerjumpto "Links to PDF documentation" "program_properties##linkspdf"}{...}
{viewerjumpto "Option" "program_properties##option"}{...}
{viewerjumpto "Remarks" "program_properties##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[P] program properties} {hline 2}}Properties of user-defined programs{p_end}
{p2col:}({mansection P programproperties:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
User-defined programs can have properties associated with them.  Some of
Stata's prefix commands -- such as {cmd:svy} and {cmd:stepwise} -- use these
properties for command validation.  You can associate program properties with
programs by using the {opt properties()} option of {opt program}.

{p 8 25 2}
{cmdab:pr:ogram}
[{cmdab:de:fine}]
	{it:command}
	[{cmd:,}
		{opt prop:erties(namelist)}
		...]{p_end}
               {cmd://} {it:body of the program}

        {cmd:end}

{pstd}
You can retrieve program properties of {it:command} by using the
{cmd:properties} macro function.

{p 8 24 2}
{cmdab:gl:obal} {it:mname} {cmd::} {cmd:properties} {it:command}

{p 8 24 2}
{cmdab:loc:al} {it:lclname} {cmd::} {cmd:properties} {it:command}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P programpropertiesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt properties(namelist)} states that {it:command} has the specified
properties.  {it:namelist} may contain up to 80 characters, including
separating spaces.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help program_properties##nestreg:Writing programs for use with nestreg and stepwise}
	{help program_properties##svy:Writing programs for use with svy}
	{help program_properties##mi:Writing programs for use with mi}
	{help program_properties##st:Properties for survival-analysis commands}
	{help program_properties##eform:Properties for exponentiating coefficients}
	{help program_properties##together:Putting it all together}
	{help program_properties##macro:Checking for program properties}


{marker nestreg}{...}
{title:Writing programs for use with nestreg and stepwise}

{pstd}
Some of Stata's estimation commands can be used with the {cmd:nestreg}
and {cmd:stepwise} prefix commands; see {helpb nestreg:[R] nestreg}
and {helpb stepwise:[R] stepwise}.  For example, the syntax diagram for the
{cmd:regress} command could be presented as

{p 16 33 2}
[{cmd:nestreg,} ...{cmd::}]  {cmdab:reg:ress} ...

{pstd}
or

{p 16 33 2}
[{cmd:stepwise,} ...{cmd::}]  {cmdab:reg:ress} ...

{pstd}In general, the syntax for these prefix commands is

{p 16 31 2}
{it:prefix_command}
[{cmd:,} {it:prefix_options}]
	{cmd::} {it:command}
	{depvar}
	{opth (varlist)}
	[{opth (varlist)} ...]
	{ifin}
	[{cmd:,} {it:options}]

{pstd}
where {it:prefix_command} is either {cmd:nestreg} or {cmd:stepwise}.

{pstd}
You must follow some additional programming requirements to write programs
(ado-files) that can be used with the {cmd:nestreg} and {cmd:stepwise} prefix
commands.  Some theoretical requirements must be satisfied to justify
using {cmd:nestreg} or {cmd:stepwise} with a given command.

{phang}
o  {it:command} must be {cmd:eclass} and accept the standard estimation
syntax; see {manhelp program P}, {manhelp syntax P}, and {manhelp mark P}.

{p 16 24 2}
{it:command} {varlist} {ifin} {weight} [{cmd:,} {it:options}]

{phang}
o  {it:command} must store the model coefficients and ancillary parameters in
{cmd:e(b)} and the estimation sample size in {cmd:e(N)}, and it
must identify the estimation subsample in {cmd:e(sample)}; see
{manhelp ereturn P}.

{phang}
o  For the likelihood-ratio test, {it:command} must have property {cmd:swml}.
For example, the program definition for {cmd:poisson} appears as

{p 16 34 2}
{cmd:program} {cmd:poisson,} ... {cmd:properties(}... {cmd:swml} ...{cmd:)}

{pmore}
{it:command} must also store the log-likelihood value in
{cmd:e(ll)} and the model degrees of freedom in {cmd:e(df_m)}.

{phang}
o  For the Wald test, {it:command} must have property {cmd:sw} if it
does not already have property {cmd:swml}.  For example, the program
definition for {cmd:qreg} appears as

{p 16 31 2}
{cmd:program} {cmd:qreg,} ...{cmd:properties(}... {cmd:sw} ...{cmd:)}

{pmore}
{it:command} must also store the variance estimates for the
coefficients and ancillary parameters in {cmd:e(V)}; see {manhelp test R}.


{marker svy}{...}
{title:Writing programs for use with svy}

{pstd}
Some of Stata's estimation commands can be used with the {cmd:svy}
prefix; see {helpb svy:[SVY] svy}.  For example, the syntax diagram for the
{cmd:regress} command could be presented as

{p 16 23 2}
[{cmd:svy:}]  {cmdab:reg:ress} ...

{pstd}
In general, the syntax for the {cmd:svy} prefix is

{p 16 20 2}
{cmd:svy} [{cmd:,} {it:svy_options}]
	{cmd::} {it:command}
	{varlist}
	{ifin}
	[{cmd:,} {it:options}]

{pstd}
You must follow some additional programming requirements to write programs
(ado-files) that can be used with the {cmd:svy} prefix.  The extra
requirements imposed by the {cmd:svy} prefix command are from the various
variance-estimation methods that it uses:
{cmd:vce(bootstrap)},
{cmd:vce(brr)},
{cmd:vce(jackknife)},
{cmd:vce(sdr)},
and {cmd:vce(linearized)}.  Each of these variance-estimation methods has
theoretical requirements that must be satisfied to justify using them
with a given command.

{phang}
o  {it:command} must be {cmd:eclass} and allow {cmd:iweight}s
and accept the standard estimation syntax; see {manhelp program P},
{helpb syntax}, and {helpb mark}.

{p 16 24 2}
{it:command} {varlist} {ifin} {weight} [{cmd:,} {it:options}]

{phang}
o  {it:command} must store the model coefficients and ancillary parameters in
{cmd:e(b)} and the estimation sample size in {cmd:e(N)}, and it
must identify the estimation subsample in {cmd:e(sample)}; see
{manhelp ereturn P}.

{phang}
o  {cmd:svy}'s {cmd:vce(bootstrap)}, {cmd:vce(brr)}, and {cmd:vce(sdr)}
require that {it:command} have {cmd:svyb} as a property.  For example, the
program definition for {cmd:regress} appears as

{p 16 35 2}
{cmd:program} {cmd:regress,} ... {cmd:properties(}... {cmd:svyb} ...{cmd:)}

{phang}
o  {cmd:vce(jackknife)} requires that {it:command} have {cmd:svyj} as a
property.

{phang}
o  {cmd:vce(linearized)} has the following requirements:

{phang2}
a.  {it:command} must have {cmd:svyr} as a property.

{phang2}
b.  {cmd:predict} after {it:command} must be able to generate scores with the
following syntax:

{p 16 24 2}
{cmd:predict} {dtype} {it:{help newvarlist##stub*:stub}}{cmd:*} {ifin}{cmd:,} {opt sc:ores}

{pmore2}
This syntax implies that estimation results with k equations will cause 
{cmd:predict} to generate k new equation-level score variables.  These new
equation-level score variables are {it:stub}{cmd:_1} for the first equation,
{it:stub}{cmd:_2} for the second equation, ..., and {it:stub}{cmd:_}k
for the last equation.  Actually {cmd:svy} does not strictly require that
these new variables be named this way, but this is a good convention
to follow.

{pmore2}
The equation-level score variables generated by {cmd:predict}  must be of the
form that can be used to estimate the variance using Taylor linearization
(otherwise known as the delta method); see 
{manlink SVY Variance estimation}

{phang2}
c.  {it:command} must store the model-based variance estimator for the
coefficients and ancillary parameters in {cmd:e(V)}; see
{manlink SVY Variance estimation}.


{marker mi}{...}
{title:Writing programs for use with mi}

{pstd}
Stata's {cmd:mi} suite of commands provides multiple imputation to provide
better estimates of parameters and their standard errors in the presence of
missing values;  see {bf:{help mi:[MI] Intro}}.  Estimation commands 
intended for use with the {cmd:mi} {cmd:estimate} prefix (see
{manhelp mi_estimate MI:mi estimate}) must 
have property {cmd:mi}, indicating that the command meets the following
requirements:

{phang}
o  The command is {cmd:eclass}.

{phang}
o  The command stores its name in {cmd:e(cmd)}.

{phang}
o The command stores the model coefficients and ancillary parameters in
  {cmd:e(b)}, stores the corresponding variance matrix in {cmd:e(V)}, 
  stores the estimation sample size in {cmd:e(N)}, and identifies the estimation
  subsample in {cmd:e(sample)}.

{phang}
o The command stores the number of ancillary parameters in {cmd:e(k_aux)}.
  This information is used for the model F test, which is reported by 
  {cmd:mi estimate} when the command stores model degrees of freedom in
  {cmd:e(df_m)}.

{phang}
o If the command employs a small-sample adjustment for tests of
  coefficients and reports of confidence intervals, the command stores the
  numerator (residual) degrees of freedom in {cmd:e(df_r)}.

{phang}
o  Because {cmd:mi} {cmd:estimate} uses its own routines to display 
   the output, to ensure that results display well the command also 
   stores its title in {cmd:e(title)}.  {cmd:mi} {cmd:estimate} also 
   uses macros {cmd:e(vcetype)} or {cmd:e(vce)} to label the 
   within-imputation variance, but those macros are usually set 
   automatically by other Stata routines.


{marker st}{...}
{title:Properties for survival-analysis commands}

{pstd}
Stata's st suite of commands have the {cmd:st} program property, indicating
that they have the following characteristics:

{phang}
o The command should only be run on data that have been previously {cmd:stset};
see {manhelp stset ST}.

{phang}
o No dependent variable is specified when calling that command.  All
variables in {it:varlist} are regressors.  The "dependent" variable is
time of failure, handled by {cmd:stset}.

{phang}
o Weights are not specified with the command but instead obtained
from {cmd:stset}.

{phang}
o If robust or replication-based standard errors are requested, the
default level of clustering is according to the ID variable that was
{cmd:stset}, if any.


{marker eform}{...}
{title:Properties for exponentiating coefficients}

{pstd}
Stata has several prefix commands -- such as {cmd:bootstrap},
{cmd:jackknife}, and {cmd:svy} -- that use alternative
variance-estimation techniques for existing commands.  These prefix commands
behave like conventional Stata estimation commands when reporting and saving
estimation results.  Given the appropriate properties, these prefix commands
can even report exponentiated coefficients.  In fact, the property names for
the various shortcuts for the {cmd:eform()} option are the same as the option
names:

{p2colset 9 28 30 2}{...}
{p2col :{it:option}/{it:property}}Description{p_end}
{p2line}
{p2col :{cmd:hr}}hazard ratio{p_end}
{p2col :{cmd:nohr}}coefficient instead of hazard ratio{p_end}
{p2col :{cmd:shr}}subhazard ratio{p_end}
{p2col :{cmd:noshr}}coefficient instead of subhazard ratio{p_end}
{p2col :{cmd:irr}}incidence-rate ratio{p_end}
{p2col :{cmd:or}}odds ratio{p_end}
{p2col :{cmd:rrr}}relative-risk ratio{p_end}
{p2line}
{p2colreset}{...}

{pstd}
For example, the program definition for {cmd:logit} looks something like the
following:

{p 8 22 2}
{cmd:program} {cmd:logit,} ... {cmd:properties(}... {cmd:or} ...{cmd:)}


{marker together}{...}
{title:Putting it all together}

{pstd}
{cmd:logit} can report odds ratios, works with {cmd:svy}, and works with 
{cmd:stepwise}.  The program definition for {cmd:logit} reads

{phang2}
{cmd:program logit,} ... {cmd:properties(or svyb svyj svyr swml mi)} ...


{marker macro}{...}
{title:Checking for program properties}

{pstd}
You can use the {cmd:properties} macro function to check the
properties associated with a program; see {manhelp macro P}.  For example, the
following retrieves and displays the program properties for {cmd:logit}.

{phang2}{cmd:. local logitprops : properties logit}{p_end}
{phang2}{cmd:. di "`logitprops'"}{p_end}
{phang2}{result:or svyb svyj svyr swml mi}{p_end}
