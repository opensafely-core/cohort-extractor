{smcl}
{* *! version 1.0.14  01nov2019}{...}
{vieweralsosee "[PSS-2] power usermethod" "mansection PSS-2 powerusermethod"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] Intro (power)" "mansection PSS-2 Intro(power)"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{viewerjumpto "Syntax" "power_usermethod##syntax"}{...}
{viewerjumpto "Description" "power_usermethod##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_usermethod##linkspdf"}{...}
{viewerjumpto "Remarks" "power_usermethod##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[PSS-2]} {it:power usermethod} {hline 2}}Add your own methods to the power command{p_end}
{p2col:}({mansection PSS-2 powerusermethod:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Compute sample size

{p 8 16 2}
{cmd:power} {help power_usermethod##usermethod:{it:usermethod}}
...
[{cmd:,} {opth p:ower(numlist)}
{help power##power_options:{it:poweropts}}
{help power_usermethod##useropts:{it:useropts}}]


{pstd}
Compute power

{p 8 16 2}
{cmd:power} {help power_usermethod##usermethod:{it:usermethod}}
...{cmd:,} {help power_usermethod##nspec:{it:nspec}}
[{help power##power_options:{it:poweropts}}
{help power_usermethod##useropts:{it:useropts}}]


{pstd}
Compute effect size

{p 8 16 2}
{cmd:power} {help power_usermethod##usermethod:{it:usermethod}}
...{cmd:,} {help power_usermethod##nspec:{it:nspec}} {opth p:ower(numlist)}
[{help power##power_options:{it:poweropts}}
{help power_usermethod##useropts:{it:useropts}}]


{marker usermethod}{...}
{phang}
{it:usermethod} is the name of the method you would like to add to the
{cmd:power} command.  When naming your {cmd:power} methods, you should follow
the same convention as for naming the programs you add to Stata -- do not pick
"nice" names that may later be used by Stata's official methods.  The length
of {it:usermethod} may not exceed 16 characters.

{marker useropts}{...}
{phang}
{it:useropts} are the options supported by your method
{it:usermethod}.

{marker nspec}{...}
{phang}
{it:nspec} contains {opth n(numlist)} for a one-sample test or any of the
sample-size options of {help power##power_options:{it:poweropts}} such as
{opt n1(numlist)} and {opt n2(numlist)} for a two-sample test.


{marker description}{...}
{title:Description}

{pstd}
The {helpb power} command allows you to add your own methods to
{cmd:power} and produce tables and graphs of results automatically.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerusermethodRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Adding your own methods to {cmd:power} is easy.  Suppose you want to add a
method called {cmd:mymethod} to {cmd:power}.  Simply

{phang}
1.  write an {help program:r-class program} called
   {cmd:power_cmd_mymethod} that computes power, sample size, or effect size
   and follows {cmd:power}'s convention for naming common options and storing
   results; and

{phang}
2.  place the program where Stata can find it.

{pstd}
You are done.  You can now use {cmd:mymethod} within {cmd:power} like any
other official {cmd:power} method.


{marker introex}{...}
    {title:A quick example}

{pstd}
Before we discuss the technical details in the following sections, let's try
an example.  Let's write a program to compute power for a one-sample {it:z}
test given sample size, standardized difference, and significance level.  For
simplicity, we assume a two-sided test.  We will call our new method
{cmd:myztest}.

{pstd}
We create an ado-file called {cmd:power_cmd_myztest.ado} that contains the
following Stata program:

{p 12 18 2}// evaluator{p_end}
{p 12 18 2}{cmd:program power_cmd_myztest, rclass}{p_end}
{p 20 26 2}{cmd:version {ccl stata_version}}{p_end}
{p 40 46 2}/* parse options */{p_end}
                    {cmd:syntax, n(integer)}        /// sample size
                             {cmd:STDDiff(real)}    /// standardized difference
                             {cmd:Alpha(string)}    /// significance level

{p 40 46 2}/* compute power */{p_end}
{p 20 26 2}{cmd:tempname power}{p_end}
{p 20 26 2}{cmd:scalar `power' = normal(`stddiff'*sqrt(`n') - invnormal(1-`alpha'/2))}{p_end}

{p 40 46 2}/* return results */{p_end}
{p 20 26 2}{cmd:return scalar power   = `power'}{p_end}
{p 20 26 2}{cmd:return scalar N       = `n'}{p_end}
{p 20 26 2}{cmd:return scalar alpha   = `alpha'}{p_end}
{p 20 26 2}{cmd:return scalar stddiff = `stddiff'}{p_end}
{p 12 18 2}{cmd:end}{p_end}

{pstd}
Our ado-program consists of three sections: the {helpb syntax} command for
parsing options, the power computation, and stored or returned results.
The three sections work as follows:

{p 8 8 2}
The {cmd:power_cmd_myztest} program has two of {cmd:power}'s common options,
{cmd:n()} for sample size and {cmd:alpha()} for significance level, and it has
its own option, {cmd:stddiff()}, to specify a standardized difference.

{p 8 8 2}
After the options are parsed, the power is computed and stored in a 
{help tempname:temporary scalar} {cmd:`power'}.

{p 8 8 2}
Finally, the resulting power and other results are stored in return scalars.
Following {cmd:power}'s {mansection pss-2 powerusermethodRemarksandexamplesconvention:convention} for
naming commonly returned results, the computed power is stored in
{cmd:r(power)}, the sample size in {cmd:r(N)}, and the significance level in
{cmd:r(alpha)}.  The program additionally stores the standardized difference
in {cmd:r(stddiff)}.

{pstd}
We can now use {cmd:myztest} within {cmd:power} as we would any other 
existing method of {cmd:power}:

{phang2}{cmd:. power myztest, alpha(0.05) n(10) stddiff(0.25)}{p_end}

{pstd}
We can compute results for multiple sample sizes by specifying multiple values
in the {cmd:n()} option.  Note that our {cmd:power_cmd_myztest} program accepts
only one value at a time in {cmd:n()}.  When a {help numlist} is
specified in the {cmd:power} command's {cmd:n()} option, {cmd:power}
automatically handles that {it:numlist} for us.

{phang2}{cmd:. power myztest, alpha(0.05) n(10 20) stddiff(0.25)}{p_end}

{pstd}
We can also compute results for multiple sample sizes and significance levels
without any additional effort on our part:

{phang2}{cmd:. power myztest, alpha(0.01 0.05) n(10 20) stddiff(0.25)}{p_end}

{pstd}
We can even produce a graph by merely specifying the {cmd:graph} option:

{phang2}{cmd:. power myztest, alpha(0.01 0.05) n(10(10)100) stddiff(0.25) graph}
{p_end}

{pstd}
The above is just a simple example.  Your program can be as complicated as you
would like: you can even use simulations to compute your results.
You can also customize your tables and graphs with a little extra effort.
{p_end}
