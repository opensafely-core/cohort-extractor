{smcl}
{* *! version 1.0.1  17jul2019}{...}
{vieweralsosee "[D] vl" "mansection D vl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] vl create" "help vl create"}{...}
{vieweralsosee "[D] vl drop" "help vl drop"}{...}
{vieweralsosee "[D] vl list" "help vl list"}{...}
{vieweralsosee "[D] vl rebuild" "help vl rebuild"}{...}
{vieweralsosee "[D] vl set" "help vl set"}{...}
{viewerjumpto "Description" "vl##description"}{...}
{viewerjumpto "Links to PDF documentation" "vl##linkspdf"}{...}
{viewerjumpto "Remarks" "vl##remarks"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[D] vl} {hline 2}}Manage variable lists{p_end}
{p2col:}({mansection D vl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{opt vl} stands for variable list.  It is a suite of commands for creating and
managing named variable lists.  Lists are intended especially to be used as
arguments to estimation commands.

{pstd}
In particular, the suite is designed to help divide variables into two groups:
one group that will be treated as factor variables and another group that will
be treated as continuous or interval variables.

{pstd}
{opt vl} creates two types of named variable lists: system-defined
variable lists, created automatically by {opt vl} {opt set}, and
user-defined variable lists, created by {opt vl} {opt create}.  You
will usually use {opt vl set} to create system-defined variable lists
first, and then create your own variable lists from them with
{opt vl} {opt create}.

{pstd}
After creating a variable list called {it:vlusername}, the expression
{cmd:$}{it:vlusername} can be used in Stata anywhere a {varlist} is
allowed.  Variable lists are actually {help macro:global macros},
and the {cmd:vl} commands are a convenient way to create and manipulate them.

{pstd}
Variable lists are saved with the dataset.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D vlRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
The {cmd:vl} commands are the following:

{synoptset 15 tabbed}{...}
{syntab:System only}
{synopt :{helpb vl set}}initializes the system-defined variable lists based on
the number of levels and other characteristics of a variable{p_end}
{synopt :{helpb vl move}}moves variables from one system-defined variable list
to another{p_end}

{syntab:User only}
{synopt :{helpb vl create}}creates user-defined variable lists{p_end}
{synopt :{helpb vl modify}}adds or removes variables from user-defined variable
lists{p_end}
{synopt :{helpb vl label}}adds a label to a user-defined variable list{p_end}
{synopt :{helpb vl substitute}}creates a user-defined variable list using
factor-variable operators{p_end}

{syntab:System or user}
{synopt :{helpb vl list}}lists the contents of variable lists, either system or
user{p_end}
{synopt :{helpb vl dir}}displays the defined variable lists, either system or
user{p_end}
{synopt :{helpb vl drop}}deletes variable lists or removes variables from
multiple variable lists{p_end}
{synopt :{helpb vl clear}}deletes all variable lists{p_end}
{synopt :{helpb vl rebuild}}restores variable lists{p_end}
{p2colreset}{...}

{pstd}
The first thing to note is that some {cmd:vl} commands only work with 
system-defined variable lists, some only work with user-defined variable
lists, and others work with both.

{pstd}
{cmd:vl} {cmd:set} is typically used first.  It initializes the 
system-defined variable lists.  By default, it classifies all the numeric
variables in your dataset.  Or you can specify {varlist} and have it 
classify only those variables.

{pstd}
When we are discussing the {cmd:vl} commands and say "variable list", we mean
a named variable list created by {cmd:vl} {cmd:set} or {cmd:vl} {cmd:create}.
A traditional Stata list of variables, that is, {it:varlist}, we will call
{it:varlist}.  Variable lists contain {it:varlist}s.

{pstd}
{cmd:vl} {cmd:create} allows you to create your own variable lists, either
starting with system-defined variable lists or with {it:varlist}s you specify.
There is no need to run {cmd:vl} {cmd:set} and create system-defined variable
lists.  You can create your own from scratch.  If you are familiar with the
variables in your dataset and know which ones you want treated as factor
variables and which as continuous variables, you may want to create only
user-defined variable lists.

{pstd}
{cmd:vl} {cmd:rebuild} restores all the {cmd:vl}-generated variable lists
after loading a dataset that previously had variable lists.  Stata saves
variable lists when you {helpb save} your data, but when you {helpb use} the
saved data file, they are not automatically restored.
{p_end}
