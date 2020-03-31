{smcl}
{* *! version 1.1.11  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi varying" "mansection MI mivarying"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi misstable" "help mi_misstable"}{...}
{viewerjumpto "Syntax" "mi_varying##syntax"}{...}
{viewerjumpto "Menu" "mi_varying##menu"}{...}
{viewerjumpto "Description" "mi_varying##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_varying##linkspdf"}{...}
{viewerjumpto "Options" "mi_varying##options"}{...}
{viewerjumpto "Remarks" "mi_varying##remarks"}{...}
{viewerjumpto "Stored results" "mi_varying##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MI] mi varying} {hline 2}}Identify variables that vary across
     imputations{p_end}
{p2col:}({mansection MI mivarying:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{cmd:mi} {cmdab:vary:ing} 
[{varlist}]
[{cmd:,}
{bf:{help mi_noupdate_option:{ul:noup}date}}]

{p 8 8 2}
{cmd:mi} {cmdab:vary:ing}{cmd:, } 
{cmdab:unreg:istered}
[{bf:{help mi_noupdate_option:{ul:noup}date}}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:varying} lists the names of variables that are unexpectedly 
varying and super varying;
see {bf:{help mi_glossary:[MI] Glossary}} for a definition of
{help mi_glossary##def_varying:varying and super-varying variables}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mivaryingRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:unregistered} 
    specifies that the listing be made only for unregistered variables.
    Specifying this option saves time, especially when the data are
    flongsep.

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
A variable is said to be varying if it varies over {it:m} in the 
{help mi_glossary##def_complete:complete} observations.
A variable is said to be super varying if it varies over {it:m} in the 
{help mi_glossary##def_complete:incomplete} observations.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_varying##detecting:Detecting problems}
	{help mi_varying##fixing:Fixing problems}


{marker detecting}{...}
{title:Detecting problems}

{p 4 4 2}
{cmd:mi} {cmd:varying} looks for five potential problems:

{p 8 12 2}
1.  {it:Imputed nonvarying}.
    Variables that are registered as imputed and are nonvarying 
    either 

{p 12 16 2}
    a.  do not have their missing values in {it:m}>0 filled in yet, 
        in which case you should use {bf:{help mi_impute:mi impute}}
        to impute them, or

{p 12 16 2}
    b.  have no missing values in {it:m}=0, in which case you 
        should {bf:mi} {cmd:unregister} the variables and perhaps use {cmd:mi}
        {cmd:register} to register the variables as regular
        (see {bf:{help mi_set:[MI] mi set}}).

{p 8 12 2}
2.  {it:Passive nonvarying}.
    Variables that are registered as passive and are nonvarying 
    either 

{p 12 16 2}
    a.  have missing values in the incomplete observations in {it:m}>0,
        in which case  
        after you have filled in the missing values of your imputed variables,
        you should use 
        {bf:{help mi_passive:mi passive}}
	to update the values of these variables, or

{p 12 16 2}
    b.  have no missing values in {it:m}=0, in which case you 
        should {cmd:mi} {cmd:unregister} the variables
        and perhaps use {bf:mi} {cmd:register} 
        to register the variables as regular 
        (see {bf:{help mi_set:[MI] mi set}}).

{p 8 12 2}
3.  {it:Unregistered varying}. 

{p 12 16 2}
    a.  It is most likely that such variables should be registered 
        as imputed or as passive.

{p 12 16 2}
    b.  If the variables are varying but should not be,
        use {cmd:mi} {cmd:register} to register them as regular.
        That will fix the problem; values from {it:m}=0 will be copied 
        to {it:m}>0.

{p 12 16 2}
    c.  It is possible that this is just like potential problem 5, below, and
        it just randomly turned out that the only observations in which
        variation occurred were the incomplete observations.  In that case,
        leave the variable unregistered. 

{p 8 12 2}
4.  {it:Unregistered super/varying}. 
    These are variables that are super varying but would have been 
    categorized as varying if they were registered as imputed.  This is to say
    that while they have varying values in the complete observations as
    complete is defined this instant-- which is based
    on the variables currently registered as imputed -- these variables merely
    vary in observations for which they themselves contain missing in
    {it:m}=0, and thus they could be registered as imputed without loss of
    information.  Such variables should be registered as imputed.

{p 8 12 2}
5.  {it:Unregistered super varying.}
    These variables really do super vary and could not be registered as 
    imputed without loss of information.
    These variables either contain true errors
    or they are passive variables that are functions of groups of 
    observations.  Fix the errors by registering the variables as 
    regular and leave unregistered those intended to be super varying.
    If you intentionally have super-varying variables in your data, 
    remember never to convert to the wide or mlong styles.  Super-varying 
    variables can appear only in the flong and flongsep styles.


{p 4 4 2}
{cmd:mi} {cmd:varying} output looks like this:


                     Possible problem   variable names
         {hline}
{p 18 32 2}
imputed nonvarying:
(none)
{p_end}
{p 18 32 2}
passive nonvarying:
(none)
{p_end}
{p 16 32 2}
unregistered varying:
(none)
{p_end}
{p 9 32 2}
*unregistered super/varying:
(none)
{p_end}
{p 10 32 2}
unregistered super varying:
(none)
{p_end}
         {hline}
{p 9 11 2}
* super/varying means super varying but would be varying if registered as
imputed; variables vary only where equal to soft missing in {it:m}=0.


{p 4 4 2}
If there are possible problems, variable names are listed in the table.

{p 4 4 2}
Super-varying variables can arise only in flong and flongsep data, so 
the last two categories are omitted when {cmd:mi} {cmd:varying} is run on 
wide or mlong data.  If there are no imputed variables, or no 
passive variables, or no unregistered variables, the corresponding 
categories are omitted from the table.


{marker fixing}{...}
{title:Fixing problems}

{p 4 4 2}
If {cmd:mi} {cmd:varying} detects problems, register all imputed variables
before registering passive variables.  
Rerun {cmd:mi} {cmd:varying} as you register new imputed variables.
Registering new variables as imputed can change which observations are 
classified as complete and incomplete, and that classification in turn 
can change the categories to which the other variables are assigned.
After registering a variable as imputed, another variable previously 
listed as super varying might now be merely varying.


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:mi varying} stores the following in {cmd:r()}:

    Macros
      {cmd:r(ivars)}      nonvarying imputed variables
      {cmd:r(pvars)}      nonvarying passive variables 
      {cmd:r(uvars_v)}	  varying unregistered variables 
      {cmd:r(uvars_s_v)}  (super) varying unregistered variables
      {cmd:r(uvars_s_s)}  super-varying unregistered variables
