{smcl}
{* *! version 1.1.14  05jun2019}{...}
{viewerdialog xi "dialog xi"}{...}
{vieweralsosee "[R] xi" "mansection R xi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11.1.10 Prefix commands" "help prefix"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (estimation)" "help estcom"}{...}
{vieweralsosee "[U] 20 Estimation and postestimation commands (postestimation)" "help postest"}{...}
{viewerjumpto "Syntax" "xi##syntax"}{...}
{viewerjumpto "Menu" "xi##menu"}{...}
{viewerjumpto "Description" "xi##description"}{...}
{viewerjumpto "Links to PDF documentation" "xi##linkspdf"}{...}
{viewerjumpto "Options" "xi##options"}{...}
{viewerjumpto "Remarks" "xi##remarks"}{...}
{viewerjumpto "Examples" "xi##examples"}{...}
{viewerjumpto "Stored results" "xi##results"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] xi} {hline 2}}Interaction expansion{p_end}
{p2col:}({mansection R xi:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:xi} [{cmd:,} {opth pre:fix(strings:string)} {opt noomit}] {it:term(s)}

{p 8 14 2}
{cmd:xi} [{cmd:,} {opth pre:fix(strings:string)} {opt noomit}] {cmd::} {it:any_stata_command} 
   {it:varlist_with_terms}  {it:...}

{phang}
where a {it:term} has the form

{col 9}{cmd:i.}{it:varname}{col 39}or{col 48}{cmd:I.}{it:varname}
{col 9}{cmd:i.}{it:varname1}{cmd:*i.}{it:varname2}{col 48}{cmd:I.}{it:varname1}{cmd:*I.}{it:varname2}
{col 9}{cmd:i.}{it:varname1}{cmd:*}{it:varname3}{col 48}{cmd:I.}{it:varname1}{cmd:*}{it:varname3}
{col 9}{cmd:i.}{it:varname1}{cmd:|}{it:varname3}{col 48}{cmd:I.}{it:varname1}{cmd:|}{it:varname3}

{pstd}
{it:varname}, {it:varname1}, and {it:varname2} denote numeric or string
categorical variables.  {it:varname3} denotes a continuous, numeric variable.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-creation commands >}
        {bf:Interaction expansion}


    {c TLC}{hline 65}{c TRC}
    {c |} Most commands in Stata now allow factor variables; see          {c |}
    {c |} {help fvvarlist}. To determine if a command allows factor variables,   {c |}
    {c |} see the information printed below the options table for the     {c |}
    {c |} command.  If the command allows factor variables, it will say   {c |}
    {c |} something like "{it:indepvars} may contain factor variables."        {c |}
    {c |}								  {c |}
    {c |} We recommend that you use factor variables instead of {cmd:xi} if a   {c |}
    {c |} command allows factor variables.                                {c |}
    {c |}								  {c |}
    {c |} We include {manhelp xi R} in our documentation so that readers can      {c |}
    {c |} consult it when using a Stata command that does not allow       {c |}
    {c |} factor variables. 						  {c |}
    {c BLC}{hline 65}{c BRC}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xi} expands terms containing categorical variables into indicator
(also called dummy) variable sets by creating new variables and, in the
second syntax ({bind:{cmd:xi:} {it:any_stata_command}}), executes the
specified command with the expanded terms.  The dummy variables created are

{p 8 32 2}{cmd:i.}{it:varname}{space 15}creates dummies for categorical
variable {it:varname}

{p 8 32 2}{cmd:i.}{it:varname1}{cmd:*i.}{it:varname2}{space 3}creates dummies
for categorical variables {it:varname1} and {it:varname2}: all 
interactions and main effects

{p 8 32 2}{cmd:i.}{it:varname1}{cmd:*}{it:varname3}{space 5}creates dummies for
categorical variable {it:varname1} and continuous variable {it:varname3}: all
interactions and main effects

{p 8 32 2}{cmd:i.}{it:varname1}{cmd:|}{it:varname3}{space 5}creates dummies for
categorical variable {it:varname1} and continuous variable {it:varname3}: all
interactions and main effect of {it:varname3}, but no main effect of
{it:varname1}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R xiRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth prefix:(strings:string)} allows you to choose a prefix other than {hi:_I}
for the newly created interaction variables.  The prefix cannot be longer than
four characters.  By default, {cmd:xi} will create interaction variables
starting with {hi:_I}.  When you use {cmd:xi}, it drops all previously created
interaction variables starting with the prefix specified in the
{opt prefix(string)} option or with {hi:_I} by default.  Therefore, if you want
to keep the variables with a certain prefix, specify a different prefix in the
{opt prefix(string)} option.

{phang}
{opt noomit} prevents {cmd:xi} from omitting groups.  This option provides a
way to generate an indicator variable for every category having one or more
variables, which is useful when combined with the {opt noconstant} option of
an estimation command.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help xi##remarks1:Summary of i.{it:varname}}
        {help xi##remarks2:Summary of controlling the omitted dummy}
        {help xi##remarks3:Interpreting output}
        {help xi##remarks4:How xi names variables}
        {help xi##remarks5:xi as a command rather than a command prefix}
        {help xi##remarks6:Warnings}{...}


{marker remarks1}{...}
{title:Summary of {cmd:i.}{it:varname}}

{phang}
o  {it:varname} may be string or numeric.

{phang}
o  Indicator (dummy) variables are created automatically.

{phang}
o  By default, the dummy-variable set is identified by dropping
the dummy corresponding to the smallest value of the variable (how to specify
otherwise is discussed below).

{phang}
o  The new dummy variables are left in your dataset.  By default, the names
of the new dummy variables start with {hi:_I}; therefore, you can drop them by
typing "{hi:drop _I*}".  You do not have to do this; each time you use
{cmd:xi}, any previously created automatically generated dummies with the same
prefix as the one specified in the {cmd:prefix()} option ({hi:_I} by default)
are dropped and new ones are created.

{phang}
o  The new dummy variables have variable labels so you can
determine what they correspond to by typing "{cmd:describe}" or
"{cmd:describe _I*}"; see {manhelp describe D}.

{phang}
o  {cmd:xi} may be used with any Stata command (not just
{cmd:logistic}).


{marker remarks2}{...}
{title:Summary of controlling the omitted dummy}

{pstd}
{cmd:i.}{it:varname} omits the first group by default but if you define

{phang2}
{cmd:char _dta[omit] "prevalent"}

{pstd}
then the default behavior changes to that of dropping the most prevalent
group.  You can restore the default behavior by typing

{phang2}
{cmd:char _dta[omit]}

{pstd}
Either way, if you define a variable characteristic of the form

{phang2}
{cmd:char} {it:varname}{cmd:[omit]} {it:#}

{pstd}
or, if {it:varname} is a string,

{phang2}
{cmd:char} {it:varname}{cmd:[omit]} {cmd:"}{it:string_literal}{cmd:"}

{pstd}
then the specified value will be omitted.

    Examples:
{phang2}
{cmd:. char agegrp[omit] 1}{p_end}
{phang2}
{cmd:. char race[omit] "White"} {space 1} (for {hi:race} a string variable){p_end}
{phang2}
{cmd:. char agegrp[omit]} {space 7} (to restore default)


{marker remarks3}{...}
{title:Interpreting output}

    {cmd:. xi: regress mpg i.rep78}
    {txt}i.rep78{right:_Irep78_1-5   (naturally coded; _Irep78_1 omitted)  }
    {it:(output from regress appears)}

{pstd}
Interpretation:  {cmd:i.rep78} expanded to the dummies {hi:_Irep78_1},
{hi:_Irep78_2}, ..., {hi:_Irep78_5}.  The numbers on the end are "naturally"
coded in the sense that {hi:_Irep78_1} corresponds to {hi:rep78}==1,
{hi:_Irep78_2} to {hi:rep78}==2, etc.  Finally, the dummy for {hi:rep78}==1
was omitted.

    {cmd:. xi: regress mpg i.make}
    {txt}i.make{right:_Imake_1-74   (_Imake_1 for make==AMC Concord omitted)  }
    {it:(output from regress appears)}

{pstd}
Interpretation:  {cmd:i.make} expanded to {hi:_Imake_1}, {hi:_Imake_2},
..., {hi:_Imake_74}.  The coding is not natural because make is a string
variable.  {hi:_Imake_1} corresponds to one make, {hi:_Imake_2} another, and
so on.  We can find out the coding by typing "{cmd:describe}".  {hi:_Imake_1}
for the AMC Concord was chosen to be omitted.


{marker remarks4}{...}
{title:How {cmd:xi} names variables}

{pstd}
The names {cmd:xi} assigns to the dummy variables it creates are of the form

	{it:<prefix>}{it:<stub>}{hi:_}{it:<groupid>}

{pstd}
By default, the prefix is {hi:_I}:

	{hi:_I}{it:<stub>}{hi:_}{it:<groupid>}

{pstd}
You may subsequently refer to the entire set of variables by
{it:<prefix>}{it:<stub>}{cmd:*}.

{pstd}
For example:

	name{col 25}=  {hi:_I} + {it:<stub>} + {hi:_} + {it:<groupid>}{col 61}Entire set
	{hline 62}
	_Iagegrp_1         _I   agegrp   _    1{col 61}_Iagegrp*
	_Iagegrp_2         _I   agegrp   _    2{col 61}_Iagegrp*
	_IageXwgt_1        _I   ageXwgt  _    1{col 61}_IageXwgt*
	_IageXrac_1_2      _I   ageXrac  _    1_2{col 61}_IageXrac*
	_IageXrac_2_1      _I   ageXrac  _    2_1{col 61}_IageXrac*


{marker remarks5}{...}
{title:{cmd:xi} as a command rather than a command prefix}

{pstd}
{cmd:xi} can be used as a command prefix or as a command by itself.  In the
latter form, {cmd:xi} merely creates the indicator and interaction variables.
Equivalent to typing

{phang}
{cmd:. xi: regress y i.agegrp*wgt}

    is

    {cmd:. xi i.agegrp*wgt}
    {txt}i.agegrp{right:_Iagegrp_1-4   (naturally coded; Iagegrp_1 omitted)  }
    i.agegrp*wgt{right:_IageXwgt_1-4   (coded as above)                      }

{phang}
{cmd:. regress y _Iagegrp* _IageXwgt*}


{marker remarks6}{...}
{title:Warnings}

{p 4 6 2}- {cmd:xi} creates new variables in your dataset; most are
{cmd:byte}s, but interactions with continuous variables will have the storage
type of the underlying continuous variable. You may get the error message
"{err:no room to add more variables}" or "{err:insufficient memory}".  You may
need to adjust the {cmd:maxvar} setting or reset {cmd:max_memory} if it has
been set too low; see {findalias frmemory}.

{p 4 6 2}- when using {cmd:xi} with an estimation command, you may get the
error message "{err:unable to allocate matrix}".  This usually occurs because
you attempted to create a matrix that is too large; see {manhelp Limits R}.


{marker examples}{...}
{title:Examples}

{psee}{cmd:. xi: logistic outcome weight i.agegrp bp}{p_end}
{psee}{cmd:. xi: logistic outcome weight bp i.agegrp i.race}{p_end}
{psee}{cmd:. xi: logistic outcome weight bp i.agegrp*i.race}{p_end}
{psee}{cmd:. xi: logistic outcome bp i.agegrp*weight i.race}{p_end}
{psee}{cmd:. xi: logistic outcome bp i.agegrp|weight i.race}{p_end}
{psee}{cmd:. xi: logistic outcome bp i.agegrp*weight i.agegrp*i.race}{p_end}
{psee}{cmd:. xi, prefix(_S) : logistic outcome weight i.agegrp bp}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xi} stores the following characteristics:

{synoptset 32 tabbed}{...}
{synopt:{cmd:_dta[__xi__Vars__Prefix__]}}prefix names{p_end}
{synopt:{cmd:_dta[__xi__Vars__To__Drop__]}}variables created{p_end}
{p2colreset}{...}
