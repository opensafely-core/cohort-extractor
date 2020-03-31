{smcl}
{* *! version 1.0.1  01nov2019}{...}
{vieweralsosee "[PSS-3] ciwidth usermethod" "mansection PSS-3 ciwidthusermethod"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-3] Intro (ciwidth)" "mansection PSS-3 Intro(ciwidth)"}{...}
{vieweralsosee "[PSS-3] ciwidth" "help ciwidth"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{viewerjumpto "Syntax" "ciwidth_usermethod##syntax"}{...}
{viewerjumpto "Description" "ciwidth_usermethod##description"}{...}
{viewerjumpto "Links to PDF documentation" "ciwidth_usermethod##linkspdf"}{...}
{viewerjumpto "Remarks" "ciwidth_usermethod##remarks"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[PSS-3]} {it:ciwidth usermethod} {hline 2}}Add your own methods to
the ciwidth command{p_end}
{p2col:}({mansection PSS-3 ciwidthusermethod:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Compute sample size

{p 8 16 2}
{cmd:ciwidth} {help ciwidth_usermethod##usermethod:{it:usermethod}}
...{cmd:,} {opth w:idth(numlist)}
[{opth probw:idth(numlist)}
{help ciwidth##ciwidth_options:{it:ciwidthopts}}
{help ciwidth_usermethod##useropts:{it:useropts}}]


{pstd}
Compute CI width

{p 8 16 2}
{cmd:ciwidth} {help ciwidth_usermethod##usermethod:{it:usermethod}}
...{cmd:,} {help ciwidth_usermethod##nspec:{it:nspec}}
[{opth probw:idth(numlist)}
{help ciwidth##ciwidth_options:{it:ciwidthopts}}
{help ciwidth_usermethod##useropts:{it:useropts}}]


{pstd}
Compute probability of CI width

{p 8 16 2}
{cmd:ciwidth} {help ciwidth_usermethod##usermethod:{it:usermethod}}
...{cmd:,} {help ciwidth_usermethod##nspec:{it:nspec}} {opth w:idth(numlist)}
[{help ciwidth##ciwidth_options:{it:ciwidthopts}}
{help ciwidth_usermethod##useropts:{it:useropts}}]


{marker usermethod}{...}
{phang}
{it:usermethod} is the name of the method you would like to add to the
{cmd:ciwidth} command.  When naming your {cmd:ciwidth} methods, you should follow
the same convention as for naming the programs you add to Stata -- do not pick
"nice" names that may later be used by Stata's official methods.  The length
of {it:usermethod} may not exceed 14 characters. 

{marker useropts}{...}
{phang}
{it:useropts} are the options supported by your method
{it:usermethod}.

{marker nspec}{...}
{phang}
{it:nspec} contains {opth n(numlist)} for a one-sample CI or any of the
sample-size options of {help ciwidth##ciwidth_options:{it:ciwidthopts}} such as
{opt n1(numlist)} and {opt n2(numlist)} for a two-sample CI.


{marker description}{...}
{title:Description}

{pstd}
The {helpb ciwidth} command allows you to add your own methods to
{cmd:ciwidth} and produce tables and graphs of results automatically.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-3 ciwidthusermethodRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Adding your own methods to {cmd:ciwidth} is easy.  Suppose you want to add a
method called {cmd:mymethod} to {cmd:ciwidth}.  Simply

{phang}
1.  write an {help program:r-class program} called
   {cmd:ciwidth_cmd_mymethod} that computes sample size, probability of CI
   width, or CI width and follows {cmd:ciwidth}'s convention for naming common
   options and storing results; and

{phang}
2.  place the program where Stata can find it.

{pstd}
You are done.  You can now use {cmd:mymethod} within {cmd:ciwidth} like any
other official {cmd:ciwidth} method.

    {title:A quick example}

{pstd}
Before we discuss the technical details in the following sections, let's try
an example.  Let's write a program to compute CI width for a one-mean 
normal-based CI
given sample size, standard deviation, and confidence level.  For
simplicity, we assume a two-sided CI.  We will call our new method
{cmd:mymean}. (Note that this method is
available in the official {helpb ciwidth onemean}
command when you specify the {cmd:knownsd} option.) 

{pstd}
We create an ado-file called {cmd:ciwidth_cmd_mymean.ado} that contains the
following Stata program:

      // evaluator
      {cmd:program ciwidth_cmd_mymean, rclass}
              {cmd:version {ccl stata_version}}
              /* parse options */
              {cmd:syntax, n(integer)}          /// sample size
                      {cmd:[ Level(cilevel)}    /// confidence level
                        {cmd:Stddev(real 1) ]}  /// standard deviation
              /* compute CI width */
              {cmd:tempname width}
              {cmd:scalar `width' = 2*invnormal(1/2+`level'/200)*`stddev'/sqrt(`n')}
              /* store results */
              {cmd}return scalar level   = `level'
              return scalar N       = `n'
              return scalar width   = `width'
              return scalar stddev  = `stddev'
      end{txt}

{pstd}
Our ado-program consists of three sections: the {helpb syntax} command for
parsing options, the CI width computation, and stored or returned results.
The three sections work as follows:

{pmore}
The {cmd:ciwidth_cmd_mymean} program has two of {cmd:ciwidth}'s common options,
{cmd:level()} for confidence level and {cmd:n()} for sample size, and it has
its own option, {cmd:stddev()}, with the minimum abbreviation {cmd:s()} and 
default value of 1, to specify a standard deviation.

{pmore}
After the options are parsed, the CI width is computed and stored in a 
{help macro:temporary scalar} {cmd:`width'}.

{pmore}
Finally, the resulting CI width and other results are stored in return scalars.
Following {cmd:ciwidth}'s
{mansection PSS-3 ciwidthusermethodRemarksandexamplesconvention:convention} for
naming commonly returned results, the confidence level is stored in
{cmd:r(level)}, the sample size in {cmd:r(N)}, and the computed CI width in
{cmd:r(width)}.  The program additionally stores the standard deviation
in {cmd:r(stddev)}.

{pstd}
We can now use {cmd:mymean} within {cmd:ciwidth} as we would any other 
existing method of {cmd:ciwidth}:

      {cmd:. ciwidth mymean, level(95) n(10) stddev(0.25)}

{pstd}
We can check out result using the official {helpb ciwidth onemean}:

      {cmd:. ciwidth onemean, level(95) n(10) sd(0.25) knownsd}

{pstd}
We can compute results for multiple sample sizes by specifying multiple values
in the {cmd:n()} option.  Note that our {cmd:ciwidth_cmd_mymean} program accepts
only one value at a time in {cmd:n()}.  When a
{help numlist} is
specified in the {cmd:ciwidth} command's {cmd:n()} option, {cmd:ciwidth}
automatically handles that {it:numlist} for us.

      {cmd:. ciwidth mymean, level(95) n(10 20) stddev(0.25)}

{pstd}
We can also compute results for multiple sample sizes and confidence levels
without any additional effort on our part:

      {cmd:. ciwidth mymean, level(90 95) n(10 20) stddev(0.25)}

{pstd}
We can even produce a graph by merely specifying the {cmd:graph} option:

      {cmd:. ciwidth mymean, level(90 95) n(10(10)100) stddev(0.25) graph}

{pstd}
The above is just a simple example.  Your program can be as complicated as you
would like: you can even use simulations to compute your results; see
{mansection PSS-3 ciwidthusermethodRemarksandexamplesmoreexamples:{it:More examples: Compute probability of CI width for a one-proportion CI}}
in {bf:[PSS-3] ciwidth usermethod}.  You can also customize your tables and
graphs with a little extra effort.
{p_end}
