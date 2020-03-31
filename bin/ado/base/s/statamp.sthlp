{smcl}
{* *! version 1.4.9  15oct2018}{...}
{vieweralsosee "[R] about" "help about"}{...}
{vieweralsosee "[D] Data types" "help data_types"}{...}
{vieweralsosee "[D] memory" "help memory"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{vieweralsosee "[U] 5 Flavors of Stata" "help flavors"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "limits" "help limits"}{...}
{vieweralsosee "Stata/IC" "help stataic"}{...}
{vieweralsosee "Stata/SE" "help statase"}{...}
{viewerjumpto "Using Stata/MP" "statamp##use"}{...}
{viewerjumpto "Contents" "statamp##contents"}{...}
{marker use}{...}
{title:Using Stata/MP}

{pstd}
There are three flavors of Stata:

{col 13}Flavor{col 29}Description
{col 13}{hline 47}
{col 13}{bf:Stata/IC}{col 29}standard version 
{col 13}{bf:Stata/SE}{col 29}Stata/IC + large datasets
{col 10}-> {bf:Stata/MP}{col 29}Stata/SE + parallel processing
{col 13}{hline 47}
{col 13}See {bf:{help flavors:[U] 5 Flavors of Stata}} for descriptions

{pstd}
To determine which flavor of Stata you are running, type

	    {cmd:. about}

{pstd}
If you are using a different flavor of Stata, click on the appropriate
link:  

{col 13}{hline 47}
{col 13}{bf:{help stataic:Stata/IC}}{col 29}Using Stata/IC
{col 13}{bf:{help statase:Stata/SE}}{col 29}Using Stata/SE
{col 13}{hline 47}

{pstd}
For information on upgrading to Stata/MP, point your browser to
{browse "https://www.stata.com"}.


{marker contents}{...}
{title:Contents}

	1.  {help statamp##starting:Starting Stata/MP}

	2.  {help statamp##setting:Setting Stata/MP's limits}
	    2.1  {help statamp##processors:Advice on setting processors}
	    2.2  {help statamp##maxvar:Advice on setting maxvar}

	3.  {help statamp##dta:Sharing .dta datasets with non-MP users}

	4.  {help statamp##query:Querying memory usage}

	5.  {help statamp##programming:Advice to programmers}
	    5.1  {help statamp##flavor:Determining flavor}
	    5.2  {help statamp##macshift:Avoid macro shift in program loops}


{marker starting}{...}
{title:1.  Starting Stata/MP}

{pstd}
You start Stata/MP in much the same way as you start Stata/IC or Stata/SE:

{p 8 12 4}
    Windows:{break}
	Select {bf:Start > All Programs > Stata {ccl stata_version} > StataMP {ccl stata_version}}

{p 8 12 4}
    Mac:{break}
        Double-click the file {hi:Stata.do} from the {hi:data} folder, or
        double-click the {hi:StataMP} icon from the {hi:Stata} folder.

{p 8 12 4}
    Unix:{break}
	At the Unix command prompt, type {cmd:xstata-mp} to invoke the
	GUI version of Stata/MP, or type {cmd:stata-mp} to invoke the
	console version.


{marker setting}{...}
{title:2.  Setting Stata/MP's limits}

{pstd}
The two limits for Stata/MP are as follows:

{p 8 16 4}
    1.  {cmd:processors}{break}
	    The maximum number of processors or cores to be used.
	    This limit is initially set to (1) the number of cores on
	    your computer or (2) the number of cores allowed by your
	    license, depending on which is less.  You reset the limit if 
	    you want to use fewer processors than that, say because you 
	    want to leave processors free for some other, non-Stata task.

{p 8 16 4}
    2.  {cmd:maxvar}{break}
	    The maximum number of variables allowed in a dataset.
	    This limit is initially set to 5,000; you can increase it
	    up to 120,000.

{pstd}
You reset the limits by using the

	    {cmd:set processors} {it:#}
	    {cmd:set maxvar}     {it:#}          [{cmd:,} {cmdab:perm:anently}]

{pstd}
commands.  For instance, you might type

	    {cmd:. set processors 4}
	    {cmd:. set maxvar     6000}

{pstd}
The order in which you set the limits does not matter.  If you specify the
{cmd:permanently} option with {cmd:maxvar}, in addition to making the change
for the present session, Stata/MP will remember the new limit and use it in
the future when you invoke Stata/MP.

{pstd}
You can reset the present or permanent limits whenever and as often as you
wish.


{marker processors}{...}
{title:2.1  Advice on setting processors}

	    {cmd:set processors} {it:#}
	
{pstd}
You may set the number of processors to be used to any number up to 
the lessor of 
(1) the number of cores on your computer and 
(2) the number of cores licensed.
You may even set {cmd:processors} to 1, and then
Stata/MP is effectively identical to Stata/SE.  

{pstd}
In general, you will get the best performance by using all processors 
available, leaving {cmd:processors} set to the default.
If you are running a large Stata job in the background, however, you may want
to reduce the maximum number that Stata/MP will use to have better 
performance in your foreground tasks.
If you are running two large Stata jobs in the background, you may get 
slightly better performance if you restrict each to using half the 
number of processors.


{marker maxvar}{...}
{title:2.2  Advice on setting maxvar}

	    {cmd:set maxvar}  {it:#} [{cmd:,} {cmdab:perm:anently}]{right:2,048 <= {it:#} <= 120,000   }

{pstd}
Why is there a limit on {cmd:maxvar}?  Why not just set {cmd:maxvar} to
120,000 and be done with it?  Because simply allowing room for variables, even
if they do not exist, consumes memory, and if you will be
using only datasets with a lot fewer variables, you will be wasting memory.

{pstd}
For instance, if you set {cmd:maxvar} to 20,000, you would consume
approximately 14 more megabytes than if you left {cmd:maxvar} at the default.
If you set {cmd:maxvar} to 120,000, you would consume a bit over 100
more megabytes than if you left {cmd:maxvar} at the default.

{p 8 8 4}
    {bf:Recommendation}:  Think about datasets with the most variables that
    you typically use.  Set {cmd:maxvar} to a few hundred or even 1,000
    above that.  (The memory cost of an extra 1,000 variables is
    about 1 MB.)

{p 8 8 4}
    {bf:Remember}, you can always reset {cmd:maxvar} temporarily by typing
    {cmd:set maxvar} {it:#}.


{marker dta}{...}
{title:3.  Sharing .dta datasets with non-MP users}

{pstd}
You may share datasets with Stata/SE and Stata/IC users
as long as your dataset does not have more variables than are allowed
in those flavors of Stata; see {help limits}.


{marker query}{...}
{title:4.  Querying memory usage}

{pstd}
The command

	    {cmd:. memory}

{pstd}
will display the current memory report and the command 

	    {cmd:. query memory}

{pstd}
will display the current memory settings.
See {help memory:help memory}.



{marker programming}{...}
{title:5.  Advice to programmers}


{marker flavor}{...}
{title:5.1  Determining flavor}

{pstd}
Programmers can determine which flavor of Stata is running by 
examining the {help creturn} values

		                 creturn values
                        {c |} {cmd:c(flavor)   c(SE)     c(MP)}
	    {hline 12}{c +}{hline 30}
	    Stata/IC    {c |}  "{cmd:IC}"         0         0
	    Stata/SE    {c |}  "{cmd:IC}"         1         0
	    Stata/MP    {c |}  "{cmd:IC}"         1         1
	    {hline 12}{c BT}{hline 30}


{marker macshift}{...}
{title:5.2  Avoid macro shift in program loops}

{pstd}
{helpb macro:macro shift} has negative performance implications when used with
variable lists containing 20,000 or more variables.  We recommend avoiding the
use of {cmd:macro shift} in loops and instead 
using either {helpb foreach} or "double
indirection".  Double indirection means referring to {cmd:``i''} when
{cmd:`i'} contains a number 1, 2, ....
{p_end}
