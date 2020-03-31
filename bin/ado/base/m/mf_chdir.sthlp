{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] chdir()" "mansection M-5 chdir()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_chdir##syntax"}{...}
{viewerjumpto "Description" "mf_chdir##description"}{...}
{viewerjumpto "Conformability" "mf_chdir##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_chdir##diagnostics"}{...}
{viewerjumpto "Source code" "mf_chdir##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] chdir()} {hline 2}}Manipulate directories
{p_end}
{p2col:}({mansection M-5 chdir():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:string scalar}
{cmd:pwd()}


{p 8 12 2}
{it:void}{bind:         }
{cmd:chdir(}{it:string scalar dirpath}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind: }
{cmd:_chdir(}{it:string scalar dirpath}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:mkdir(}{it:string scalar dirpath}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:mkdir(}{it:string scalar dirpath}{cmd:,}
{it:real scalar public}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind: }
{cmd:_mkdir(}{it:string scalar dirpath}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind: }
{cmd:_mkdir(}{it:string scalar dirpath}{cmd:,}
{it:real scalar public}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:rmdir(}{it:string scalar dirpath}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind: }
{cmd:_rmdir(}{it:string scalar dirpath}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:pwd()} returns the full name (path) of the current working directory.


{p 4 4 2}
{cmd:chdir(}{it:dirpath}{cmd:)}
changes the current working directory to {it:dirpath}.  {cmd:chdir()} aborts
with error if the directory does not exist or the operating system cannot
change to it.

{p 4 4 2}
{cmd:_chdir(}{it:dirpath}{cmd:)}
does the same thing but returns 170 (a return code) when {cmd:chdir()} would
abort.  {cmd:_chdir()} returns 0 if it is successful.


{p 4 4 2}
{cmd:mkdir(}{it:dirpath}{cmd:)} 
and
{cmd:mkdir(}{it:dirpath}{cmd:,} {it:public}{cmd:)}
create directory {it:dirpath}.  {cmd:mkdir()} aborts with error if 
the directory already exists or cannot be created.
If {it:public}!=0 is specified, the directory is given permissions so 
that everyone can read it; otherwise, it is given the usual permissions.

{p 4 4 2}
{cmd:_mkdir(}{it:dirpath}{cmd:)} 
and 
{cmd:_mkdir(}{it:dirpath}{cmd:,} {it:public}{cmd:)}
do the same thing but return 693 (a return code) when {cmd:mkdir()} would
abort.  {cmd:_mkdir()} returns 0 if it is successful.

{p 4 4 2}
{cmd:rmdir(}{it:dirpath}{cmd:)} 
removes directory {it:dirpath}.  {cmd:rmdir()} aborts with error 
if the directory does not exist, is not empty, or the operating system 
refuses to remove it.

{p 4 4 2}
{cmd:_rmdir(}{it:dirpath}{cmd:)} 
does the same thing but returns 693 (a return code) when {cmd:rmdir()} would
abort.  {cmd:_rmdir()} returns 0 if it is successful.


{marker conformability}{...}
{title:Conformability}

    {cmd:pwd()}:
	   {it:result}:  1 {it:x} 1

    {cmd:chdir(}{it:dirpath}{cmd:)}:
	  {it:dirpath}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:_chdir(}{it:dirpath}{cmd:)}:
	  {it:dirpath}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:mkdir(}{it:dirpath}{cmd:,} {it:public}{cmd:)}:
	  {it:dirpath}:  1 {it:x} 1
	   {it:public}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:void}

    {cmd:_mkdir(}{it:dirpath}{cmd:,} {it:public}{cmd:)}:
	  {it:dirpath}:  1 {it:x} 1
	   {it:public}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x} 1

    {cmd:rmdir(}{it:dirpath}{cmd:)}:
	  {it:dirpath}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:_rmdir(}{it:dirpath}{cmd:)}:
	  {it:dirpath}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:pwd()}
never aborts with error, but it can return {cmd:""} if the operating system
does not know or does not have a name for the current directory (which happens
when another process removes the directory in which you are working).

{p 4 4 2}
{cmd:chdir(}{it:dirpath}{cmd:)} 
aborts with error if the directory does not exist or the operating system
cannot change to it.

{p 4 4 2}
{cmd:_chdir(}{it:dirpath}{cmd:)} never aborts with error; it returns 0 
on success and 170 on failure.

{p 4 4 2}
{cmd:mkdir(}{it:dirpath}{cmd:)} 
and
{cmd:mkdir(}{it:dirpath}{cmd:,} {it:public}{cmd:)}
abort with error if the directory already exists or the operating system
cannot change to it.

{p 4 4 2}
{cmd:_mkdir(}{it:dirpath}{cmd:)} 
and
{cmd:_mkdir(}{it:dirpath}{cmd:,} {it:public}{cmd:)}
never abort with error; they return 0 
on success and 693 on failure.

{p 4 4 2}
{cmd:rmdir(}{it:dirpath}{cmd:)} 
aborts with error if the directory does not exist, is not empty, or the
operating system cannot remove it.

{p 4 4 2}
{cmd:_rmdir(}{it:dirpath}{cmd:)} 
never aborts with error; it returns 0 on success and 693 on failure.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view chdir.mata, adopath asis:chdir.mata},
{view mkdir.mata, adopath asis:mkdir.mata},
{view rmdir.mata, adopath asis:rmdir.mata};
other functions are built in.
{p_end}
