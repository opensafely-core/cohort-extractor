{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-5] eltype()" "mansection M-5 eltype()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] isreal()" "help mf_isreal"}{...}
{vieweralsosee "[M-5] isview()" "help mf_isview"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_eltype##syntax"}{...}
{viewerjumpto "Description" "mf_eltype##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_eltype##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_eltype##remarks"}{...}
{viewerjumpto "Conformability" "mf_eltype##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_eltype##diagnostics"}{...}
{viewerjumpto "Source code" "mf_eltype##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] eltype()} {hline 2}}Element type, organizational type, and type
name of object
{p_end}
{p2col:}({mansection M-5 eltype():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:string scalar} {cmd:eltype(}{it:X}{cmd:)}

{p 8 8 2}
{it:string scalar} {cmd:orgtype(}{it:X}{cmd:)}

{p 8 8 2}
{it:string scalar} {cmd:classname(}{it:X}{cmd:)}

{p 8 8 2}
{it:string scalar} {cmd:structname(}{it:X}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:eltype()} returns the current {it:eltype} of the argument.

{p 4 4 2}
{cmd:orgtype()} returns the current {it:orgtype} of the argument.

{p 4 4 2}
{cmd:classname()} returns the name of the class for a Mata class scalar.

{p 4 4 2}
{cmd:structname()} returns the name of the struct for a Mata struct scalar.

{p 4 4 2}
See {bf:{help m6_glossary:[M-6] Glossary}} 
for a definition of {it:{help m6_glossary##type:eltype}} and
{it:{help m6_glossary##type:orgtype}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 eltype()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
If {it:X} is a matrix (syntax 1), returned is

		{cmd:eltype(}{it:X}{cmd:)}               {cmd:orgtype(}{it:X}{cmd:)}
		{hline 40}
		{cmd:real}                    {cmd:scalar}
		{cmd:complex}                 {cmd:rowvector}
		{cmd:string}                  {cmd:colvector}
		{cmd:pointer}                 {cmd:matrix}
		{cmd:struct}
		{cmd:class}
		{hline 40}

{p 4 4 2}
The returned value reflects the current contents of {it:X}.
That is, {it:X} 
might be declared a {cmd:transmorphic} {cmd:matrix}, but at any 
instant, it contains something, and if that something were 5, returned would
be {cmd:"real"} and {cmd:"scalar"}.

{p 4 4 2}
For {cmd:orgtype()}, returned is 
{cmd:"scalar"} if the object is currently 
1 {it:x} 1; {cmd:"rowvector"} if it is 
1 {it:x k}, {it:k}!=1; {cmd:"colvector"} if it is {it:k x} 1, {it:k}!=1; 
and {cmd:"matrix"} otherwise (it is {it:r x c}, {it:r}!=1, {it:c}!=1).

{p 4 4 2}
{it:X} can be a function (syntax 2).  Returned is

		{cmd:eltype(*(&}{it:func}{cmd:()))}      {cmd:orgtype(*(&}{it:func}{cmd:()))}
		{hline 43}
		{cmd:transmorphic}            {cmd:matrix}
		{cmd:numeric}                 {cmd:vector}
		{cmd:real}                    {cmd:rowvector}
		{cmd:complex}                 {cmd:colvector}
		{cmd:string}                  {cmd:scalar}
		{cmd:pointer}                 {cmd:void}
		{cmd:struct}
		{cmd:structdef}
		{cmd:class}
		{cmd:classdef}
		{hline 43}

{p 4 4 2}
These types are obtained from the declaration of the function.

{p 4 4 2}
Aside:
{cmd:struct} and {cmd:structdef} have to do with structures; 
see {bf:{help m2_struct:[M-2] struct}}.  {cmd:structdef} indicates 
the function not only returns a structure but is the routine that 
defines the structure as well.  {cmd:class} and {cmd:classdef} have 
to do with Mata classes;  see {bf:{help m2_class:[M-2] class}}.  
{cmd:classdef} indicates the function not only returns a class but 
is the routine that defines the class as well.

{p 4 4 2}
{cmd:classname()} returns the name {cmd:"cA"} if the object is a class cA
scalar.  The function returns {cmd:""} if the object has element type other
than {cmd:class} or has organizational type other than {cmd:scalar}. 

{p 4 4 2}
{cmd:structname()} returns the name {cmd:"sA"} if the object is a struct sA
scalar.  The function returns {cmd:""} if the object has element type other
than {cmd:struct} or has organizational type other than {cmd:scalar}. 
 

{marker conformability}{...}
{title:Conformability}

{pstd}
    {cmd:eltype(}{it:X}{cmd:)}, {cmd:orgtype(}{it:X}{cmd:)},
    {cmd:classname(}{it:X}{cmd:)}, {cmd:structname(}{it:X}{cmd:)}:{p_end}
		{it:X}:  {it:r x c}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
