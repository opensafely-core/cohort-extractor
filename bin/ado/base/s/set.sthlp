{smcl}
{* *! version 1.0.6  11oct2019}{...}
{vieweralsosee "[R] set" "mansection R set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[M-3] mata set" "help mata set"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] set_defaults" "help set_defaults"}{...}
{viewerjumpto "Syntax" "set##syntax"}{...}
{viewerjumpto "Description" "set##description"}{...}
{viewerjumpto "Links to PDF documentation" "set##linkspdf"}{...}
{viewerjumpto "Examples" "set##examples"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] set} {hline 2}}Overview of system parameters{p_end}
{p2col:}({mansection R set:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}{cmd:set} [{it:setcommand ...}]

{pstd}
{it:setcommand} is one of the following:

            {helpb adosize}
            {helpb autotabgraphs}

            {helpb set cformat:cformat}
            {helpb checksum}
            {helpb clevel}
            {helpb set coeftabresults:coeftabresults}
            {helpb conren}
            {helpb set printcolor:copycolor}

            {helpb dockable}
            {helpb set docx:docx_hardbreak}
            {helpb set docx:docx_paramode}
            {helpb set dots:dots}
            {helpb doublebuffer}
            {helpb format:dp}

            {helpb emptycells}

            {helpb fastscroll}
            {helpb floatwindows}
            {helpb import fred:fredkey}
            {helpb set fvbase:fvbase}
            {helpb set showbaselevels:fvlabel}
            {helpb set fvtrack:fvtrack}
            {helpb set showbaselevels:fvwrap}
            {helpb set showbaselevels:fvwrapon}

            {helpb set graphics:graphics}
 
            {helpb import haver:haverdir}
            {helpb netio:httpproxy}
            {helpb netio:httpproxyauth}
            {helpb netio:httpproxyhost}
            {helpb netio:httpproxyport}
            {helpb netio:httpproxypw}
            {helpb netio:httpproxyuser}

            {helpb include_bitmap}
            {helpb set iter:iterlog}
 
            {helpb java_utilities:java_heapmax}
            {helpb java_utilities:java_home}

            {helpb level}
            {helpb linegap}
            {helpb log:linesize}
            {helpb set locale_functions:locale_functions}
            {helpb set locale_ui:locale_ui}
            {helpb locksplitters}
            {helpb logtype}
            {helpb lstretch}

            {helpb mata set:matacache}
            {helpb mata set:matafavor}
            {helpb mata set:matalibs}
            {helpb mata set:matalnum}
            {helpb mata set:matamofirst}
            {helpb mata set:mataoptimize}
            {helpb mata set:matastrict}
            {helpb maxbezierpath}
            {helpb db:maxdb}
            {helpb set iter:maxiter}
            {helpb memory:max_memory}
            {helpb preserve:max_preservemem}
            {helpb memory:maxvar}
            {helpb memory:min_memory}
            {helpb more}

            {helpb memory:niceness}
            {helpb notifyuser}

            {helpb obs}
            {helpb odbc:odbcdriver}
            {helpb odbc:odbcmgr}
            {helpb quietly:output}

            {helpb more:pagesize}
            {helpb set cformat:pformat}
            {helpb pinnable}
            {helpb playsnd}
            {helpb set prefix:prefix}
            {helpb set printcolor:printcolor}
            {helpb processors}
            {helpb python:python_exec}
            {helpb python:python_userpath}

            {helpb reventries}
            {helpb varkeyboard:revkeyboard}
            {helpb rmsg}
            {helpb set rng:rng}
            {helpb set rngstate:rngstate}
            {helpb set rngstream:rngstream}

            {helpb set scheme:scheme}
            {helpb scrollbufsize}
            {helpb search:searchdefault}
            {helpb set seed:seed}
            {helpb memory:segmentsize}
            {helpb set cformat:sformat}
            {helpb set showbaselevels:showbaselevels}
            {helpb set showbaselevels:showemptycells}
            {helpb set showbaselevels:showomitted}
            {helpb smoothfonts}

            {helpb netio:timeout1}
            {helpb netio:timeout2}
            {helpb trace}
            {helpb trace:tracedepth}
            {helpb trace:traceexpand}
            {helpb trace:tracehilite}
            {helpb trace:traceindent}
            {helpb trace:tracenumber}
            {helpb trace:tracesep}
            {helpb generate:type}

            {helpb update:update_interval}
            {helpb update:update_prompt}
            {helpb update:update_query}

            {helpb varabbrev}
            {helpb varkeyboard}


{marker description}{...}
{title:Description}

{pstd}
This help file provides a reference to Stata's {cmd:set} commands.

{pstd}
To reset system parameters to factory defaults,
see {manhelp set_defaults R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R setRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{phang}
Use a %9.2f format for coefficients, standard errors, and confidence limits
{p_end}
{phang2}{cmd:. set cformat %9.2f}

{phang}
Make the %9.2f format the default setting when Stata is invoked
{p_end}
{phang2}{cmd:. set cformat %9.2f, permanently}

{phang}
Reset all output settings to their original Stata defaults
{p_end}
{phang2}{cmd:. set_defaults output}
{p_end}
