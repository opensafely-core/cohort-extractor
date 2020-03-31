{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] trace()" "mansection M-5 trace()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_trace##syntax"}{...}
{viewerjumpto "Description" "mf_trace##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_trace##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_trace##remarks"}{...}
{viewerjumpto "Conformability" "mf_trace##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_trace##diagnostics"}{...}
{viewerjumpto "Source code" "mf_trace##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] trace()} {hline 2}}Trace of square matrix
{p_end}
{p2col:}({mansection M-5 trace():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric scalar} 
{cmd:trace(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:numeric scalar} 
{cmd:trace(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:)}

{p 8 12 2}
{it:numeric scalar} 
{cmd:trace(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:,}
{it:real scalar t}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:trace(}{it:A}{cmd:)}
returns the sum of the diagonal elements of {it:A}.  
Returned result is real if {it:A} is real, complex if {it:A} is complex.

{p 4 4 2}
{cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:)}
returns trace({it:A}{it:B}), the calculation being made without calculating
or storing the off-diagonal elements of {it:A}{it:B}.  
Returned result is real if {it:A} and {it:B} are real and is complex otherwise.

{p 4 4 2}
{cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:,} {it:t}{cmd:)}
returns trace({it:A}{it:B}) if {it:t}=0 and returns
trace({it:A}{bf:'}{it:B}{cmd:)} otherwise, where, if either {it:A} or {it:B} 
is complex, transpose is understood to mean
{help m6_glossary##transpose:conjugate transpose}.
Returned result is real if {it:A} and {it:B} are real and is complex otherwise.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 trace()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:)}
returns the same result as 
{cmd:trace(}{it:A}{cmd:*}{it:B}{cmd:)} but is more efficient if you do 
not otherwise need to calculate {it:A}{cmd:*}{it:B}.

{p 4 4 2}
{cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:, 1)}
returns the same result as 
{cmd:trace(}{it:A}{cmd:'}{it:B}{cmd:)} but is more efficient.

{p 4 4 2}
For real matrices {it:A} and {it:B},

		trace({it:A}{bf:'}) = trace({it:A})

		trace({it:A}{it:B}) = trace({it:B}{it:A})

{p 4 4 2}
and for complex matrices,

		trace({it:A}{bf:'}) = conj(trace({it:A}))

		trace({it:A}{it:B}) = trace({it:B}{it:A})

{p 4 4 2}
where, for complex matrices, transpose is understood to mean 
conjugate transpose.

{p 4 4 2}
Thus for real matrices, 

		To calculate         Code
		{hline 35}
		trace({it:AB})            {cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:)}
		trace({it:A}{bf:'}{it:B})           {cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:, 1)}
        	trace({it:AB}{bf:'})           {cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:, 1)}
		trace({it:A}{bf:'}{it:B}{bf:'})          {cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:)}
		{hline 35}

{p 4 4 2}
and for complex matrices, 

		To calculate         Code
		{hline 41}
		trace({it:AB})            {cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:)}
		trace({it:A}{bf:'}{it:B})           {cmd:trace(}{it:A}{cmd:,} {it:B}{cmd:, 1)}
        	trace({it:AB}{bf:'})           {cmd:conj(trace(}{it:A}{cmd:,} {it:B}{cmd:, 1))}
		trace({it:A}{bf:'}{it:B}{bf:'})          {cmd:conj(trace(}{it:A}{cmd:,} {it:B}{cmd:))}
		{hline 41}
		Transpose in the first column means conjugate
		transpose.


{marker conformability}{...}
{title:Conformability}
  
    {cmd:trace(}{it:A}{cmd:)}:
		{it:A}:  {it:n x n}
	   {it:result}:  1 {it:x} 1

    {cmd:trace(}{it:A}, {it:B}{cmd:)}:
		{it:A}:  {it:n x m}
		{it:B}:  {it:m x n}
	   {it:result}:  1 {it:x} 1

    {cmd:trace(}{it:A}, {it:B}, {it:t}{cmd:)}
		{it:A}:  {it:n x m}  if {it:t}=0, {it:m x n}  otherwise
		{it:B}:  {it:m x n}
	        {it:t}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:trace(}{it:A}{cmd:)}
aborts with error if {it:A} is not square.

{p 4 4 2}
{cmd:trace(}{it:A}, {it:B}{cmd:)} {cmd:trace(}{it:A}, {it:B},
{it:t}{cmd:)} abort with error if the matrices are not conformable or their
product is not square.

{p 4 4 2}
The trace of a 0 {it:x} 0 matrix is 0.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view trace.mata, adopath asis:trace.mata}
{p_end}
