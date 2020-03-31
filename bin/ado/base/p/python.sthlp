{smcl}
{* *! version 1.0.3  06may2019}{...}
{vieweralsosee "[P] python" "mansection P python"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Stata-Python API Specification" "browse https://www.stata.com/python/"}{...}
{vieweralsosee "[P] Java intro" "help java intro"}{...}
{vieweralsosee "[P] javacall" "help javacall"}{...}
{viewerjumpto "Syntax" "python##syntax"}{...}
{viewerjumpto "Description" "python##description"}{...}
{viewerjumpto "Links to PDF documentation" "python##linkspdf"}{...}
{viewerjumpto "Options" "python##options"}{...}
{viewerjumpto "Examples" "python##examples"}{...}
{viewerjumpto "Stored results" "python##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[P] python} {hline 2}}Call Python from Stata{p_end}
{p2col:}({mansection P python:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{marker pyint12}{...}
{phang}
Enter Python interactive environment

{p 8 22 2}
{cmd:python}[{cmd::}]


{marker pyint3}{...}
{phang}
Execute Python simple statements

{p 8 22 2}
{cmd:python}{cmd::} {it:{help python##pyistmt:istmt}}


{marker pyscript}{...}
{phang}
Execute a Python script file

{p 8 22 2}
{cmd:python} {cmd:script} {it:{help python##pyfilename:pyfilename}}
[{cmd:,} 
{opt args(args_list)}
{opt global}
{opt userpaths}{cmd:(}{it:user_paths}[{cmd:,} {cmdab:pre:pend}]{cmd:)}]


{marker pysetexec}{...}
{phang}
Set which version of Python to use

{p 8 22 2}
{cmd:python} {cmd:set} {cmd:exec} 
{it:{help python##pyexecutable:pyexecutable}}
[{cmd:,} {cmdab:perm:anently}]

{phang}
{cmd:set python_exec} is a synonym for {cmd:python set exec}.{p_end}


{marker pysetupath}{...}
{phang}
Set user's additional module search paths

{p 8 22 2}
{cmd:python} {cmd:set} {cmd:userpath} 
{it:path} [{it:path} ...] [{cmd:,} {cmdab:perm:anently} {cmdab:pre:pend}]

{phang}
{cmd:set python_userpath} is a synonym for {cmd:python set userpath}.{p_end}


{marker pydesc}{...}
{phang}
List objects in the namespace of the {cmd:__main__} module

{p 8 22 2}
{cmd:python} {cmdab:des:cribe} [{it:{help python##pynamelist:namelist}}]
[{cmd:,} {opt all}]


{marker pydrop}{...}
{phang}
Drop objects from the namespace of the {cmd:__main__} module

{p 8 22 2}
{cmd:python} {cmd:drop} {it:{help python##pynamelist:namelist}}


{marker pyclear}{...}
{phang}
Clear objects from the namespace of the {cmd:__main__} module

{p 8 22 2}
{cmd:python} {cmd:clear}


{marker pyquery}{...}
{phang}
Query current Python settings and system information

{p 8 22 2}
{cmd:python} {cmdab:q:uery}


{marker pysearch}{...}
{phang}
Search for Python installations on the current system

{p 8 22 2}
{cmd:python} {cmdab:sea:rch}


{marker pywhich}{...}
{phang}
Check the availability of a Python module

{p 8 22 2}
{cmd:python} {cmd:which} {it:{help python##pymodulename:modulename}}


{marker pyistmt}{...}
{phang}
{it:istmt} is either one Python simple statement or several simple statements
separated by semicolons.

{marker pyfilename}{...}
{phang}
{it:pyfilename} specifies the name of a Python script file with extension
{cmd:.py}.

{marker pyexecutable}{...}
{phang}
{it:pyexecutable} specifies the executable of a Python installation, such
as {cmd:"C:\Program Files\Python36\python.exe"}, {cmd:"/usr/bin/python"},
{cmd:"/usr/local/bin/python"}, {cmd:"~/anaconda3/bin/python"},
or {cmd:"~/anaconda/bin/python"}.

{marker pynamelist}{...}
{phang}
{it:namelist} specifies a list of object names, such as {cmd:sys}, {cmd:spam},
or {cmd:foo}.  Names can also be specified using the {cmd:*} and {cmd:?}
wildcard characters:

{phang2}
{cmd:*} indicates zero or more characters.

{phang2}
{cmd:?} indicates exactly one character.

{marker pymodulename}{...}
{phang}
{it:modulename} specifies the name of a Python module.  The module can be a
system module or a user-written module.  The name can be a regular single
module name or a dotted module name, such as {cmd:sys}, {cmd:numpy}, or
{cmd:numpy.random}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:python} provides utilities for embedding Python code within Stata.  With
these utilities, users can invoke Python interactively or in do-files and
ado-files.

{phang2}
{cmd:python}[{cmd::}] creates a Python environment in which Python code can be
executed interactively, just like a Python interpreter.  In this environment,
the classic "{cmd:>>>}" and "{cmd:...}" prompts are used to indicate the user
input.  All the objects inside this environment are created in the namespace of
the {cmd:__main__} module.

{phang2}
{cmd:python}{cmd::} {it:istmt} executes one Python simple statement or several
simple statements separated by semicolons.

{phang2}
{cmd:python} {cmd:script} executes a Python script {cmd:.py} file.  A list of
arguments can be passed to the file by using option {cmd:args()}.

{phang2}
{cmd:python} {cmd:set} {cmd:exec} {it:pyexecutable} sets which Python version
to use.  {it:pyexecutable} specifies the full path of the Python executable.
If the executable does not exist or does not meet the minimum version
requirement, an error message will be issued.

{phang2}
{cmd:python} {cmd:set} {cmd:userpath} {it:path} [{it:path} ...] sets the user's
own module search paths in addition to system search paths.  Multiple paths may
be specified.  When specified, those paths will be loaded automatically when
the Python environment is initialized.

{phang2}
{cmd:python} {cmd:describe} lists the objects in the namespace of the
{cmd:__main__} module.

{phang2}
{cmd:python} {cmd:drop} removes the specified objects from the namespace of the
{cmd:__main__} module.

{phang2}
{cmd:python} {cmd:clear} clears all the objects whose names are not prefixed
with {cmd:_} from the namespace of the {cmd:__main__} module.

{phang2}
{cmd:python} {cmd:query} lists the current Python settings and system
information.

{phang2}
{cmd:python} {cmd:search} finds the Python versions installed on the current
operating system.  Only Python 2.7 and greater will be listed.  On Windows, the
registry will be searched for official Python installation and versions
installed through {cmd:Anaconda}.  On Unix or Mac, the registry will be
searched for Python installations in the {cmd:/usr/bin/},
{cmd:/usr/local/bin/}, {cmd:/opt/local/python/bin/}, {cmd: ~/anaconda/bin}, or
{cmd:~/anaconda3/bin} directories.

{phang2}
{cmd:python} {cmd:which} checks the availability of a Python module.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P pythonRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt args(args_list)} specifies a list of arguments, {it:args_list}, that will
be passed to the Python script file and can be accessed through {cmd:argv} in
Python's {cmd:sys} module.  {it:args_list} may contain one argument or a list
of arguments separated by spaces.

{phang}
{opt global} specifies that the objects created in the Python script file be
appended to the namespace of the {cmd:__main__} module so that they can be
accessed globally.  By default, the objects created in the script file are
discarded after execution.

{phang}
{opt userpaths}{cmd:(}{it:user_paths}[{cmd:,} {cmd:prepend}]{cmd:)} specifies
the additional module search paths that will be added to the system paths
stored in {cmd:sys.path}.  {it:user_paths} may be one or a list of paths
separated either by spaces or by semicolons.  By default, those paths will be
added to the end of system paths.  If {cmd:prepend} is specified, they will be
added in front of the system paths.

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke
Python.

{phang}
{cmd:prepend} specifies that instead of adding the user's additional module
search paths to the end of system paths, the paths are to be added in front of
the system paths.

{phang}
{opt all} specifies that all the objects in the namespace of the {cmd:__main__}
module be listed.  By default, only objects that do not begin with an
underscore will be listed.


{marker examples}{...}
{title:Examples}

{pstd}Enter Python interactive environment and execute Python code{p_end}
	{cmd:. python}
	{cmd:a1 = 1}
	{cmd:a2 = 2**3}
	{cmd:s1 = 'spam egg'}
	{cmd:s2 = 3*'spam' + "egg"}
	{cmd:l1 = [1,4,9,16,25]}
	{cmd:l2 = ['a','b','c']}
	{cmd:l3 = [l1,l2]}
	{cmd:d = {'a':1, 'b':2, 'c':3}}
	{cmd:end}

{pstd}List objects in the namespace of the {cmd:__main__} module{p_end}
{phang2}{cmd:. python describe}

{pstd}List objects whose names start with {cmd:s} in the namespace of the
{cmd:__main__} module{p_end}
{phang2}{cmd:. python describe s*}

{pstd}Drop {cmd:l1}, {cmd:l2}, and {cmd:l3} from the namespace of the
{cmd:__main__} module{p_end}
{phang2}{cmd:. python drop l1 l2 l3}

{pstd}Clear all objects from the namespace of the {cmd:__main__} module{p_end}
{phang2}{cmd:. python clear}

{pstd}List all available Python installations{p_end}
{phang2}{cmd:. python search}

{pstd}Query current Python settings and system information{p_end}
{phang2}{cmd:. python query}

{pstd}Check whether {cmd:numpy} is installed in the Python version currently in
use{p_end}
{phang2}{cmd:. python which numpy}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:python query} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(initialized)}}whether Python environment initialized ({cmd:0} or {cmd:1}){p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(execpath)}}Python executable path{p_end}
{synopt:{cmd:r(userpath)}}Python user path{p_end}
{synopt:{cmd:r(version)}}Python version{p_end}
{synopt:{cmd:r(arch)}}Python architecture ({cmd:64-bit} or {cmd:32-bit}){p_end}
{synopt:{cmd:r(libpath)}}Python shared library{p_end}
{p2colreset}{...}
