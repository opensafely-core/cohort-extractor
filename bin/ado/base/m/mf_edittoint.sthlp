{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] edittoint()" "mansection M-5 edittoint()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] edittozero()" "help mf_edittozero"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_edittoint##syntax"}{...}
{viewerjumpto "Description" "mf_edittoint##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_edittoint##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_edittoint##remarks"}{...}
{viewerjumpto "Conformability" "mf_edittoint##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_edittoint##diagnostics"}{...}
{viewerjumpto "Source code" "mf_edittoint##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] edittoint()} {hline 2}}Edit matrix for roundoff error (integers)
{p_end}
{p2col:}({mansection M-5 edittoint():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:numeric matrix}
{cmd:edittoint(}{it:numeric matrix Z}{cmd:,}
{it:real scalar amt}{cmd:)}

{p 8 8 2}
{it:void}{bind:         }
{cmd:_edittoint(}{it:numeric matrix Z}{cmd:,}
{it:real scalar amt}{cmd:)}


{p 8 8 2}
{it:numeric matrix} 
{cmd:edittointtol(}{it:numeric matrix Z}{cmd:,}
{it:real scalar tol}{cmd:)}

{p 8 8 2}
{it:void}{bind:         }
{cmd:_edittointtol(}{it:numeric matrix Z}{cmd:,}
{it:real scalar tol}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
These edit functions set elements of matrices to integers that are close 
to integers.

{p 4 4 2}
{cmd:edittoint(}{it:Z}{cmd:,} {it:amt}{cmd:)} and 
{cmd:_edittoint(}{it:Z}{cmd:,} {it:amt}{cmd:)} set 

		{it:Z_ij} = {cmd:round(}{it:Z_ij}{cmd:)}        if  |{it:Z_ij}-{cmd:round(}Z_ij{cmd:)}| <= |{it:tol}|

{p 4 4 2}
for {it:Z} real and set

	    Re({it:Z_ij}) = {cmd:round(}Re(Z_ij){cmd:)}  if |Re({it:Z_ij})-{cmd:round(}Re(Z_ij){cmd:)}| <= |{it:tol}|

	    Im({it:Z_ij}) = {cmd:round(}Im(Z_ij){cmd:)}  if |Im({it:Z_ij})-{cmd:round(}Im(Z_ij){cmd:)}| <= |{it:tol}|

{p 4 4 2}
for {it:Z} complex, where in both cases 

	    {it:tol} = {cmd:abs(}{it:amt}{cmd:)}{cmd:*epsilon(sum(abs(}{it:Z}{cmd:))/(rows(}{it:Z}{cmd:)*cols(}{it:Z}{cmd:)))}

{p 4 4 2}
{cmd:edittoint()} leaves {it:Z} unchanged and returns the edited matrix.
{cmd:_edittoint()} edits {it:Z} in place.

{p 4 4 2}
{cmd:edittointtol(}{it:Z}{cmd:,} {it:tol}{cmd:)} and
{cmd:_edittointtol(}{it:Z}{cmd:,} {it:tol}{cmd:)} do the same thing, except
that {it:tol} is specified directly.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 edittoint()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
These functions mirror the {cmd:edittozero()} functions documented in 
{bf:{help mf_edittozero:[M-5] edittozero()}}, except that, rather than solely 
resetting to zero values close to zero, they reset to integer values 
close to integers.

{p 4 4 2}
See {bf:{help mf_edittozero:[M-5] edittozero()}}.
Whereas use of the functions documented there is recommended, use of the
functions documented here generally is not.
Although zeros commonly arise in real problems so that 
there is reason to suspect small numbers would be zero but for
roundoff error, integers arise more rarely.

{p 4 4 2}
If you have reason to believe that integer values are likely, then by 
all means use these functions.


{marker conformability}{...}
{title:Conformability}

    {cmd:edittoint(}{it:Z}{cmd:,} {it:amt}{cmd:)}:
		{it:Z}:  {it:r x c}
	      {it:amt}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

    {cmd:_edittoint(}{it:Z}{cmd:,} {it:amt}{cmd:)}:
	{it:input:}
		{it:Z}:  {it:r x c}
	      {it:amt}:  1 {it:x} 1
	{it:output:}
		{it:Z}:  {it:r x c}

    {cmd:edittointtol(}{it:Z}{cmd:,} {it:tol}{cmd:)}:
		{it:Z}:  {it:r x c}
	      {it:tol}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

    {cmd:_edittointtol(}{it:Z}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:Z}:  {it:r x c}
	      {it:tol}:  1 {it:x} 1
	{it:output:}
		{it:Z}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view edittoint.mata, adopath asis:edittoint.mata},
{view _edittoint.mata, adopath asis:_edittoint.mata},
{view edittointtol.mata, adopath asis:edittointtol.mata},
{view _edittointtol.mata, adopath asis:_edittointtol.mata}
{p_end}
