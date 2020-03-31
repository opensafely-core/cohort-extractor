{smcl}
{* *! version 1.0.2  05may2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] qrd()" "help mf_qrd"}{...}
{vieweralsosee "[M-5] qrsolve()" "help mf_qrsolve"}{...}
{vieweralsosee "[M-5] solveupper()" "help mf_solveupper"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "mf__lsfitqr##syntax"}{...}
{viewerjumpto "Description" "mf__lsfitqr##description"}{...}
{viewerjumpto "Remarks" "mf__lsfitqr##remarks"}{...}
{viewerjumpto "Conformability" "mf__lsfitqr##conformability"}{...}
{viewerjumpto "Diagnostics" "mf__lsfitqr##diagnostics"}{...}
{viewerjumpto "Source code" "mf__lsfitqr##source"}{...}
{title:Title}

{p 4 26 2}
{bf:[M-5] _lsfitqr()} {hline 2} Least-squares regression using
	QR decomposition{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} 
{cmd:_lsfitqr(}{it:real matrix X}{cmd:,} {it:real matrix Y}{cmd:,}
	{it:real colvector wt}{cmd:,} {it:real scalar cons}{cmd:,} 
	{it:real scalar rank}{cmd:,} {it:real matrix E}{cmd:,} 
	{it:real matrix r}{cmd:,} {it:real matrix R}{cmd:,} 
	{it:real rowvector p}{cmd:, |}{it: real scalar tol}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:_lsfitqr(}{it:X}{cmd:,} {it:Y}{cmd:,} {it:wt}{cmd:,} 
	{it:cons}{cmd:,} {it:rank}{cmd:,} {it:E}{cmd:,} {it:r}{cmd:,} 
	{it:R}{cmd:,} {it:p}{cmd:, |} {it:tol}{cmd:)}
computes the least-squares regression fit of {it:Y} on {it:X} using the 
positive weights {it:wt}.  If no weights are needed, use 
{it:wt} = {cmd:J(}0{cmd:,}1{cmd:,}0{cmd:)}.  Use {it:cons} = 1 if you
want a constant term in the model and a column of ones is not in {it:X}
already. 


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:_lsfitqr()} returns a matrix of regression coefficients from regressing
{it:Y} on {it:X}.  Weights, {it:wt}, are optional.  A constant term is added to
the model if {it:cons} is nonzero.  The rank of the model is returned in
{it:rank}, the residual covariance is returned in {it:E}, the regression mean
square matrix in {it:r}.  The upper triangular matrix {it:R} is from the QR
decomposition and {it:p} is the pivot vector.  Letting 
{it:q} = {cmd:invorder(}{it:p}{cmd:)} and {it:Z} =
{it:R}{cmd:[}{it:q}{cmd:,}{it:q}{cmd:]}, then {it:X}{cmd:'}{it:X} =
{it:Z}{cmd:'}{it:Z}. 

{p 4 4 2}
On return, {it:Y} contains the predicted values,  
{it:X}{cmd:*}{it:b} = {it:Q1}{cmd:*}{it:Q}{cmd:'}{it:Y}.  
See {helpb mf_qrd:qrd()} for a definition of {it:Q1}.
{it:X} and {it:wt} are modified.  When {cmd:_lsfitqr()} adds the constant term
it is not pivoted and the regression mean squares is adjusted for the mean.
The tolerance used to determine the rank of the regression, {it:tol}, is
passed through to {cmd:_solveupper()}.  {cmd:_lsfitqr()} uses 2^10 as a default
value.  See {helpb mf_solveupper:_solveupper()} on how {it:tol} is used to
determine the rank of the regression.


{marker conformability}{...}
{title:Conformability}

    {cmd:_lsfitqr(}{it:X}{cmd:,} {it:Y}{cmd:,} {it:wt}{cmd:,} {it:cons}{cmd:,} {it:rank}{cmd:,} {it:E}{cmd:,} {it:r}{cmd:,} {it:R}{cmd:,} {it:p}{cmd:, |}{it: tol}{cmd:)}:
	       {it:X}:  {it:n x k}
	       {it:Y}:  {it:n x m}
	      {it:wt}:  {it:n x} 1 or  0 {it: x} 1
	    {it:cons}:  1 {it:x} 1
	    {it:rank}:  1 {it:x} 1
	       {it:E}:  {it:m x m}
	       {it:r}:  {it:m x m}
	       {it:R}:  {it:k x k}
	       {it:p}:  1 {it:x k}
             {it:tol}:  1 {it:x} 1
	  {it:result}:  {it:k x m}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The rows of {it:Y} and {it:X} must be equal unless 
{it:X} = {bf:J(}0{bf:,}0{bf:,}0{cmd:)}.  If 
{it:X} = {bf:J(}0{bf:,}0{bf:,}0{cmd:)}, {it:cons} must be nonzero.  The
weights, {it:wt}, are ignored unless {bf:length(}{it:wt}{cmd:)} == {it:n}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view _lsfitqr.mata, adopath asis:_lsfitqr.mata}
{p_end}
