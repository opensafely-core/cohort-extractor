{smcl}
{* *! version 1.1.6  11may2018}{...}
{vieweralsosee "[M-1] Interactive" "mansection M-1 Interactive"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Description" "m1_interactive##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_interactive##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_interactive##remarks"}{...}
{viewerjumpto "Review" "m1_interactive##review"}{...}
{viewerjumpto "Reference" "m1_interactive##reference"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-1] Interactive} {hline 2}}Using Mata interactively
{p_end}
{p2col:}({mansection M-1 Interactive:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{p 4 4 2}
With Mata, you simply type matrix formulas to obtain the desired
results.  Below we provide guidelines when doing this with statistical 
formulas.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 InteractiveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
You have data and statistical formulas that you wish to calculate, such as
{bind:{bf:b} = ({bf:X}'{bf:X})^(-1){bf:X}'{bf:y}}.  Perform the following nine
steps:

{p 8 12 2}
    1.  Start in Stata.  Load the data.

{p 8 12 2}
    2.  If you are doing time-series analysis, generate new variables
        containing any {it:op}{cmd:.}{it:varname} variables you need, such as
        {cmd:l.gnp} or {cmd:d.r}.

{p 8 12 2}
    3.  Create a constant variable (. {cmd:gen} {cmd:cons} {cmd:=} {cmd:1}).
        In most statistical formulas, you will find it useful.

{p 8 12 2}
    4.  Drop variables that you will not need.
        This saves memory and makes some things easier because you can 
        just refer to all the variables.

{p 8 12 2}
    5.  Drop observations with missing values.  
        Mata understands missing values, but Mata is a matrix language, not a
        statistical system, so Mata does not always ignore observations with
        missing values.

{p 8 12 2}
    6.  Put variables on roughly the same numeric scale.
        This is optional, but we recommend it.  We explain what we mean and
        how to do this below.

{p 8 12 2}
    7.  Enter Mata.
        Do that by typing {cmd:mata} at the Stata command prompt.  Do not type
        a colon after the {cmd:mata}.  This way, when you make a mistake, you
        will stay in Mata.

{p 8 12 2}
    8.  Use Mata's {bf:{help mf_st_view:[M-5] st_view()}} function to create 
        matrices based on your Stata dataset.  Create all the matrices you want 
        or find convenient.  The matrices created by {cmd:st_view()} 
        are in fact views onto one copy of the data.

{p 8 12 2}
    9.  Perform your matrix calculations.

{pstd}If you are reading the entries in the order suggested in
{bf:{help mata:[M-0] Intro}}, see {bf:{help m1_how:[M-1] How}} next.


{title:1.  Start in Stata; load the data}

{p 4 4 2}
We will use the {cmd:auto} dataset and will fit the regression 

		{cmd:mpg}_{it:j} = {it:b0} + {it:b1}*{cmd:weight}_{it:j} + {it:b2}*{cmd:foreign}_{it:j} + {it:e}_{it:j}

{p 4 4 2}
by using the formulas

	        {bf:b} = ({bf:X}'{bf:X})^(-1){bf:X}'{bf:y}

	        {bf:V} = {it:s}^2*({bf:X}'{bf:X})^(-1)

	where

              {it:s}^2 = {bf:e}'{bf:e}/({it:n}-{it:k})

		{bf:e} = {bf:y} - {bf:X}*{bf:b}

		{it:n} = rows({bf:X})

		{it:k} = cols({bf:X})

{p 4 4 2}
We begin by typing

	. {cmd:sysuse auto}
	(1978 Automobile data)


{title:2.  Create any time-series variables}

{p 4 4 2}
We do not have any time-series variables but, just for a minute, let's 
pretend we did.  If our model contained 
lagged {cmd:gnp}, we would type

	. {cmd: gen lgnp = l.gnp}

{p 4 4 2}
so that we would have a new variable {cmd:lgnp} that we would use in place 
of {cmd:l.gnp} in the subsequent steps.


{title:3.  Create a constant variable}

	. {cmd:gen cons = 1}


{title:4.  Drop unnecessary variables}

{p 4 4 2}
We will need the variables {cmd:mpg}, {cmd:weight}, {cmd:foreign}, and
{cmd:cons}, so it is easier for us to type {cmd:keep} instead of {cmd:drop}:

	. {cmd:keep mpg weight foreign cons}


{title:5.  Drop observations with missing values}

{p 4 4 2}
We do not have any missing values in our data, but let's pretend we did, 
or let's pretend we are uncertain.  Here is an easy trick for getting 
rid of observations with missing values:

	. {cmd:regress mpg weight foreign cons}
	{it:(output omitted)}

	. {cmd:keep if e(sample)}

{p 4 4 2}
We estimated a regression using all the variables and then 
kept the observations {cmd:regress} chose to use.  It does not 
matter which variable you choose as the dependent variable, nor the order
of the independent variables, so we 
just as well could have typed

	. {cmd:regress weight mpg foreign cons}
	{it:(output omitted)}

	. {cmd:keep if e(sample)}

{p 4 4 2}
or even 

	. {cmd:regress cons mpg weight foreign}
	{it:(output omitted)}

	. {cmd:keep if e(sample)}

{p 4 4 2}
The output produced by {cmd:regress} is irrelevant, even if some variables are
dropped.  We are merely borrowing {cmd:regress}'s ability to identify the
subsample with no missing values.

{p 4 4 2}
Using {cmd:regress} causes Stata to make many unnecessary calculations and,
if that offends you, here is a more sophisticated alternative:

	. {cmd:local 0 "mpg weight foreign cons"}

	. {cmd:syntax varlist}

	. {cmd:marksample touse}

	. {cmd:keep if `touse'}

	. {cmd:drop `touse'}

{p 4 4 2}
Using {cmd:regress} is easier.


{title:6.  Put variables on roughly the same numeric scale}

{p 4 4 2}
This step is optional, but we recommend it.  You are about to use formulas
that have been derived by people who assumed that the usual rules of arithmetic
hold, such as ({it:a}+{it:b})-{it:c} = {it:a}+({it:b}-{it:c}).  Many of the
standard rules, such as the one shown, are violated when arithmetic is
performed in finite precision, and this leads to roundoff error in the final,
calculated results.

{p 4 4 2}
You can obtain a lot of protection by making sure that your variables are on 
roughly the same scale, by which we mean their means and standard deviations
are all roughly equal.  By roughly equal, we mean equal up to a factor of
1,000 or so.  So let's look at our data:

	. {cmd:summarize}

        {txt}    Variable {c |}       Obs        Mean    Std. Dev.       Min        Max
        {hline 13}{c +}{hline 56}
                 mpg {c |}{res}        74     21.2973    5.785503         12         41
              {txt}weight {c |}{res}        74    3019.459    777.1936       1760       4840
             {txt}foreign {c |}{res}        74    .2972973    .4601885          0          1
                {txt}cons {c |}{res}        74           1           0          1          1{txt}

{p 4 4 2}
Nothing we see here bothers us much.  Variable {cmd:weight} is the largest,
with a mean and standard deviation that are 1,000 times larger than those of the
smallest variable, {cmd:foreign}.  We would feel comfortable, but only 
barely, ignoring scale differences.  If {cmd:weight} were 10 times larger,
we would begin to be concerned, and our concern would grow as {cmd:weight}
grew.

{p 4 4 2}
The easiest way to address our concern is to divide {cmd:weight} so
that, rather than measuring weight in pounds, it measures weight in 
thousands of pounds:

	. {cmd:replace weight = weight/1000}

	. {cmd:summarize}

        {txt}    Variable {c |}       Obs        Mean    Std. Dev.       Min        Max
        {hline 13}{c +}{hline 56}
                 mpg {c |}{res}        74     21.2973    5.785503         12         41
              {txt}weight {c |}{res}        74    3.019459    .7771936       1.76       4.84
             {txt}foreign {c |}{res}        74    .2972973    .4601885          0          1
                {txt}cons {c |}{res}        74           1           0          1          1{txt}

{p 4 4 2}
What you are supposed to do is make the means and standard deviations of the
variables roughly equal.  If {cmd:weight} had a large mean and reasonable
standard deviation, we would have subtracted, so that we would have had a
variable measuring weight in excess of some number of pounds.  Or we could do
both, subtracting, say, 2,000 and then dividing by 100, so we would have weight
in excess of 2,000 pounds, measured in 100-pound units.

{p 4 4 2}
Remember, the definition of roughly equal allows lots of leeway, so you 
do not have to give up easy interpretation.


{title:7.  Enter Mata}

{p 4 4 2}
We type 

	. {cmd:mata}
        {txt}{hline 38} mata (type {cmd:end} to exit) {hline}
	: {cmd:_}
	
{p 4 4 2}
Mata uses a colon prompt, whereas Stata uses a period.


{title:8.  Use st_view() to access your data}

{p 4 4 2}
Our matrix formulas are 

	        {bf:b} = ({bf:X}'{bf:X})^(-1){bf:X}'{bf:y}

	        {bf:V} = {it:s}^2*({bf:X}'{bf:X})^(-1)

	where

              {it:s}^2 = {bf:e}'{bf:e}/({it:n}-{it:k})

		{bf:e} = {bf:y} - {bf:X}*{bf:b}

		{it:n} = rows({bf:X})

		{it:k} = cols({bf:X})
	        
{p 4 4 2} 
so we are going to need {bf:y} and {cmd:X}.  {bf:y} is an {it:n} {it:x} 1
column vector of dependent-variable values, and {bf:X} is an {it:n}
{it:x} {it:k} matrix of the {it:k} independent variables, including the
constant.  Rows are observations, columns are variables.

{p 4 4 2}
We make the vector and matrix as follows:

	: {cmd:st_view(y=., ., "mpg")}

	: {cmd:st_view(X=., ., ("weight", "foreign", "cons"))}

{p 4 4 2}
Let us explain.  We wish we could type 

	: {cmd:y = st_view(., "mpg")}

	: {cmd:X = st_view(., ("weight", "foreign", "cons"))}

{p 4 4 2}
because that is what the functions are really doing.  We cannot
because {helpb mf_st_view:st_view()} (unlike all other Mata functions), returns
a special kind of matrix called a view.  A view acts like a regular matrix in
nearly every respect, but views do not consume nearly as much memory, because
they are in fact views onto the underlying Stata dataset!

{p 4 4 2}
We could instead create {cmd:y} and {cmd:X} with Mata's 
{bf:{help mf_st_data:[M-5] st_data()}} function, and then we could type the
creation of {cmd:y} and {cmd:X} the natural way,

	: {cmd:y = st_data(., "mpg")}

	: {cmd:X = st_data(., ("weight", "foreign", "cons"))}

{p 4 4 2}
{cmd:st_data()} returns a real matrix, which is a copy of the data Stata has
stored in memory.

{p 4 4 2}
We could use {cmd:st_data()} and be done with the problem.  For
our automobile-data example, that would be a fine solution.  But were the
automobile data larger, you might run short of memory, and views can save lots
of memory.  You can create views willy-nilly -- lots and lots of them -- and
never consume much memory!  Views are wonderfully convenient and it is worth
mastering the little bit of syntax to use them.

{p 4 4 2}
{cmd:st_view()} requires three arguments:  the name of the view matrix 
to be created, the observations (rows) the matrix is to contain, and the
variables (columns).  If we wanted to create a view matrix
{cmd:Z} containing all the observations and all the variables, we could type

	: {cmd:st_view(Z, ., .)}

{p 4 4 2}
{cmd:st_view()} understands missing value in the second and third positions to
mean all the observations and all the variables.  Let's try it:

	: {cmd:st_view(Z, ., .)}
	                 {err:<istmt>:  3499  Z not found}
        r(3499);

	: {cmd:_}

{p 4 4 2}
That did not work because Mata requires {cmd:Z} to be predefined.  The reasons
are technical, but it should not surprise you that function arguments need to
be defined before a function can be used.  Mata just does not understand that
{cmd:st_view()} really does not need {cmd:Z} defined.  The way around Mata's
confusion is to define {cmd:Z} and then let {cmd:st_view()} redefine it:

	: {cmd:Z = .}

	: {cmd:st_view(Z, ., .)}

{p 4 4 2}
You can, if you wish, combine all that into one statement


	: {cmd:st_view(Z=., ., .)}

{p 4 4 2}
and that is what we did when we defined {cmd:y} and {cmd:X}:

	: {cmd:st_view(y=., ., "mpg")}

	: {cmd:st_view(X=., ., ("weight", "foreign", "cons"))}

{p 4 4 2}
The second argument ({cmd:.}) specified that we wanted all the observations,
and the third argument specified the variables we wanted.  Be careful not to
omit the "extra" parentheses when typing the variables.  Were you to type

	: {cmd:st_view(X=., ., "weight", "foreign", "cons")}

{p 4 4 2}
you would be told you typed an invalid expression.  {cmd:st_view()} expects
three arguments, and the third argument is a row vector specifying the
variables to be selected:  {cmd:("weight",} {cmd:"foreign",} {cmd:"cons")}.

{p 4 4 2}
At this point, we suggest you type 

	: {cmd:y}
	{it:(output omitted)}

	: {cmd:X}
	{it:(output omitted)}

{p 4 4 2} 
to see that {cmd:y} and {cmd:X} really do contain our data.  In case 
you have lost track of what we have typed, here is our complete session so
far:

	. {cmd:sysuse auto}
	. {cmd:gen cons = 1}
	. {cmd:keep mpg weight foreign cons}
	. {cmd:regress mpg weight foreign cons}
	. {cmd:keep if e(sample)}
	. {cmd:replace weight = weight/1000}
	. {cmd:mata}
	: {cmd:st_view(y=., ., "mpg")}
	: {cmd:st_view(X=., ., ("weight", "foreign", "cons"))}


{title:9.  Perform your matrix calculations}

{p 4 4 2}
To remind you: our matrix calculations are

	        {bf:b} = ({bf:X}'{bf:X})^(-1){bf:X}'{bf:y}

	        {bf:V} = {it:s}^2*({bf:X}'{bf:X})^(-1)

	where

              {it:s}^2 = {bf:e}'{bf:e}/({it:n}-{it:k})

		{bf:e} = {bf:y} - {bf:X}*{bf:b}

		{it:n} = rows({bf:X})

		{it:k} = cols({bf:X})

{p 4 4 2}
Let's get our regression coefficients, 

	: {cmd:b = invsym(X'X)*X'y}

	: {cmd:b}
        {res}       {txt}           1
            {c TLC}{hline 16}{c TRC}
          1 {c |}  {res}-6.587886358{txt}  {c |}
          2 {c |}  {res}-1.650029004{txt}  {c |}
          3 {c |}  {res} 41.67970227{txt}  {c |}
            {c BLC}{hline 16}{c BRC}{txt}

{p 4 4 2}
and let's form the residuals, define {it:n} and {it:k}, and 
obtain {it:s}^2,

	: {cmd:e  = y - X*b}
	: {cmd:n  = rows(X)}
	: {cmd:k  = cols(X)}
	: {cmd:s2 = (e'e)/(n-k)}

{p 4 4 2}
so we are able to calculate the variance matrix:

	: {cmd:V = s2*invsym(X'X)}
	: {cmd:V}
        {res}{txt}[symmetric]
                          1              2              3
            {c TLC}{hline 46}{c TRC}
          1 {c |}  {res} .4059128628                              {txt}  {c |}
          2 {c |}  {res} .4064025078    1.157763273               {txt}  {c |}
          3 {c |}  {res}-1.346459802    -1.57131579    4.689594304{txt}  {c |}
            {c BLC}{hline 46}{c BRC}{txt}

{p 4 4 2}
We are done.

{p 4 4 2}
We can present the results in more readable fashion by pulling the diagonal of
{it:V} and calculating the square root of each element:

	: {cmd:se = sqrt(diagonal(V))}
	: {cmd:(b, se)}
        {res}       {txt}           1              2
            {c TLC}{hline 31}{c TRC}
          1 {c |}  {res}-6.587886358    .6371129122{txt}  {c |}
          2 {c |}  {res}-1.650029004    1.075994086{txt}  {c |}
          3 {c |}  {res} 41.67970227    2.165547114{txt}  {c |}
            {c BLC}{hline 31}{c BRC}{txt}

{p 4 4 2}
You know that if we were to type 

	: {cmd:2+3}
	  5

{p 4 4 2}
Mata evaluates the expression and shows us the result, and that is 
exactly what happened when we typed 

	: {cmd:(b, se)}

{p 4 4 2}
{cmd:(b,} {cmd:se)} is an expression, and Mata evaluated it and displayed the
result.  The expression means to form the matrix whose first column is
{cmd:b} and second column is {cmd:se}.  We could obtain a listing of the
coefficient, standard error, and its t statistic by asking Mata to display
{cmd:(b, se, b:/se)},

	: {cmd:(b, se, b:/se)}
        {res}       {txt}           1              2              3
            {c TLC}{hline 46}{c TRC}
          1 {c |}  {res}-6.587886358    .6371129122   -10.34021793{txt}  {c |}
          2 {c |}  {res}-1.650029004    1.075994086   -1.533492633{txt}  {c |}
          3 {c |}  {res} 41.67970227    2.165547114    19.24673077{txt}  {c |}
            {c BLC}{hline 46}{c BRC}{txt}

{p 4 4 2}
In the expression above, {cmd:b:/se} means to divide the elements of {cmd:b} 
by the elements of {cmd:se}.  {cmd::/} is called a colon operator and 
you can learn more about it by seeing 
{bf:{help m2_op_colon:[M-2] op_colon}}.

{p 4 4 2}
We could add the significance level by typing

	: {cmd:(b, se, b:/se, 2*ttail(n-k, abs(b:/se)))}
        {res}       {txt}           1              2              3              4
            {c TLC}{hline 61}{c TRC}
          1 {c |}  {res}-6.587886358    .6371129122   -10.34021793    8.28286e-16{txt}  {c |}
          2 {c |}  {res}-1.650029004    1.075994086   -1.533492633     .129598713{txt}  {c |}
          3 {c |}  {res} 41.67970227    2.165547114    19.24673077    6.89556e-30{txt}  {c |}
            {c BLC}{hline 61}{c BRC}{txt}

{p 4 4 2}
Those are the same results reported by {cmd:regress}; type 

	. {cmd:sysuse auto}
	. {cmd:replace weight = weight/1000}
	. {cmd:regress mpg weight foreign}

{p 4 4 2}
and compare results.


{marker review}{...}
{title:Review}

{p 4 4 2}
Our complete session was

	. {cmd:sysuse auto}
	. {cmd:gen cons = 1}
	. {cmd:keep mpg weight foreign cons}
	. {cmd:regress mpg weight foreign cons}
	. {cmd:keep if e(sample)}
	. {cmd:replace weight = weight/1000}

	. {cmd:mata}
	: {cmd:st_view(y=., ., "mpg")}
	: {cmd:st_view(X=., ., ("weight", "foreign", "cons"))}

	: {cmd:b = invsym(X'X)*X'y}
	: {cmd:b}
	: {cmd:e = y - X*b}
	: {cmd:n = rows(X)}
	: {cmd:k = cols(X)}
	: {cmd:s2= (e'e)/(n-k)}
	: {cmd:V = s2*invsym(X'X)}
	: {cmd:V}

	: {cmd:se = sqrt(diagonal(V))}
	: {cmd:(b, se)}
	: {cmd:(b, se, b:/se)}
	: {cmd:(b, se, b:/se, 2*ttail(n-k, abs(b:/se)))}
	: {cmd:end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2006.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0024":Mata Matters: Interactive use}.
{it:Stata Journal} 6: 387-396.
{p_end}
