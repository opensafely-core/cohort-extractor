{smcl}
{* *! version 1.2.3  10may2018}{...}
{vieweralsosee "[MI] Workflow" "mansection MI Workflow"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Glossary" "help mi_glossary"}{...}
{viewerjumpto "Description" "mi_workflow##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_workflow##linkspdf"}{...}
{viewerjumpto "Remarks" "mi_workflow##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[MI] Workflow} {hline 2}}Suggested workflow{p_end}
{p2col:}({mansection MI Workflow:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{p 4 4 2}
Provided below are suggested workflows for working with original data and for
working with data that already have imputations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI WorkflowRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_workflow##wforig:Suggested workflow for original data}
	{help mi_workflow##wfimported:Suggested workflow for data that already have imputations}
	{help mi_workflow##example:Example}


{marker wforig}{...}
{title:Suggested workflow for original data}

{p 4 4 2}
By original data, we mean data with missing values for which you do not
already have imputations.  Your task is to identify the missing values, impute
values for them, and perform estimation.

{p 4 4 2}
{cmd:mi} does not have a fixed order in which you must perform tasks except
that you must {cmd:mi} {cmd:set} the data first. 

{p 8 12 2}
1.  {bf:{help mi_set:mi set}} your data.

{p 12 12 2}
    Set the data to be wide, mlong, flong, or flongsep.
    Choose flongsep only if your data are bumping up against the 
    constraints of memory.  Choose flong or flongsep if you 
    will need super-varying variables.

{p 12 12 2}
    Memory is not usually a problem, and super-varying variables are seldom 
    necessary, so we generally start with the data as wide:

	        . {cmd:use} {it:originaldata}

	        . {cmd:mi set wide}

{p 12 12 2}
    If you need to use flongsep, you also need to specify a name for the 
    flongsep dataset collection.  Choose a name different from the current
    name of the dataset:

	        . {cmd:use} {it:originaldata}

                . {cmd:mi set flongsep} {it:newname}

{p 12 12 2}
    If the original data is {cmd:chd.dta}, you might choose {cmd:chdm} for
    {it:newname}.  {it:newname} does not include the {cmd:.dta} suffix.  If
    you choose {cmd:chdm}, the data will then be stored in {cmd:chdm.dta},
    {cmd:_1_chdm.dta}, and so on.  It is important that you choose a name
    different from {it:originaldata} because you do not want your {cmd:mi} data
    to overwrite the original.  Stata users are used to working with a copy of
    the data in memory, meaning that the changes made to the data are not
    reflected in the {cmd:.dta} dataset until the user saves them.  With
    flongsep data, however, changes are made to the {cmd:mi} {cmd:.dta} dataset
    collection as you work.
    See 
    {it:{help mi_styles##advice_flongsep:Advice for using flongsep}}
    in {bf:{help mi_styles:[MI] Styles}}.

{p 8 12 2}
2.  Use {bf:{help mi_describe:mi describe}} often.

{p 12 12 2}
    {cmd:mi} {cmd:describe} will not tell you anything useful yet, but as
    you set more about the data, {cmd:mi} {cmd:describe} will be more
    informative.

	        . {cmd:mi describe}

{p 8 12 2}
3.  Use {bf:{help mi_misstable:mi misstable}} to identify missing
    values.

{p 12 12 2}
    {cmd:mi} {cmd:misstable} is the standard 
    {bf:{help misstable:misstable}} but tailored for {cmd:mi} data.
    Several Stata commands have {cmd:mi} variants -- become familiar with
    them.  If there is no {cmd:mi} variant, then it is generally safe to use
    the standard command directly, although it may not be appropriate.  For
    instance, typing {cmd:misstable} rather than {cmd:mi} {cmd:misstable}
    would produce appropriate results right now, but it would not produce
    appropriate results later.  If {cmd:mi} datasets {it:m}=0, {it:m}=1, ...,
    {it:m}={it:M} exist and you run {cmd:misstable}, you might end up running
    the command on a strange
    combination of the {it:m}'s.  We recommend the wide style because general
    Stata commands will do what you expect.  The same is true for the
    flongsep style.  It is your responsibility to get this right.

{p 12 12 2}
    So what is the difference between {cmd:mi} {cmd:misstable} and 
    {cmd:misstable}?  {cmd:mi} {cmd:misstable} amounts to 
    {cmd:mi} {cmd:xeq} {cmd:0:} {cmd:misstable,} {cmd:exok}, which is 
    to say it runs on {it:m}=0 and specifies the {cmd:exok} option so 
    that extended missing values are treated as 
    {help mi_glossary##def_hardmissing:hard missings}.

{p 12 12 2}
    In general, you need to become familiar with all the {cmd:mi} commands, 
    use the {cmd:mi} variant of regular Stata commands whenever one exists,
    and think twice before using a command without an {cmd:mi} prefix.  Doing
    the right thing will become automatic once you gain familiarity with the
    styles; see {bf:{help mi_styles:[MI] Styles}}.

{p 12 12 2}
    To learn about the missing values in your data, type

	        . {cmd:mi misstable summarize}

{p 8 12 2}
4.  Use {cmd:mi register imputed} to register the variables you wish to impute;
    see {bf:{help mi_set:[MI] mi set}}.

{p 12 12 2}
    The only variables that {cmd:mi} will impute are those registered 
    as {cmd:imputed}.  You can register variables one at a time or all at once.
    If you register a variable mistakenly, 
    use {bf:{help mi_set:mi unregister}} to unregister it.

	        . {cmd:mi register imputed} {it:varname} [{it:varname} ...]

{p 8 12 2}
5.  Use {cmd:mi impute} to impute (fill in) the missing values;
     see {bf:{help mi_impute:[MI] mi impute}}.

{p 12 12 2}
    There is a lot to be said here.
    For instance, in a dataset where variables {cmd:age} and {cmd:bmi}
    contain missing, you might type

	        . {cmd:mi register imputed age bmi}

	        . {cmd:mi impute mvn age bmi =  attack smokes hsgrad, add(10)}

{p 12 12 2}
    {cmd:mi} {cmd:impute}'s {cmd:add(}{it:#}{cmd:)} option specifies the
    number of imputations to be added.  We currently have 0 imputations,
    so after imputation, we will have 10.  We usually start with a small
    number of imputations and add more later.

{p 8 12 2}
6.  Use {bf:{help mi_describe:mi describe}} to verify that all missing 
    values are filled in.

	        . {cmd:mi describe}

{p 12 12 2}
    You might also want to use {bf:{help mi_xeq:mi xeq}} to look at
    summary statistics in each of the imputation datasets:

	        . {cmd:mi xeq: summarize}

{p 8 12 2}
7.  Generate passive variables; {bf:{help mi_passive:[MI] mi passive}}.

{p 12 12 2}
    Passive variables are variables that are functions of imputed variables,
    such as {cmd:lnage} when some values of {cmd:age} are imputed.
    The values of passive variables differ across {it:m} just as the 
    values of imputed variables do.  The official way to generate imputed values
    is by using {cmd:mi passive}:

	        . {cmd:mi passive: generate lnage = ln(age)}

{p 12 12 2}
    Rather than use the official way, however, we often switch our data to
    mlong and just generate the passive variables directly:

	        . {cmd:mi convert mlong}

	        . {cmd:generate lnage = ln(age)}

	        . {cmd:mi register passive lnage}

{p 12 12 2}
    If you work as we do, remember to register any passive variables 
    you create.  When you are done, you may {cmd:mi} {cmd:convert} your 
    data back to wide, but there is no reason to do that.
    

{p 8 12 2}
8.  Use {bf:{help mi_estimate:mi estimate}} to fit models:

	       . {cmd:mi estimate: logistic attack smokes age bmi hsgrad}

{p 12 12 2}
    You fit your model just as you would ordinarily except that 
    you add {cmd:mi estimate:} in front of the command.

{p 4 4 2}
To see an example of the advice applied to a simple dataset, 
see {it:{help mi_workflow##example:Example}} below.

{p 4 4 2}
In theory, you should get your data cleaning and data management out 
of the way before {cmd:mi} {cmd:set}ting your data.  In practice 
that will not happen, so you will want to become familiar with 
the other {cmd:mi} commands.
Among the data-management commands available are 
{bf:{help mi_append:mi append}}, 
{bf:{help mi_merge:mi merge}}, 
{bf:{help mi_expand:mi expand}}, and
{bf:{help mi_reshape:mi reshape}}.
If you are working with survival-time data, also see 
{bf:{help mi_stsplit:mi stsplit}}.
To {cmd:stset} your data, or {cmd:svyset}, or {cmd:xtset}, see 
{bf:{help mi_set:[MI] mi set}} and 
{bf:{help mi_xxxset:[MI] mi XXXset}}.


{marker wfimported}{...}
{title:Suggested workflow for data that already have imputations}

{p 4 4 2}
Data sometimes come with imputations included.  The data might be made by
another researcher for you or the data might come from an official source.
Either way, we will assume that the data are not in Stata format, because if
they were, you would just use the data and would type 
{cmd:mi} {cmd:describe}.

{p 4 4 2}
{cmd:mi} can import officially produced datasets created by the 
National Health and Nutrition Examination Survey (NHANES)
with the 
{cmd:mi} {cmd:import} {cmd:nhanes1} command,
and {cmd:mi} can import more informally created datasets that are 
wide-, 
flong-, or
flongsep-like with 
{cmd:mi} {cmd:import} {cmd:wide}, 
{cmd:mi} {cmd:import} {cmd:flong}, or
{cmd:mi} {cmd:import} {cmd:flongsep};
see {bf:{help mi_import:[MI] mi import}}.

{p 4 4 2}
The required workflow is hardly different from 
{it:{help mi_workflow##wforig:Suggested workflow for original data}},
presented above.
The differences are that you will use {cmd:mi} {cmd:import} rather than
{cmd:mi} {cmd:set} and you will skip using {cmd:mi} {cmd:impute} to generate
the imputations.  In this sense, your job is easier.

{p 4 4 2}
On the other hand, 
you need to verify that you have imported your data correctly, and we have 
a lot to say about that.
Basically, after importing, you need to be careful about which 
{cmd:mi} commands you use until you have verified that you have 
the variables registered correctly.  
That is discussed in {bf:{help mi_import:[MI] mi import}}.


{marker example}{...}
{title:Example}

{p 4 4 2}
We are going to repeat {it:{help mi##example:A simple example}}
from {bf:{help mi:[MI] Intro}}, but this time we are going to follow 
the advice given above in 
{it:{help mi_workflow##wforig:Suggested workflow for original data}}.

{p 4 4 2}
We have fictional data on 154 patients and want to examine the relationship
between binary outcome {cmd:attack}, recording heart attacks, and variables
{cmd:smokes}, {cmd:age}, {cmd:bmi}, {cmd:hsgrad}, and {cmd:female}.  We will
use logistic regression.  Below we load our original data and show you a
little about it using the standard commands {cmd:describe} and {cmd:summarize}.
We emphasize that {cmd:mheart5.dta} is just a standard Stata dataset;
it has not been {cmd:mi} {cmd:set}.

         . {cmd:webuse mheart5}
         . {cmd:describe}
         . {cmd:summarize}

{p 4 4 8}
The first guideline is

{p 8 12 2}
1.  {bf:{help mi_set:mi set}} your data.

{p 4 4 2}
We will set the data to be flong even though in 
{it:{help mi##example:A simple example}}
we set the data to be mlong.  {cmd:mi} provides four styles -- flong, mlong,
wide, and flongsep -- and at this point it does not matter which we choose.
{cmd:mi} commands work the same way regardless of style.  Four styles are
provided because, should we decide to step outside of {cmd:mi} and attack the
data with standard Stata commands, we will find different styles more
convenient depending on what we want to do.  It is easy to switch styles.

{p 4 4 2}
Below we type {cmd:mi} {cmd:set} {cmd:flong} and then, to show you 
what that command did to the data, we show you the output from a standard
{cmd:describe}:

         . {cmd:mi set flong}
         . {cmd:describe}

{p 4 4 2}
Typing {cmd:mi} {cmd:set} {cmd:flong} added three variables to our data:
{cmd:_mi_miss}, {cmd:_mi_m}, and {cmd:_mi_id}.  Those variables belong to 
{cmd:mi}.  If you are curious about them, see
{bf:{help mi_styles:[MI] Styles}}.  Advanced users can even use them. 
No matter how advanced you are, however, you must never change their 
contents.

{p 4 4 2}
Except for the three added variables, the data are unchanged, and we would 
see that if we typed {cmd:summarize}.  The three added variables 
are due to the style we chose.  When you {cmd:mi} {cmd:set} your
data, different styles will change the data differently, but the changes 
will be just around the edges.

{p 4 4 2}
The second guideline is 

{p 8 12 2}
2.  Use {bf:{help mi_describe:mi describe}} often.

{p 4 4 2}
The guideline is to use {cmd:mi} {cmd:describe}, not {cmd:describe} as 
we just did.  Here is the result:

          . {cmd:mi describe}

{p 4 4 2}
As the guideline warned us, "{cmd:mi} {cmd:describe} will not tell you
anything useful yet."

{p 4 4 2}
The third guideline is

{p 8 12 2}
3.  Use {bf:{help mi_misstable:mi misstable}} to identify missing
    values.

{p 4 4 2}
Below we type {cmd:mi} {cmd:misstable} {cmd:summarize} and {cmd:mi}
{cmd:misstable} {cmd:nested}:

          . {cmd:mi misstable summarize}
          . {cmd:mi misstable nested}

{p 4 4 2}
{cmd:mi} {cmd:misstable} {cmd:summarize} reports the variables containing
missing values.  Those variables in our data are {cmd:age}
and {cmd:bmi}.  Notice that {cmd:mi} {cmd:misstable} {cmd:summarize} draws a
distinction between, as it puts it, "Obs=." and "Obs>.", which is to say
between standard missing ({cmd:.)} and extended missing ({cmd:.a}, {cmd:.b},
..., {cmd:.z}).  That is because {cmd:mi} has a concept of soft and hard
missing, and it associates soft missing with system missing and hard missing
with extended missing.  Hard missing values -- extended missings -- are taken 
to mean missing values that are not to be imputed.  Our data have no missing
values like that.

{p 4 4 2}
After typing {cmd:mi} {cmd:misstable} {cmd:summarize}, we typed 
{cmd:mi} {cmd:misstable} {cmd:nested} because we were curious whether 
the missing values were nested or, to use the jargon, monotone.  
We discovered that they were.  That is, {cmd:age} has 12 missing 
values in the data, and in every observation in which {cmd:age} is 
missing, so is {cmd:bmi}, although {cmd:bmi} has another  
16 missing values scattered around the data.  
That means we can use a monotone imputation method, and that is good 
news because monotone methods are more flexible and faster.
We will discuss the implications of that shortly.
There is a mechanical detail we must handle first.

{p 4 4 2}
The fourth guideline is

{p 8 12 2}
4.  Use {cmd:mi register imputed} to register the variables you wish to impute;
    see {bf:{help mi_set:[MI] mi set}}.

{p 4 4 2}
We know that {cmd:age} and {cmd:bmi} have missing values, and 
before we can impute replacements for those missing values, we must register 
the variables as to-be-imputed, which we do by typing 

          . {cmd:mi register imputed age bmi}

{p 4 4 2}
Guideline 2 suggested that we type {cmd:mi} {cmd:describe} often.  Perhaps now 
would be a good time:

          . {cmd:mi describe}

{p 4 4 2}
The output has indeed changed.  {cmd:mi} knows just as it did before
that we have 154 observations, and it now knows that 126 of them are 
complete and 28 of them are incomplete.  It also knows that 
{cmd:age} and {cmd:bmi} are to be imputed.  The numbers in parentheses 
are the number of missing values.

{p 4 4 2}
The fifth guideline is

{p 8 12 2}
5.  Use {cmd:mi impute} to impute (fill in) the missing values.

{p 4 4 2}
In {it:{help mi##example:A simple example}}
from {bf:{help mi:[MI] Intro}}, we imputed values for {cmd:age} and 
{cmd:bmi} by typing 

	. {cmd:mi impute mvn age bmi = attack smokes hsgrad female, add(10)}

{p 4 4 2}
This time, we will impute values by typing 

{p 12 51 2}
{cmd:mi impute monotone (regress) age bmi = attack smokes hsgrad female,}
{cmd:add(20)}

{p 4 4 2}
We changed {cmd:add(10)} to {cmd:add(20)} for no other reason than to show
that we could, although we admit to a preference for more imputations whenever
possible.  {cmd:add()} specifies the number of imputations to be added to the
data.  For every missing value, we will impute 20 nonmissing replacements.

{p 4 4 2}
We switched from {cmd:mi} {cmd:impute} {cmd:mvn} to {cmd:mi} {cmd:impute}
{cmd:monotone} because our data are monotone.  Here {cmd:mi}
{cmd:impute} {cmd:monotone} will be faster than {cmd:mi} {cmd:impute}
{cmd:mvn} but will offer no statistical advantage.  In other cases, there
might be statistical advantages.  All of which is to say that when you get to
the imputation step, you have important decisions to make and you need to
become knowledgeable about the subject.  You can start by reading
{bf:{help mi_impute:[MI] mi impute}}.

          . {cmd:set seed 20039}
{p 10 15 2}
          . {cmd:mi impute monotone (regress) age bmi = attack smokes hsgrad female, add(20)}{p_end}

{p 4 4 2}
Note that we typed {cmd:set} {cmd:seed} {cmd:20039} before issuing the
{cmd:mi} {cmd:impute} command.  Doing that made our results reproducible.  We
could have specified {cmd:mi} {cmd:impute}'s {cmd:rseed(20039)} option
instead.  Or we could have skipped setting the random-number seed altogether,
and then we would not be able to reproduce our results.

{p 4 4 2}
The sixth guideline is

{p 8 12 2}
6.  Use {bf:{help mi_describe:mi describe}} to verify that all missing 
    values are filled in.

          . {cmd:mi describe, detail}

{p 4 4 2}
This time, we specified {cmd:mi} {cmd:describe}'s {cmd:detail} option, 
although you have to look closely at the output to see the effect.  When
you do not specify {cmd:detail}, {cmd:mi} {cmd:describe} reports results for
the original, unimputed data only, what we call {it:m}=0 throughout this
documentation.  When you specify {cmd:detail}, {cmd:mi} {cmd:describe} also
includes information about the imputation data, what we call {it:m}>0 and is
{it:m}=1, {it:m}=2, ...,  {it:m}=20 here.  Previously, {cmd:mi}
{cmd:describe} reported "age(12)", meaning that {cmd:age} in {it:m}=0 has 12 
missing values.  This time, it reports "age(12; 20*0)", meaning that {cmd:age}
still has 12 missing values in {it:m}=0, and it has 0 missing values in
the 20 imputations.  {cmd:bmi} also has 0 missing values in the
imputations.  Success!

{p 4 4 2}
Let's take a detour to see how our data really look.  Let's type 
Stata's standard {cmd:describe} command.  The last time we looked, 
our data had three extra variables.  

          . {cmd:describe}

{p 4 4 2}
Nothing has changed as far as variables are concerned, but notice 
the number of observations.  Previously, we had 154 observations.  Now we 
have 3,234!  That works out to 21*154.  Stored is our original data 
plus 20 imputations.   The flong style makes extra copies of the data.

{p 4 4 2}
We chose style flong only because it is so easy to explain.  In 
{it:{help mi##example:A simple example}} from 
{bf:{help mi:[MI] Intro}} using this same data, we choose style
mlong.  It is not too late:

          . {cmd:mi convert mlong}

{p 4 4 2}
All that is required to change styles is typing {cmd:mi} {cmd:convert}. 
The style of the data changes, but not the contents.
Let's see what {cmd:describe} has to report:

          . {cmd:describe}

{p 4 4 2}
The data look much like they did when they were flong, except 
that the number of observations has fallen from 3,234 to 714!
Style mlong is an efficient style in that rather than storing the 
full data for every imputation, it stores only the changes.  
Back when the data were flong, {cmd:mi} {cmd:describe} reported that 
we had 28 incomplete observations.  We get 714 from the 154 original
observations plus 20*28 replacement observations for the 
incomplete observations.

{p 4 4 2}
We recommend style mlong. 
Style wide is also recommended.  Below we type {cmd:mi} {cmd:convert} to 
convert our mlong data to wide, and then we run the standard {cmd:describe} 
command:

          . {cmd:mi convert wide}
          . {cmd:describe}

{p 4 4 2}
In the wide style, our data are back to having 154 observations, 
but now we have 47 variables!  Variable {cmd:_1_age} contains 
{cmd:age} for {it:m}=1, {cmd:_1_bmi} contains {cmd:bmi} for 
{it:m}=1, {cmd:_2_age} contains {cmd:age} for {it:m}=2, and so on.  

{p 4 4 2}
Guideline 7 is 

{p 8 12 2}
7.  Generate passive variables.

{p 4 4 2}
Passive variables are variables derived from imputed variables.
For instance, if we needed {cmd:lnage} = ln({cmd:age)}, variable 
{cmd:lnage} would be passive.  Passive variables are easy to 
create; see {bf:{help mi_passive:[MI] mi passive}}.
We are not going to need any passive variables in this example.

{p 4 4 2}
Guideline 8 is

{p 8 12 2}
8.  Use {bf:{help mi_estimate:mi estimate}} to fit models.

{p 4 4 2}
Our data are wide right now, but that does not matter.  We fit 
our model:

          . {cmd:mi estimate: logistic attack smokes age bmi hsgrad female}

{p 4 4 2}
Those familiar with the {cmd:logistic} command will be surprised that {cmd:mi}
{cmd:estimate:} {cmd:logistic} reported coefficients rather than odds ratios.
That is because the estimation command is not {cmd:logistic} using {cmd:mi}
{cmd:estimate}, it is {cmd:mi} {cmd:estimate} using {cmd:logistic}. If we
wanted to see odds ratios at estimation time, we could have typed

          . {cmd:mi estimate, or:  logistic} ...

{p 4 4 2}
By the same token, if we wanted to replay results, we would not type 
{cmd:logistic}, we would type {cmd:mi} {cmd:estimate}:

          . {cmd:mi estimate}

{p 4 4 2}
If we wanted to replay results with odds ratios, we would type 

          . {cmd:mi estimate, or}

{p 4 4 2}
And that concludes the guidelines.
{p_end}
