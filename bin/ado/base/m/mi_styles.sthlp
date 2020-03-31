{smcl}
{* *! version 1.0.12  08feb2019}{...}
{vieweralsosee "[MI] Styles" "mansection MI Styles"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi copy" "help mi_copy"}{...}
{vieweralsosee "[MI] mi erase" "help mi_erase"}{...}
{vieweralsosee "[MI] Technical" "help mi_technical"}{...}
{viewerjumpto "Syntax" "mi_styles##syntax"}{...}
{viewerjumpto "Description" "mi_styles##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_styles##linkspdf"}{...}
{viewerjumpto "Remarks" "mi_styles##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MI] Styles} {hline 2}}Dataset styles{p_end}
{p2col:}({mansection MI Styles:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
There are four dataset styles available for storing {cmd:mi} data:

{p 8 8 2}
{opt w:ide}

{p 8 8 2}
{opt ml:ong}

{p 8 8 2}
{opt fl:ong}

{p 8 8 2}
{opt flongs:ep}


{marker description}{...}
{title:Description}

{p 4 4 2}
The purpose of this entry is to familiarize you with the 
four styles in which {cmd:mi} data can be stored.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI StylesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_styles##styles:The four styles}
	    {help mi_styles##wide:Style wide}
	    {help mi_styles##flong:Style flong}
	    {help mi_styles##mlong:Style mlong}
	    {help mi_styles##flongsep:Style flongsep}
	    {help mi_styles##how:How we constructed this example}

	{help mi_styles##sysvars:Using mi system variables}

	{help mi_styles##advice_flongsep:Advice for using flongsep}


{marker styles}{...}
{title:The four styles}

{p 4 4 2}
We have highly artificial data, which we will first describe verbally and then
show to you in each of the styles.  The original data have two 
observations on two variables:

                       {c TLC}{hline 11}{c TRC}
		       {c |} a       b {c |}
                       {c LT}{hline 11}{c RT}
                       {c |} 1       2 {c |}
                       {c |} 4       . {c |}
                       {c BLC}{hline 11}{c BRC}

{p 4 4 2}
Variable {cmd:b} has a missing value.  We have two imputed values for 
{cmd:b}, namely, 4.5 and 5.5.  
There will also be a third variable, {cmd:c}, in our dataset, where
{cmd:c} = {cmd:a} + {cmd:b}.

{p 4 4 2}
Thus, in the jargon of {cmd:mi}, we have {it:M}=2 imputations, and the datasets 
{it:m}=0, {it:m}=1, and {it:m}=2 are

                       {c TLC}{hline 19}{c TRC}
	     {it:m}=0:      {c |} a       b       c {c |}
                       {c LT}{hline 19}{c RT}
                       {c |} 1       2       3 {c |}
                       {c |} 4       .       . {c |}
                       {c BLC}{hline 19}{c BRC}

                       {c TLC}{hline 19}{c TRC}
	     {it:m}=1:      {c |} a       b       c {c |}
                       {c LT}{hline 19}{c RT}
                       {c |} 1       2       3 {c |}
                       {c |} 4     4.5     8.5 {c |}
                       {c BLC}{hline 19}{c BRC}

                       {c TLC}{hline 19}{c TRC}
	     {it:m}=2:      {c |} a       b       c {c |}
                       {c LT}{hline 19}{c RT}
                       {c |} 1       2       3 {c |}
                       {c |} 4     5.5     9.5 {c |}
                       {c BLC}{hline 19}{c BRC}

{p 4 4 2}
Continuing with jargon, {cmd:a} is a regular variable, {cmd:b} is an imputed
variable, and {cmd:c} is a passive variable.


{marker wide}{...}
    {title:Style wide}

{p 4 4 2}
The above data have been stored in {cmd:miproto.dta} in the wide style.

{* --------------------------------------------------- junk1.smcl ---}{...}
	. {cmd:webuse miproto}

	. {cmd:list}
        {txt}
             {c TLC}{hline 3}{c -}{hline 3}{c -}{hline 3}{c -}{hline 6}{c -}{hline 6}{c -}{hline 6}{c -}{hline 6}{c -}{hline 10}{c TRC}
             {c |} {res}a   b   c   _1_b   _2_b   _1_c   _2_c   _mi_miss {txt}{c |}
             {c LT}{hline 3}{c -}{hline 3}{c -}{hline 3}{c -}{hline 6}{c -}{hline 6}{c -}{hline 6}{c -}{hline 6}{c -}{hline 10}{c RT}
          1. {c |} {res}1   2   3      2      2      3      3          0 {txt}{c |}
          2. {c |} {res}4   .   .    4.5    5.5    8.5    9.5          1 {txt}{c |}
             {c BLC}{hline 3}{c -}{hline 3}{c -}{hline 3}{c -}{hline 6}{c -}{hline 6}{c -}{hline 6}{c -}{hline 6}{c -}{hline 10}{c BRC}
{* --------------------------------------------------- junk1.smcl ---}{...}

{p 4 4 2}
There is no significance to the order in which the variables appear.

{p 4 4 2}
On the left, under variables {cmd:a}, {cmd:b}, and {cmd:c}, you can see 
the original data.

{p 4 4 2}
The imputed values for {cmd:b} appear under the variables named {cmd:_1_b} and
{cmd:_2_b}; {it:m}=1 appears under {cmd:_1_b}, and {it:m}=2 appears under 
{cmd:_2_b}.  Note that in the first observation, the observed value of {cmd:b}
is simply repeated in {cmd:_1_b} and {cmd:_2_b}.  In the second observation,
however, {cmd:_1_b} and {cmd:_2_b} show the replacement values for the missing
value of {cmd:b}.

{p 4 4 2}
The passive values for {cmd:c} appear under the variables named {cmd:_1_c} and
{cmd:_2_c} in the same way that the imputed values appeared under the
variables named {cmd:_1_b} and {cmd:_2_b}.

{p 4 4 2}
Finally, one extra variable appears:  {cmd:_mi_miss}.  This is an example 
of an {cmd:mi} system variable.  You are never to change {cmd:mi} system
variables; they take care of themselves.  The wide style has only one system
variable.  {cmd:_mi_miss} contains 0 for complete observations and 1 for
incomplete observations.


{marker flong}{...}
    {title:Style flong}

{p 4 4 2}
Let's convert this dataset to style flong:

{* --------------------------------------------------- junk2.smcl ---}{...}
	. {cmd:mi convert flong, clear}

	. {cmd:list, separator(2)}
        {txt}
             {c TLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c TRC}
             {c |} {res}a     b     c   _mi_miss   _mi_m   _mi_id {txt}{c |}
             {c LT}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c RT}
          1. {c |} {res}1     2     3          0       0        1 {txt}{c |}
          2. {c |} {res}4     .     .          1       0        2 {txt}{c |}
             {c LT}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c RT}
          3. {c |} {res}1     2     3          .       1        1 {txt}{c |}
          4. {c |} {res}4   4.5   8.5          .       1        2 {txt}{c |}
             {c LT}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c RT}
          5. {c |} {res}1     2     3          .       2        1 {txt}{c |}
          6. {c |} {res}4   5.5   9.5          .       2        2 {txt}{c |}
             {c BLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c BRC}
{* --------------------------------------------------- junk2.smcl ---}{...}

{p 4 4 2}
We listed these data with a separator line after every two rows so that they
would be easier to understand.
Ignore the {cmd:mi} system variables and focus on variables {cmd:a}, {cmd:b},
and {cmd:c}.
Observations 1 and 2 contain {it:m}=0;
observations 3 and 4 contain {it:m}=1;
observations 5 and 6 contain {it:m}=2.

{p 4 4 2}
We will now explain the system variables, but you do not need to remember this.

{p 8 12 2}
1.  We again see {cmd:_mi_miss}, just as we did in the wide style.
    It marks the incomplete observations in {it:m}=0.
    It contains missing in {it:m}>0.  

{p 8 12 2}
2.  {cmd:_mi_m} records {it:m}.  The first two observations are 
    {it:m}=0; the next two, {it:m}=1; and the last two, {it:m}=2.

{p 8 12 2}
3.  {cmd:_mi_id} records an arbitrarily coded observation-identification
     variable.  It is 1 and 2 in {it:m}=0, 
    and then repeats in {it:m}=1 and {it:m}=2.  
    Observations {cmd:_mi_id}=1 correspond to each other for all 
    {it:m}.  The same applies to {cmd:_mi_id}=2.

{p 12 12 2}
    Warning:  Do not use {cmd:_mi_id} as your own ID variable.  You might
    look one time, see that a particular observation has {cmd:_mi_id}=8,
    and look a little later, and see that the observation has changed from
    {cmd:_mi_id}=8 to {cmd:_mi_id}=5.  {cmd:_mi_id} belongs to {cmd:mi}.  If
    you want your own ID variable, make your own.  All that is true of
    {cmd:_mi_id} is that, at any instant, it uniquely identifies, and ties
    together, the observations.

{p 4 4 2}
There is no significance to the order of the variables or, for that matter, 
to the order of the observations.


{marker mlong}{...}
    {title:Style mlong}

{p 4 4 2}
Let's convert this dataset to the mlong style:

{* --------------------------------------------------- junk3.smcl ---}{...}
	. {cmd:mi convert mlong, clear}

	. {cmd:list}
        {txt}
             {c TLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c TRC}
             {c |} {res}a     b     c   _mi_miss   _mi_m   _mi_id {txt}{c |}
             {c LT}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c RT}
          1. {c |} {res}1     2     3          0       0        1 {txt}{c |}
          2. {c |} {res}4     .     .          1       0        2 {txt}{c |}
          3. {c |} {res}4   4.5   8.5          .       1        2 {txt}{c |}
          4. {c |} {res}4   5.5   9.5          .       2        2 {txt}{c |}
             {c BLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c BRC}
{* --------------------------------------------------- junk3.smcl ---}{...}

{p 4 4 2}
This listing will be easier to read if we add some carefully chosen blank 
lines:

             {c TLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c TRC}
             {c |} {res}a     b     c   _mi_miss   _mi_m   _mi_id {txt}{c |}
             {c LT}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c RT}
          1. {c |} {res}1     2     3          0       0        1 {txt}{c |}
          2. {c |} {res}4     .     .          1       0        2 {txt}{c |}
             {c |}                                           {c |}
          3. {c |} {res}4   4.5   8.5          .       1        2 {txt}{c |}
             {c |}                                           {c |}
          4. {c |} {res}4   5.5   9.5          .       2        2 {txt}{c |}
             {c BLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 10}{c -}{hline 7}{c -}{hline 8}{c BRC}

{p 4 4 2}
The mlong style is just like flong except that the complete observations --
observations for which {cmd:_mi_miss}=0 in {it:m}=0 -- are omitted in
{it:m}>0.

{p 4 4 2}
Observations 1 and 2 are the original, {it:m}=0 data.

{p 4 4 2}
Observation 3 is the {it:m}=1 replacement observation for observation 2.

{p 4 4 2}
Observation 4 is the {it:m}=2 replacement observation for observation 2.


{marker flongsep}{...}
    {title:Style flongsep}

{p 4 4 2}
Let's look at these data in the flongsep style:

{* --------------------------------------------------- junk4.smcl ---}{...}
	. {cmd:mi convert flongsep example, clear}
        (files example.dta _1_example.dta _2_example.dta created)

	. {cmd:list}
        {txt}
             {c TLC}{hline 3}{c -}{hline 3}{c -}{hline 3}{c -}{hline 10}{c -}{hline 8}{c TRC}
             {c |} {res}a   b   c   _mi_miss   _mi_id {txt}{c |}
             {c LT}{hline 3}{c -}{hline 3}{c -}{hline 3}{c -}{hline 10}{c -}{hline 8}{c RT}
          1. {c |} {res}1   2   3          0        1 {txt}{c |}
          2. {c |} {res}4   .   .          1        2 {txt}{c |}
             {c BLC}{hline 3}{c -}{hline 3}{c -}{hline 3}{c -}{hline 10}{c -}{hline 8}{c BRC}
{* --------------------------------------------------- junk4.smcl ---}{...}

{p 4 4 2}
The flongsep style stores {it:m}=0, {it:m}=1, and {it:m}=2 in separate files.
When we converted to the flongsep style, we had to specify a name for these
files and we chose {cmd:example}.  This resulted in {it:m}=0 being stored in
{cmd:example.dta}, {it:m}=1 being stored in {cmd:_1_example.dta}, and {it:m}=2
being stored in {cmd:_2_example.dta}.

{p 4 4 2}
In the listing above, we see the original, {it:m}=0 data.

{p 4 4 2}
After conversion, {it:m}=0 ({cmd:example.dta}) was left in memory.
When working with flongsep data, you always work with {it:m}=0 in 
memory.  Nothing can stop us, however, from taking a brief peek:

{* --------------------------------------------------- junk5.smcl ---}{...}
        . {cmd:save example, replace}
        file example.dta saved

        . {cmd:use _1_example, clear}
        (mi prototype)

	. {cmd:list}
        {txt}
             {c TLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 8}{c TRC}
             {c |} {res}a     b     c   _mi_id {txt}{c |}
             {c LT}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 8}{c RT}
          1. {c |} {res}1     2     3        1 {txt}{c |}
          2. {c |} {res}4   4.5   8.5        2 {txt}{c |}
             {c BLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 8}{c BRC}
{* --------------------------------------------------- junk5.smcl ---}{...}

{p 4 4 2}
There are the data for {it:m}=1.  
As previously, system variable {cmd:_mi_id} ties together observations.
In the {it:m}=1 data, however, {cmd:_mi_miss} is not repeated.

{p 4 4 2}
Let's now look at {cmd:_2_example.dta}: 

{* --------------------------------------------------- junk6.smcl ---}{...}
        . {cmd:use _2_example, clear}
        (mi prototype)

	. {cmd:list}
        {txt}
             {c TLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 8}{c TRC}
             {c |} {res}a     b     c   _mi_id {txt}{c |}
             {c LT}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 8}{c RT}
          1. {c |} {res}1     2     3        1 {txt}{c |}
          2. {c |} {res}4   5.5   9.5        2 {txt}{c |}
             {c BLC}{hline 3}{c -}{hline 5}{c -}{hline 5}{c -}{hline 8}{c BRC}
{* --------------------------------------------------- junk6.smcl ---}{...}

{p 4 4 2}
And there are the data for {it:m}=2.

{p 4 4 2}
We have an aside, but an important one.  Review the commands we just 
gave, stripped of their output:

	. {cmd:mi convert flongsep example, clear}
	. {cmd:list}
        . {cmd:save example, replace}
        . {cmd:use _1_example, clear}
	. {cmd:list}
        . {cmd:use _2_example, clear}
	. {cmd:list}

{p 4 4 2}
What we want you to notice is the line {cmd:save} {cmd:example,} {cmd:replace}.
After converting to flongsep, for some reason we felt obligated to 
save the dataset.  We will explain below.  Now look farther down the history.
After using {cmd:_1_example.dta}, we did not feel obligated to resave 
that dataset before using {cmd:_2_example.dta}.  We will explain that below,
too.

{p 4 4 2}
The flongsep style data are a matched set of datasets.  You work with the 
{it:m}=0 dataset in memory.  It is your responsibility to save that 
dataset.  Sometimes {cmd:mi} will have already saved the dataset 
for you.  That was true here after {cmd:mi} {cmd:convert},
but it is impossible for you to know that in general, and it is your 
responsibility to save the dataset just as you would save any other dataset.

{p 4 4 2}
The {it:m}>0 datasets, {cmd:_}{it:#}{cmd:_}{it:name}{cmd:.dta}, are 
{cmd:mi}'s responsibility.  We do not have to concern ourselves with 
saving them.  Obviously, it was not necessary to save them here 
because we had just used the data and made no changes.  The point is 
that, in general, {it:m}>0 datasets are not our responsibility.  The {it:m}=0
dataset, however, is our responsibility.

{p 4 4 2}
We are done with the demonstration:

{* --------------------------------------------------- junk7.smcl ---}{...}
        . {cmd:drop _all}

        . {cmd:mi erase example}
        (files example.dta _1_example.dta _2_example.dta erased)
{* --------------------------------------------------- junk7.smcl ---}{...}


{marker how}{...}
    {title:How we constructed this example}

{p 4 4 2}
You might be curious as to how we constructed {cmd:miproto.dta}.  Here is what
we did:

{* --------------------------------------------------- junk8.smcl ---}{...}
        . {cmd:drop _all}

        . {cmd:input a b}

             {txt}        a          b
          1{cmd}. 1 2 
        {txt}  2{cmd}. 4 .
        {txt}  3{cmd}. end
        {txt}
        . {cmd}mi set wide
        {txt}
        . {cmd}mi set M = 2 
        {txt}
        . {cmd}mi register regular a
        {txt}
        . {cmd}mi register imputed b
        {txt}
        . {cmd}replace _1_b = 4.5 in 2
        {txt}
        . {cmd}replace _2_b = 5.5 in 2
        {txt}
        . {cmd}mi passive: gen c = a + b
        {txt}
        . {cmd}order a b c _1_b _2_b _1_c _2_c _mi_miss{txt}
{* --------------------------------------------------- junk8.smcl ---}{...}


{marker sysvars}{...}
{title:Using mi system variables}

{p 4 4 2}
You can use {cmd:mi}'s system variables to make some tasks easier.
For instance, if you wanted to know the overall number of complete 
and incomplete observations, you could type 

	. {cmd:tabulate _mi_miss}

{p 4 4 2}
because in all styles, the {cmd:_mi_miss} variable is created in {it:m}=0
containing 0 if complete and 1 if incomplete.

{p 4 4 2}
If you wanted to know the summary statistics for 
{cmd:weight} in {it:m}=1, the general solution is

        . {cmd:mi xeq 1: summarize weight}

{p 4 4 2}
If you were using wide data, however, you could instead type

        . {cmd:summarize _1_weight}

{p 4 4 2}
If you were using flong data, you could type 

        . {cmd:summarize weight if _mi_m==1}

{p 4 4 2}
If you were using mlong data, you could type 

	. {cmd:summarize weight if (_mi_m==0 & !_mi_miss) | _mi_m==1}

{p 4 4 2}
Well, that last is not so convenient.

{p 4 4 2}
What is convenient to do directly depends on the style you are using.
Remember, however, you can always switch between styles by using 
{bf:{help mi_convert:mi convert}}.  
If you were using mlong data and wanted to compare summary statistics of
the {cmd:weight} variable in the original data and in all imputations, you could
type

	. {cmd:mi convert wide}

	. {cmd:summarize *weight}


{marker advice_flongsep}{...}
{title:Advice for using flongsep}

{p 4 4 2}
Use the flongsep style when your data are too big to fit into any of the other 
styles.  If you already have flongsep data, you can try to convert it 
to another style.  If you get the error "no room to add more observations"
or "no room to add more variables", then you need to increase the 
amount of memory Stata is allowed to use (see {bf:{help memory:[D] memory}}) or
resign yourself to using the flongsep style.

{p 4 4 2}
There is nothing wrong with the flongsep style except that you need to learn 
some new habits.  Usually, in Stata, you work with a copy of the data in 
memory, and the changes you make are not reflected in the underlying 
disk file until and unless you explicitly save the data.  If you want 
to change the name of the data, you merely save them in a file of a 
different name.  None of that is true when working with flongsep data.
Flongsep data are a collection of datasets; you work with the one 
corresponding to {it:m}=0 in memory, and {cmd:mi} handles keeping the 
others in sync.  As you make changes, the datasets on disk change.

{p 4 4 2}
Think of the collection of datasets as having one name.  That name is
established when the flongsep data are created.  There are three ways that can
happen.  You might start with a non-{cmd:mi} dataset in memory and {cmd:mi}
{cmd:set} it; you might import a dataset into Stata and the result be
flongsep; or you might convert another {cmd:mi} dataset to flongsep.
Here are all the corresponding commands:

	. {cmd:mi set flongsep} {it:name}{right:(1)     }

	. {cmd:mi import flongsep} {it:name}{right:(2)     }
	. {cmd:mi import nhanes1}  {it:name}

	. {cmd:mi convert flongsep} {it:name}{right:(3)     }

{p 4 4 2}
In each command, you specify a name and that name becomes the name of 
the flongsep dataset collection.  In particular, 
{it:name}{cmd:.dta} becomes {it:m}=0, 
{cmd:_1_}{it:name}{cmd:.dta} becomes {it:m}=1, 
{cmd:_2_}{it:name}{cmd:.dta} becomes {it:m}=2, 
and so on.
You {bf:{help use}} flongsep data by typing {cmd:use} {it:name}, just as you
would any other dataset.  As we said, you work with {it:m}=0 in memory 
and {cmd:mi} handles the rest.

{p 4 4 2}
Flongsep data are stored in the current (working) directory.  Learn about
{bf:{help pwd}} to find out where you are and about {bf:{help cd}} to change
that; see {bf:{help cd:[D] cd}}.

{p 4 4 2}
As you work with flongsep data, it is your responsibility to {bf:{help save}}
{it:name}{cmd:.dta} almost as it would be with any Stata dataset.  The
difference is that {cmd:mi} might and probably has saved {it:name}{cmd:.dta}
along the way without mentioning the fact, and {cmd:mi} has doubtlessly 
updated the {cmd:_}{it:#}{cmd:_}{it:name}{cmd:.dta} datasets, too.
Nevertheless, it is still your responsibility to {cmd:save} {it:name}{cmd:.dta}
when you are done because you do not know whether {cmd:mi} has saved
{it:name}{cmd:.dta} recently enough.  It is not your responsibility to worry
about {cmd:_}{it:#}{cmd:_}{it:name}{cmd:.dta}.

{p 4 4 2}
It is a wonderful feature of Stata that you can usually work with a dataset 
in memory without modifying the original copy on disk except when you 
intend to update it.  It is an unpleasant feature of flongsep that the same 
is not true.  We therefore recommend working with a copy of the data, 
and {cmd:mi} provides an {helpb mi copy} command for just that 
purpose:

        . {cmd:mi copy} {it:newname}

{p 4 4 2}
With flongsep data in memory, when you type {cmd:mi} {cmd:copy} {it:newname}, 
the current flongsep files are saved in their existing name (this is one 
case where you are not responsible for saving {it:name}{cmd:.dta}), and 
then the files are copied to {it:newname}, meaning that
{it:m}=0 is copied to {it:newname}{cmd:.dta}, 
{it:m}=1 is copied to {cmd:_1_}{it:newname}{cmd:.dta}, 
and so on.  You are now working with the same data, but with the new name 
{it:newname}.

{p 4 4 2}
As you work, you may reach a point where you would like to save the 
data collection under {it:name} and continue working with {it:newname}.
Do the following:

	. {cmd:mi copy} {it:name}{cmd:, replace}

        . {cmd:use} {it:newname}

{p 4 4 2}
When you are done for the day, if you want your data saved, do not forget 
to save them by using {cmd:mi} {cmd:copy}.  It is also a good idea to 
erase the flongsep {it:newname} dataset collection:

	. {cmd:mi copy} {it:name}{cmd:, replace}

	. {cmd:mi erase} {it:newname}

{p 4 4 2}
By the way, {it:name}{cmd:.dta}, {cmd:_1_}{it:name}{cmd:.dta}, ... are just
ordinary Stata datasets.  By using general (non-{cmd:mi}) Stata commands, 
you can look at them and even make changes to them.  Be careful about 
doing the latter; see {bf:{help mi_technical:[MI] Technical}}.

{p 4 4 2}
See {bf:{help mi_copy:[MI] mi copy}} to learn more about {cmd:mi} {cmd:copy}.
{p_end}
