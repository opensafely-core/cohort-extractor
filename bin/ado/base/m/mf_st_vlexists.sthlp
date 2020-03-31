{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] st_vlexists()" "mansection M-5 st_vlexists()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_vlexists##syntax"}{...}
{viewerjumpto "Description" "mf_st_vlexists##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_vlexists##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_vlexists##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_vlexists##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_vlexists##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_vlexists##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] st_vlexists()} {hline 2}}Use and manipulate value labels
{p_end}
{p2col:}({mansection M-5 st_vlexists():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:st_vlexists(}{it:name}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_vldrop(}{it:name}{cmd:)}

{p 8 12 2}
{it:string matrix}
{cmd:st_vlmap(}{it:name}{cmd:,}
{it:real matrix values}{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:  }
{cmd:st_vlsearch(}{it:name}{cmd:,}
{it:string matrix text}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:st_vlload(}{it:name}{cmd:,}
{it:values}{cmd:,}
{it:text}{cmd:)}

{p 8 52 2}
{it:void}{bind:         }
{cmd:st_vlmodify(}{it:name}{cmd:,}
{it:real colvector values}{cmd:,}{break}
{it:string colvector text}{cmd:)}


{p 4 10 2}
where {it:name} is {it:string scalar} and where the types of 
{it:values} and {it:text} in {cmd:st_vlload()} are irrelevant because 
they are replaced.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_vlexists(}{it:name}{cmd:)}
returns 1 if value label {it:name} exists and returns 0 otherwise.

{p 4 4 2}
{cmd:st_vldrop(}{it:name}{cmd:)}
drops value label {it:name} if it exists.

{p 4 4 2}
{cmd:st_vlmap(}{it:name}{cmd:,} {it:values}{cmd:)}
maps {it:values} through value label {it:name} and returns the result.

{p 4 4 2}
{cmd:st_vlsearch(}{it:name}{cmd:,} {it:text}{cmd:)}
does the reverse; it returns the value corresponding to the text.

{p 4 4 2}
{cmd:st_vlload(}{it:name}{cmd:,} {it:values}{cmd:,} {it:text}{cmd:)}
places value label {it:name} into {it:values} and {it:text}.

{p 4 4 2}
{cmd:st_vlmodify(}{it:name}{cmd:,} {it:values}{cmd:,} {it:text}{cmd:)}
creates a new value label or modifies an existing one.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_vlexists()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Value labels are named and record a mapping from numeric values to text.  For
instance, a value label named {cmd:sexlbl} might record that 1 corresponds to
male and 2 to female.  Values labels are attached to Stata numeric
variables.  If a Stata numeric variable had the value label {cmd:sexlbl}
attached to it, then the 1s and 2s in the variable would display as male and
female.  How other values would appear -- if there were other values --
would not be affected.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_st_vlexists##remarks1:Value-label mapping}
	{help mf_st_vlexists##remarks2:Value-label creation and editing}
	{help mf_st_vlexists##remarks3:Loading value labels}


{marker remarks1}{...}
{title:Value-label mapping}

{p 4 4 2}
Let us consider value label {cmd:sexlbl} mapping 1 to male and 2 to
female.  {cmd:st_vlmap("sexlbl",} {it:values}{cmd:)} would map the {it:r}
{it:x} {it:c} matrix values through {cmd:sexlbl} and return an {it:r} {it:x}
{it:c} string matrix containing the result.  Any values for which there was
no mapping would result in {cmd:""}.  Thus

	: {cmd:res = st_vlmap("sexlbl", 1)}

	: {cmd:res}
	  male

	: {cmd:res = st_vlmap("sexlbl", (2, 3, 1))}

	: {cmd:res}
	{res}       {txt}     1        2        3
	    {c TLC}{hline 28}{c TRC}
	  1 {c |}  {res}female              male{txt}  {c |}
	    {c BLC}{hline 28}{c BRC}


{p 4 4 2}
{cmd:st_vlsearch(}{it:name}{cmd:,} {it:text}{cmd:)}
performs the reverse mapping:

	: {cmd:txt = st_vlmap("sexlbl", ("female","","male"))}

	: {cmd:txt}
	{res}       {txt}1   2   3
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  {res}2   .   1{txt}  {c |}
	    {c BLC}{hline 13}{c BRC}


{marker remarks2}{...}
{title:Value-label creation and editing}

{p 4 4 2}
{cmd:st_vlmodify(}{it:name}{cmd:,} {it:values}{cmd:,} {it:text}{cmd:)}
creates new value labels and modifies existing ones.

{p 4 4 2}
If value label {cmd:sexlbl} did not exist, coding 

	: {cmd:st_vlmodify("sexlbl", (1\2), ("male"\"female"))}

{p 4 4 2}
would create it.  If the value label did previously exist, the above would
modify it so that 1 now corresponds to male and 2 to female, regardless
of what 1 or 2 previously corresponded to, if they corresponded to anything.
Other mappings that might have been included in the value label remain 
unchanged.  Thus

	: {cmd:st_vlmodify("sexlbl", 3, "unknown")}

{p 4 4 2}
would add another mapping to the label.  Values are deleted by specifying the
text as {cmd:""}, so

	: {cmd:st_vlmodify("sexlbl", 3, "")}

{p 4 4 2}
would remove the mapping for 3 (if there was a mapping).
If you remove all the mappings, the value label itself is automatically 
dropped:

	: {cmd:st_vlmodify("sexlbl", (1\2), (""\""))}

{p 4 4 2}
results in value label {cmd:sexlbl} being dropped if 1 and 2 were the
final mappings in it.


{marker remarks3}{...}
{title:Loading value labels}

{p 4 4 2}
{cmd:st_vlload(}{it:name}{cmd:,} {it:values}{cmd:,} {it:text}{cmd:)}
returns the value label in {it:values} and {it:text}, where you can 
do with it as you please.  Thus you could code

		{cmd:st_vlload("sexlbl", values, text)}
		...
		{cmd:st_vldrop("sexlbl")}
		{cmd:st_vlmodify("sexlbl", values, text)}


{marker conformability}{...}
{title:Conformability}

    {cmd:st_vlexists(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:st_vldrop(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:st_vlmap(}{it:name}{cmd:,} {it:values}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:values}:  {it:r x c}
	   {it:result}:  {it:r x c}

    {cmd:st_vlsearch(}{it:name}{cmd:,} {it:text}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	     {it:text}:  {it:r x c}
	   {it:result}:  {it:r x c}

    {cmd:st_vlload(}{it:name}{cmd:,} {it:values}{cmd:,} {it:text}{cmd:)}:
	{it:input:}
	     {it:name}:  1 {it:x} 1
	{it:output:}
	   {it:values}:  {it:k x} 1
	     {it:text}:  {it:k x} 1

    {cmd:st_vlmodify(}{it:name}{cmd:,} {it:values}{cmd:,} {it:text}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:values}:  {it:m x} 1
	     {it:text}:  {it:m x} 1
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The only conditions under which the above functions abort with error is
when {it:name} is malformed or Mata is out of memory.
Functions tolerate all other problems.

{p 4 4 2}
{cmd:st_vldrop(}{it:name}{cmd:)}
does nothing if value label {it:name} does not exist.

{p 4 4 2}
{cmd:st_vlmap(}{it:name}{cmd:,} {it:values}{cmd:)}
returns {cmd:J(rows(values), cols(values), "")} if value label {it:name} does
not exist.  When the value label does exist, individual values for which there
is no recorded mapping are returned as {cmd:""}.

{p 4 4 2}
{cmd:st_vlsearch(}{it:name}{cmd:,} {it:text}{cmd:)}
returns {cmd:J(rows(values), cols(values), .)} if value label {it:name} does not
exist.  When the value label does exist, individual text values for which there 
is no corresponding value are returned as {cmd:.} (missing).

{p 4 4 2}
{cmd:st_vlload(}{it:name}{cmd:,} {it:values}{cmd:,} {it:text}{cmd:)} 
sets {it:values} and {it:text} to be 0 {it:x} 1 when value label 
{it:name} does not exist.

{p 4 4 2}
{cmd:st_vlmodify(}{it:name}{cmd:,} {it:values}{cmd:,} {it:text}{cmd:)} 
creates the value label if it does not already exist.
Value labels may map only integers and {cmd:.a}, {cmd:.b}, ..., {cmd:.z}.
Attempts to insert a mapping for {cmd:.} are ignored. 
Noninteger values are truncated to integer values.  If an element of 
{it:text} is {cmd:""}, then the corresponding mapping is removed.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
