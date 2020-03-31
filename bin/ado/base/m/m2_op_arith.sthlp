{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] op_arith" "mansection M-2 op_arith"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] exp" "help m2_exp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_op_arith##syntax"}{...}
{viewerjumpto "Description" "m2_op_arith##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_op_arith##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_op_arith##remarks"}{...}
{viewerjumpto "Conformability" "m2_op_arith##conformability"}{...}
{viewerjumpto "Diagnostics" "m2_op_arith##diagnostics"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-2] op_arith} {hline 2}}Arithmetic operators
{p_end}
{p2col:}({mansection M-2 op_arith:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:a} {cmd:+} {it:b}                      addition

	{it:a} {cmd:-} {it:b}                      subtraction

	{it:a} {cmd:*} {it:b}                      multiplication

	{it:a} {cmd:/} {it:b}                      division

	{it:a} {cmd:^} {it:b}                      power


	{cmd:-}{it:a}                         negation


{p 4 4 2}
where {it:a} and {it:b} may be numeric scalars, vectors, or matrices.


{marker description}{...}
{title:Description}

{p 4 4 2}
The above operators perform basic arithmetic.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 op_arithRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Also see {bf:{help m2_op_colon:[M-2] op_colon}}
for the {cmd::+}, {cmd::-}, {cmd::*}, and {cmd::/} operators.  
Colon operators have relaxed conformability restrictions.

{p 4 4 2}
The {cmd:*} and {cmd::*} multiplication operators can also perform string
duplication -- 3*"a" = "aaa" -- see {bf:{help mf_strdup:[M-5] strdup()}}.


{marker conformability}{...}
{title:Conformability}

	{it:a} {cmd:+} {it:b}, {it:a} {cmd:-} {it:b}:
		{it:a}:  {it:r x c}
		{it:b}:  {it:r x c}
	   {it:result}:  {it:r x c}

	{it:a} {cmd:*} {it:b}:
		{it:a}:  {it:k x n}      {it:k x n}      1 {it:x} 1
		{it:b}:  {it:n x m}      1 {it:x} 1      {it:n x m}
	   {it:result}:  {it:k x m}      {it:k x n}      {it:n x m}

	{it:a} {cmd:/} {it:b}:
		{it:a}:  {it:r x c}
		{it:b}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

	{it:a} {cmd:^} {it:b}:
		{it:a}:  1 {it:x} 1
		{it:b}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

	{cmd:-}{it:a}:
		{it:a}:  {it:r x c}
	   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All operators return missing when arguments are missing.

{p 4 4 2}
{it:a}{cmd:*}{it:b} with {it:a}: {it:k} {it:x} 0 and {it:b}: 0 {it:x} {it:m}
returns a {it:k} {it:x} {it:m} matrix of zeros.

{p 4 4 2}
{it:a}{cmd:/}{it:b} returns missing when {it:b}==0 or when {it:a}{cmd:/}{it:b}
would result in overflow.

{p 4 4 2}
{it:a}{cmd:^}{it:b} returns a real when both {it:a} and {it:b} are real; 
thus, {cmd:(-4)^.5} evaluates to missing, whereas 
{cmd:(-4+0i)^.5} evaluates to {cmd:2i}.

{p 4 4 2}
{it:a}{cmd:^}{it:b} returns missing on overflow.
{p_end}
