{smcl}
{* *! version 1.1.8  19dec2012}{...}
{viewerdialog haver "dialog haver"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] infile" "help infile"}{...}
{vieweralsosee "[D] insheet" "help insheet"}{...}
{vieweralsosee "[D] odbc" "help odbc"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "haver##syntax"}{...}
{viewerjumpto "Menu" "haver##menu"}{...}
{viewerjumpto "Description" "haver##description"}{...}
{viewerjumpto "Option for use with haver describe" "haver##option_haver_describe"}{...}
{viewerjumpto "Options for use with haver use" "haver##options_haver_use"}{...}
{viewerjumpto "Examples" "haver##examples"}{...}
{pstd}
{cmd:haver} has been superseded by {helpb import haver}.  {cmd:haver}
continues to work but, as of Stata 13, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.


{title:Title}

{p2colset 5 19 21 2}{...}
{p2col:{bf:[TS] haver} {hline 2}}Load data from Haver Analytics database{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}Describe contents of a Haver dataset

{p 8 17 2}
{cmd:haver}
{opt des:cribe}
{it:{help filename}}
[{cmd:,}
{opt det:ail}]


{pstd}Describe specified variables in a Haver dataset

{p 8 17 2}
{cmd:haver}
{opt des:cribe}
{varlist}
{opt using}
{it:{help filename}}
[{cmd:,}
{opt det:ail}]


{pstd}Load Haver dataset

{p 8 17 2}
{cmd:haver}
{opt use}
{it:{help filename}}
[{cmd:,}
{it:use_options}]


{pstd}Load specified variables from a Haver dataset

{p 8 17 2}
{cmd:haver}
{opt use}
{varlist}
{opt using}
{it:{help filename}}
[{cmd:,}
{it:use_options}]


{synoptset 33}{...}
{synopthdr:use_options}
{synoptline}
{synopt:{cmdab:ti:n:(}[{it:constant}]{cmd:,} [{it:constant}]{cmd:)}}load data
within specified date range {p_end}
{synopt:{cmdab:tw:ithin:(}[{it:constant}]{cmd:,} [{it:constant}]{cmd:)}}same as
{opt tin()}, except exclude the end points of range{p_end}
{synopt:{opth tv:ar(varname)}}create time variable {it:varname}{p_end}
{synopt:{opth hm:issing(missing:misval)}}record missing values as {it:misval}
{p_end}
{synopt:{opt fi:ll}}include observations with missing data in resulting
dataset and record missing values for them{p_end}
{synopt:{opt clear}}clear data in memory before loading the Haver dataset{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Import > Haver Analytics database}


{marker description}{...}
{title:Description}

{pstd}
Haver Analytics ({browse "http://www.haver.com"}) provides
economic and financial databases in the form of {opt .dat} files to which you
can purchase access.  The {opt haver} command allows you to use those datasets
with Stata.  The {opt haver} command is provided only with Stata for Windows.  

{pstd}
{opt haver describe} describes the contents of a Haver file.

{pstd}
{opt haver use} loads the specified variables from a Haver file into
Stata's memory.

{pstd}
If {it:{help filename}} is specified without a suffix, {opt .dat} is assumed.


{marker option_haver_describe}{...}
{title:Option for use with haver describe}

{phang}
{opt detail} specifies that a detailed report of all information available on
   the variables be presented.  By default, the Haver concepts data type,
   number of observations, aggregate type, difference type, magnitude, and
   date modified are not reported.


{marker options_haver_use}{...}
{title:Options for use with haver use}

{phang}
{cmd:tin(}[{it:constant}]{cmd:,} [{it:constant}]{cmd:)} 
   specifies the date range of the data to be loaded.  {it:constant} refers to
   a date constant specified in the usual way, for example,
   {cmd:tin(1jan1999, 31dec1999)}, which would mean from and including 1
   January 1999 through 31 December 1999.

{phang}
{cmd:twithin(}[{it:constant}]{cmd:,} [{it:constant}]{cmd:)}
   functions the same as {cmd:tin()}, except that the endpoints of the range
   will be excluded in the data loaded.

{phang}
{opth tvar(varname)} specifies the name of the time variable Stata will
   create; the default is {cmd:tvar(time)}.  The {opt tvar()} variable is the
   name of the variable that you would use to {cmd:tsset} the data after
   loading, although doing so is unnecessary because {opt haver use}
   automatically {opt tsset}s the data for you.

{phang}
{opt hmissing(misval)} specifies which of Stata's 27 missing values ({cmd:.},
   {cmd:.a}, ..., {cmd:.z}) is to be recorded when there are missing values in
   the Haver dataset.

{pmore}
   Two kinds of missing values can occur when loading a Haver dataset.  One is
   created when a variable's data does not span the entire time series, and
   these missing values are always recorded as {cmd:.} by Stata.  The other
   corresponds to an actual missing value recorded in the Haver format.
   {opt hmissing()} sets what is recorded when this second kind of missing
   value is encountered.  You could specify {cmd:hmissing(.h)} to cause
   Stata's {cmd:.h} code to be recorded here.

{pmore}
  The default is to store {cmd:.} for both kinds of missing values.  See
  {help missing}.

{phang}
{opt fill} specifies that observations with no data be left in the resulting
   dataset formed in memory and that missing values be recorded for them.  The
   default is to exclude such observations, which can result in the loaded
   time-series dataset having gaps.

{pmore}
   Specifying {opt fill} has the same effect as issuing the {opt tsfill}
   command after loading; see {manhelp tsfill TS}.

{phang}
{opt clear} clears the data in memory before loading the Haver dataset.


{marker examples}{...}
{title:Examples}

{pstd}Describing data{p_end}

{phang2}{cmd:. haver describe dailytst}{p_end}
{phang2}{cmd:. haver describe FDB6 using dailytst, detail}{p_end}

{phang2}{cmd:. haver use dailytst.dat}{p_end}
{phang2}{cmd:. char list FDB6[]}{p_end}

{pstd}Merging variables

{phang2}{cmd:. haver describe dailytst}{p_end}
{phang2}{cmd:. haver use dailytst.dat, clear}{p_end}
{phang2}{cmd:. egen fedfunds = rfirst(FFED FFED2 FFED3 FFED4 FFED5 FFED6)}{p_end}

{pstd}More complex command

{phang2}{cmd:. haver use FFED FFED2 using dailytst.dat, tin(1jan1990,31dec1999) hmissing(.h)}{p_end}
