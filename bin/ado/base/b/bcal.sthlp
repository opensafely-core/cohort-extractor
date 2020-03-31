{smcl}
{* *! version 1.4.5  20sep2018}{...}
{viewerdialog bcal "dialog bcal"}{...}
{viewerdialog "bcal create" "dialog bcal_create"}{...}
{vieweralsosee "[D] bcal" "mansection D bcal"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Datetime" "help datetime"}{...}
{vieweralsosee "[D] Datetime business calendars" "help datetime_business_calendars"}{...}
{vieweralsosee "[D] Datetime business calendars creation" "help datetime_business calendars creation"}{...}
{viewerjumpto "Syntax" "bcal##syntax"}{...}
{viewerjumpto "Menu" "bcal##menu"}{...}
{viewerjumpto "Description" "bcal##description"}{...}
{viewerjumpto "Links to PDF documentation" "bcal##linkspdf"}{...}
{viewerjumpto "Option for bcal check" "bcal##option_bcalcheck"}{...}
{viewerjumpto "Options for bcal create" "bcal##options_bcalcreate"}{...}
{viewerjumpto "Remarks" "bcal##remarks"}{...}
{viewerjumpto "Stored results" "bcal##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] bcal} {hline 2}}Business calendar file manipulation{p_end}
{p2col:}({mansection D bcal:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
List business calendars used by the data in memory

{p 8 25 2}
{cmd:bcal} {cmdab:c:heck} [{it:{help bcal##define:varlist}}] [{cmd:, rc0}]


{pstd}
List filenames and directories of available business calendars

{p 8 25 2}
{cmd:bcal} {cmd:dir} [{it:{help bcal##define:pattern}}]


{pstd}
Describe the specified business calendar

{p 8 25 2}
{cmd:bcal} {cmdab:d:escribe} {it:{help bcal##define:calname}}


{pstd}
Load the specified business calendar

{p 8 25 2}
{cmd:bcal} {cmd:load} {it:{help bcal##define:calname}}


{pstd}
Create a business calendar from the current dataset

{p 8 25 2}
{cmd:bcal} {cmd:create} {it:{help bcal##define:filename}}
{ifin}
{cmd:,} {opth from(varname)}
[{it:{help bcal##bcal_create_options:bcal_create_options}}]


{marker define}{...}
{p 4 4 2}
where

{p 8 12 2}
{it:varlist} is a list of variable names to be
checked for whether they use business calendars.  If not specified, all
variables are checked.

{p 8 12 2}
{it:pattern} is the name of a business calendar possibly containing
wildcards {cmd:*} and {cmd:?}.  If {it:pattern} is not specified, all
available business calendar names are listed.

{p 8 12 2}
{it:calname} is the name of a business calendar either as a name or as a
datetime format; for example, {it:calname} could be {cmd:simple} or
{cmd:%tbsimple}.

{p 8 12 2}
{it:filename} is the name of the business calendar file created by {cmd:bcal}
{cmd:create}. 


{synoptset 37 tabbed}{...}
{marker bcal_create_options}{...}
{synopthdr :bcal_create_options}
{synoptline}
{syntab :Main}
{p2coldent:* {opth from(varname)}}specify date variable for calendar{p_end}
{synopt :{opth g:enerate(newvar)}}generate {it:newvar} containing business dates{p_end}
{synopt :{cmdab:exclude:missing(}{it:{help varlist}} [{cmd:, any}]{cmd:)}}exclude
	observations with missing values in {it:varlist}{p_end}
{synopt :{cmd:personal}}save calendar file in your
	{helpb sysdir:PERSONAL} directory{p_end}
{synopt :{cmd:replace}}replace file if it already exists{p_end}

{syntab :Advanced}
{synopt :{opt purpose(text)}}describe purpose of calendar{p_end}
{synopt :{cmd:dateformat(ymd}|{cmd:ydm}|{cmd:myd}|{cmd:mdy}|{cmd:dym}|{cmd:dmy)}}specify
	date format in calendar file{p_end}
{synopt :{opt range(fromdate todate)}}specify range of calendar{p_end}
{synopt :{opt center:date(date)}}specify center date of calendar{p_end}
{synopt :{opt maxgap(#)}}specify maximum gap allowed; default is 10 days{p_end}
{synoptline}
{p 4 6 2}
* {opt from(varname)} is required.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Other utilities > Create a business calendar}

{phang}
{bf:Data > Other utilities > Manage business calendars}

{phang}
{bf:Data > Variables Manager}


{marker description}{...}
{title:Description}

{pstd}
See {bf:{help datetime_business_calendars:[D] Datetime business calendars}}
for an introduction to business calendars and dates.

{pstd}
{cmd:bcal} {cmd:check} lists the business calendars used by the data 
in memory, if any. 

{pstd}
{cmd:bcal} {cmd:dir} {it:pattern} lists filenames and directories of all
available business calendars matching {it:pattern}, or all business
calendars if {it:pattern} is not specified.

{pstd}
{cmd:bcal} {cmd:describe} {it:calname} presents a description of the
specified business calendar.

{pstd}
{cmd:bcal} {cmd:load} {it:calname} loads the specified business calendar.
Business calendars load automatically when needed, and thus use of {cmd:bcal}
{cmd:load} is never required.  {cmd:bcal} {cmd:load} is used by programmers
writing their own business calendars.  {cmd:bcal} {cmd:load} {it:calname}
forces immediate loading of a business calendar and displays output, including
any error messages due to improper calendar construction.

{pstd}
{cmd:bcal} {cmd:create} {it:filename}{cmd:, from(}{it:varname}{cmd:)}
creates a business calendar file based on dates in {it:varname}.
Business holidays are inferred from gaps in {it:varname}.  The qualifiers
{cmd:if} and {cmd:in}, as well as the option {opt excludemissing()},
can also be used to exclude dates from the new business calendar. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D bcalQuickstart:Quick start}

        {mansection D bcalRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option_bcalcheck}{...}
{title:Option for bcal check}

{dlgtab:Main}

{p 4 8 2}
{cmd:rc0} 
    specifies that {cmd:bcal} {cmd:check} is to exit without error (return 0)
    even if some calendars do not exist or have errors.  Programmers can 
    then access the results {cmd:bcal} {cmd:check} stores in {cmd:r()} 
    to get even more details about the problems.  If you wish to suppress 
    {cmd:bcal} {cmd:dir}, precede the {cmd:bcal} {cmd:check} command with
    {cmd:capture} and specify the {cmd:rc0} option if you wish to access the
    {cmd:r()} results.


{marker options_bcalcreate}{...}
{title:Options for bcal create}

{dlgtab:Main}

{p 4 8 2}
{opth from(varname)} 
specifies the date variable used to create the business calendar.
Gaps between dates in {it:varname} define business holidays.  The
longest gap allowed can be set with the {opt maxgap()} option.
{opt from()} is required.

{p 4 8 2}
{opth generate(newvar)} specifies that {it:newvar} be created.  {it:newvar} is
a date variable in {cmd:%tb}{it:{help bcal##define:calname}} format, where
{it:calname} is the name of the business calendar derived from
{it:{help bcal##define:filename}}.

{p 4 8 2}
{cmd:excludemissing(}{it:{help varlist}} [{cmd:, any}]{cmd:)} 
specifies that the dates of observations with missing values in {it:varlist}
are business holidays.  By default, the dates of observations with missing
values in all variables in {it:varlist} are holidays.  The {cmd:any}
suboption specifies that the dates of observations with missing values in any
variable in {it:varlist} are holidays.

{p 4 8 2}
{cmd:personal} specifies that the calendar file be saved in the
{helpb sysdir:PERSONAL} directory.  This option cannot be used if
{it:{help bcal##define:filename}} contains the pathname of the directory where
the file is to be saved. 

{p 4 8 2}
{cmd:replace} specifies that the business calendar file be replaced if
it already exists.

{dlgtab:Advanced}

{p 4 8 2}
{opt purpose(text)} specifies the purpose of the business calendar being
created.  {it:text} cannot exceed 63 characters.

{p 4 8 2}
{cmd:dateformat(ymd}|{cmd:ydm}|{cmd:myd}|{cmd:mdy}|{cmd:dym}|{cmd:dmy)}
specifies the date format in the new business calendar.  The default is
{cmd:dateformat(ymd)}.  {cmd:dateformat()} has nothing to do with how dates
will look when variables are formatted with
{cmd:%tb}{it:{help bcal##define:calname}}; it specifies how dates are typed in
the calendar file. 

{p 4 8 2}
{opt range(fromdate todate)} defines the date range of the calendar
being created.  {it:fromdate} and {it:todate} should be in the format specified
by the {cmd:dateformat()} option; if not specified, the default {cmd:ymd} format
is assumed. 

{p 4 8 2}
{opt centerdate(date)} defines the center date of the new business
calendar.  If not specified, the earliest date in the calendar is assumed.
{it:date} should be in the format specified by the {cmd:dateformat()} option; if
not specified, the default {cmd:ymd} format is assumed. 

{p 4 8 2}
{opt maxgap(#)} specifies the maximum number of consecutive business holidays
allowed by {cmd:bcal} {cmd:create}.  The default is {cmd:maxgap(10)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:bcal} {cmd:check} reports on any {cmd:%tb} formats used by the 
data in memory:

        {cmd}. bcal check
        {res}{txt}
               {res}%tbsimple:  {txt}defined, {txt}used by variable
                           mydate

{pstd}
{cmd:bcal} {cmd:dir} reports on business calendars available:

        {cmd}. bcal dir
        {res}{txt}  1 calendar file found:
          simple:  C:\Program Files\Stata16\ado\base\s\simple.stbcal

{pstd}
{cmd:bcal} {cmd:describe} reports on an individual calendar.

        {cmd}. bcal describe simple

        {txt}  Business calendar {res}simple{txt} (format {res}%tbsimple{txt}):

            purpose:  {res}Example for manual

        {txt}      range:  {res}01nov2012  30nov2012
        {txt}             {res}    18932      18961{txt}{col 46}in %td units
                     {res}        0         19{txt}{col 46}in %tbsimple units

             center:  {res}01nov2012
        {txt}             {res}    18932{txt}{col 46}in %td units
                     {res}        0{txt}{col 46}in %tbsimple units

            omitted: {res}       10{txt}{col 46}days
                     {res}      121.8{txt}{col 46}approx. days/year

           included: {res}       20{txt}{col 46}days
                     {res}      243.5{txt}{col 46}approx. days/year{txt}

{pstd}
{cmd:bcal} {cmd:load} is used by programmers writing new stbcal-files.
See 
{bf:{help datetime_business_calendars_creation:[D] Datetime business calendars creation}}.

{pstd}
{cmd:bcal} {cmd:create} creates a business calendar file from the current dataset and
describes the new calendar.  For example, {cmd:sp500.dta} is a dataset installed
with Stata that has daily records on the S&P 500 stock market index in 2001.
The dataset has observations only for days when trading took place.  A business
calendar for stock trading in 2001 can be automatically created from this
dataset as follows:

        {cmd:. sysuse sp500}
	{phang2}
        {cmd:. bcal create sp500, from(date) purpose(S&P 500 for 2001) generate(bizdate)}{p_end}

	  Business calendar {bf:sp500} (format {bf:%tbsp500}):

    	    purpose:  {bf:S&P 500 for 2001}

              range:  {bf:02jan2001  31dec2001}
                         {bf:14977      15340}   in %td units
                             {bf:0        247}   in %tbsp500 units

             center:  {bf:02jan2001}
                         {bf:14977}              in %td units
                             {bf:0}              in %tbsp500 units

            omitted:       {bf:116}              days
                           {bf:116.4}            approx. days/year

           included:       {bf:248}              days
                           {bf:248.9}            approx. days/year

	  Notes:
		
            business calendar file {bf:sp500.stbcal} saved

            variable {bf:bizdate} created; it contains business dates in {bf:%tbsp500}
	    > format

{pstd}
The business calendar file created: 

        {hline 40} sp500.stbcal {hline 3}
	{cmd}* Business calendar "sp500" created by -bcal create-
	* Created/replaced on 23 Sep 2017

        version {ccl stata_version}
        purpose "S&P 500 for 2001"
        dateformat ymd

        range 2001jan02 2001dec31
        centerdate 2001jan02

        omit dayofweek (Sa Su)
        omit date 2001jan15
        omit date 2001feb19
        omit date 2001apr13
        omit date 2001may28
        omit date 2001jul04
        omit date 2001sep03
        omit date 2001sep11
        omit date 2001sep12
        omit date 2001sep13
        omit date 2001sep14
        omit date 2001nov22
        omit date 2001dec25{txt}
        {hline 40} sp500.stbcal {hline 3}

{pstd}
{cmd:bcal} {cmd:create} {it:{help bcal##define:filename}}{cmd:,} {cmd:from()}
can save the calendar file anywhere in your directory system by specifying a
path in {it:filename}.  It is assumed that the directory where the file is to
be saved already exists.  The pattern of {it:filename} should be
[{it:path}]{it:{help bcal##define:calname}}[{cmd:.stbcal}].  Here {it:calname}
should be without the {cmd:%tb} prefix; {it:calname} has to be a valid Stata
name but limited to 10 characters.  If {it:path} is not specified, the file is
saved in the current working directory.  If the {cmd:.stbcal} extension is not
specified, it is added.

{pstd}
Save the file in a directory where Stata can find it.
Stata automatically searches for stbcal-files in the same way it searches for
ado-files.  Stata looks for ado-files and stbcal-files in the official Stata
directories, your site's directory ({helpb sysdir:SITE}), your current
working directory, your personal directory ({helpb sysdir:PERSONAL}),
and your directory for materials written by other users
({helpb sysdir:PLUS}).  The option {cmd:personal} specifies that the
calendar file be saved in your {cmd:PERSONAL} directory, which ensures that the
created calendar can be easily found in future work.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bcal} {cmd:check} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(defined)}}business calendars used, stbcal-file exists, and file contains no errors{p_end}
{synopt:{cmd:r(undefined)}}business calendars used, but no stbcal-files exist for them{p_end}
{synopt:{cmd:r(varlist_}{it:{help bcal##define:calname}}{cmd:)}}list of variable names that use business calendar {it:calname}{p_end}
{p2colreset}{...}

{pstd}
Warning to programmers:
    Specify the {cmd:rc0} option to access these returned results. 
    By default, {cmd:bcal} {cmd:check} returns code 459 if a business
    calendar does not exist or if a business calendar exists but has errors;
    in such cases, the results are not stored.

{pstd}
{cmd:bcal} {cmd:dir} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(calendars)}}business calendars available{p_end}
{synopt:{cmd:r(fn_}{it:{help bcal##define:calname}{cmd:)}}}stbcal-file for business calendar {it:calname}{p_end}
{p2colreset}{...}

{pstd}
{cmd:bcal} {cmd:describe} and {cmd:bcal} {cmd:create} store the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(min_date_td)}}calendar's minimum date in {cmd:%td} units{p_end}
{synopt:{cmd:r(max_date_td)}}calendar's maximum date in {cmd:%td} units{p_end}
{synopt:{cmd:r(ctr_date_td)}}calendar's zero date    in {cmd:%td} units{p_end}
{synopt:{cmd:r(min_date_tb)}}calendar's minimum date in {cmd:%tb} units{p_end}
{synopt:{cmd:r(max_date_tb)}}calendar's maximum date in {cmd:%tb} units{p_end}
{synopt:{cmd:r(omitted)}}total number of days omitted from calendar{p_end}
{synopt:{cmd:r(included)}}total number of days included in calendar{p_end}
{synopt:{cmd:r(omitted_year)}}approximate number of days omitted per year from calendar{p_end}
{synopt:{cmd:r(included_year)}}approximate number of days included per year in calendar{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(name)}}pure calendar name (for example, {cmd:nyse}){p_end}
{synopt:{cmd:r(purpose)}}short description of calendar's purpose{p_end}
{synopt:{cmd:r(fn)}}name of stbcal-file{p_end}
{p2colreset}{...}

{pstd}
{cmd:bcal load} stores the same results in {cmd:r()} as {cmd:bcal describe},
except it does not store {cmd:r(omitted)}, {cmd:r(included)}, {cmd:r(omitted_year)},
and {cmd:r(included_year)}.  
{p_end}
