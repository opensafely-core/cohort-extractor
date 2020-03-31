{smcl}
{* *! version 1.0.8  07feb2020}{...}
{vieweralsosee "[P] Java utilities" "mansection P Javautilities"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] Java intro" "help java_intro"}{...}
{viewerjumpto "Syntax" "java_utilities##syntax"}{...}
{viewerjumpto "Description" "java_utilities##description"}{...}
{viewerjumpto "Remarks" "java_utilities##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[P] Java utilities} {hline 2}}Java utilities 
{p_end}
{p2col:}({mansection P Javautilities:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
List Java Runtime Environment settings and system information

{p 8 16 2}
{cmd:java} {cmdab:q:uery}


{pstd}
Initialize the Java Runtime Environment

{p 8 16 2}
{cmd:java} {cmdab:init:ialize}


{pstd}
Set the path to the Java Runtime Environment

{p 8 16 2}
{cmd:java} {cmd:set} 
{cmd:home}
{cmd:default} | {cmd:"}{it:path_to_java_home_dir}{cmd:"} 

{phang}
{cmd:set java_home} is a synonym for {cmd:java set home}.{p_end}


{pstd}
Set the amount of heap memory for the Java Runtime Environment

{p 8 16 2}
{cmd:java} {cmd:set} 
{cmd:heapmax}
{cmd:default} | {it:size}  

{phang}
{cmd:set java_heapmax} is a synonym for {cmd:java set heapmax}.{p_end}
{phang}
{it:size} is {it:#}[{cmd:m}|{cmd:g}], and the default unit is {cmd:m}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:java} {cmd:query} shows settings and system information for the 
Java Runtime Environment (JRE).  Some system information is only
available after the Java Virtual Machine (JVM) has been initialized.

{pstd}
{cmd:java} {cmd:set} {cmd:home} sets the path to the JRE.

{pstd}
{cmd:java} {cmd:set} {cmd:heapmax} sets the maximum amount of heap memory
allocated for the JVM.

{pstd}
{cmd:java} {cmd:initialize} manually initializes the JVM.  Manual
initialization is not typically used because the JVM initializes
automatically when it is required.  Once the JVM has been initialized,
it cannot be uninitialized within a Stata session.

{pstd}
For details about creating Java plugins in Stata, see
{helpb java intro:[P] Java intro}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Stata requires a JRE for some functionality.
The JRE redistributed with Stata is based on source code from the OpenJDK and
is licensed under the terms of the
{browse "https://openjdk.java.net/legal/gplv2+ce.html":GPL v2 with Classpath Exception}.
This version of Stata contains build 11.0.6-LTS acquired from Azul Systems.

{pstd}
Sometimes, it may be necessary to use and maintain your own version of the 
JRE.  For example, some institutions require that frequent security patches be
applied to the JRE to maintain security compliance.  For these situations,
using {cmd:java} {cmd:set} {cmd:home} will tell Stata to use your JRE instead
of the JRE that is distributed with Stata.  When replacing the default JRE, we
recommend that only long-term support (LTS) versions be used.  The minimum
Java version supported by this version of Stata is release 8.  For developers
who wish to redistribute a Java plugin, we recommend that they compile their
code to target release 8.
{p_end}
