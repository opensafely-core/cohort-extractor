{smcl}
{* *! version 1.2.8  14may2018}{...}
{vieweralsosee "[M-5] st_global()" "mansection M-5 st_global()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_rclear()" "help mf_st_rclear"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_global##syntax"}{...}
{viewerjumpto "Description" "mf_st_global##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_global##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_global##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_global##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_global##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_global##source"}{...}
{viewerjumpto "Reference" "mf_st_global##reference"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] st_global()} {hline 2}}Obtain strings from and put strings into global macros
{p_end}
{p2col:}({mansection M-5 st_global():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string scalar}
{cmd:st_global(}{it:string scalar name}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_global(}{it:string scalar name}{cmd:,} 
{it:string scalar contents}{cmd:)}

{p 8 52 2}
{it:void}{bind:         }
{cmd:st_global(}{it:string scalar name}{cmd:,} 
{it:string scalar contents}{cmd:,}
{it:string scalar hcat}{cmd:)}

{p 8 52 2}
{it:string scalar}
{cmd:st_global_hcat(}{it:string scalar name}{cmd:)}


{p 4 8 2}
where

{p 8 12 2}
1.   {it:name} is to contain
{p_end}

{p 16 20 2}
     a.  global macro such as {cmd:"myname"}
{p_end}

{p 16 20 2}
     b.  {cmd:r()} macro such as {cmd:"r(names)"}
{p_end}

{p 16 20 2}
     c.  {cmd:e()} macro such as {cmd:"e(cmd)"}
{p_end}

{p 16 20 2}
     d.  {cmd:s()} macro such as {cmd:"s(vars)"}
{p_end}

{p 16 20 2}
     e.  {cmd:c()} macro such as {cmd:"c(current_date)"}
{p_end}

{p 16 20 2}
     f.  dataset characteristic such as {cmd:"_dta[date]"}
{p_end}

{p 16 20 2}
     g.  variable characteristic such as {cmd:"mpg[note]"}

{p 8 12 2}
2.  {cmd:st_global(}{it:name}{it:)} returns the contents of 
    the specified Stata global.  It returns "" when the global does 
    not exist.

{p 8 12 2}
3.  {cmd:st_global(}{it:name}{cmd:,} {it:contents}{cmd:)} sets or 
    resets the contents of the specified Stata global.

{p 8 12 2}
4.  {cmd:st_global(}{it:name}{cmd:,} {cmd:"")}
    deletes the specified Stata global.  It does this even if {it:name} is not
    a macro.  {cmd:st_global("r(N)",} {cmd:"")} would delete {cmd:r(N)}
    whether it were a macro, scalar, or matrix.

{p 8 12 2}
5.  {cmd:st_global(}{it:name}{cmd:,} {it:contents}{cmd:,} {it:hcat}{cmd:)} 
    sets or resets the contents of the specified Stata global, and it 
    sets or resets the hidden or historical status when {it:name} is 
    an {cmd:e()} or {cmd:r()} value.  Allowed {it:hcat} 
    values are "{cmd:visible}", "{cmd:hidden}", "{cmd:historical}",
    and a string scalar release number such as such as "{cmd:10}",
    "{cmd:10.1}", or any string release number matching
    "{it:#}[{it:#}][{cmd:.}[{it:#}[{it:#}]]]".  See {manlink P return} for a
    description of hidden and historical {cmd:r()} and {cmd:e()} values.

{p 12 12 2}
    When {cmd:st_global(}{it:name}{cmd:,} {it:contents}{cmd:)} is used to set
    an {cmd:e()} or {cmd:r()} value, its {it:hcat} is set to "{cmd:visible}".

{p 8 12 2}
6.  {cmd:st_global_hcat(}{it:name}{cmd:)} returns the {it:hcat} 
    associated with an {cmd:e()} or {cmd:r()} value.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_global(}{it:name}{cmd:)} returns the contents of the specified 
Stata global.

{p 4 4 2}
{cmd:st_global(}{it:name}{cmd:,} {it:contents}{cmd:)} sets or resets the
contents of the specified Stata global.  If the Stata global did not previously
exist, a new global is created.  If the global did exist, the new contents
replace the old.

{p 4 4 2}
{cmd:st_global(}{it:name}{cmd:,} {it:contents}{cmd:,} {it:hcat}{cmd:)}
and {cmd:st_global_hcat(}{it:name}{cmd:)} are used to set and query the 
{it:hcat} corresponding to an {cmd:e()} or {cmd:r()} value. 
They are also rarely used.  See 
{manlink R Stored results} and {manlink P return} for 
more information.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_global()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Mata provides a suite of functions for obtaining and setting the contents of
global macros, local macros, stored results, etc.  It can sometimes be
confusing to know which you should use.  The following will help

	{hline 70}
	Stata component/action             Function call
	{hline 70}
	Local macro

	  obtain contents            {it:contents}{cmd: = st_local("}{it:name}{cmd:")}

	  create/set/replace         {cmd:st_local("}{it:name}{cmd:",} {it:contents}{cmd:)}

	  delete                     {cmd:st_local("}{it:name}{cmd:", "")}
	{hline 70}
	Global macro

	  obtain contents            {it:contents}{cmd: = st_global("}{it:name}{cmd:")}

	  create/set/replace         {cmd:st_global("}{it:name}{cmd:",} {it:contents}{cmd:)}

	  delete                     {cmd:st_global("}{it:name}{cmd:", "")}
	{hline 70}
	Global numeric scalar

	  obtain contents            {it:value}{cmd: = st_numscalar("}{it:name}{cmd:")}

	  create/set/replace         {cmd:st_numscalar("}{it:name}{cmd:",} {it:value}{cmd:)}

	  delete                     {cmd:st_numscalar("}{it:name}{cmd:", J(0,0,.))}
	{hline 70}
	Global string scalar

	  obtain contents            {it:contents}{cmd: = st_strscalar("}{it:name}{cmd:")}

	  create/set/replace         {cmd:st_strscalar("}{it:name}{cmd:",} {it:contents}{cmd:)}

	  delete                     {cmd:st_strscalar("}{it:name}{cmd:", J(0,0,""))}
	{hline 70}
	Global matrix

	  obtain contents            {it:matrix}   {cmd:= st_matrix("}{it:name}{cmd:")}
				     {it:rowlabel} {cmd:= st_matrixrowstripe("}{it:name}{cmd:")}
				     {it:collabel} {cmd:= st_matrixcolstripe("}{it:name}{cmd:")}

	  create/set/replace         {cmd:st_matrix("}{it:name}{cmd:",} {it:matrix}{cmd:)}
				     {cmd:st_matrixrowstripe("}{it:name}{cmd:",} {it:rowlabel}{cmd:)}
				     {cmd:st_matrixcolstripe("}{it:name}{cmd:",} {it:collabel}{cmd:)}
				     
          replace                    {cmd:st_replacematrix("}{it:name}{cmd:",} {it:matrix}{cmd:)}

	  delete                     {cmd:st_matrix("}{it:name}{cmd:", J(0,0,.))}
	{hline 70}
	Characteristic

	  obtain contents            {it:contents}{cmd: = st_global("}{it:name}{cmd:[}{it:name}{cmd:]")}

	  create/set/replace         {cmd:st_global("}{it:name}{cmd:[}{it:name}{cmd:]",} {it:contents}{cmd:)}

	  delete                     {cmd:st_global("}{it:name}{cmd:[}{it:name}{cmd:]", "")}
	{hline 70}
	{cmd:r()} results

	  macro
	    obtain contents          {it:contents}{cmd: = st_global("r(}{it:name}{cmd:)")}
	    create/set/replace       {cmd:st_global("r(}{it:name}{cmd:)",} {it:contents}{cmd:)}

	  numeric scalar
	    obtain contents          {it:value}{cmd: = st_numscalar("r(}{it:name}{cmd:)")}
	    create/set/replace       {cmd:st_numscalar("r(}{it:name}{cmd:)",} {it:value}{cmd:)}

	  matrix
	    obtain contents          {it:matrix}   {cmd:= st_matrix("r(}{it:name}{cmd:)")}
				     {it:rowlabel} {cmd:= st_matrixrowstripe("r(}{it:name}{cmd:)")}
				     {it:collabel} {cmd:= st_matrixcolstripe("r(}{it:name}{cmd:)")}
	    create/set/replace       {cmd:st_matrix("r(}{it:name}{cmd:)",} {it:matrix}{cmd:)}
				     {cmd:st_matrixrowstripe("r(}{it:name}{cmd:)",} {it:rowlabel}{cmd:)}
				     {cmd:st_matrixcolstripe("r(}{it:name}{cmd:)",} {it:collabel}{cmd:)}
            replace                  {cmd:st_replacematrix("r(}{it:name}{cmd:)",} {it:matrix}{cmd:)}

	  IN ALL CASES
	    delete                   {cmd:st_global("r(}{it:name}{cmd:)", "")}
            to delete all of {cmd:r()}     {cmd:st_rclear()}
	{hline 70}
	{cmd:e()} results

	   same as {cmd:r()} results, but code {cmd:e(}{it:name}{cmd:)} and {cmd:st_eclear()}
	{hline 70}
	{cmd:s()} results
	
	  macro
	    obtain contents          {it:contents}{cmd: = st_global("s(}{it:name}{cmd:)")}
	    create/set/replace       {cmd:st_global("s(}{it:name}{cmd:)",} {it:contents}{cmd:)}
	    delete                   {cmd:st_global("s(}{it:name}{cmd:)", "")}
	    delete all of {cmd:s()}        {cmd:st_sclear()}
	{hline 70}
	{cmd:c()} results

	  macro
	    obtain contents          {it:contents}{cmd: = st_global("c(}{it:name}{cmd:)")}

	  numeric scalar
	    obtain contents          {it:value}{cmd: = st_numscalar("c(}{it:name}{cmd:)")}
	{hline 70}
{p 8 8 2}
See {bf:{help mf_st_local:[M-5] st_local()}}, 
{bf:{help mf_st_numscalar:[M-5] st_numscalar()}}, 
{bf:{help mf_st_matrix:[M-5] st_matrix()}}, 
and
{bf:{help mf_st_rclear:[M-5] st_rclear()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_global(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:st_global(}{it:name}{cmd:,} {it:contents}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	 {it:contents}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:st_global(}{it:name}{cmd:,} {it:contents}{cmd:,} {it:hcat}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	 {it:contents}:  1 {it:x} 1
	     {it:hcat}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:st_global_hcat(}{it:name}{cmd:)}
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_global(}{it:name}{cmd:)} returns "" if the name contained in 
{it:name} is not defined.  {cmd:st_global(}{it:name}{cmd:)} aborts with
error if the name is malformed, such as {cmd:st_global("invalid name")}.

{p 4 4 2}
{cmd:st_global(}{it:name}{cmd:,} {it:contents}{cmd:)} aborts with error if
the name contained in {it:name} is malformed.
The maximum length of strings in Mata is significantly longer 
than in Stata.  {cmd:st_global()} truncates what is stored at the 
appropriate maximum length if that is necessary.

{p 4 4 2}
{cmd:st_global_hcat(}{it:name}{cmd:)} returns "{cmd:visible}" when
{it:name} is not an {cmd:e()} or {cmd:r()} value and returns {cmd:""} 
when {it:name} is an {cmd:e()} or {cmd:r()} value that does not exist.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2008.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0040":Mata Matters: Macros}.
{it:Stata Journal} 8: 401-412.
{p_end}
