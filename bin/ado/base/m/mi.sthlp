{smcl}
{* *! version 1.2.5  05sep2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] Intro" "mansection MI Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Glossary" "help mi_glossary"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi_intro_substantive"}{...}
{vieweralsosee "[MI] Styles" "help mi_styles"}{...}
{vieweralsosee "[MI] Workflow" "help mi_workflow"}{...}
{viewerjumpto "Description" "mi##description"}{...}
{viewerjumpto "Remarks" "mi##remarks"}{...}
{viewerjumpto "Acknowledgments" "mi##ack"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[MI] Intro} {hline 2}}Introduction to mi{p_end}
{p2col:}({mansection MI Intro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{p 8 9 9}
{it:[Suggestion:  Read}
{bf:{help mi_intro_substantive:[MI] Intro substantive}}
{it:first.]}


{marker description}{...}
{title:Description}

    {c TLC}{hline 61}{c TRC}
    {c |} The {cmd:mi} suite of commands deals with multiple-imputation{col 67}{c |}
    {c |} data, abbreviated as {cmd:mi} data. To become familiar with {cmd:mi}{col 67}{c |}
    {c |} as quickly as possible, do the following:{col 67}{c |}
    {c |}{col 67}{c |}
    {c |}    1.  See {it:{help mi##example:A simple example}} under {...}
{bf:{help mi##remarks:Remarks}} below.{col 67}{c |}
    {c |}{col 67}{c |}
    {c |}    2.  If you have data that require imputing, see{col 67}{c |}
    {c |}        {bf:{help mi_set:[MI] mi set}}{col 67}{c |}
    {c |}        {bf:{help mi_impute:[MI] mi impute}}{col 67}{c |}
    {c |}{col 67}{c |}
    {c |}    3.  Alternatively, if you have already imputed data, see{col 67}{c |}
    {c |}        {bf:{help mi_import:[MI] mi import}}{col 67}{c |}
    {c |}{col 67}{c |}
    {c |}    4.  To fit your model, see{col 67}{c |}
    {c |}        {bf:{help mi_estimate:[MI] mi estimate}}{col 67}{c |}
    {c BLC}{hline 61}{c BRC}


{p 4 4 2}
To create {cmd:mi} data from original data

{col 7}{...}
{...}
{...}
{col 7}{...}
{hline 70}
{...}
{...}
{...}
{...}
{col 7}{bf:{help mi_set:mi set}}{...}
{col 30}declare data to be {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_set:mi register}}{...}
{col 30}register imputed, passive, or regular variables
{...}
{...}
{col 7}{bf:{help mi_set:mi unregister}}{...}
{col 30}unregister previously registered variables
{...}
{...}
{col 7}{bf:{help mi_set:mi unset}}{...}
{col 30}return data to unset status (rarely used)
{...}
{...}
{col 7}{...}
{hline 70}
{p 6 6 2}
See {it:{help mi##summary:Summary}} below for a 
summary of {cmd:mi} data and these commands.
See {bf:{help mi_glossary:[MI] Glossary}} for a definition of terms.


{p 4 4 2}
To import data that already have imputations for the missing values
(do not {cmd:mi} {cmd:set} the data)

{col 7}{...}
{hline 70}
{col 7}{bf:{help mi_import:mi import}}{...}
{col 30}import {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_export:mi export}}{...}
{col 30}export {cmd:mi} data to non-Stata application
{...}
{...}
{col 7}{...}
{hline 70}
{p 6 6 2}


{p 4 4 2}
Once data are {cmd:mi set} or {cmd:mi import}ed

{col 7}{...}
{hline 70}
{col 7}{bf:{help mi_describe:mi query}}{...}
{col 30}query whether and how {cmd:mi set}
{...}
{...}
{col 7}{bf:{help mi_describe:mi describe}}{...}
{col 30}describe {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_varying:mi varying}}{...}
{col 30}identify variables that vary over {it:m}
{...}
{...}
{col 7}{bf:{help mi_misstable:mi misstable}}{...}
{col 30}tabulate missing values
{...}
{...}
{col 7}{bf:{help mi_passive:mi passive}}{...}
{col 30}create passive variable and register it
{col 7}{...}
{hline 70}


{p 4 4 2}
To perform estimation on {cmd:mi} data

{col 7}{...}
{hline 70}
{col 7}{bf:{help mi_impute:mi impute}}{...}
{col 30}impute missing values
{...}
{...}
{col 7}{bf:{help mi_estimate:mi estimate}}{...}
{col 30}perform and combine estimation on {it:m}>0
{...}
{...}
{col 7}{bf:{help mi_ptrace:mi ptrace}}{...}
{col 30}check stability of MCMC
{...}
{...}
{col 7}{bf:{help mi_test:mi test}}{...}
{col 30}perform tests on coefficients
{...}
{...}
{col 7}{bf:{help mi_test:mi testtransform}}{...}
{col 30}perform tests on transformed coefficients
{...}
{...}
{col 7}{bf:{help mi_predict:mi predict}}{...}
{col 30}obtain linear predictions
{...}
{...}
{col 7}{bf:{help mi_predict:mi predictnl}}{...}
{col 30}obtain nonlinear predictions
{...}
{...}
{...}
{col 7}{...}
{hline 70}


{p 4 4 2}
To {cmd:stset}, {cmd:svyset}, {cmd:tsset}, or {cmd:xtset} any {cmd:mi} 
data that were not set at the time they were {cmd:mi} {cmd:set}

{col 7}{...}
{hline 70}
{col 7}{bf:{help mi_xxxset:mi fvset}}{...}
{col 30}{cmd:fvset}   for {cmd:mi} data
{...}
{col 7}{bf:{help mi_xxxset:mi svyset}}{...}
{col 30}{cmd:svyset}  for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_xxxset:mi xtset}}{...}
{col 30}{cmd:xtset}   for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_xxxset:mi tsset}}{...}
{col 30}{cmd:tsset}   for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_xxxset:mi stset}}{...}
{col 30}{cmd:stset}   for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_xxxset:mi streset}}{...}
{col 30}{cmd:streset} for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_xxxset:mi st}}{...}
{col 30}{cmd:st}      for {cmd:mi} data
{...}
{...}
{col 7}{...}
{hline 70}


{p 4 4 2}
To perform data management on {cmd:mi} data

{col 7}{...}
{hline 70}
{col 7}{bf:{help mi_rename:mi rename}}{...}
{col 30}rename variable
{...}
{...}
{col 7}{bf:{help mi_append:mi append}}{...}
{col 30}{cmd:append}  for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_merge:mi merge}}{...}
{col 30}{cmd:merge}   for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_expand:mi expand}}{...}
{col 30}{cmd:expand}  for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_reshape:mi reshape}}{...}
{col 30}{cmd:reshape} for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_stsplit:mi stsplit}}{...}
{col 30}{cmd:stsplit} for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_stsplit:mi stjoin}}{...}
{col 30}{cmd:stjoin}  for {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_add:mi add}}{...}
{col 30}add imputations from one {cmd:mi} dataset to another
{...}
{...}
{col 7}{...}
{hline 70}


{p 4 4 2}
To perform data management for which no {cmd:mi} prefix command exists 

{col 7}{...}
{hline 70}
{col 7}{bf:{help mi_extract:mi extract 0}}{...}
{col 30}extract {it:m}=0 data
{col 7}{help mi_replace0:...}{...}
{col 30}perform data management the usual way
{col 7}{bf:{help mi_replace0:mi replace0}}{...}
{col 30}replace {it:m}=0 data in {cmd:mi} data
{col 7}{...}
{hline 70}


{p 4 4 2}
To perform the same data-management or data-reporting command(s) on 
{it:m}=0, {it:m}=1, ...

{col 7}{...}
{hline 70}
{col 7}{bf:{help mi_xeq:mi xeq:}} ...{...}
{col 30}execute commands on {it:m}=0, {it:m}=1, {it:m}=2, ..., {it:m}={it:M}
{...}
{col 7}{bf:{help mi_xeq:mi xeq #:}} ...{...}
{col 30}execute commands on {it:m}=#
{...}
{col 7}{bf:{help mi_xeq:mi xeq # # ...:}} ...{...}
{col 30}execute commands on specified values of {it:m}
{col 7}{...}
{hline 70}


{p 4 4 2}
Useful utility commands

{col 7}{...}
{hline 70}
{col 7}{bf:{help mi_convert:mi convert}}{...}
{col 30}convert {cmd:mi} data from one style to another
{...}

{...}
{col 7}{bf:{help mi_extract:mi extract #}}{...}
{col 30}extract {it:m}={it:#} from {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_select:mi select #}}{...}
{col 30}programmer's command similar to {cmd:mi} {cmd:extract}

{...}
{...}
{col 7}{bf:{help mi_copy:mi copy}}{...}
{col 30}copy {cmd:mi} data
{...}
{...}
{col 7}{bf:{help mi_erase:mi erase}}{...}
{col 30}erase files containing {cmd:mi} data
{...}
{...}

{col 7}{bf:{help mi_update:mi update}}{...}
{col 30}verify/make {cmd:mi} data consistent
{...}
{...}
{col 7}{bf:{help mi_reset:mi reset}}{...}
{col 30}reset imputed or passive variable
{col 7}{...}
{hline 70}


{p 4 4 2}
For programmers interested in extending {cmd:mi}

{col 7}{...}
{hline 70}
{col 7}{bf:{help mi_technical:[MI] Technical}}{...}
{col 30}Detail for programmers
{col 7}{hline 70}


{marker sum_styles}{...}
{p 4 4 2}
{it:Summary of styles}

{p 6 6 2}
There are four styles or formats in which {cmd:mi} data are stored: 
flongsep, flong, mlong, and wide.

{p 8 12 2}
1.  Flongsep:  {it:m}=0, {it:m=1}, ..., {it:m}={it:M} are each separate
    {cmd:.dta} datasets.  If {it:m}=0 data are stored 
    in {cmd:pat.dta}, then {it:m}=1 data are stored in {cmd:_1_pat.dta}, 
    {it:m}=2 in {cmd:_2_pat.dta}, and so on.
    Flongsep stands for {it:full long and separate}.

{p 8 12 2}
2.  Flong:  {it:m}=0, {it:m}=1, ..., {it:m}={it:M} are stored 
    in one dataset with {it:_N} = {bind:{it:N} + {it:M}*{it:N}}
    observations, where 
    {it:N} is the number of observations in {it:m}=0.
    Flong stands for {it:full long}. 

{p 8 12 2}
3.  Mlong:  {it:m=0}, {it:m=1}, ..., {it:m}={it:M} are stored 
    in one dataset with {it:_N} = {bind:{it:N} + {it:M}*{it:n}}
    observations,
    where {it:n} is the number of incomplete observations in {it:m}=0.
    Mlong stands for {it:marginal long}.

{p 8 12 2}
4.  Wide:  {it:m=0}, {it:m=1}, ..., {it:m}={it:M} are stored 
    in one dataset with {it:_N} = {it:N} observations.  Each imputed and 
    passive variable has {it:M} additional variables associated with it.
    If variable {cmd:bp} contains the values in {it:m}=0, then 
    values for {it:m}=1 are contained in variable {cmd:_1_bp}, 
    values for {it:m}=2 in {cmd:_2_bp}, and so on.
    Wide stands for {it:wide}.

{p 6 6 2}
See 
{it:{help mi_glossary##def_style:style}} in 
{bf:{help mi_glossary:[MI] Glossary}}
and see 
{bf:{help mi_styles:[MI] Styles}} for examples.
See {bf:{help mi_technical:[MI] Technical}} for programmer's 
details.  


{marker summary}{...}
{p 4 4 2}
{it:Summary}

{p 8 12 2}
1.  {cmd:mi} data may be stored in one of four formats -- 
    flongsep, flong, mlong, and wide -- known as styles.
    Descriptions are provided in
    {it:{help mi##sum_styles:Summary of styles}} 
    directly above.

{p 8 12 2}
2.  {cmd:mi} data contain {it:M} imputations numbered {it:m} = 1, 2, ...,
    {it:M}, and contain {it:m}=0, the original data with missing values.

{p 8 12 2}
3.  Each variable in {cmd:mi} data is registered as
    imputed, passive, or regular, or it is unregistered.
{p_end}
{p 12 16 2}
a.
    Unregistered variables are mostly treated like regular variables.  
{p_end}
{p 12 16 2}
b.  Regular
    variables usually do not contain missing, or if they do, the missing
    values are not imputed in {it:m}>0.
{p_end}
{p 12 16 2}
c.  Imputed variables contain missing in
    {it:m}=0, and those values are imputed, or are to be imputed, in {it:m}>0.
{p_end}
{p 12 16 2}
d.  Passive variables are algebraic combinations of imputed,
    regular, or other passive variables.

{p 8 12 2}
4.  If an imputed variable contains a value greater 
    than {cmd:.} in {it:m}=0 -- it contains {cmd:.a}, {cmd:.b}, ..., 
    {cmd:.z} -- then that value is considered a hard missing and the missing
    value persists in {it:m}>0.

{p 6 6 2}
See {bf:{help mi_glossary:[MI] Glossary}} for a more thorough description 
of terms used throughout this manual.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi##example:A simple example}
	{help mi##order:Suggested reading order}


{marker example}{...}
{title:{it:A simple example}}

{pstd}
We have six basic commands:

	. {cmd:webuse mheart5}{right:(1)    }

	. {cmd:mi set mlong}{right:(2)    }

	. {cmd:mi register imputed age bmi}{right:(3)    }

	. {cmd:set seed 29390}{right:(4)    }

	. {cmd:mi impute mvn age bmi = attack smokes hsgrad female, add(10)}{right:(5)    }

	. {cmd:mi estimate: logistic attack smokes age bmi hsgrad female}{right:(6)    }

{pstd}
The story is that we want to fit  

	. {cmd:logistic attack smokes age bmi hsgrad female}

{pstd} 
but the {cmd:age} and {cmd:bmi} variables contain missing values.  Fitting
the model by typing {cmd:logistic} ... would ignore some of the information in
our data.  Multiple imputation (MI) attempts to recover that information.
The method imputes {it:M} values to fill in each of the missing values. 
After that, statistics are performed on the {it:M} imputed datasets
separately and the results combined.  The goal is to obtain better estimates
of parameters and their standard errors.

{pstd}
In the solution shown above, 

{p 8 12 2}
1.  We load the data.

{p 8 12 2}
2.  We set our data to be {cmd:mi}.

{p 8 12 2}
3.  We inform {cmd:mi} which variables containing missing values 
    for which we want to impute values.

{p 8 12 2}
4.  We impute values in command 5; we prefer that our results be 
    reproducible, so we set the random-number seed in command 4.  This step is
    optional.

{p 8 12 2}
5.  We create {it:M}=10 imputations for each missing value in the 
    variables we registered in command 3.

{p 8 12 2}
6.  We fit the desired model separately on each of the 10 imputed datasets
    and combine the results. 

{pstd}
We will be using variations of these data throughout the {cmd:mi}
documentation.


{marker order}{...}
{title:{it:Suggested reading order}}

{p 4 4 2}
The order of suggested reading of this manual is

	{bf:{help mi_intro_substantive:[MI] Intro substantive}}
	{bf:[MI] Intro} 
	{bf:{help mi_glossary:[MI] Glossary}}
	{bf:{help mi_workflow:[MI] Workflow}}

	{bf:{help mi_set:[MI] mi set}}
	{bf:{help mi_import:[MI] mi import}}
	{bf:{help mi_describe:[MI] mi describe}}
	{bf:{help mi_misstable:[MI] mi misstable}}

	{bf:{help mi_impute:[MI] mi impute}} 
	{bf:{help mi_estimate:[MI] mi estimate}}

	{bf:{help mi_styles:[MI] Styles}}
	{bf:{help mi_convert:[MI] mi convert}}
	{bf:{help mi_update:[MI] mi update}}

	{bf:{help mi_rename:[MI] mi rename}}
	{bf:{help mi_copy:[MI] mi copy}}
	{bf:{help mi_erase:[MI] mi erase}}
	{bf:{help mi_xxxset:[MI] mi XXXset}}

	{bf:{help mi_extract:[MI] mi extract}}
	{bf:{help mi_replace0:[MI] mi replace0}}

	{bf:{help mi_append:[MI] mi append}}
	{bf:{help mi_add:[MI] mi add}}
	{bf:{help mi_merge:[MI] mi merge}}
	{bf:{help mi_reshape:[MI] mi reshape}}
	{bf:{help mi_stsplit:[MI] mi stsplit}}
	{bf:{help mi_varying:[MI] mi varying}}

{p 4 4 2}
Programmers will want to see 
{bf:{help mi_technical:[MI] Technical}}.


{marker ack}{...}
{title:Acknowledgments}

{p 4 4 2}
We thank Jerry (Jerome)
Reiter of Duke University, 
Patrick Royston of the MRC Clinical Trials Unit, and 
Ian White of the MRC Biostatistics Unit
for their comments and assistance in the development of {cmd:mi}.  We also
thank 
James Carpenter of the London School of Hygiene and Tropical Medicine and 
Jonathan Sterne of the University of Bristol for their comments.

{p 4 4 2}
Previous and still ongoing work on multiple imputation in Stata 
influenced the design of {cmd:mi}.
For their past and current contributions, we thank
Patrick Royston and Ian White again for {cmd:ice};
John Carlin and John Galati, both 
of the Murdoch Children's Research Institute and 
University of Melbourne, and 
Patrick Royston and Ian White (yet again)
for {cmd:mim}; 
John Galati for {cmd:inorm};
and Rodrigo Alfaro of the Banco Central de Chile for {cmd:mira}. 
{p_end}
