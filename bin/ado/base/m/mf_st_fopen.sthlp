{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] fopen" "help mf_fopen"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_st_fopen##syntax"}{...}
{viewerjumpto "Description" "mf_st_fopen##description"}{...}
{viewerjumpto "Remarks" "mf_st_fopen##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_fopen##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_fopen##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_fopen##source"}{...}
{title:Title}

{p 4 8 2}
{bf:[M-5] st_fopen()} {hline 2} Open file the Stata way


{marker syntax}{...}
{title:Syntax}

{p 8 29 2}
{it:real scalar}
{cmd:st_fopen(}{it:filename}{cmd:,}
{it:suffix}{cmd:,}
{it:mode}{cmd:,}
{it:replace}{cmd:,}
{it:public}{cmd:)}

{p 8 29 2}
{it:real scalar}
{cmd:st_fopen(}{it:filename}{cmd:,}
{it:suffix}{cmd:,}
{it:mode}{cmd:,}
{it:replace}{cmd:)}

{p 8 29 2}
{it:real scalar}
{cmd:st_fopen(}{it:filename}{cmd:,}
{it:suffix}{cmd:,}
{it:mode}{cmd:)}


{p 4 4 2}
where
{p_end}
{p 12 23 2}
{it:filename}:  {it:string scalar} containing filename or path and filename
such as {cmd:"myfile"} or {cmd:"myfile.dta"}; {it:filename} is updated 
by {cmd:st_fopen()} to contain the full name of the file, which 
would be {cmd:"myfile.dta"} in both examples


{p 14 23 2}
{it:suffix}:  {it:string scalar} containing default suffix with leading
period, such as {cmd:".dta"}


{p 16 23 2}
{it:mode}:  {it:string scalar} containing {cmd:"r"}, {cmd:"w"}, or {cmd:"rw"}


{p 13 23 2}
{it:replace}:  
relevant only if {it:mode} is {cmd:"w"} or {cmd:"rw"};{break}
if {it:mode} is {cmd:"w"}, {it:replace} is an optional {it:real scalar}
containing{p_end}

{p 25 28 2}
2{bind:  }file may be overwritten (but is left in place for read/write access)
and display note if file does not exist,
{p_end}

{p 25 28 2}
1{bind:  }file may be replaced (and is erased before opening if it already
exists) and display note if file does not exist,
{p_end}

{p 25 28 2}
0{bind:  }file may not be replaced,
{p_end}

{p 24 28 2}
-1{bind:  }file may be replaced (and is erased before opening if it already
exists) but do not show note if file does not exist, or
{p_end}

{p 24 28 2}
-2{bind:  }file may be overwritten (but is left in place for read/write access)
but do not show note if file does not exist.
{p_end}

{p 23 23 2}
{it:replace}<0 treated as -1; {it:replace}>0 treated as 1; 
{it:replace}=={cmd:.} treated as 0;  
{it:replace} not specified treated as 0

{p 23 23 2}
if {it:mode} is {cmd:"rw"}, {it:replace} is an optional {it:real scalar}
containing{p_end}

{p 25 28 2}
1{bind:  }file may be replaced and 
display note if it is, 
{p_end}

{p 25 28 2}
0{bind:  }file may not be replaced, or 
{p_end}

{p 24 28 2}
-1{bind:  }file may
be replaced but do not show note if it is.  
{p_end}

{p 23 23 2}
{it:replace}<-1 treated as -2; {it:replace}>1 treated as 2; 
{it:replace}=={cmd:.} treated as 0;  
{it:replace} not specified treated as 0


{p 14 23 2}
{it:public}:  relevant only if {it:mode} is {cmd:"w"} or {cmd:"rw"};{break}
optional {it:real scalar} containing 
{p_end}

{p 25 28 2}
0{bind:  }file to be private or
{p_end}

{p 25 28 2}
1{bind:  }file to be public
{p_end}

{p 23 23 2}
All nonzero (including missing) treated as 1; 
1 assumed if {it:public} not specified


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_fopen(}{it:filename}{cmd:,} 
{it:suffix}{cmd:,}
{it:mode}{cmd:,}
...{cmd:)}
is an alternative to {bf:{help mf_fopen:[M-5] fopen()}} for
opening files.  Files can be opened only in pure read or write modes
({cmd:"r"} or {cmd:"w"}), but in return {cmd:st_fopen()} provides Statalike
notes and error messages and, on error, {cmd:st_fopen()} aborts without
producing a Mata traceback log.  

{p 4 4 2}
If the file opens successfully,
argument {it:filename} is updated with the full filename and 
{cmd:st_fopen()} returns a file handle that can be used with any of the other
{bf:{help mf_fopen:[M-5] fopen()}} functions just as if the file were 
opened by the standard {cmd:fopen()}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:st_fopen()} is for use in Mata functions that will be run 
from Stata ado-files.  {cmd:st_fopen()} duplicates Statalike behavior 
such as

	. {cmd:save myfile, replace}
	(note: file myfile.dta not found)
        file myfile.dta saved

{p 4 4 2}
If you were writing {cmd:save}, it would be your responsibility
to produce the message "file myfile.dta saved", but the note about 
myfile.dta not being found even though {cmd:replace} had been specified 
would be handled by {cmd:st_fopen()} for you.  {cmd:st_fopen()} also updates
the shortened filename to make it easier to produce the closing message.  The
code to produce the above output would be

		{cmd:fh = st_fopen(filename, ".dta", "w", repflag)}
		...
		... {it:(code to write data)}
		...
		{cmd:printf("file %s saved\n", filename)}

{p 4 4 2}
The above code works even when {cmd:filename} initially contains 
{cmd:myfile} and not {cmd:myfile.dta}.

{p 4 4 2}
Similarly, consider the Statalike output

	. {cmd:save myfile}
        {err:file myfile.dta already exists}
	r(602);

{p 4 4 2}
Note the lack of a Mata traceback log.  The above would be created by the same
code just shown except that, here,  {cmd:repflag} would contain 0 
rather than 1.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:st_fopen(}{it:filename}{cmd:,} 
{it:suffix}{cmd:,}
{it:mode}{cmd:,}
{it:replace}{cmd:,}
{it:public}{cmd:)}:
{p_end}
	{it:input:}
	 {it:filename}:  1 {it:x} 1
	   {it:suffix}:  1 {it:x} 1
	     {it:mode}:  1 {it:x} 1
	  {it:replace}:  1 {it:x} 1    (optional)
	   {it:public}:  1 {it:x} 1    (optional)
	{it:output:}
	 {it:filename}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1



{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_fopen(}{it:filename}{cmd:,} 
{it:suffix}{cmd:,}
{it:mode}{cmd:,}
{it:replace}{cmd:,}
{it:public}{cmd:)}
aborts with error -- but nicely, without a traceback log -- if {it:filename}
cannot be opened.  {cmd:st_fopen()} aborts with error -- with a traceback 
log -- if it is used improperly, such as calling it with {it:mode} different
from {cmd:"r"} or {cmd:"w"}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view st_fopen.mata, adopath asis:st_fopen.mata}
{p_end}
