{smcl}
{* *! version 1.1.3  19oct2017}{...}
{vieweralsosee "[P] class" "mansection P class"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class: classman" "help classman"}{...}
{vieweralsosee "[P] class: classdeclare" "help classdeclare"}{...}
{vieweralsosee "[P] class: classassign" "help classassign"}{...}
{vieweralsosee "[P] class: classmacro" "help classmacro"}{...}
{viewerjumpto "Appendix C.4: Quick summary of built-ins" "classbi##app_c4"}{...}
{viewerjumpto "Description" "classbi##description"}{...}
{viewerjumpto "Links to PDF documentation" "classbi##linkspdf"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] class} {hline 2}}Class programming  (continuation of
        {manhelp classman P:class})
{p_end}
{p2col:}({mansection P class:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker app_c4}{...}
{title:Appendix C.4:  Quick summary of built-ins}

{pstd}
Built-ins come in two forms:  (1) built-in functions -- built-ins that
return a result but do not change the object on which they are run, and (2)
built-in modifiers -- built-ins that might return a result but most
importantly modify the object on which they are run.


    {title:Built-in functions (may be used as {it:rvalues})}

{synoptset 31}{...}
{synopt :{cmd:.}{it:object}{cmd:.id}}creates new instance of
   {cmd:.}{it:object}{p_end}

{synopt :{cmd:.}{it:instance}{cmd:.copy}}makes a copy of
   {cmd:.}{it:instance}{p_end}

{synopt :{cmd:.}{it:instance}{cmd:.ref}}for using in assignment by
   reference{p_end}

{synopt :{cmd:.}{it:object}{cmd:.objtype}}returns "{cmd:double}",
   "{cmd:string}", "{cmd:array}", or "{it:classname}"{p_end}

{synopt :{cmd:.}{it:object}{cmd:.isa}}returns "{cmd:double}", "{cmd:string}",
   "{cmd:array}", "{cmd:class}", or "{cmd:classtype}"{p_end}

{synopt :{cmd:.}{it:object}{cmd:.classname}}returns "{it:classname}" or
   ""{p_end}

{synopt :{cmd:.}{it:object}{cmd:.isofclass} {it:classname}}returns 1 if
   {it:object} is of class type {it:classname}{p_end}

{synopt :{cmd:.}{it:object}{cmd:.objkey}}returns a string that can be used to
   reference {it:object} outside the implied context{p_end}

{synopt :{cmd:.}{it:object}{cmd:.uname}}returns a string that can be used as a
   name throughout Stata; name corresponds to {cmd:.}{it:object}'s
   {cmd:.ref}{p_end}

{synopt :{cmd:.}{it:object}{cmd:.ref_n}}returns number ({cmd:double}) of total
   number of identifiers sharing object{p_end}

{synopt :{cmd:.}{it:array}{cmd:.arrnels}}returns number ({cmd:double})
   corresponding to largest index of the array assigned{p_end}

{synopt :{cmd:.}{it:array}{cmd:.arrindexof "}{it:string}{cmd:"}}searches 
   array for first element equal to {it:string} and returns the index
   ({cmd:double}) of element or returns 0{p_end}

{synopt :{cmd:.}{it:object}{cmd:.classmv}}returns {cmd:array} containing the
   {cmd:.ref}s of each classwide member of {cmd:.}{it:object}{p_end}

{synopt :{cmd:.}{it:object}{cmd:.instancemv}}returns {cmd:array} containing
   the {cmd:.ref}s of each instance-specific member of {cmd:.}{it:object}{p_end}

{synopt :{cmd:.}{it:object}{cmd:.dynamicmv}}returns {cmd:array} containing the
   {cmd:.ref}s of each dynamically added member of {cmd:.}{it:object}{p_end}

{synopt :{cmd:.}{it:object}{cmd:.superclass}}returns {cmd:array} containing
   the {cmd:.ref}s of each of the classes from which {cmd:.}{it:object}
   inherited{p_end}

{synopt :{cmd:.oncopy_src}}returns the object key of the source object
   for the current {cmd:.oncopy} member program.{p_end}
{p2colreset}{...}


    {title:Built-in modifiers}

{synoptset 31}{...}
{synopt :{cmd:.}{it:instance}{cmd:.Declare} {it:declarator}}returns nothing;
   adds member variable to instance; see {help classdeclare}{p_end}

{synopt :{cmd:.}{it:array}{cmd:[}{it:exp}{cmd:].Arrdropel} {it:#}} returns
   nothing; drops the specified array element{p_end}

{synopt :{cmd:.}{it:array}{cmd:.Arrpop}}returns nothing; finds the top element
   and removes it{p_end}

{synopt :{cmd:.}{it:array}{cmd:.Arrpush "}{it:string}{cmd:"}} returns nothing;
   adds string to end of array{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
See {help classman} for more information.
{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P classRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


