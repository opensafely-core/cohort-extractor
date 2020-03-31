{smcl}
{* *! version 1.1.5  01mar2017}{...}
{cmd:help impute}{right:dialog:  {dialog impute}{space 15}}
{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:impute} continues to work but, as of Stata 11, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {helpb mi impute} for a newer alternative to {cmd:impute}.


{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{hi:[D] impute} {hline 2}}Fill in missing values{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 15 2}
{cmd:impute}
{depvar}
{indepvars}
{ifin}
{weight}
{cmd:,}
{opt g:enerate(newvar1)}
[{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent :* {opth g:enerate(newvar:newvar1)}}generate
{it:newvar1} to contain the imputations{p_end}
{synopt :{opth nomis:sings(varlist)}}include {it:varlist} without missing values
in the best-subset regressions{p_end}
{synopt :{opt all}}estimate using all observations (regardless of {opt if} and
{opt in}){p_end}
{synopt :{opth reg:sample(exp)}}estimate using observations specified in
{it:exp}{p_end}
{synopt :{opt copy:rest}}copy out-of-sample values of dependent variable to
generated variable{p_end}
{synopt :{opth v:arp(newvar:newvar2)}}create new variable to
contain the variance of the prediction{p_end}
{synoptline}
{p 4 6 2}
* {opt generate(newvar1)} is required.{p_end}
{p 4 4 2}
{it:indepvars} and {it:varlist} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}{cmd:aweight}s and {cmd:fweight}s are allowed; see {help weight}.{p_end}


{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-creation commands >}
       {bf:Fill in missing values}


{title:Description}

{pstd}{opt impute} fills in missing values; {depvar} is the variable whose
missing values are to be imputed.  {indepvars} is the list of variables on
which the imputations are to be based, and {it:{help newvar:newvar1}} is the
new variable that contains the imputations.

{pstd}
{opt impute} organizes the cases
by patterns of missing data so that the missing-value regressions can
be conducted efficiently; this necessitates a limit of 31 variables in
{it:indepvars}.

{pstd}{opt if} {it:exp} and {opt in} {it:range}
restrict the sample in which missings are imputed
and, unless {opt regsample()} or {opt all} is specified, also the sample
used in the regressions.


{title:Options}

{dlgtab:Main}

{phang}{opth "generate(newvar:newvar1)"}
specifies the name of the new variable to be created. {opt generate()} is
required.

{phang}{opth nomissings(varlist)}
specifies the variables to include in the best-subset regressions.
This option requires that the specified variables be free of missing
values within the sample of observations used in the regressions.

{phang}{opt all}
specifies that all observations be used in the regression sample.
Thus {opt all} is equivalent to {cmd:regsample(_n<=_N)} or
{cmd:regsample(1)}.

{phang}{opth regsample(exp)}
specifies the sample used to fit regressions. Don't confuse the
{opt if} and {opt in} clauses with the {opt regsample()} option.  If
{opt regsample()} is not specified, the regression sample defaults to
all observations if {opt if} and {opt in} are not specified or to
all selected observations otherwise.

{phang}{opt copyrest}
specifies that out-of-sample values of {depvar} be copied to
the {opt generate()}-d variable.  The default is to set out-of-sample
values to missing ({opt .}).

{phang}{opth "varp(newvar:newvar2)"}
specifies the name of a new variable to contain the variance (not the
standard error) of the prediction.


{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse emd, clear}{p_end}

{pstd}Report codebook for {cmd:ln_rsales_pc} to see missing-value
information{p_end}
{phang2}{cmd:. codebook ln_rsales_pc}

{pstd}Create {cmd:i_ln_rsales_pc} containing imputed values for
{cmd:ln_rsales_pc}{p_end}
{phang2}{cmd:. impute ln_rsales_pc jantemp precip ln_income median_age hhsize,}
       {cmd:gen(i_ln_rsales_pc)}{p_end}

{pstd}Run regression using {cmd:i_ln_rsales_pc} in the model{p_end}
{phang2}{cmd:. regress ln_eat i_ln_rsales_pc jantemp precip ln_income}
       {cmd:median_age hhsize}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Perform factor analysis using variables {cmd:mpg} through
{cmd:foreign}{p_end}
{phang2}{cmd:. factor mpg-foreign}{p_end}

{pstd}Create first two common factors{p_end}
{phang2}{cmd:. predict f1 f2}{p_end}

{pstd}Report codebook for {cmd:f1} and {cmd:f2} to see missing-value
information{p_end}
{phang2}{cmd:. codebook f1 f2, mv}

{pstd}Create {cmd:i_f1} containing imputed values for {cmd:f1}{p_end}
{phang2}{cmd:. impute f1  mpg-foreign, gen(i_f1)}{p_end}

{pstd}Create {cmd:i_f2} containing imputed values for {cmd:f2}{p_end}
{phang2}{cmd:. impute f2  mpg-foreign, gen(i_f2)}{p_end}

{pstd}Run regression using {cmd:i_f1} and {cmd:i_f2} in the model{p_end}
{phang2}{cmd:. regress price i_f1 i_f2}{p_end}
    {hline}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp ipolate D},
{manhelp predict R},
{manhelp regress R}
{p_end}
