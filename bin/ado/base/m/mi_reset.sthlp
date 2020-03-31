{smcl}
{* *! version 1.0.11  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi reset" "mansection MI mireset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi update" "help mi_update"}{...}
{viewerjumpto "Syntax" "mi_reset##syntax"}{...}
{viewerjumpto "Menu" "mi_reset##menu"}{...}
{viewerjumpto "Description" "mi_reset##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_reset##linkspdf"}{...}
{viewerjumpto "Options" "mi_reset##options"}{...}
{viewerjumpto "Remarks" "mi_reset##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[MI] mi reset} {hline 2}}Reset imputed or passive variables
{p_end}
{p2col:}({mansection MI mireset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{cmd:mi} {cmd:reset} 
{varlist} 
[{bf:=} {it:{help exp}}]
[{it:{help if}}]
[{cmd:,}
{it:options}]

{synoptset 15 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{cmd:m(}{it:{help numlist}}{cmd:)}}values of {it:m} to be reset; default all{p_end}

{synopt:{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:reset} resets the imputed or passive variables specified.
Values are reset to the values in {it:m}=0, which are typically missing, 
but if you specify {cmd:=} {it:exp}, they are reset to the value specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miresetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{p 4 8 2}
{cmd:m(}{it:{help numlist}}{cmd:)} 
    specifies the values of {it:m} that are to be reset; the default is to
    update all values of {it:m}.  If {it:M} were equal to 3, the default
    would be equivalent to specifying {cmd:m(1/3)} or {cmd:m(1} {cmd:2}
    {cmd:3)}.  If you wished to update the specified variable(s) in just
    {it:m}=2, you could specify {cmd:m(2)}.

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_reset##use:Using mi reset}
	{help mi_reset##tech:Technical notes and relation to mi update}
	

{marker use}{...}
{title:Using mi reset}

{p 4 4 2}
Resetting an imputed or passive variable means setting its values in
{it:m}>0 equal to the values recorded in {it:m}=0.  For instance, if variable
{cmd:inc} were imputed, typing

	. {cmd:mi reset inc}
	(15 values reset)

{p 4 4 2}
would reset its incomplete values back to missing in all {it:m}.  In the
sample output shown, we happen to have {it:M}=5 and reset back to missing 
the three previously imputed
values in each imputation.

{p 4 4 2}
It is rare that you would want to reset an imputed variable, but one can
imagine cases.  Your coworker Joe sent you the data and just buzzed you on the
telephone.  "There is one value wrong in the data I sent you," he says.
"There is an imputed value for {cmd:inc} that is 15,000, which is obviously
absurd.  Just reset it back to missing until I find out what happened."
So you type

	. {cmd:mi reset inc if inc==15000}
	(1 value reset)

{p 4 4 2}
Later Joe calls back.  "It is a long and very stupid story," he begins, and you
can hear him settling into his chair to tell it.  As you finish your second
cup of coffee, he is wrapping up.  "So the value of {cmd:inc} for {cmd:pid}
1433 should be 0.725."  You type

	. {cmd:mi reset inc = .725 if pid=1433}
	(1 value reset)

{p 4 4 2}
It is common to need to reset passive variables if imputed values change.
For instance, you have variables {cmd:age} and {cmd:lnage} in your 
data.  You imputed {cmd:lnage}; {cmd:age} is passive.  You recently updated
the imputed values for {cmd:lnage}.  One way to update the values 
for {cmd:age} would be to type

	. {cmd:mi passive: replace age = exp(lnage)}.
	{it:m}=0:
	{it:m}=1:
	(10 real changes made)
	{it:m}=2:
	(10 real changes made)
	{it:m}=3:
	(8 real changes made)

{p 4 4 2}
Alternatively, you could type 

	. {cmd:mi reset age = exp(lnage)}
	(28 values reset)


{marker tech}{...}
{title:Technical notes and relation to mi update}

{p 4 4 2}
{cmd:mi} {cmd:reset}, used with an imputed variable, changes only the values
for which the variable contains hard missing ({cmd:.}) in {it:m}=0.  The other
values are, by definition, already equal to their {it:m}=0 values.

{p 4 4 2}
{cmd:mi} {cmd:reset}, used with a passive variable, changes only the values
in incomplete observations, observations in which any imputed variable
contains hard missing.  The other values of the passive variable are,
by definition, already equal to their {it:m}=0 values.

{p 4 4 2}
{cmd:mi} {cmd:update} can be used to ensure that values that are supposed 
to be equal to their {it:m}=0 values in fact are equal to them;
see {bf:{help mi_update:[MI] mi update}}.
{p_end}
