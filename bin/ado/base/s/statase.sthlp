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
{vieweralsosee "Stata/MP" "help statamp"}{...}
{viewerjumpto "Using Stata/SE" "statase##use"}{...}
{viewerjumpto "Contents" "statase##contents"}{...}
{marker use}{...}
{title:Using Stata/SE}

{pstd}
There are three flavors of Stata:

{col 13}Flavor{col 29}Description
{col 13}{hline 47}
{col 13}{bf:Stata/IC}{col 29}standard version 
{col 10}-> {bf:Stata/SE}{col 29}Stata/IC + large datasets
{col 13}{bf:Stata/MP}{col 29}Stata/SE + parallel processing
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
{col 13}{bf:{help statamp:Stata/MP}}{col 29}Using Stata/MP
{col 13}{hline 47}

{pstd}
For information on upgrading to Stata/SE or Stata/MP, point your browser to
{browse "https://www.stata.com"}.


{marker contents}{...}
{title:Contents}

	1.  {help statase##starting:Starting Stata/SE}

	2.  {help statase##setting:Setting Stata/SE's limits}

	3.  {help statase##dta:Sharing .dta datasets with non-SE users}

	4.  {help statase##query:Querying memory usage}

	5.  {help statase##programmers:Advice to programmers}
	    5.1  {help statase##flavor:Determining flavor}
	    5.2  {help statase##macshift:Avoid macro shift in program loops}


{marker starting}{...}
{title:1.  Starting Stata/SE}

{pstd}
You start Stata/SE in much the same way as you start Stata/IC:

{p 8 12 4}
    Windows:{break}
	Select {bf:Start > All Programs > Stata {ccl stata_version} > StataSE {ccl stata_version}}

{p 8 12 4}
    Mac:{break}
        Double-click the file {hi:Stata.do} from the {hi:data} folder, or
        double-click the {hi:StataSE} icon from the {hi:Stata} folder.

{p 8 12 4}
    Unix:{break}
	At the Unix command prompt, type {cmd:xstata-se} to invoke the
	GUI version of Stata/SE, or type {cmd:stata-se} to invoke the
	console version.


{marker setting}{...}
{title:2.  Setting Stata/SE's limits}

{pstd}
The limit for Stata/SE is

{p 8 16 4}
    1.  {cmd:maxvar}{break}
	    The maximum number of variables allowed in a dataset.
	    This limit is initially set to 5,000; you can increase it
	    up to 32,767.

{pstd}
You reset the limit by using

	    {cmd:set maxvar}  {it:#} [{cmd:,} {cmdab:perm:anently}]{right:2,048 <= {it:#} <= 32,767    }

{pstd}
For instance, you might type

	    {cmd:. set maxvar  6000}

{pstd}
The order in which you set the limits does not matter.  If you specify the
{cmd:permanently} option when you set a limit, in addition to making the
change for the present session, Stata/SE will remember the new limit and use
it in the future when you invoke Stata/SE:

	    {cmd:. set maxvar  6000, permanently}

{pstd}
You can reset the current or permanent limits whenever and as often as you
wish.

{pstd}
Why is there a limit on {cmd:maxvar}?  Why not just set {cmd:maxvar} to
32,767 and be done with it?  Because simply allowing room for variables, even
if they do not exist, consumes memory, and if you will be
using only datasets with a lot fewer variables, you will be wasting memory.

{pstd}
For instance, if you set {cmd:maxvar} to 20,000, you would consume
approximately 14 more megabytes than if you left {cmd:maxvar} at the default.
That's not a huge amount of memory, but there is no need to waste it.

{p 8 8 4}
    {bf:Recommendation}:  Think about datasets with the most variables that
    you typically use.  Set {cmd:maxvar} to a few hundred or even 1,000
    above that.  (The memory cost of an extra 1,000 variables is
    about 1 MB.)


{marker dta}{...}
{title:3.  Sharing .dta datasets with non-SE users}

{pstd}
You may share datasets with Stata/MP users with no changes necessary.
You may share datasets with Stata/IC users
as long as your dataset does not have more variables than are allowed
in those flavors of Stata.  See {help limits}.


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


{marker programmers}{...}
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
