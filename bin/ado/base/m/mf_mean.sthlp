{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] mean()" "mansection M-5 mean()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "mf_mean##syntax"}{...}
{viewerjumpto "Description" "mf_mean##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_mean##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_mean##remarks"}{...}
{viewerjumpto "Conformability" "mf_mean##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_mean##diagnostics"}{...}
{viewerjumpto "Source code" "mf_mean##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] mean()} {hline 2}}Means, variances, and correlations
{p_end}
{p2col:}({mansection M-5 mean():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real rowvector}
{cmd:mean(}{it:X} [{cmd:,}
{it:w}]{cmd:)}


{p 8 12 2}
{it:real matrix}{bind:   }
{cmd:variance(}{it:X} [{cmd:,}
{it:w}]{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:   }
{cmd:quadvariance(}{it:X} [{cmd:,}
{it:w}]{cmd:)}


{p 8 12 2}
{it:real matrix}{bind:   }
{cmd:meanvariance(}{it:X} [{cmd:,}
{it:w}]{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:   }
{cmd:quadmeanvariance(}{it:X} [{cmd:,}
{it:w}]{cmd:)}



{p 8 12 2}
{it:real matrix}{bind:   }
{cmd:correlation(}{it:X} [{cmd:,}
{it:w}]{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:   }
{cmd:quadcorrelation(}{it:X} [{cmd:,}
{it:w}]{cmd:)}


{p 4 4 2}
where

{p 12 12 2}
{it:X}:  {it:real matrix X} (rows are observations, columns are variables)

{p 12 12 2}
{it:w}:  {it:real colvector w} and is optional.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mean(}{it:X}{cmd:,} {it: w}{cmd:)}
returns the weighted-or-unweighted column means of data matrix {it:X}.
{cmd:mean()} uses quad precision in forming sums and so is very accurate.

{p 4 4 2}
{cmd:variance(}{it:X}{cmd:,} {it: w}{cmd:)}
returns the weighted-or-unweighted variance matrix of {it:X}.  In the
calculation, means are removed and those means are calculated in
quad precision, but quad precision is not otherwise used.

{p 4 4 2}
{cmd:quadvariance(}{it:X}{cmd:,} {it: w}{cmd:)}
returns the weighted-or-unweighted variance matrix of {it:X}.  Calculation is
highly accurate; quad precision is used in forming all sums.

{p 4 4 2}
{cmd:meanvariance(}{it:X}{cmd:,} {it: w}{cmd:)}
returns {cmd:mean(}{it:X}{cmd:,}{it:w}{cmd:)\variance(}{it:X}{cmd:,}{it:w}{cmd:)}.

{p 4 4 2}
{cmd:quadmeanvariance(}{it:X}{cmd:,} {it: w}{cmd:)}
returns {cmd:mean(}{it:X}{cmd:,}{it:w}{cmd:)\quadvariance(}{it:X}{cmd:,}{it:w}{cmd:)}.


{p 4 4 2}
{cmd:correlation(}{it:X}{cmd:,} {it: w}{cmd:)}
returns the weighted-or-unweighted correlation matrix of {it:X}.
{cmd:correlation()} obtains the variance matrix from {cmd:variance()}.

{p 4 4 2}
{cmd:quadcorrelation(}{it:X}{cmd:,} {it: w}{cmd:)}
returns the weighted-or-unweighted correlation matrix of {it:X}.
{cmd:quadcorrelation()} obtains the variance matrix from {cmd:quadvariance()}.


{p 4 4 2}
In all cases, 
{it:w} specifies the weight.  
Omit {it:w}, or 
specify {it:w} as 1 to obtain unweighted means.

{p 4 4 2}
In all cases, 
rows of {it:X} or {it:w} that contain missing values are omitted 
from the calculation, which amounts to casewise deletion.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 mean()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 8 2}
1.
There is no {cmd:quadmean()} function because {cmd:mean()}, 
in fact, is {cmd:quadmean()}.  
The fact that {cmd:mean()} defaults to the quad-precision calculation 
reflects our judgment that the extra computational cost in computing means
in quad precision is typically justified.  

{p 4 8 2}
2.
The fact that {cmd:variance()} and {cmd:correlation()}
do not default to using quad precision for their calculations reflects 
our judgment that the extra computational cost is typically not justified.
The emphasis on this last sentence is on the word typically.  

{p 8 8 2}
It is easier to justify means in part because the extra computational cost
is less:  there are only {it:k} means but {it:k}({it:k}+1)/2 variances 
and covariances.


{p 4 8 2}
3.  If you need just the mean or just the variance matrix, call 
    {cmd:mean()} or {cmd:variance()} (or {cmd:quadvariance()}).  
    If you need both, there is a 
    CPU-time savings to be had by calling {cmd:meanvariance()}
    instead of the two functions separately (or {cmd:quadmeanvariance()}
    instead of calling {cmd:mean()} and {cmd:quadvariance()}).

{p 8 8 2}
    The savings is not great -- one {cmd:mean()} calculation is saved --
    but the greater {cmd:rows(}{it:X}{cmd:)}, the greater the savings.

{p 8 8 2}
    Upon getting back the combined result, it can be efficiently broken 
    into its components via

	    : {cmd:var   = meanvariance(X)}
	    : {cmd:means = var[1,.]}
	    : {cmd:var   = var[|2,1 \ .,.|]}


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:mean(}{it:X}{cmd:,} {it:w}{cmd:)}:
{p_end}
		{it:X}:  {it:n x k}
		{it:w}:  {it:n x 1} or {it:1 x 1}   (optional, {it:w}=1 assumed)
	   {it:result}:  {it:1 x k}

{p 4 4 2}
{cmd:variance(}{it:X}{cmd:,} {it:w}{cmd:)},
{cmd:quadvariance(}{it:X}{cmd:,} {it:w}{cmd:)},
{cmd:correlation(}{it:X}{cmd:,} {it:w}{cmd:)},
{cmd:quadcorrelation(}{it:X}{cmd:,} {it:w}{cmd:)}:
{p_end}
		{it:X}:  {it:n x k}
		{it:w}:  {it:n x 1} or {it:1 x 1}   (optional, {it:w}=1 assumed)
	   {it:result}:  {it:k x k}

{p 4 4 2}
{cmd:meanvariance(}{it:X}{cmd:,} {it:w}{cmd:)},
{cmd:quadmeanvariance(}{it:X}{cmd:,} {it:w}{cmd:)}:
{p_end}
		{it:X}:  {it:n x k}
		{it:w}:  {it:n x} 1 or 1 {it:x} 1   (optional, {it:w}=1 assumed)
	   {it:result}:  ({it:k}+1) {it:x} k


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All functions omit from the calculation rows that contain missing values
unless all rows contain missing values.  Then the returned result contains all
missing values.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view mean.mata, adopath asis:mean.mata},
{view variance.mata, adopath asis:variance.mata},
{view quadvariance.mata, adopath asis:quadvariance.mata},
{view meanvariance.mata, adopath asis:meanvariance.mata},
{view quadmeanvariance.mata, adopath asis:quadmeanvariance.mata},
{view correlation.mata, adopath asis:correlation.mata},
{view quadcorrelation.mata, adopath asis:quadcorrelation.mata}
{p_end}
