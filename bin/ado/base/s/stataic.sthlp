{smcl}
{* *! version 1.3.7  15oct2018}{...}
{vieweralsosee "[R] about" "help about"}{...}
{vieweralsosee "[D] Data types" "help data_types"}{...}
{vieweralsosee "[D] memory" "help memory"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{vieweralsosee "[U] 5 Flavors of Stata" "help flavors"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "limits" "help limits"}{...}
{vieweralsosee "Stata/MP" "help statamp"}{...}
{vieweralsosee "Stata/SE" "help statase"}{...}
{viewerjumpto "Using Stata/IC" "stataic##use"}{...}
{viewerjumpto "Contents" "stataic##contents"}{...}
{marker use}{...}
{title:Using Stata/IC}

{pstd}
There are three flavors of Stata:

{col 13}Flavor{col 29}Description
{col 13}{hline 47}
{col 10}-> {bf:Stata/IC}{col 29}standard version 
{col 13}{bf:Stata/SE}{col 29}Stata/IC + large datasets
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
{col 13}{bf:{help statase:Stata/SE}}{col 29}Using Stata/SE
{col 13}{bf:{help statamp:Stata/MP}}{col 29}Using Stata/MP
{col 13}{hline 47}

{pstd}
For information on upgrading to Stata/SE or Stata/MP, point your
browser to {browse "https://www.stata.com"}.


{marker contents}{...}
{title:Contents}

	1.  {help stataic##starting:Starting Stata/IC}

	2.  {help stataic##setting:Setting Stata/IC's limits}

	3.  {help stataic##dta:Sharing .dta datasets with non-IC users}

	4.  {help stataic##query:Querying memory usage}

	5.  {help stataic##programming:Advice to programmers:  Determining flavor}



{marker starting}{...}
{title:1.  Starting Stata/IC}

{pstd}
You start Stata/IC as follows:

{p 8 12 4}
    Windows:{break}
	Select {bf:Start > All Programs > Stata {ccl stata_version} > StataIC {ccl stata_version}}

{p 8 12 4}
    Mac:{break}
        Double-click the file {hi:Stata.do} from the {hi:data} folder, or
        double-click the {hi:Stata} icon from the {hi:Stata} folder.

{p 8 12 4}
    Unix:{break}
	At the Unix command prompt, type {cmd:xstata} to invoke the
	GUI version of Stata/IC, or type {cmd:stata} to invoke the
	console version.


{marker setting}{...}
{title:2.  Setting Stata/IC's limits}

{pstd}
The limit for Stata/IC is

{p 8 16 4}
    1.  {cmd:maxvar}{break}
	    The maximum number of variables allowed in a dataset.
	    This limit is set to 2,048 and cannot be reset.


{marker dta}{...}
{title:3.  Sharing .dta datasets with non-IC users}

{pstd}
You may share datasets with Stata/SE and Stata/MP users with no changes 
necessary.


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
{title:5.  Advice to programmers:  Determining flavor}

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
