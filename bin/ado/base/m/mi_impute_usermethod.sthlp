{smcl}
{* *! version 1.2.3  10may2018}{...}
{vieweralsosee "[MI] mi impute usermethod" "mansection MI miimputeusermethod"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Syntax" "mi_impute_usermethod##syntax"}{...}
{viewerjumpto "Description" "mi_impute_usermethod##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute_usermethod##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute_usermethod##options"}{...}
{viewerjumpto "Remarks and examples" "mi_impute_usermethod##remarks"}{...}
{viewerjumpto "Stored results" "mi_impute_usermethod##results"}{...}
{viewerjumpto "Acknowledgment" "mi_impute_usermethod##ack"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[MI]} {it:mi impute usermethod} {hline 2}}User-defined imputation methods{p_end}
{p2col:}({mansection MI miimputeusermethod:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {it:usermethod} {it:userspec}
[{cmd:,}
{it:{help mi_impute_usermethod##options_table:options}}]

{marker usermethod}{...}
{phang}
{it:usermethod} is the name of the method you would like to add to the
{cmd:mi impute} command.  When naming an {cmd:mi impute} method, you should
follow the same convention as for naming the programs you add to Stata -- do
not pick "nice" names that may later be used by Stata's official methods.

{marker userspec}{...}
{phang}
{it:userspec} is a specification of an imputation model as supported by the
user-defined method {it:usermethod}.  It must include imputation variables
{it:ivars}.  It may also include independent variables {it:indepvars}, 
{help weight}s, and an {help if:{it:if}} qualifier if those things are also
supported by {it:usermethod}.  The actual syntax of {it:userspec} will be
specific to {it:usermethod}.  We encourage users who are adding their own
methods to {cmd:mi impute} to follow {helpb mi impute}'s syntax or Stata's
general {help syntax} when designing their methods.

{marker options_table}{...}
{synoptset 22}{...}
{synopthdr:options}
{synoptline}
{synopt: {it:impute_options}}any option of {helpb mi_impute##impopts:mi impute} except {cmd:noupdate} and {cmd:by()}{p_end}
{synopt: {opt orderasis}}impute variables in the specified order{p_end}
{synopt: {it:user_options}}additional options supported by {it:usermethod}{p_end}
{synoptline}
{p 4 6 2}
You must {cmd:mi set} your data before using {cmd:mi} {cmd:impute}
{it:usermethod}; see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
You must {cmd:mi register} imputation variables as {cmd:imputed} before using
{cmd:mi} {cmd:impute} {it:usermethod}; see {manhelp mi_set MI:mi set}.{p_end}


{marker description}{...}
{title:Description}

{pstd}
This entry describes how to add your own imputation methods to the {cmd:mi}
{cmd:impute} command.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputeusermethodRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:impute_options} include {cmd:add()}, {cmd:replace}, {cmd:rseed()},
{cmd:double}, {cmd:dots}, {cmd:noisily}, {cmd:nolegend}, {cmd:force}; see
{manhelp mi_impute MI:mi impute} for details.

{phang}
{cmd:orderasis} requests that the variables be imputed in the specified order.
By default, variables are imputed in order from the most observed to the least
observed.

{phang}
{it:user_options} specify any additional options supported by {it:usermethod}.


{marker remarks}{...}
{title:Remarks and examples}

{pstd}
Adding your own methods to {cmd:mi impute} is rather straightforward.  Suppose
that you want to add a method called {cmd:mymethod} to {cmd:mi impute}.

{phang}
1.  Write an ado-file that contains a {help program:program} called
   {cmd:mi_impute_cmd_mymethod_parse} to parse your imputation model.

{phang}
2.  Write an ado-file that contains a {help program:program} called
   {cmd:mi_impute_cmd_mymethod}, which will perform a single imputation
   on all of your imputation variables.

{phang}
3.  Place the ado-files where Stata can find them.

{pstd}
You are done.  You can now use {cmd:mymethod} within {cmd:mi impute} like any
other official {cmd:mi impute} method.  {cmd:mi impute} will take care of
performing your imputation step multiple times and will do it properly for any
{help mi_styles:{bf:mi} style}.

{pstd}
Remarks are presented under the following headings:

{p 8 8 2}{help mi_impute_usermethod##introex:Toy example: Naive regression imputation}{p_end}
{p 8 8 2}{help mi_impute_usermethod##steps:Steps for adding a new method to mi impute}{p_end}
{p 12 12 2}{help mi_impute_usermethod##parserdef:Writing an imputation parser}{p_end}
{p 12 12 2}{help mi_impute_usermethod##initializerdef:Writing an initializer}{p_end}
{p 12 12 2}{help mi_impute_usermethod##imputerdef:Writing an imputer}{p_end}
{p 12 12 2}{help mi_impute_usermethod##returndef:Storing additional results}{p_end}
{p 12 12 2}{help mi_impute_usermethod##cleanupdef:Writing a cleanup program}{p_end}
{p 8 8 2}{help mi_impute_usermethod##examples:Examples}{p_end}
{p 12 12 2}{help mi_impute_usermethod##exnaive_init:Naive regression imputation}{p_end}
{p 12 12 2}{help mi_impute_usermethod##exregress:Univariate regression imputation}{p_end}
{p 12 12 2}{help mi_impute_usermethod##exmonotone:Multivariate monotone imputation}{p_end}
{p 8 8 2}{help mi_impute_usermethod##glmacros:Global macros}{p_end}


{marker introex}{...}
{title:Toy example: Naive regression imputation}

{pstd}
As a quick example, let's write a method called {cmd:naivereg} to perform a
naive regression imputation, also known as stochastic regression imputation,
of a single variable {it:ivar} based on independent variables {it:xvars}.

{pstd}
First, let's describe our imputation procedure.

{phang}
1.  Regress {it:ivar} on {it:xvars} using the observed data.

{phang}
2.  Obtain the linear predictor, {it:xb}.

{phang}
3.  Replace missing values in {it:ivar} with {it:xb} plus a random error
    generated from N(0,{it:sigma_mle}), where {it:sigma_mle} is the estimated
    error standard deviation.

{pstd}
Let's now write our imputation program.  We create an ado-file called
{cmd:mi_impute_cmd_naivereg.ado} that contains the following Stata program:

{p 8 14 2}// imputer{p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_naivereg}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}/* step 1: run regression on observed data */{p_end}
{p 16 20 2}{cmd:quietly regress $MI_IMPUTE_user_ivar $MI_IMPUTE_user_xvars}{p_end}
{p 16 20 2}/* step 2: compute linear prediction */{p_end}
{p 16 20 2}{cmd:tempvar xb}{p_end}
{p 16 20 2}{cmd:quietly predict double `xb', xb}{p_end}
{p 16 20 2}/* step 3: replace missing values */{p_end}
{p 16 20 2}{cmd:quietly replace $MI_IMPUTE_user_ivar = `xb' + rnormal(0,e(rmse))} ///{p_end}
{p 26 30 2}{cmd:           if $MI_IMPUTE_user_miss==1}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
Global macros {cmd:MI_IMPUTE_user_ivar} and {cmd:MI_IMPUTE_user_xvars} contain
the names of the imputation and independent variables, respectively, and
{cmd:MI_IMPUTE_user_miss} contains the indicator for missing values in the
imputation variable. {helpb ereturn} scalar {cmd:e(rmse)} contains the
estimated error standard deviation from the {helpb regress} command
used in step 1. The {helpb rnormal()} function is used to generate values from
a normal distribution.

{pstd}
In addition to the imputer, we also need to write a parser program that passes
the imputation model specification to {cmd:mi impute}.  We create an ado-file
called {cmd:mi_impute_cmd_naivereg_parse.ado} that contains the following
simple program:

{p 8 14 2}// parser{p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_naivereg_parse}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}{cmd:syntax anything [, * ]}{p_end}
{p 16 20 2}{cmd:gettoken ivar xvars : anything}{p_end}
{p 16 20 2}{cmd:u_mi_impute_user_setup, ivars(`ivar') xvars(`xvars') `options'}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
The parser retrieves the information about imputation and independent
variables to be supplied by the user and passes it to {cmd:mi impute} via the
utility program {cmd:u_mi_impute_user_setup}, which will be discussed later.

{pstd}
We can now use {cmd:naivereg} with {cmd:mi impute}.  For demonstration
purposes only, let's use our new method to impute missing values of variable
{cmd:rep78} from the {cmd:auto} dataset.  We will use complete variables
{cmd:mpg} and {cmd:weight} as predictors.

{pstd}
We load the data, declare the {cmd:mi} style, and register {cmd:rep78} as
an imputation variable.

{com}. sysuse auto, clear
{com}. mi set wide
{com}. mi register imputed rep78
{res}{txt}

{pstd}
We now use our new method {cmd:naivereg} within {cmd:mi impute}.

{com}. mi impute naivereg rep78 mpg weight, add(2)
{res}{txt}
Multiple imputation{txt}{col 45}{ralign 12:Imputations }= {res}       2
{txt}{txt}User method {cmd}naivereg{txt}{col 45}{ralign 12:added }= {res}       2
{txt}Imputed: {it:m}=1 through {it:m}=2{txt}{col 45}{ralign 12:updated }= {res}       0

{txt}{hline 19}{c TT}{hline 35}{hline 11}
{txt}{col 20}{c |}{center 46:  Observations per {it:m}}
{txt}{col 20}{c LT}{hline 35}{c TT}{hline 10}
{txt}{col 11}Variable {c |}{ralign 12:Complete }{ralign 13:Incomplete }{ralign 10:Imputed }{c |}{ralign 10:Total}
{hline 19}{c +}{hline 35}{c +}{hline 10}
{txt}{ralign 19:rep78 }{c |}{res}         69            5         5 {txt}{c |}{res}        74
{txt}{hline 19}{c BT}{hline 35}{c BT}{hline 10}
{p 0 1 1 66}(complete + incomplete = total; imputed is the minimum across {it:m}
 of the number of filled-in observations.){p_end}
{res}{txt}

{pstd}
We created two imputations using {cmd:mi impute}'s option {cmd:add()}
and obtained the standard output from {cmd:mi impute}.  We imputed all five
missing values of variable {cmd:rep78} using the new {cmd:naivereg} method.

{pstd}
This is just a simple example.  Your imputation model can be as complicated as
you would like.  See {it:{help mi_impute_usermethod##examples:Examples}} for
more complicated imputation models.


{marker steps}{...}
{title:Steps for adding a new method to mi impute}

{pstd}
Suppose you want to add your own method, {it:usermethod}, to the {cmd:mi}
{cmd:impute} command.  Here is an outline of the steps to follow:

{marker parser}{...}
{phang}
1.  Create a {it:parser}, a {help program:program} called
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:_parse} and defined by the ado-file
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:_parse.ado} that parses the
imputation model and checks the syntax of user-specific options,
{it:user_options}. 
See {it:{help mi_impute_usermethod##parserdef:Writing an imputation parser}}.

{marker initializer}{...}
{phang}
2.  Optionally, create an {it:initializer}, a {help program:program} called
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:_init} and defined by the ado-file
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:_init.ado} that performs certain
tasks to be executed once on the observed data.  For example, during monotone
imputation, the estimation of model parameters can be done just once using the
observed data. See {it:{help mi_impute_usermethod##initializerdef:Writing an initializer}}.

{marker imputer}{...}
{phang}
3.  Create an {it:imputer}, a {help program:program} called
{cmd:mi_impute_cmd_}{it:usermethod} and defined by the ado-file
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:.ado} that performs one round of
imputation for all imputation variables. See {it:{help mi_impute_usermethod##imputerdef:Writing an imputer}}.

{marker return}{...}
{phang}
4.  Optionally, create a {help program:program} for storing additional 
{helpb return:r()} results called
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:_return} and defined by the
ado-file {cmd:mi_impute_cmd_}{it:usermethod}{cmd:_return.ado}. See 
{it:{help mi_impute_usermethod##returndef:Storing additional results}}.

{marker cleanup}{...}
{phang}
5.  Optionally, create a {it:cleanup} program (or garbage collector), a 
{help program:program} called
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:_cleanup} and defined by the
ado-file {cmd:mi_impute_cmd_}{it:usermethod}{cmd:_cleanup.ado} that removes
all the intermediate variables, {help macro:global macros}, etc., you
created during parsing, initialization, or imputation. See 
{it:{help mi_impute_usermethod##cleanupdef:Writing a cleanup program}}.

{phang}
6.  Place all of your programs where Stata can find them.

{pstd}
You can now use your {it:usermethod} with {cmd:mi impute},

{phang2}{cmd:. mi impute} {it:usermethod} ...{p_end}

{pstd}
and access any of {cmd:mi impute}'s 
{help mi_impute##options:options} (except {cmd:by()} and
{cmd:noupdate}).

{marker parserdef}{...}
{title:Writing an imputation parser}

{pstd}
A parser is a program that parses the
imputation model specification {it:userspec}, passes the necessary information
to {cmd:mi} {cmd:impute}, and checks user-specified options.  It
must be defined within an ado file with the name
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:_parse.ado}.  You can use any of
Stata's parsing utilities such as the {helpb syntax} command to write your
parser.  It
may be more convenient for users if you follow the syntax of 
{helpb mi impute} when designing your imputation methods.

{pstd}
At a minimum, your parser must supply information about the imputation
variables to {cmd:mi impute}.  This is done via the {cmd:ivars()} option of
the utility command {cmd:u_mi_impute_user_setup}:

{phang2}
{cmd: u_mi_impute_user_setup, ivars({varlist})} ...

{pstd}
You may supply other information such as independent variables (complete
predictors) in option {cmd:xvars()}, weights, an {it:if} qualifier, and so
on.  

{pstd}
A simple univariate parser may look as follows.

{phang2}
{cmd:program mi_impute_cmd_}{it:usermethod}{cmd:_parse}{p_end}
	        {cmd:version} ...
                {cmd:syntax anything [if] [fw iw] [, * ]}
	        {cmd:gettoken ivar xvars : anything}
	        {cmd:u_mi_impute_user_setup `if' [`weight'`exp'],   ///}
			{cmd:ivars(`ivar') xvars(`xvars') `options'}
{phang2}{cmd:end}{p_end}

{pstd}
The above parser corresponds to the following {it:userspec},

{phang2}
{it:{help varname:ivar}} [{it:{help varlist:indepvars}}] [{it:{help if}}] {weight}

{pstd}
where only {cmd:fweight}s and {cmd:iweight}s are allowed.

{pstd}
A simple multivariate parser may look as follows.

{phang2}
{cmd:program mi_impute_cmd_}{it:usermethod}{cmd:_parse}{p_end}
	        {cmd:version} ...
                {cmd:syntax anything(equalok) [if] [fw iw] [, * ]}
	        {cmd:gettoken ivars xvars : anything, parse("=")}
	        {cmd:gettoken eq xvars : xvars, parse("=")}
	        {cmd:u_mi_impute_user_setup `if' [`weight'`exp'],   ///}
			{cmd:ivars(`ivars') xvars(`xvars') `options'}
{phang2}{cmd:end}{p_end}

{pstd}
This parser corresponds to the following {it:userspec},

{phang2}
{it:{help varlist:ivars}} [{cmd:=} {it:{help varlist:indepvars}}] [{it:{help if}}] {weight}

{pstd}
where only {cmd:fweight}s and {cmd:iweight}s are allowed.

{pstd}
You may also supply complete predictors, {it:if} qualifiers, and weights
specific to each imputation variable or control the order in which variables
are imputed. Here is the full syntax of the utility program.

{p 8 19 2}{cmd:u_mi_impute_user_setup} [{it:{help if}}] {weight}
[{cmd:,} {it:setup_options}] 

{synoptset 22 tabbed}{...}
{synopthdr:setup_options}
{synoptline}
{syntab:Main}
{p2coldent :* {opth ivars(varlist)}}specify imputation variables{p_end}
{synopt: {opth xvars(varlist)}}specify complete predictors for all imputation variables{p_end}
{synopt: {cmd:xvars}{it:#}{cmd:(}{varlist}{cmd:)}}specify complete predictors for the {it:#}th imputation variable; overrides {cmd:xvars()}{p_end}
{synopt: {cmd:if}{it:#}{cmd:(}{it:{help if}}{cmd:)}}specify an {it:if}
qualifier for the {it:#}th imputation variable (in addition to the global {it:if}){p_end}
{synopt: {cmd:weight}{it:#}{cmd:(}{it:{help weight}}{cmd:)}}specify weights for the {it:#}th imputation variable; overrides global weights{p_end}
{synopt: {opt orderasis}}impute variables in the specified order{p_end}
{synopt: [{cmdab:no:}]{opt fillmis:sing}}do not replace current imputed data with missing values{p_end}
{synopt: {opt title1(string)}}specify the main title{p_end}
{synopt: {opt title2(string)}}specify the secondary title{p_end}
{synoptline}
{p 4 6 2}
* {opt ivars(varlist)} is required.{p_end}

{phang}
{opth ivars(varlist)} specifies the names of the imputation variables.  This 
option is required.

{phang}
{opth xvars(varlist)} specifies the names of the independent variables 
(complete predictors) for all imputation variables.  You may use 
{cmd:xvars}{it:#}{cmd:()} to override the complete predictors for the {it:#}th 
imputation variable.

{phang}
{cmd:xvars}{it:#}{cmd:(}{varlist}{cmd:)} specifies the names of the 
independent variables for the {it:#}th imputation variable.  This option 
overrides the {cmd:xvars()} option for that variable.   If 
{cmd:xvars}{it:#}{cmd:()} is not specified, then {cmd:xvars()} (if specified) 
is assumed for that variable. 

{phang}
{cmd:if}{it:#}{cmd:(}{it:{help if}}{cmd:)} specifies an {it:if}
qualifier for the {it:#}th imputation variable.  This option is used in
conjunction with the global {it:if} qualifier specified with the program to
define an imputation sample for that variable.   

{phang}
{cmd:weight}{it:#}{cmd:(}{it:{help weight}}{cmd:)} specifies weights for the 
{it:#}th imputation variable.  This option overrides the global weight 
specified with the program.   If {cmd:weight}{it:#}{cmd:()} is not specified, 
then the global weight (if specified) is used for that variable. 

{phang}
{cmd:orderasis} requests that the variables be imputed in the specified order.
By default, variables are imputed in order from the most observed to the least
observed.

{phang}
{cmd:fillmissing} or {cmd:nofillmissing} requests that the imputed data be 
filled in or not filled in with missing values prior to the imputation.  The 
default is {cmd:fillmissing}.  This option is rarely used.

{phang}
{opt title1(string)} specifies the main title.  The default is "Multiple 
imputation". 

{phang}
{opt title2(string)} specifies the secondary title.  The default is "User 
method: {it:usermethod}".


{pstd}
{cmd:u_mi_impute_user_setup} sets certain global macros used by {cmd:mi}
{cmd:impute}; see {it:{help mi_impute_usermethod##glmacros:Global macros}} for
details.


{marker initializerdef}{...}
{title:Writing an initializer}

{pstd}
An initializer (in the context of {cmd:mi}
{cmd:impute}) is a program that is executed once on the observed data,
{it:m}=0, before imputation.  This program is optional.  If you choose to
write an initializer, it must be defined within an ado-file with the name
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:_init.ado}.  This program is useful
if you have an estimation task that needs to be performed only once on the
observed data.

{pstd}
For example, a univariate regression imputation requires that the regression
be performed on the observed data prior to imputation.  A simple initializer
for such imputation may look as follows.

{phang2}
{cmd:program mi_impute_cmd_}{it:usermethod}{cmd:_init}{p_end}
	        {cmd:version} ...
		{cmd:quietly regress $MI_IMPUTE_user_ivar $MI_IMPUTE_user_xvars ///}
			{cmd:if $MI_IMPUTE_user_touse}
{phang2}{cmd:end}{p_end}


{marker imputerdef}{...}
{title:Writing an imputer}

{pstd}
An imputer is a program that imputes missing values
of all specified imputation variables once.  This program is required and must
be defined within an ado-file with the name
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:.ado}.  {cmd:mi} {cmd:impute} will
execute this program multiple times to produce multiply imputed datasets.

{pstd}
A simple univariate imputer may look as follows.

{phang2}
{cmd:program mi_impute_cmd_}{it:usermethod}{p_end}
	        {cmd:version} ...
		{cmd:quietly replace $MI_IMPUTE_user_ivar =} ...  {cmd:///}
			{cmd:if $MI_IMPUTE_user_miss}
{phang2}{cmd:end}{p_end}


{marker returndef}{...}
{title:Storing additional results}

{pstd}
To store results in addition to those
provided by {cmd:mi} {cmd:impute} (see 
{it:{help mi_impute_usermethod##results:Stored results}}), you need to create
a {help program:r-class program} called
{cmd:mi_impute_cmd_}{it:usermethod}{cmd:_return}.  Here is an example.

{phang2}
{cmd:program mi_impute_cmd_}{it:usermethod}{cmd:_return, rclass}{p_end}
	        {cmd:version} ...
		{cmd:syntax [, myopt(real 0) * ]}
		{cmd:return scalar myopt = `myopt'}
{phang2}{cmd:end}{p_end}


{marker cleanupdef}{...}
{title:Writing a cleanup program}

{pstd}
A "cleanup" program or garbage collector is 
a program that is called at the end of the imputation process to remove any
intermediate results you created in your parser, initializer, or imputer that 
will not be removed automatically upon program completion.  For example, such
results may include new variables (except {help tempvar:temporary variables}),
global macros, global names for estimation results, and so on.  This program
is optional but highly recommended when you have intermediate results that 
need to be cleared manually.


{marker examples}{...}
{title:Examples}

{marker exnaive_init}{...}
{title:Naive regression imputation}

{pstd}
Recall our introductory example from {it:{help mi_impute_usermethod##introex:Toy example: Naive regression imputation}}
of a naive (or stochastic) regression imputation.  

{pstd}
{bf:Initializer}. We can make our imputer more computationally efficient by
separating the estimation and imputation tasks.  Currently, regression is
performed in each imputation.  We can move this step into the initializer.

{p 8 14 2}// initializer (naivereg) {p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_naivereg_init}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}/* step 1: run regression on observed data */{p_end}
{p 16 20 2}{cmd:quietly regress $MI_IMPUTE_user_ivar $MI_IMPUTE_user_xvars}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
Here is the updated imputer.

{p 8 14 2}// imputer (naivereg) {p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_naivereg}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}/* step 2: compute linear prediction */{p_end}
{p 16 20 2}{cmd:tempvar xb}{p_end}
{p 16 20 2}{cmd:quietly predict double `xb', xb}{p_end}
{p 16 20 2}/* step 3: replace missing values */{p_end}
{p 16 20 2}{cmd:quietly replace $MI_IMPUTE_user_ivar = `xb'+rnormal(0,e(rmse))} ///{p_end}
{p 24 28 2}{cmd:           if $MI_IMPUTE_user_miss==1}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
If we now run {cmd:mi impute naivereg}, the {cmd:regress} command will be run
only once, on the observed data {it:m}=0.

{pstd}
{bf:If qualifier and weights}.  We can also extend our method to allow the
specification of an {it:if} qualifier and, say, frequency weights.

{p 8 14 2}// parser (naivereg, if and weights){p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_naivereg_parse}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}{cmd:syntax anything [if] [fw] [, * ]}{p_end}
{p 16 20 2}{cmd:gettoken ivar xvars : anything}{p_end}
{p 16 20 2}{cmd:u_mi_impute_user_setup `if' [`weight'`exp'] ,  ///}{p_end}
{p 24 28 2}{cmd:ivars(`ivar') xvars(`xvars') `options'}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
We updated the {cmd:syntax} statement to allow {it:if} and frequency weights
and passed that information to the utility program
{cmd:u_mi_impute_user_setup}.

{p 8 14 2}// initializer (naivereg, if and weights) {p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_naivereg_init}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}/* step 1: run regression on observed data */{p_end}
{p 16 20 2}{cmd:quietly regress $MI_IMPUTE_user_ivar $MI_IMPUTE_user_xvars  ///}{p_end}
{p 24 28 2}{cmd:$MI_IMPUTE_user_weight if $MI_IMPUTE_user_touse}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
We included the global macros containing the information about weights and the
imputation sample in our {cmd:regress} command.

{p 8 14 2}// imputer (naivereg, if and weights) {p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_naivereg}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}/* step 2: compute linear prediction */{p_end}
{p 16 20 2}{cmd:tempvar xb}{p_end}
{p 16 20 2}{cmd:quietly predict double `xb' if $MI_IMPUTE_user_touse, xb}{p_end}
{p 16 20 2}/* step 3: replace missing values */{p_end}
{p 16 20 2}{cmd:quietly replace $MI_IMPUTE_user_ivar = `xb'+rnormal(0,e(rmse))} ///{p_end}
{p 26 30 2}{cmd:           if $MI_IMPUTE_user_miss==1}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
We restricted the computation of the linear predictor for the sample
determined by the specified {it:if} qualifier. A more efficient approach
would be to also restrict the computation of the linear predictor for missing
values only.  This can be done by replacing {cmd:if $MI_IMPUTE_user_touse}
in the {cmd:predict} line above with {cmd:if $MI_IMPUTE_user_miss}.

{pstd}
For example, we can now impute {cmd:rep78} separately for foreign and domestic
cars and incorporate frequency weights.  For the purpose of demonstration, we
will use {cmd:turn} as a frequency weight.

{com}. sysuse auto, clear
{com}. mi set wide
{com}. mi register imputed rep78
{res}{txt}

{com}. mi impute naivereg rep78 mpg weight [fweight=turn] if foreign==1, add(2)
{res}{txt}
Multiple imputation{txt}{col 45}{ralign 12:Imputations }= {res}       2
{txt}{txt}User method {cmd}naivereg{txt}{col 45}{ralign 12:added }= {res}       2
{txt}Imputed: {it:m}=1 through {it:m}=2{txt}{col 45}{ralign 12:updated }= {res}       0

{txt}{hline 19}{c TT}{hline 35}{hline 11}
{txt}{col 20}{c |}{center 46:  Observations per {it:m}}
{txt}{col 20}{c LT}{hline 35}{c TT}{hline 10}
{txt}{col 11}Variable {c |}{ralign 12:Complete }{ralign 13:Incomplete }{ralign  10:Imputed }{c |}{ralign 10:Total}
{hline 19}{c +}{hline 35}{c +}{hline 10}
{txt}{ralign 19:rep78 }{c |}{res}        741           38        38 {txt}{c |}{ res}       779
{txt}{hline 19}{c BT}{hline 35}{c BT}{hline 10}
{p 0 1 1 66}(complete + incomplete = total; imputed is the minimum across {it:m}
 of the number of filled-in observations.){p_end}
{res}{txt}
{com}. mi impute naivereg rep78 mpg weight [fweight=turn] if foreign==0, replace
{res}{txt}
Multiple imputation{txt}{col 45}{ralign 12:Imputations }= {res}       2
{txt}{txt}User method {cmd}naivereg{txt}{col 45}{ralign 12:added }= {res}       0
{txt}Imputed: {it:m}=1 through {it:m}=2{txt}{col 45}{ralign 12:updated }= {res}       2

{txt}{hline 19}{c TT}{hline 35}{hline 11}
{txt}{col 20}{c |}{center 46:  Observations per {it:m}}
{txt}{col 20}{c LT}{hline 35}{c TT}{hline 10}
{txt}{col 11}Variable {c |}{ralign 12:Complete }{ralign 13:Incomplete }{ralign 10:Imputed }{c |}{ralign 10:Total}
{hline 19}{c +}{hline 35}{c +}{hline 10}
{txt}{ralign 19:rep78 }{c |}{res}       2005          150       150 {txt}{c |}{ res}      2155
{txt}{hline 19}{c BT}{hline 35}{c BT}{hline 10}
{p 0 1 1 66}(complete + incomplete = total; imputed is the minimum across {it:m }
 of the number of filled-in observations.){p_end}
{res}{txt}


{marker exregress}{...}
{title:Univariate regression imputation}

{pstd}
In {it:{help mi_impute_usermethod##exnaive_init:Naive regression imputation}}, we
added a new method, {cmd:naivereg}.  The reason we called this imputation
method naive is that it did not incorporate the uncertainty about the
estimates of coefficients and error standard deviation when computing the
linear predictor and simulating the imputed values.

{pstd}
Let's add a new method, {cmd:myregress}, that improves the {cmd:naivereg}
method.  The parser and the initializer stay the same (except they need to be
renamed to {cmd:mi_impute_cmd_myregress_parse} and
{cmd:mi_impute_cmd_myregress_init}, respectively).  The imputer, however,
changes substantially.  Before we move on to the programming task, let's
revisit the imputation procedure described in
{it:{help mi_impute_usermethod##introex:Toy example: Naive regression imputation}}.

{pstd}
The linear predictor from step 2 is computed using the maximum likelihood
estimates of regression coefficients, {it:beta_mle}, from step 1.
Also, the random normal variates are generated using the maximum likelihood
estimate of the error standard deviation, {it:sigma_mle}.  The proper
regression imputation simulates a new set of parameters, {it:beta} and
{it:sigma}, from their respective posterior distributions and uses them to
compute results in steps 2 and 3.  Let's update our imputation procedure.

{phang}
1.  Regress {it:ivar} on {it:xvars} using the observed data.

{phang}
2.  Simulate new regression coefficients {it:beta} and error standard
deviation {it:sigma} from their respective posterior distributions, which are
based on their maximum likelihood estimates, {it:beta_mle} and {it:sigma_mle}.

{phang}
3.  Obtain the linear predictor, {it:xb}, using the new regression coefficients
{it:beta}.

{phang}
4.  Replace missing values in {it:ivar} with {it:xb} plus a random error
    generated from N(0,{it:sigma}).

{pstd}
Let's now update our imputer.

{p 8 14 2}// imputer (myregress) {p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_myregress, eclass}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}/* step 2: simulate new {it:beta} and {it:sigma} */{p_end}
{p 16 20 2}{cmd:tempname sigma beta sigma_mle beta_mle vce_chol rnorm}{p_end}
{p 16 20 2}{cmd:matrix `beta_mle'  = e(b)}{p_end}
{p 16 20 2}{cmd:scalar `sigma_mle' = e(rmse)}{p_end}
{p 16 20 2}{cmd:matrix `vce_chol'  = cholesky(e(V))/`sigma_mle'}{p_end}
{p 16 20 2}{cmd:local ncols        = colsof(`beta_mle')}{p_end}
{p 16 20 2}/* draw {it:beta} and {it:sigma} from the posterior distribution */{p_end}
{p 16 20 2}{cmd:scalar `sigma' = `sigma_mle'*sqrt(e(df_r)/rchi2(e(df_r)))}{p_end}
{p 16 20 2}{cmd:mata: st_matrix("`rnorm'", rnormal(`ncols',1,0,1))}{p_end}
{p 16 20 2}{cmd:matrix `beta' = `beta_mle'+(`sigma'*(`vce_chol'*`rnorm'))'}{p_end}
{p 16 20 2}/* step 3: compute linear prediction */{p_end}
{p 16 20 2}{cmd:ereturn repost b = `beta'} // repost new {it:beta}{p_end}
{p 16 20 2}{cmd:tempvar xb}{p_end}
{p 16 20 2}{cmd:quietly predict double `xb' if $MI_IMPUTE_user_miss, xb}{p_end}
{p 16 20 2}{cmd:ereturn repost b = `beta_mle'} // repost back {it:beta_mle}{p_end}
{p 16 20 2}/* step 4: replace missing values */{p_end}
{p 16 20 2}{cmd:quietly replace $MI_IMPUTE_user_ivar = `xb'+`sigma'*rnormal()} ///{p_end}
{p 26 30 2}{cmd:           if $MI_IMPUTE_user_miss==1}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
Our new imputer is much more involved.  In step 2, we generate a new
(temporary) matrix of coefficients, {cmd:`beta'}, and a temporary scalar
containing new error standard deviation.  The new parameters are simulated
from their posterior distribution.  In step 3, we repost new coefficients to
{helpb ereturn:e()} results to obtain the proper linear predictor, and we
repost the old coefficients back to be used in the next imputation.  In step
4, we use a new {cmd:`sigma'} to generate random errors.

{pstd}
We can check that we obtain the same imputed values as Stata's official 
{helpb mi impute regress} command, provided that we use the same random-number
seed.  For example,

{cmd:. sysuse auto, clear}
{cmd:. mi set wide}
{cmd:. mi register imputed rep78}

{cmd:. mi impute myregress rep78 mpg weight, add(1) rseed(234)}
{cmd:. mi impute regress rep78 mpg weight, add(1) rseed(234)}

{cmd:. mi xeq 1 2: summarize rep78}
{res}{txt}

{marker exmonotone}{...}
{title:Multivariate monotone imputation}

{pstd}
Our previous examples demonstrated univariate imputation -- imputation of a
single variable.  Here we demonstrate an example of multivariate imputation
for variables with a monotone missing-value pattern.  For simplicity, we will
consider imputation of two variables using a new method, {cmd:mymonreg}.

{pstd}
We start with a parser.

{p 8 14 2}// imputer (mymonreg) {p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_mymonreg_parse}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}{cmd:syntax anything(equalok) [if] [, * ]}{p_end}
{p 16 20 2}{cmd:gettoken ivars xvars : anything, parse("=")}{p_end}
{p 16 20 2}{cmd:gettoken eq xvars : xvars, parse("=")}{p_end}
{p 16 20 2}{cmd:u_mi_impute_user_setup `if', ivars(`ivars') xvars(`xvars') `options'}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
We separate multiple-imputation variables from the complete predictors with the
equality ({cmd:=}) sign.  The same set of complete predictors will be used to
impute all imputation variables.

{p 8 14 2}// initializer (mymonreg) {p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_mymonreg_init}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}/* run regression on observed data for each imputation variable and store estimation results */{p_end}
{p 16 20 2}{cmd:quietly regress $MI_IMPUTE_user_ivar1{space 18}///}{p_end}
{p 26 30 2}{cmd:$MI_IMPUTE_user_xvars1 if $MI_IMPUTE_user_touse1}{p_end}
{p 16 20 2}{cmd:quietly estimates store myreg1}{p_end}
{p 16 20 2}{cmd:quietly regress $MI_IMPUTE_user_ivar2{space 18}///}{p_end}
{p 26 30 2}{cmd:$MI_IMPUTE_user_ivar1 $MI_IMPUTE_user_xvars2 ///}{p_end}
{p 26 30 2}{cmd:if $MI_IMPUTE_user_touse2}{p_end}
{p 16 20 2}{cmd:quietly estimates store myreg2}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
With multiple imputation variables, {cmd:mi impute} automatically orders them
from the least missing to the most missing. In our example,
{cmd:MI_IMPUTE_user_ivar1} will contain the name of the imputation variable
with the least number of missing values, and {cmd:MI_IMPUTE_user_ivar2} with
the most number. You can use the {cmd:orderasis} option to prevent {cmd:mi}
{cmd:impute} from ordering the variables.  Notice that during monotone
imputation, the previously imputed variables are used as predictors of the
subsequent imputation variables in addition to the complete predictors. So we
used {cmd:MI_IMPUTE_user_ivar1} as an additional predictor of
{cmd:MI_IMPUTE_user_ivar2}.

{pstd}
To avoid refitting models on each imputed dataset, we store estimation results
as {cmd:myreg1} and {cmd:myreg2}.  It is our responsibility to drop these
estimation results from memory at the end of the imputation.

{pstd}
During imputation, we will need to apply the steps of the regression
imputation described in 
{it:{help mi_impute_usermethod##exregress:Univariate regression imputation}}
to each imputation variable.  To simplify this task, we can create a
subprogram within our imputer that performs these steps, {cmd:ImputeIvar}.
Then, our imputer may look like this.

{p 8 14 2}// imputer (mymonreg) {p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_mymonreg}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}{cmd:ImputeIvar 1 myreg1}{p_end}
{p 16 20 2}{cmd:ImputeIvar 2 myreg2}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{p 8 14 2}// subprogram defined within mi_impute_cmd_mymonreg.ado{p_end}
{p 8 14 2}{cmd:program ImputeIvar, eclass}{p_end}
{p 16 20 2}{cmd:args index estres}{p_end}
{p 16 20 2}/* load the appropriate estimation results */{p_end}
{p 16 20 2}{cmd:quietly estimates restore `estres'}{p_end}
{p 16 20 2}/* step 2: simulate new {it:beta} and {it:sigma} */{p_end}
{p 16 20 2}{cmd:tempname sigma beta sigma_mle beta_mle vce_chol rnorm}{p_end}
{p 16 20 2}{cmd:matrix `beta_mle' = e(b)}{p_end}
{p 16 20 2}{cmd:scalar `sigma_mle' = e(rmse)}{p_end}
{p 16 20 2}{cmd:matrix `vce_chol' = cholesky(e(V))/`sigma_mle'}{p_end}
{p 16 20 2}{cmd:local ncols = colsof(`beta_mle')}{p_end}
{p 16 20 2}/* draw {it:beta} and {it:sigma} from the posterior distribution */{p_end}
{p 16 20 2}{cmd:scalar `sigma' = `sigma_mle'*sqrt(e(df_r)/rchi2(e(df_r)))}{p_end}
{p 16 20 2}{cmd:mata: st_matrix("`rnorm'", rnormal(`ncols',1,0,1))}{p_end}
{p 16 20 2}{cmd:matrix `beta' = `beta_mle'+(`sigma'*(`vce_chol'*`rnorm'))'}{p_end}
{p 16 20 2}/* step 3: compute linear prediction */{p_end}
{p 16 20 2}{cmd:ereturn repost b = `beta'} // repost new {it:beta}{p_end}
{p 16 20 2}{cmd:tempvar xb}{p_end}
{p 16 20 2}{cmd:quietly predict double `xb' if ${MI_IMPUTE_user_miss`index'}, xb}{p_end}
{p 16 20 2}{cmd:ereturn repost b = `beta_mle'} // repost back {it:beta_mle}{p_end}
{p 16 20 2}/* step 4: replace missing values */{p_end}
{p 16 20 2}{cmd:quietly replace ${MI_IMPUTE_user_ivar`index'} = `xb' +  ///}{p_end}
{p 24 28 2}{cmd:rnormal(0,`sigma') if ${c -(}MI_IMPUTE_user_miss`index'{c )-}==1}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
The {cmd:ImputeIvar} subprogram is almost the same as the imputer from the
univariate regression imputation, except we replaced global macros with their
analogs specific to each imputation variable.  For example, we replaced
{cmd:MI_IMPUTE_user_ivar} with {cmd:MI_IMPUTE_user_ivar`index'}, where local
macro {cmd:`index'} will contain a value of 1 or 2.  We also passed to the
subprogram the corresponding names of the estimation results.

{pstd}
Finally, we write a cleanup program to drop the estimation results we created
during initialization from memory.

{p 8 14 2}// cleanup program (mymonreg) {p_end}
{p 8 14 2}{cmd:program mi_impute_cmd_mymonreg_cleanup}{p_end}
{p 16 20 2}{cmd:version {ccl stata_version}}{p_end}
{p 16 20 2}{cmd:capture estimates drop myreg1 myreg2}{p_end}
{p 8 14 2}{cmd:end}{p_end}

{pstd}
Returning to our {cmd:auto} example, we can replace missing values in
{cmd:rep78} and {cmd:mpg}.

{com}. sysuse auto, clear
{com}. quietly replace mpg = . in 3
{com}. mi set wide
{com}. mi register imputed rep78 mpg
{res}{txt}

{com}. mi impute mymonreg rep78 mpg = weight, add(1)
{res}{txt}
Multiple imputation{txt}{col 45}{ralign 12:Imputations }= {res}       1
{txt}{txt}User method {cmd}mymonreg{txt}{col 45}{ralign 12:added }= {res}       1
{txt}Imputed: {it:m}=1{txt}{col 45}{ralign 12:updated }= {res}       0

{txt}{hline 19}{c TT}{hline 35}{hline 11}
{txt}{col 20}{c |}{center 46:  Observations per {it:m}}
{txt}{col 20}{c LT}{hline 35}{c TT}{hline 10}
{txt}{col 11}Variable {c |}{ralign 12:Complete }{ralign 13:Incomplete }{ralign 10:Imputed }{c |}{ralign 10:Total}
{hline 19}{c +}{hline 35}{c +}{hline 10}
{txt}{ralign 19:rep78 }{c |}{res}         69            5         5 {txt}{c |}{res}        74
{txt}{ralign 19:mpg }{c |}{res}         73            1         1 {txt}{c |}{res}        74
{txt}{hline 19}{c BT}{hline 35}{c BT}{hline 10}
{p 0 1 1 66}(complete + incomplete = total; imputed is the minimum across {it:m}
 of the number of filled-in observations.){p_end}
{res}{txt}


{marker glmacros}{...}
{title:Global macros}

{pstd}
{cmd:mi impute} {it:usermethod} stores global macros that can be consumed by
the programmers of imputation methods.  The global macros are
{cmd:MI_IMPUTE_user_}{it:name}, where {it:name} is defined below.  Global
macro {cmd:MI_IMPUTE_user} is set to 1 for all user-defined imputation methods
and to 0 for all official imputation methods.  

{synoptset 22 tabbed}{...}
{synopthdr:{it:name}}
{synoptline}
{synopt: {cmd:method}}name of the imputation method{p_end}
{synopt: {cmd:user_options}}method-specific options{p_end}
{synopt: {cmd:k_ivars}}total number of specified imputation variables (complete and incomplete){p_end}
{synopt: {cmd:allivars}}names of all specified imputation variables (complete and incomplete){p_end}
{synopt: {cmd:k_ivarsinc}}number of incomplete imputation variables{p_end}
{synopt: {cmd:ivarsinc}}names of incomplete imputation variables in the original order{p_end}
{synopt: {cmd:ivars}}synonym for {cmd:ivarsinc}{p_end}
{synopt: {cmd:ivarscomplete}}names of complete imputation variables in the original order{p_end}
{synopt: {cmd:ivarsincord}}names of incomplete imputation variables ordered from the least missing to the most missing{p_end}
{synopt: {cmd:ordind}}indices of ordered imputation variables{p_end}
{synopt: {cmd:incordind}}indices for ordered incomplete imputation variables{p_end}
{synopt: {cmd:pattern}}{cmd:monotone} or {cmd:nonmonotone} pattern among all specified imputation variables with respect to the global imputation sample{p_end}
{synopt: {cmd:ivar}{it:#}}name of the {it:#}th incomplete imputation variable{p_end}
{synopt: {cmd:ivar}}synonym for {cmd:ivar1}; stored only with one imputation variable{p_end}
{synopt: {cmd:xvars}}names of complete predictors for all incomplete imputation variables{p_end}
{synopt: {cmd:xvars}{it:#}}names of the complete predictors for the {it:#}th incomplete imputation variable{p_end}
{synopt: {cmd:weight}}global weight expression{p_end}
{synopt: {cmd:weight}{it:#}}weight expression for the {it:#}th imputation variable{p_end}
{synopt: {cmd:touse}}indicator for the global imputation sample{p_end}
{synopt: {cmd:touse}{it:#}}indicator for the imputation sample for the {it:#}th imputation variable{p_end}
{synopt: {cmd:tousevars}}names of all imputation-sample indicators{p_end}
{synopt: {cmd:miss}{it:#}}missing-value indicator for the {it:#}th imputation variable{p_end}
{synopt: {cmd:miss}}synonym for {cmd:miss1}; stored only with one imputation variable{p_end}
{synopt: {cmd:missvars}}names of all missing-value indicators{p_end}
{synopt: {cmd:m}}current imputation number{p_end}
{synopt: {cmd:quietly}}contains {cmd:quietly} unless {cmd:mi impute}'s option
{cmd:noisily} was specified{p_end}
{synopt: {cmd:opt_add}}content of option {cmd:add()}{p_end}
{synopt: {cmd:opt_replace}}content of option {cmd:replace}{p_end}
{synopt: {cmd:opt_rseed}}content of option {cmd:rseed()}{p_end}
{synopt: {cmd:opt_double}}content of option {cmd:double}{p_end}
{synopt: {cmd:opt_dots}}content of option {cmd:dots}{p_end}
{synopt: {cmd:opt_noisily}}content of option {cmd:noisily}{p_end}
{synopt: {cmd:opt_nolegend}}content of option {cmd:nolegend}{p_end}
{synopt: {cmd:opt_force}}content of option {cmd:force}{p_end}
{synopt: {cmd:opt_orderasis}}content of option {cmd:orderasis}{p_end}
{synoptline}

{pstd}
You may need to define your own global macros.  In that case, you need to use
the prefix {cmd:MI_IMPUTE_userdef_} for all of your global macros to avoid
collision with {cmd:mi impute}'s internal global macros.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute} {it:usermethod} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables{p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method ({it:usermethod}){p_end}
{synopt:{cmd:r(ivars)}}names of imputation variables{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(N)}}number of observations in imputation sample{p_end}
{synopt:{cmd:r(N_complete)}}number of complete observations in imputation sample{p_end}
{synopt:{cmd:r(N_incomplete)}}number of incomplete observations in imputation sample{p_end}
{synopt:{cmd:r(N_imputed)}}number of imputed observations in imputation sample{p_end}

{pstd}
You may also store your own results; see {it:{help mi_impute_usermethod##returndef:Storing additional results}} for details.


{marker ack}{...}
{title:Acknowledgment}

{pstd}
The development of this functionality was partially supported by the World Bank.
{p_end}
