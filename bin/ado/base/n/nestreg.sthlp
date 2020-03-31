{smcl}
{* *! version 1.2.17  08oct2019}{...}
{viewerdialog nestreg "dialog nestreg"}{...}
{vieweralsosee "[R] nestreg" "mansection R nestreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] program properties" "help program_properties"}{...}
{viewerjumpto "Syntax" "nestreg##syntax"}{...}
{viewerjumpto "Menu" "nestreg##menu"}{...}
{viewerjumpto "Description" "nestreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "nestreg##linkspdf"}{...}
{viewerjumpto "Options" "nestreg##options"}{...}
{viewerjumpto "Remarks/Examples" "nestreg##remarks"}{...}
{viewerjumpto "Stored results" "nestreg##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] nestreg} {hline 2}}Nested model statistics{p_end}
{p2col:}({mansection R nestreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Standard estimation command syntax

{p 8 31 2}
{cmd:nestreg}
	[{cmd:,}
		{it:options}
	] {cmd::} {it:{help nestreg##cmd_name:command_name}}
	{depvar} {opth (varlist)} [{opth (varlist)} ...] {ifin}
        [{it:{help nestreg##weight:weight}}]
	[{cmd:,} {it:command_options}]


{pstd}
Survey estimation command syntax

{p 8 31 2}
{cmd:nestreg}
	[{cmd:,}
		{it:options}] {cmd::} {cmd:svy}
          [{it:{help svy##svy_vcetype:vcetype}}] [{cmd:,}
           {it:{help svy##svy_options:svy_options}}]
        {cmd::} {it:{help nestreg##cmd_name:command_name}}
	{depvar} {opth (varlist)} [{opth (varlist)} ...] {ifin}
	[{cmd:,} {it:command_options}]


{synoptset 15 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Reporting}
{synopt:{opt wald:table}}report Wald test results; the default{p_end}
{synopt:{opt lr:table}}report likelihood-ratio test results{p_end}
{synopt:{opt qui:etly}}suppress any output from
      {it:{help nestreg##cmd_name:command_name}}{p_end}
{synopt:{opt store(stub)}}store nested estimation results in 
             {cmd:_est_}{it:stub#}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:by} is allowed; see {help prefix}.
{p_end}
{marker weight}{...}
{p 4 6 2}
Weights are allowed if {it:command_name} allows them; see {help weight}.
{p_end}
{p 4 6 2}
A {it:varlist} in parentheses indicates that this list of variables is
to be considered as a block.  Each variable in a {it:varlist} not bound in
parentheses will be treated as its own block.
{p_end}
{p 4 6 2}
All postestimation commands behave as they would after {it:command_name}
without the {opt nestreg} prefix; see the postestimation manual entry for
{it:command_name}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Other > Nested model statistics}


{marker description}{...}
{title:Description}

{pstd}
{opt nestreg} fits nested models by sequentially adding blocks of variables
and then reports comparison tests between the nested models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R nestregQuickstart:Quick start}

        {mansection R nestregRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Reporting}

{phang}
{opt waldtable} specifies that the table of Wald test results be reported.
{opt waldtable} is the default.

{phang}
{opt lrtable} specifies that the table of likelihood-ratio tests be reported.
This option is not allowed if {helpb weights:pweight}s, the
{cmd:vce(robust)} option, or the 
{cmd:vce(cluster} {it:clustvar}{cmd:)} option is specified.  {opt lrtable}
is also not allowed with the {helpb svy} prefix.

{phang}
{opt quietly} suppresses the display of any output from
{it:{help nestreg##cmd_name:command_name}}.

{phang}
{opt store(stub)} specifies that each model fit by {cmd:nestreg} be
stored under the name {cmd:_est_}{it:stub#}, where {it:#} is the nesting order
from first to last.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

{pmore2}
{help nestreg##nestreg:Estimation commands}{break}
{help nestreg##wald:Wald tests}{break}
{help nestreg##lr:Likelihood-ratio tests}{break}
{help nestreg##programming:Programming for nestreg}


{marker nestreg}{...}
{title:Estimation commands}

{pstd}
{cmd:nestreg} removes collinear predictors and observations with missing
values from the estimation sample before calling {it:command_name}.

{marker cmd_name}{...}
{pstd}
The following Stata commands are supported by {cmd:nestreg}:

{pmore}
{helpb betareg},
{helpb clogit},
{helpb cloglog},
{helpb glm},
{helpb intreg},
{helpb logistic},
{helpb logit},
{helpb nbreg},
{helpb ologit},
{helpb oprobit},
{helpb poisson},
{helpb probit},
{helpb qreg},
{helpb regress},
{helpb scobit},
{helpb stcox},
{helpb stcrreg},
{helpb stintreg},
{helpb streg}, and
{helpb tobit}

{pstd}
You do not supply a {it:depvar} for {helpb stcox}, {helpb stcrreg}, 
{helpb stintreg}, or
{helpb streg}; otherwise, {it:depvar} is required.  You must supply two
{it:depvar}s for {helpb intreg}.


{marker wald}{...}
{title:Wald tests}

{pstd}
We wish to test the significance of the following
predictors of birth rate: median age ({cmd:medage}),
median age squared ({cmd:c.medage#c.medage}, and indicators of the
census region ({cmd:i.region}).

{phang2}
{cmd:. webuse census4}
{p_end}
{phang2}
{cmd:. nestreg: regress brate (medage) (c.medage#c.medage) (i.region)}
{p_end}

{pstd}
This single call to {cmd:nestreg} ran {helpb regress} three times, adding a
block of predictors to the model for each run as in

{phang2}
{cmd:. regress brate medage}
{p_end}
{phang2}
{cmd:. regress brate medage c.medage#c.medage}
{p_end}
{phang2}
{cmd:. regress brate medage c.medage#c.medage i.region}
{p_end}

{pstd}
{cmd:nestreg} collected the F statistic for the corresponding block of
predictors and the model R-squared statistic from each model fit.

{pstd}
The F statistic for the first block, 164.72, is for a test of the
joint significance of the first block of variables; it is simply the F
statistic from the regression of {cmd:brate} on {cmd:medage}.  The F
statistic for the second block, 35.25, is for a test of the joint 
significance of the second block of variables in a regression of both 
the first and second blocks of variables.  In our example, it is an F 
test of {cmd:c.medage#c.medage} in the regression of {cmd:brate} on
{cmd:medage} and {cmd:c.medage#c.medage}.  Similarly, the third block's F
statistic of 8.85 corresponds to a joint test of the indicators for the
{cmd:N Cntrl}, {cmd:South}, and {cmd:West} regions in the final regression.


{marker lr}{...}
{title:Likelihood-ratio tests}

{pstd}
The {cmd:nestreg} command provides a simple syntax for performing
likelihood-ratio tests for nested model specifications; also see
{manhelp lrtest R}.  Using the data from the first example of {hi:[R] lrtest},
we wish to jointly test the significance of the following predictors of low
birthweight:  {cmd:age}, {cmd:lwt}, {cmd:ptl}, and {cmd:ht}.

{phang2}
{cmd:. webuse lbw}
{p_end}
{phang2}
{cmd:. nestreg, lr: logistic low (i.race smoke ui) (age lwt ptl ht)}
{p_end}

{pstd}
The estimation results from the full model are left in {cmd:e()}, so we can
later use {cmd:estat} and other postestimation commands.

{phang2}
{cmd:. estat gof}
{p_end}


{marker programming}{...}
{title:Programming for nestreg}

{pstd}
If you want your community-contributed command ({it:command_name}) to work with
{cmd:nestreg}, it must follow {help language:standard Stata syntax} and allow
the {helpb if} qualifier.  Furthermore, {it:command_name} must have {opt sw}
or {opt swml} as a program property; see
{manhelp program_properties P:program properties}.  If
{it:command_name} has {opt swml} as a property, {it:command_name} must store
the log-likelihood value in {cmd:e(ll)} and the model degrees of freedom in
{cmd:e(df_m)}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:nestreg} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{p2col :{cmd:r(wald)}}matrix corresponding to the Wald table{p_end}
{p2col :{cmd:r(lr)}}matrix corresponding to the likelihood-ratio table{p_end}
{p2colreset}{...}
