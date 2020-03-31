{smcl}
{* *! version 1.0.3  21aug2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] Toeplitz()" "help mf_toeplitz"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] arfimaacf()" "help mf_arfimaacf"}{...}
{viewerjumpto "Syntax" "mf_toeplitzsolve##syntax"}{...}
{viewerjumpto "Description" "mf_toeplitzsolve##description"}{...}
{viewerjumpto "Remarks" "mf_toeplitzsolve##remarks"}{...}
{viewerjumpto "Conformability" "mf_toeplitzsolve##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_toeplitzsolve##diagnostics"}{...}
{viewerjumpto "Source code" "mf_toeplitzsolve##source"}{...}
{viewerjumpto "References" "mf_toeplitzsolve##references"}{...}
{title:Title}

{p 4 8 2}
{bf:[M-5] toeplitzsolve()} {hline 2} Solve linear systems using Toeplitz
matrix{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} 
{cmd:toeplitzsolve(}{it:real colvector c1}{cmd:,} |{it:real matrix Y}{cmd:)}

{p 8 12 2}
{it:real matrix} 
{cmd:toeplitzscale(}{it:real colvector c1}{cmd:,} {it:real matrix Y}{cmd:)}

{p 8 12 2}
{it:real matrix} 
{cmd:_toeplitzscale(}{it:real colvector c1}{cmd:,} {it:real matrix Y}{cmd:,}
	{it:real colvector v}{cmd:,} {it:real scalar ldet}{cmd:)}

{p 8 12 2}
{it:real matrix} 
{cmd:toeplitzchprod(}{it:real colvector c1}{cmd:,} {it:real matrix Z}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:toeplitzsolve(}{it:c1}{cmd:,} |{it:Y}{cmd:)}
solves {it:T}*{it:B} = {it:Y} for {it:B}, where 
{it:T} = {cmd:Toeplitz(}{it:c1}{cmd:,}{it:c1}{cmd:')}.
If {it:Y} is missing
{cmd:_toeplitzsolve()} solves the Yule-Walker equations, where 
{it:Y} = {it:c1}[|{it:2}\{it:n}|].

{p 4 4 2}
{cmd:toeplitzscale(}{it:c1}{cmd:,} {it:Y}{cmd:)}
computes {cmd:solvelower(}{it:R}{cmd:,}{it:Y}{cmd:)} using the
Durbin-Levinson algorithm.  Here 
{it:T} = {cmd:Toeplitz(}{it:c1}{cmd:,}{it:c1}{cmd:')} = 
{it:R}*{it:R}{cmd:'}, {it:R} = {cmd:cholesky(}{it:T}{cmd:)}.

{p 4 4 2}
{cmd:_toeplitzscale(}{it:c1}{cmd:,} {it:Y}{cmd:,} {it:v}{cmd:,} {it:ldet}{cmd:)}
computes {cmd:solvelower(}{it:L}{cmd:,}{it:Y}{cmd:)} using the 
Durbin-Levinson algorithm.  Here
{it:T} = {cmd:Toeplitz(}{it:c1}{cmd:,}{it:c1}{cmd:')} = 
{it:L}*{it:D}*{it:L}{cmd:'}, {it:D} = {cmd:diag(}{it:v}{cmd:)}, and
{it:L} is lower triangular with 1's on the diagonal.

{p 4 4 2}
{cmd:toeplitzchprod(}{it:c1}{cmd:,} {it:Z}{cmd:)} computes {it:R}*{it:Z},
where {it:R} = {cmd:cholesky(}{it:T}{cmd:)} and 
{it:T} = {cmd:Toeplitz(}{it:c1}{cmd:,} {it:c1}{cmd:')} = 
{it:R}*{it:R}{cmd:'}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:toeplitzsolve()}, {cmd:toeplitzscale()}, and {cmd:_toeplitzchprod()}
are designed specifically for time-series applications.  The column
vector {it:c1} is the autocovariance of the process.  Elements 
{it:c1}[{it:h}] = 
{cmd:cov(}{it:Y}[{it:t},{it:j}]{cmd:,}{it:Y}[{it:t+h}-1,{it:j}]{cmd:)},
{it:h} = 1, ..., {it:n-t}+1, so 
{it:c1}[1] = {cmd:var(}{it:y}[{it:t}]{cmd:)}.  Here
{it:n} = {cmd:length(}{it:c1}{cmd:)} = {cmd:rows(}{it:Y}{cmd:)}.

{p 4 4 2}
The Yule-Walker estimates of an autoregressive process are found by
{it:P} = {cmd:toeplitzsolve(}{it:c1}{cmd:)}, where it is preferred that
{it:c1} be the autocorrelation function, that is, {it:c1}[1] = 1.
{cmd:toeplitzsolve()} is also useful in computing time-series forecasts;
see {help mf_toeplitzsolve##B1994:Beran (1994, sec. 8.7)}.

{p 4 4 2}
{it:E} = {cmd:_toeplitzscale(}{it:c1}{cmd:,}{it:Y}{cmd:,}{it:v}{cmd:,}{it:ldet}{cmd:)}
is the {it:r x c1} matrix of residuals of the one-step predictions of 
{it:Y}, where columns of {it:Y} are generated from the autoregressive process
with covariance {it:T} = {cmd:Toeplitz(}{it:c1}{cmd:,}{it:c1}{cmd:')};
see {help mf_toeplitzsolve##P2007:Palma (2007, sec. 4.1.2)}.  Specifically,
{it:E}[{it:t},{it:j}] = {it:Y}[{it:t},{it:j}] - 
{it:M}[{it:t},1\{it:t},{it:t-1}]*{it:Y}[|1,{it:j}\{it:t}-1,{it:j}|], where 
{it:M} = {cmd:cholinv(}{it:L}{cmd:)}, but carried out efficiently using
the Durbin-Levinson algorithm.  The rows of -{it:M} contain the autoregressive
parameters of the process.  The vector {it:v} contains the variances
of the residuals and {it:ldet} is the log determinate of {it:T}.  These
are all the quantities necessary to compute the log likelihood of {it:Y} coming
from a zero mean time-series process with covariance {it:T}.

{p 4 4 2}
{it:Z} = {cmd:toeplitzscale(}{it:c1}{cmd:,}{it:Y}{cmd:)} computes 
{it:Z} = {it:E}:/{cmd:sqrt(}{it:v}{cmd:)}, where {it:E} and {it:v} are from
a call to {cmd:_toeplitzscale()}.

{p 4 4 2}
If {it:Z} = {cmd:rnormal(}{it:r}{cmd:,}{it:c1}{cmd:,}0{cmd:,}1{cmd:)}, then
{it:Y} = {cmd:toeplitzchprod(}{it:c1}{cmd:,}{it:Z}{cmd:)} is a set of {it:c1}
independent zero mean processes of length {it:r} with covariances 
{it:T} = {cmd:Toeplitz(}{it:c1}{cmd:,}{it:c1}{cmd:')}.  Typically, {it:c1} = 1.
{it:R} = {cmd:cholesky(}{it:T}{cmd:)} is carried out efficiently using 
Shur's algorithm ({help mf_toeplitzsolve##S1997:Stewart 1997}).  

{p 4 4 2}
See {helpb mf_arfimaacf:[M-5] arfimaacf()} for generating the autocovariance
function, {it:c1}, for an autoregressive (fractionally integrated)
moving-average process.


{marker conformability}{...}
{title:Conformability}

    {cmd:toeplitzsolve(}{it:c1}{cmd:,} |{it:Y}{cmd:)}:
	      {it:c1}:  {it:r x} 1
	       {it:Y}:  {it:r x c1}
	  {it:result}:  {it:r x c1} or {it: r x} 1

    {cmd:toeplitzscale(}{it:c1}{cmd:,} {it:Y}{cmd:)}:
	      {it:c1}:  {it:r x} 1
	       {it:Y}:  {it:r x c1}
	  {it:result}:  {it:r x c1}

    {cmd:_toeplitzscale(}{it:c1}{cmd:,} {it:Y}{cmd:,} {it:v}{cmd:,} {it:ldet}{cmd:)}:
	      {it:c1}:  {it:r x} 1
	       {it:Y}:  {it:r x c1}
	       {it:v}:  {it:r x} 1
            {it:ldet}:  1 {it:x} 1
	  {it:result}:  {it:r x c1}

    {cmd:toeplitzchprod(}{it:c1}{cmd:,} {it:Z}{cmd:)}:
	       {it:c1}:  {it:r x} 1
	       {it:Z}:  {it:r x c1}
          {it:result}:  {it:r x c1}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view toeplitzsolve.mata, adopath asis:toeplitzsolve.mata}


{marker references}{...}
{title:References}

{marker B1994}{...}
{phang}
Beran, J. 1994. {it:Statistics for Long-Memory Processes}. Chapman & Hall/CRC.

{marker P2007}{...}
{phang}
Palma, W. 2007. {it:Long-Memory Time Series: Theory and Methods}. Wiley.

{marker S1997}{...}
{phang}
Stewart, M. 1997. Cholesky factorization of semi-definite Toeplitz matrices.
{it:Linear Algebra and its Applications} 254: 497-525.
{p_end}
