{smcl}
{* *! version 1.0.28  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi impute" "mansection MI miimpute"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Glossary" "help mi_glossary"}{...}
{viewerjumpto "Syntax" "mi_impute##syntax"}{...}
{viewerjumpto "Menu" "mi_impute##menu"}{...}
{viewerjumpto "Description" "mi_impute##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute##options"}{...}
{viewerjumpto "Remarks" "mi_impute##remarks"}{...}
{viewerjumpto "Examples" "mi_impute##examples"}{...}
{viewerjumpto "Stored results" "mi_impute##results"}{...}
{viewerjumpto "References" "mi_impute##references"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi impute} {hline 2}}Impute missing values
{p_end}
{p2col:}({mansection MI miimpute:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {it:{help mi_impute##methods:method}} ...
   [{cmd:,} {it:{help mi_impute##impopts:impute_options}} ... ]


{synoptset 24 tabbed}{...}
{marker methods}{...}
{synopthdr:method}
{synoptline}
{syntab:Univariate}
{synopt: {helpb mi_impute_regress:{ul:reg}ress}}linear regression for a continuous variable{p_end}
{synopt: {helpb mi_impute_pmm:pmm}}predictive mean matching for a continuous variable{p_end}
{synopt: {helpb mi_impute_truncreg:truncreg}}truncated regression for a continuous variable with a restricted range{p_end}
{synopt: {helpb mi_impute_intreg:intreg}}interval regression for a continuous partially observed (censored) variable{p_end}
{synopt: {helpb mi_impute_logit:{ul:logi}t}}logistic regression for a binary variable{p_end}
{synopt: {helpb mi_impute_ologit:{ul:olog}it}}ordered logistic regression for an ordinal variable{p_end}
{synopt: {helpb mi_impute_mlogit:{ul:mlog}it}}multinomial logistic regression for a nominal variable{p_end}
{synopt: {helpb mi_impute_poisson:poisson}}Poisson regression for a count variable{p_end}
{synopt: {helpb mi_impute_nbreg:nbreg}}negative binomial regression for an overdispersed count variable{p_end}

{syntab:Multivariate}
{synopt: {helpb mi_impute_monotone:{ul:mon}otone}}sequential imputation using a monotone-missing pattern{p_end}
{synopt: {helpb mi_impute_chained:{ul:chain}ed}}sequential imputation using chained equations{p_end}
{synopt: {helpb mi_impute_mvn:mvn}}multivariate normal regression{p_end}

{syntab:User-defined}
{synopt: {helpb mi_impute_usermethod:{it:usermethod}}}user-defined imputation methods{p_end}
{synoptline}


{synoptset 24 tabbed}{...}
{marker impopts}{...}
{synopthdr:impute_options}
{synoptline}
{syntab:Main}
{p2coldent :* {opt add(#)}}specify number of imputations to add; required when 
no imputations exist{p_end}
{p2coldent:* {opt replace}}replace imputed values in existing 
imputations{p_end}
{synopt: {opt rseed(#)}}specify random-number seed{p_end}
{synopt: {opt double}}store imputed values in double precision; the default is to store them as {cmd:float}{p_end}
{synopt:{cmd:by(}{help varlist:{it:varlist}} [{cmd:,} {help mi_impute##byopts:{it:byopts}}]{cmd:)}}impute separately on each group formed
by {it:varlist} (not allowed with {it:usermethod}){p_end}

{syntab:Reporting}
{synopt: {opt dots}}display dots as imputations are performed{p_end}
{synopt: {opt noi:sily}}display intermediate output{p_end}
{synopt: {opt noleg:end}}suppress all table legends{p_end}

{syntab:Advanced}
{synopt: {opt force}}proceed with imputation, even when missing imputed values are encountered{p_end}

{synopt: {opt noup:date}}do not perform {cmd:mi update} (not allowed with
{it:usermethod}); see 
{manhelp mi_noupdate_option MI:noupdate option}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt add(#)} is required when no imputations exist; 
{opt add(#)} or {cmd:replace} is required if imputations exist.{p_end}
{p 4 6 2}
{opt noupdate} does not appear in the dialog box.{p_end}
{p 4 6 2}
You must {cmd:mi set} your data before using {cmd:mi} {cmd:impute};
see {manhelp mi_set MI:mi set}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mi} {cmd:impute} fills in missing values ({cmd:.}) of a single variable
or of multiple variables using the specified method.  The available methods
(by variable type and missing-data pattern) are summarized in the tables
below.

{col 8}Single imputation variable (univariate imputation)
{col 8}{hline 60}
{col 8}{ralign 20:Pattern}{ralign 20:Type}{ralign 20:Imputation method}
{col 8}{hline 60}
{col 28}{ralign 20:continuous}{ralign 20:{cmd:regress}, {cmd:pmm},}
{col 28}{ralign 20:          }{ralign 20:{cmd:truncreg}, {cmd:intreg}}
{col 8}{ralign 20:always monotone}{ralign 20:binary}{ralign 20:{cmd:logit}}
{col 28}{ralign 20:categorical}{ralign 20:{cmd:ologit}, {cmd:mlogit}}
{col 28}{ralign 20:count}{ralign 20:{cmd:poisson}, {cmd:nbreg}}
{col 8}{hline 60}

{col 8}Multiple imputation variables (multivariate imputation)
{col 8}{hline 60}
{col 8}{ralign 20:Pattern}{ralign 20:Type}{ralign 20:Imputation method}
{col 8}{hline 60}
{col 8}{ralign 20:monotone missing}{ralign 20:mixture}{ralign 20:{cmd:monotone}}
{col 8}{ralign 20:arbitrary missing}{ralign 20:mixture}{ralign 20:{cmd:chained}}
{col 8}{ralign 20:arbitrary missing}{ralign 20:continuous}{ralign 20:{cmd:mvn}}
{col 8}{hline 60}

{pstd}
The suggested reading order of {cmd:mi} {cmd:impute}'s subentries is

        {manhelp mi_impute_regress MI:mi impute regress}
        {manhelp mi_impute_pmm MI:mi impute pmm}
        {manhelp mi_impute_truncreg MI:mi impute truncreg}
        {manhelp mi_impute_intreg MI:mi impute intreg}
        {manhelp mi_impute_logit MI:mi impute logit}
        {manhelp mi_impute_ologit MI:mi impute ologit}
        {manhelp mi_impute_mlogit MI:mi impute mlogit}
        {manhelp mi_impute_poisson MI:mi impute poisson}
        {manhelp mi_impute_nbreg MI:mi impute nbreg}

        {manhelp mi_impute_monotone MI:mi impute monotone}
        {manhelp mi_impute_chained MI:mi impute chained}
        {manhelp mi_impute_mvn MI:mi impute mvn}
        {manhelpi mi_impute_usermethod MI:mi impute usermethod}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputeRemarksandexamples:Remarks and examples}

        {mansection MI miimputeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt add(#)} specifies the number of imputations to add to the {cmd:mi} data.
This option is required if there are no imputations in the data.  If
imputations exist, then {cmd:add()} is optional.  The total number of
imputations cannot exceed 1,000.

{phang}
{opt replace} specifies to replace existing imputed values with new ones.  One
of {cmd:replace} or {cmd:add()} must be specified when {cmd:mi} data already
have imputations.

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used to
reproduce results.  {opt rseed(#)} is equivalent to typing {cmd:set}
{cmd:seed} {it:#} prior to calling {cmd:mi} {cmd:impute}; see
{manhelp set_seed R:set seed}.

{phang} 
{opt double} specifies that the imputed values be stored as {cmd:double}s.
By default, they are stored as {cmd:float}s.  {cmd:mi} {cmd:impute}
makes this distinction only when necessary.  For example, if the {cmd:logit}
method is used, the imputed values are stored as {cmd:byte}s.

{marker byopts}{...}
{phang}
{cmd:by(}{varlist} [{cmd:,} {it:byopts}]{cmd:)} specifies that imputation
be performed separately for each by-group.  By-groups are identified by equal
values of the variables in {it:varlist} in the
{help mi_glossary##original_data:original data} ({it:m}=0).
Missing categories in {it:varlist} are omitted, unless the {cmd:missing}
suboption is specified within {cmd:by()}.  Imputed and passive variables may
not be specified within {cmd:by()}.  This option is not allowed with
user-defined imputation methods, {it:usermethod}.

{phang2}
{it:byopts} are {cmdab:mis:sing}, {cmd:noreport}, {cmdab:noleg:end}, and
{cmd:nostop}.

{phang3}
{cmd:missing} specifies that missing categories in {it:varlist} are not
omitted.

{phang3}
{cmd:noreport} suppresses reporting of intermediate information about each
group.

{phang3}
{cmd:nolegend} suppresses the display of group legends that appear before the
imputation table when long group descriptions are encountered.

{phang3}
{cmd:nostop} specifies to proceed with imputation when imputation fails in
some groups.  By default, {cmd:mi impute} terminates with error when this
happens.

{dlgtab:Reporting}

{marker dots}{...}
{phang}
{cmd:dots} specifies to display dots as imputations are successfully completed.
An {bf:x} is displayed if any of the specified imputation variables still have
missing values.

{phang}
{cmd:noisily} specifies that intermediate output from {cmd:mi impute} be
displayed.  

{phang}
{cmd:nolegend} suppresses the display of all legends that appear before the
imputation table.

{dlgtab:Advanced}

{phang}
{cmd:force} specifies to proceed with imputation even when missing imputed
values are encountered.  By default, {cmd:mi impute} terminates with error
if missing imputed values are encountered.

{pstd}
The following option is available with {opt mi impute} but is not shown in the
dialog box:

{phang}
{cmd:noupdate} in some cases suppresses the automatic {cmd:mi update} this
command might perform; see 
{manhelp noupdate_option MI:noupdate option}.  This option is rarely
used and is not allowed with user-defined imputation methods, {it:usermethod}.


{marker remarks}{...}
{title:Remarks}

	{help mi_impute##mi_impute_use:Using mi impute}
	{help mi_impute##mi_impute_methods:Imputation methods}


{marker mi_impute_use}{...}
{title:Using mi impute}

{pstd}
The data must be {helpb mi set} prior to using {cmd:mi} {cmd:impute}.  All
variables whose missing values are to be filled in must be registered as
imputed variables; see {helpb mi register}.  If there are no imputations, you
must specify {cmd:add()}.  If imputations already exist, you must specify
either {cmd:add()} or {cmd:replace}.

{pstd}
If you do not have imputations, you must specify the number of imputations to
add in {cmd:add()}.  If you already have imputations, you have three choices:

{phang}
1.  Add new imputations to the existing ones by specifying the 
{cmd:add()} option.{p_end}
{phang}
2.  Add new imputations and also replace the existing ones by specifying
both the {cmd:add()} and the {cmd:replace} options.{p_end}
{phang}
3.  Replace existing imputed values by specifying the 
{cmd:replace} option.{p_end}

{pstd}
{cmd:mi} {cmd:impute} may change the type of the specified imputation
variables and the sort order of the data.  These changes are specific to the
declared {cmd:mi} style.


{marker mi_impute_methods}{...}
{title:Imputation methods}

{pstd}
{cmd:mi impute} supports both univariate and multivariate imputation under the
missing at random assumption (see
{mansection MI IntrosubstantiveRemarksandexamplesAssumptionsaboutmissingdata:{it:Assumptions about missing data}} under
{it:Remarks and examples} in {bf:[MI] Intro substantive}).

{pstd}
Univariate imputation is used to impute a single variable.  It can be used
repeatedly to impute multiple variables only when the variables are
independent and will be used in separate
analyses.  To impute a single variable, you can choose from the following 
methods: {helpb mi impute regress:regress}, {helpb mi impute pmm:pmm},
{helpb mi impute truncreg:truncreg}, {helpb mi impute intreg:intreg},
{helpb mi impute logit:logit}, {helpb mi impute ologit:ologit},
{helpb mi impute mlogit:mlogit}, {helpb mi impute poisson:poisson},
and {helpb mi impute nbreg:nbreg}.

{pstd}
For a continuous variable, either {cmd:regress} or {cmd:pmm} can be used
(for example, {help mi impute##R1987:Rubin [1987]} and
{help mi impute##ST1996:Schenker and Taylor [1996]}).  For a continuous
variable with a restricted range, a truncated variable, either {cmd:pmm} or
{cmd:truncreg} ({help mi impute##R2001:Raghunathan et al. 2001}) can be used.
For a continuous partially observed or censored variable, {cmd:intreg} can be
used ({help mi impute##R2007:Royston 2007}).
For a binary variable, {cmd:logit} can be used
({help mi impute##R1987:Rubin 1987}).  For a categorical
variable, {cmd:ologit} can be used to impute missing categories if they are
ordered, and {cmd:mlogit} can be used to impute missing categories if they are
unordered ({help mi impute##R2001:Raghunathan et al. 2001}).  For a count
variable, either {cmd:poisson} 
({help mi impute##R2001:Raghunathan et al. 2001}) or {cmd:nbreg}
({help mi impute##R2009:Royston 2009}), in the presence of overdispersion, is
often suggested.
Also see {help mi impute##vb2007:van Buuren (2007)} for a 
detailed list of univariate imputation methods.

{pstd}
In practice, multiple variables usually must be imputed simultaneously, and
that requires using a multivariate imputation method.  The choice of an
imputation method in this case also depends on the pattern of missing values.

{pstd}
If variables follow a 
{help mi_glossary##def_monotone:monotone-missing pattern} (see
{mansection MI IntrosubstantiveRemarksandexamplesPatternsofmissingdata:{it:Patterns of missing data}}
under {it:Remarks and examples} in {bf:[MI] Intro substantive}),
they can be imputed sequentially using univariate conditional distributions,
which is implemented in the {cmd:monotone} method (see
{helpb mi impute monotone:[MI] mi impute monotone}).  A separate univariate
imputation model can be specified for each imputation variable, which allows
simultaneous imputation of variables of different types
({help mi impute##R1987:Rubin 1987}).

{pstd} When a pattern of missing values is arbitrary, iterative methods are
used to fill in missing values.  The {cmd:mvn} method (see
{helpb mi impute mvn:[MI] mi impute mvn}) uses multivariate
normal data augmentation to impute missing values of continuous imputation
variables ({help mi impute##S1997:Schafer 1997}).
{help mi impute##A2001:Allison (2001)}, for example, also discusses how to use
this method to impute binary and categorical variables.

{pstd}
Another multivariate imputation method that accommodates arbitrary
missing-value patterns is multiple imputation using chained equations (MICE),
also known as imputation using fully conditional specifications 
({help mi impute##vb1999:van Buuren, Boshuizen, and Knook 1999}) and as 
sequential regression multivariate imputation 
({help mi impute##R2001:Raghunathan et al. 2001}) in the literature.  The MICE
method is implemented in the {cmd:chained} method
(see {manhelp mi_impute_chained MI:mi impute chained}) and uses a Gibbs-like
algorithm to impute multiple variables sequentially using univariate fully
conditional specifications.  Despite a lack of theoretical justification, the
flexibility of MICE has made it one of the most popular choices used in
practice.  

{pstd}
For a recent comparison of MICE and multivariate normal imputation, see 
{help mi impute##L2010:Lee and Carlin (2010)}.


{marker examples}{...}
{title:Examples:  Univariate imputation}

{pstd}
    Setup
{p_end}
{phang2}{cmd:. webuse mheart1s0}
{p_end}

{pstd}
    Describe {cmd:mi} data
{p_end}
{phang2}{cmd:. mi describe}
{p_end}

{pstd}
    Create 20 imputations using regression imputation, and then add 30 more
{p_end}
{phang2}{cmd:. mi impute regress bmi attack smokes age female hsgrad, add(20)}
{p_end}
{phang2}{cmd:. mi impute regress bmi attack smokes age female hsgrad, add(30)}
{p_end}

{pstd}
Use predictive mean matching and replace 50 existing imputations
{p_end}
{phang2}{cmd:. mi impute pmm bmi attack smokes age female hsgrad, replace knn(5)}
{p_end}


{title:Examples:  Multivariate imputation}

{pstd}
Setup
{p_end}
{phang2}
{cmd:. webuse mheart5s0, clear}
{p_end}

{pstd}
Describe {cmd:mi} data
{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
Examine missing-data patterns
{p_end}
{phang2}
{cmd:. mi misstable nested}
{p_end}

{pstd}
Create 10 imputations using monotone imputation (monotone-missing pattern)
{p_end}
{phang2}
{cmd:. mi impute monotone (regress) age bmi = attack smokes hsgrad female, add(10)}

{pstd}
Use multivariate normal imputation (arbitrary pattern) and replace existing imputations
{p_end}
{phang2}
{cmd:. mi impute mvn bmi = attack smokes hsgrad female, replace nolog}
{p_end}

{pstd}
Impute using chained equations (arbitrary pattern) and replace existing
imputations
{p_end}
{phang2}
{cmd:. mi impute chained (regress) age bmi = attack smokes hsgrad female, replace}
{p_end}


{title:Examples:  Imputing on subsamples}

{pstd}
Setup
{p_end}
{phang2}
{cmd:. webuse mheart1s0, clear}
{p_end}

{pstd}
Impute males and females separately and create 20 imputations
{p_end}
{phang2}
{cmd:. mi impute regress bmi attack smokes age hsgrad, add(20) by(female)}
{p_end}


{title:Examples:  Conditional imputation}

{pstd}
Setup
{p_end}
{phang2}
{cmd:. webuse mheart7s0, clear}
{p_end}

{pstd}
Describe {cmd:mi} data
{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
Examine missing-data patterns
{p_end}
{phang2}
{cmd:. mi misstable nested}
{p_end}

{pstd}
Impute {cmd:hightar} using only observations for which imputation variable {cmd:smokes} is equal to one
{p_end}
{phang2}
{cmd:. mi impute monotone}{break}
{cmd:    (regress) bmi age}{break} 
{cmd:    (logit, conditional(if smokes==1)) hightar}{break} 
{cmd:    (logit) smokes = attack hsgrad female, add(2)}
{p_end}


{title:Examples:  User-defined imputation methods}

{pstd}
See {help mi_impute_usermethod##examples:{it:Examples}} in
{manhelpi mi_impute_usermethod MI:mi impute usermethod}.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables{p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups ({cmd:1} if {cmd:by()} is not specified){p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method{p_end}
{synopt:{cmd:r(ivars)}}names of imputation variables{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used{p_end}
{synopt:{cmd:r(by)}}names of variables specified within {cmd:by()}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(N)}}number of observations in imputation sample in each group (per variable){p_end}
{synopt:{cmd:r(N_complete)}}number of complete observations in imputation sample in each group (per variable)
{p_end}
{synopt:{cmd:r(N_incomplete)}}number of incomplete observations in imputation sample in each group (per variable)
{p_end}
{synopt:{cmd:r(N_imputed)}}number of imputed observations in imputation sample in each group (per variable){p_end}

{pstd}
Also see {it:Stored results} in the method-specific entries for a list of
additional stored results.


{marker references}{...}
{title:References}

{marker A2001}{...}
{phang}
Allison, P. D. 2001. {it:Missing Data}. Thousand Oaks, CA: Sage.

{marker L2010}{...}
{phang}
Lee, K. J., and J. B. Carlin. 2010. Multiple imputation for missing data:
Fully conditional specification versus multivariate normal imputation.
{it:American Journal of Epidemiology} 171: 624-632.

{marker R2001}{...}
{phang}
Raghunathan, T. E., J. M. Lepkowski, J. Van Hoewyk, and P. Solenberger. 2001.
A multivariate technique for multiply imputing missing values using a sequence
of regression models. {it:Survey Methodology} 27: 85-95.

{marker R2007}{...}
{phang}
Royston, P. 2007. 
    {browse "http://www.stata-journal.com/sjpdf.html?articlenum=st0067_3":Multiple imputation of missing values:  Further update of ice, with an emphasis on interval censoring.}
    {it:Stata Journal} 7: 445-464.

{marker R2009}{...}
{phang}
------. 2009.
    {browse "http://www.stata-journal.com/article.html?article=st0067_4":Multiple imputation of missing values:  Further update of ice, with an emphasis on categorical variables.}
    {it:Stata Journal} 9: 466-477.

{marker R1987}{...}
{phang}
Rubin, D. B. 1987. {it:Multiple Imputation for Nonresponse in Surveys}.
New York: Wiley.

{marker S1997}{...}
{phang}
Schafer, J. L. 1997. {it:Analysis of Incomplete Multivariate Data}.
Boca Raton, FL: Chapman & Hall/CRC.

{marker ST1996}{...}
{phang}
Schenker, N., and J. M. G. Taylor. 1996. Partially parametric techniques for
multiple imputation. {it:Computational Statistics & Data Analysis} 22: 425-446.

{marker vb2007}{...}
{phang}
van Buuren, S. 2007. Multiple imputation of discrete and continuous data by
fully conditional specification. {it:Statistical Methods in Medical Research}
16: 219-242.

{marker vb1999}{...}
{phang}
van Buuren, S., H. C. Boshuizen, and D. L. Knook. 1999. Multiple imputation of
missing blood pressure covariates in survival analysis. 
{it:Statistics in Medicine} 18: 681-694.
{p_end}
