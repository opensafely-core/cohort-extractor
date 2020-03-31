{smcl}
{* *! version 1.0.19  15oct2018}{...}
{viewerdialog "import haver" "dialog import_haver_dlg"}{...}
{vieweralsosee "[D] import haver" "mansection D importhaver"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[D] import delimited" "help import delimited"}{...}
{vieweralsosee "[D] import fred" "help import fred"}{...}
{vieweralsosee "[D] odbc" "help odbc"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "import_haver##syntax"}{...}
{viewerjumpto "Menu" "import_haver##menu"}{...}
{viewerjumpto "Description" "import_haver##description"}{...}
{viewerjumpto "Links to PDF documentation" "import_haver##linkspdf"}{...}
{viewerjumpto "Options for import haver" "import_haver##importoptions"}{...}
{viewerjumpto "Options for import haver, describe" "import_haver##importdescribeoptions"}{...}
{viewerjumpto "Option for set haverdir" "import_haver##sethaverdiroption"}{...}
{viewerjumpto "Remarks and examples" "import_haver##remarks"}{...}
{viewerjumpto "Stored results" "import_haver##results"}{...}
{p2colset 1 21 18 2}{...}
{p2col:{bf:[D] import haver} {hline 2}}Import data from Haver Analytics
databases{p_end}
{p2col:}({mansection D importhaver:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Load Haver data

{p 8 32 2}
{cmd:import} {cmdab:hav:er} {it:{help import_haver##seriesdblist:seriesdblist}} [,
     {it:{help import_haver##import_haver_options:import_haver_options}}]


{phang}
Load Haver data using a dataset that is loaded in memory

{p 8 32 2}
{cmd:import} {cmdab:hav:er}, {opt frommem:ory}
     [{it:{help import_haver##import_haver_options:import_haver_options}}]


{phang}
Describe contents of Haver database

{p 8 32 2}
{cmd:import} {cmdab:hav:er} {it:{help import_haver##seriesdblist:seriesdblist}},
     {cmdab:des:cribe} [{it:{help import_haver##import_haver_describe_options:import_haver_describe_options}}]


{phang}
Specify the directory where the Haver databases are stored

{p 8 32 2}
{cmd:set haverdir "}{it:path}{cmd:"} [{cmd:,} {opt perm:anently}]


{synoptset 37}{...}
{marker import_haver_options}{...}
{synopthdr :import_haver_options}
{synoptline}
{synopt:{cmdab:fi:n:(}[{it:datestring}]{cmd:,} [{it:datestring}]{cmd:)}}load data
within specified date range {p_end}
{synopt:{cmdab:fw:ithin:(}[{it:datestring}]{cmd:,} [{it:datestring}]{cmd:)}}same
as {opt fin()} but exclude the end points of range{p_end}
{synopt:{opth tv:ar(varname)}}create time variable {it:varname}{p_end}
{synopt:{cmd:case(}{cmdab:l:ower}|{cmdab:u:pper}{cmd:)}}read variable names as
   lowercase or uppercase{p_end}
{synopt:{opth hm:issing(missing:misval)}}record missing values as {it:misval}
{p_end}
{synopt:{cmdab:aggm:ethod(}{cmd:strict}|{cmd:relaxed}|{cmd:force)}}set how
temporal aggregation calculations deal with missing data{p_end}

{synopt :{opt frommem:ory}}load data using file in memory {p_end}
{synopt:{opt clear}}clear data in memory before loading Haver
database{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{opt frommemory} and {opt clear} do not appear in the dialog box.{p_end}


{synoptset 37 tabbed}{...}
{marker import_haver_describe_options}{...}
{synopthdr :import_haver_describe_options}
{synoptline}
{p2coldent :* {opt des:cribe}}describe contents of {it:seriesdblist}{p_end}
{synopt :{opt det:ail}}list full series information table for each
 series{p_end}
{synopt:{cmdab:saving(}{it:{help filename}}[{cmd:, verbose replace}]{cmd:)}}save
 series information to {it:filename}{cmd:.dta}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt describe} is required.


{marker seriesdblist}{...}
{p 4 4 2}
{it:seriesdblist} is one or more of the following:

            {it:dbfile}
            {it:series}{cmd:@}{it:dbfile}
            {cmd:(}{it:series series} ....{cmd:)@}{it:dbfile}

{p 4 4 2}
where {it:dbfile} is the name of a Haver Analytics database and
{it:series} contains a Haver Analytics series.  Wildcards {cmd:?} and
{cmd:*} are allowed in {it:series}.  {it:series} and {it:dbfile} are not
case sensitive.

{marker seriesdblist_examples}{...}
{p 8 8 2}
Example:  {cmd:import haver gdp@usecon}
{p_end}
{p 12 12 2}
	Import series GDP from the USECON database.

{p 8 8 2}
Example:  {cmd:import haver gdp@usecon c1*@ifs}
{p_end}
{p 12 12 2}
	Import series GDP from the USECON database, and import any series that
	starts with c1 from the IFS database.

{p 4 4 2}
Note:  You must specify a path to the database if you did not use the
{cmd:set haverdir} command.{p_end}

{p 8 8 2}
Example:  {cmd:import haver gdp@"C:\data\usecon" c1*@"C:\data\ifs"}

{p 4 4 2}
If you do not specify a path to the database and you did not
{cmd:set haverdir}, then {cmd:import haver} will look in the current working
directory for the database.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Import > Haver Analytics database}


{marker description}{...}
{title:Description}

{pstd}
Haver Analytics ({browse "http://www.haver.com"}) provides economic and
financial databases to which you can purchase access.  The {opt import haver}
command allows you to use those databases with Stata.  The {opt import haver}
command is provided only with Stata for Windows.

{pstd}
{cmd:import} {cmd:haver} {it:seriesdblist} loads data from one or more Haver
databases into Stata's memory.

{pstd}
{cmd:import} {cmd:haver} {it:seriesdblist}{cmd:, describe} describes the
contents of one or more Haver databases.

{pstd}
If a database is specified without a suffix, then the suffix {opt .dat} is assumed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importhaverQuickstart:Quick start}

        {mansection D importhaverRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker importoptions}{...}
{title:Options for import haver}

{phang}
{cmd:fin(}[{it:datestring}]{cmd:,} [{it:datestring}]{cmd:)}
   specifies the date range of the data to be loaded.  {it:datestring} must 
   adhere to the Stata default for the different frequencies.  See 
   {manhelp datetime_display_formats D:Datetime display formats}.  Examples are
   23mar2012 (daily and weekly), 2000m1 (monthly), 2003q4 (quarterly), and
   1998 (annual).  {cmd:fin(1jan1999, 31dec1999)} would mean from and
   including 1 January 1999 through 31 December 1999.  Note that weekly data
   must be specified as daily data because Haver-week data are conceptually
   different than Stata-week data.

{pmore}
   {cmd:fin()} also determines the aggregation frequency.
   If you want to retrieve data in a frequency that is lower than the one in
   which the data are stored, specify the dates in option {cmd: fin()}
   accordingly.  For example, to retrieve series that are stored in quarterly
   frequency into an annual dataset, you can type {cmd:fin(1980,2010)}.

{phang}
{cmd:fwithin(}[{it:datestring}]{cmd:,} [{it:datestring}]{cmd:)}
   functions the same as {cmd:fin()} except that the endpoints of the range
   will be excluded in the loaded data.

{phang}
{opth tvar(varname)} specifies the name of the time variable Stata will
   create.  The default is {cmd:tvar(time)}.  The {opt tvar()} variable is the
   name of the variable that you would use to {cmd:tsset} the data after
   loading, although doing so is unnecessary because {cmd:import haver}
   automatically {cmd:tsset}s the data for you.

{phang}
{cmd:case(lower}|{cmd:upper)} specifies the case of the variable names after
import. The default is {cmd:case(lower)}.

{phang}
{opt hmissing(misval)} specifies which of Stata's 27 missing values ({cmd:.},
   {cmd:.a}, ..., {cmd:.z}) to record when there are missing values
   in the Haver database.

{pmore}
   Two kinds of missing values occur in Haver databases.  The first occurs
   when nothing is recorded because the data do not span the entire range;
   these missing values are always stored as {cmd:.} by Stata.  The second
   occurs when Haver has recorded a Haver missing value; by default, these
   are stored as {cmd:.} by Stata, but you can use {opt hmissing()} to specify
   that a different {help missing:extended missing-value} code be used.

{phang}
{cmd:aggmethod(strict}|{cmd:relaxed}|{cmd:force)} specifies a method of
temporal aggregation in the presence of missing observations.
{cmd:aggmethod(strict)} is the default aggregation method.

{pmore}
Most Haver series of higher than annual frequency has an aggregation type
that determines how data can be aggregated.  The three aggregation types are
average (AVG), sum (SUM), and end of period (EOP).  Each aggregation method
behaves differently for each aggregation type.

{pmore}
An aggregated span is a time period expressed in the original frequency.
The goal is to aggregate the data in an aggregation span to a single
observation in the (lower) target frequency.  For example, 1973m1-1973m3 is
an aggregated span for quarterly aggregation to 1973q1.

{pmore}
{cmd:strict} aggregation method:

{p 12 15 2}
1) (Average) The aggregated value is the average value if no observation in
   the aggregated span is missing; otherwise, the aggregated value is missing.

{p 12 15 2}
2) (Sum) The aggregated value is the sum if no observation in the aggregated
span is missing; otherwise, the aggregated value is missing.

{p 12 15 2}
3) (End of period) The aggregated value is the series value in the last period
in the aggregated span, be it missing or not.

{pmore}
{cmd:relaxed} aggregation method:

{p 12 15 2}
1) (Average) The aggregated value is the average value as long as there is one
nonmissing data point in the aggregated span; otherwise, the aggregated value
is missing.

{p 12 15 2}
2) (Sum) The aggregated value is the sum if no observation in the aggregated
span is missing; otherwise, the aggregated value is missing.

{p 12 15 2}
3) (End of period) The aggregated value is the last available nonmissing data
point in the aggregated span; otherwise, the aggregated value is missing.

{pmore}
{cmd:force} aggregation method:

{p 12 15 2}
1) (Average) The aggregated value is the average value as long as there is one
nonmissing data point in the aggregated span; otherwise, the aggregated value
is missing.

{p 12 15 2}
2) (Sum) The aggregated value is the sum if there is at least one nonmissing
data point in the aggregated span; otherwise, the aggregated value is missing.

{p 12 15 2}
3) (End of period) The aggregated value is the last available nonmissing data
point in the aggregated span; otherwise, the aggregated value is missing.

{pstd}
The following options are available with {cmd:import haver} but are not shown
in the dialog box:

{phang}
{cmd:frommemory}
   specifies that each observation of the dataset in memory specifies the
   information for a Haver series to be imported.  The dataset in memory
   must contain variables named {opt path}, {opt file}, and {opt series}.
   The observations in {opt path} specify paths to Haver databases, the
   observations in {opt file} specify Haver databases, and the observations
   in {opt series} specify the series to import.

{phang}
{opt clear} clears the data in memory before loading the Haver database.


{marker importdescribeoptions}{...}
{title:Options for use with import haver, describe}

{phang}
{opt describe} describes the contents of one or more Haver databases.

{phang}
{opt detail} specifies that a detailed report of all the information available
on the variables be presented.

{phang}
{cmdab:saving(}{it:{help filename}}[{cmd:, verbose replace}]{cmd:)} saves
the series meta-information to a Stata dataset.  By default, the series
meta-information is not displayed to the Results window, but you can use the
{opt verbose} option to display it.

{pmore}{cmdab:saving()} saves a Stata dataset that can subsequently be used
with the {cmdab:frommemory} option.


{marker sethaverdiroption}{...}
{title:Option for set haverdir}

{phang}
{cmd:permanently}
specifies that in addition to making the change right now, the {cmd:haverdir}
setting be remembered and become the default setting when you invoke Stata.


{marker remarks}{...}
{title:Remarks and examples}

{pstd}
Remarks are presented under the following headings:

	{help import_haver##remarks1:Installation}
	{help import_haver##remarks2:Setting the path to Haver databases}
	{help import_haver##remarks3:Download example Haver databases}
	{help import_haver##remarks4:Determining the contents of a Haver database}
	{help import_haver##remarks5:Loading a Haver database}
	{help import_haver##remarks6:Loading a Haver database from a describe file}
	{help import_haver##remarks7:Temporal aggregation}
	{help import_haver##remarks8:Daily data}
	{help import_haver##remarks9:Weekly data}


{marker remarks1}{...}
{title:Installation}

{pstd}
Haver Analytics ({browse "http://www.haver.com"})  provides more than 200
economic and financial databases in the form of {cmd:.dat} files to which you
can purchase access.  The {cmd:import haver} command provides easy access
to those databases from Stata.  {cmd:import haver} is provided only with Stata
for Windows.


{marker remarks2}{...}
{title:Setting the path to Haver databases}

{pstd}
If you want to retrieve data from Haver Analytics databases, you must
discover the directory in which the databases are stored.  This will most likely
be a network location.  If you do not know the directory, contact your
technical support staff or Haver Analytics ({browse "http://www.haver.com"}).
Once you have determined the directory location -- for example,
{cmd:H:\haver_files} -- you can save it by using the command

{phang2}
	{cmd:. set haverdir "H:\haver_files\", permanently}

{pstd}
Using the {opt permanently} option will preserve the Haver directory
information between Stata sessions.  Once the Haver directory is set, you
can start retrieving data.  For example, if you are subscribing to the
USECON database, you can type

{phang2}
	{cmd:. import haver gdp@usecon}

{pstd}
to load the GDP series into Stata.  If you did not use {cmd:set haverdir}, you
would type

{phang2}
	{cmd:. import haver gdp@"H:\haver_files\usecon"}

{pstd}
The directory path passed to {cmd:set haverdir} is saved in the
{cmd:creturn} value {cmd:c(haverdir)}.  You can view it by typing

{phang2}
	{cmd:. display "`c(haverdir)'"}


{marker remarks3}{...}
{title:Download example Haver databases}

{pstd}
There are three example Haver databases you can download to your working
directory.  Run the {cmd:copy} commands below to download HAVERD, HAVERW, and
HAVERMQA.

	{cmd:. copy https://www.stata.com/haver/HAVERD.DAT haverd.dat}
	{cmd:. copy https://www.stata.com/haver/HAVERD.IDX haverd.idx}
	{cmd:. copy https://www.stata.com/haver/HAVERW.DAT haverw.dat}
	{cmd:. copy https://www.stata.com/haver/HAVERW.IDX haverw.idx}
	{cmd:. copy https://www.stata.com/haver/HAVERMQA.DAT havermqa.dat}
	{cmd:. copy https://www.stata.com/haver/HAVERMQA.IDX havermqa.idx}

{pstd}
To use these files, you need to make sure your Haver directory is not set:

{phang2}
	{cmd:. set haverdir ""}


{marker remarks4}{...}
{title:Determining the contents of a Haver database}

{pstd}
{cmd:import} {cmd:haver} {it:seriesdblist}{cmd:, describe} displays the
contents of a Haver database.  If no series is specified, then all series are
described.

        {cmd:. import haver haverd, describe}

Dataset: haverd
-------------------------------------------------------------------------------
Variable   Description               Time span             Frequency Source
-------------------------------------------------------------------------------
FXTWB      Nominal Broad Trade-W..   03jan2005-02mar2012   Daily     FRB
FXTWM      Nominal Trade-Weighte..   03jan2005-02mar2012   Daily     FRB
FXTWOTP    Nominal Trade-Weighte..   03jan2005-02mar2012   Daily     FRB
-------------------------------------------------------------------------------

Summary
-------------------------------------------------------------------------------
    number of series described: 3
              series not found: 0


{pstd}
Above we describe the Haver database {cmd:haverd.dat}, which we already have
on our computer and in our current directory.

{pstd}
By default, each line of the output corresponds to one Haver series.
Specifying {opt detail} displays more information about each series, and
specifying {it:seriesname}{cmd:@} allows us to restrict the output to the series
that interests us:

        {cmd:. import haver FXTWB@haverd, describe detail}

-------------------------------------------------------------------------------
FXTWB         Nominal Broad Trade-Weighted Exchange Value of the US$ (1/97=100)
-------------------------------------------------------------------------------
    Frequency: Daily                     Time span: 03jan2005-02mar2012
    Number of Observations: 1870         Date Modified: 07mar2012 11:27:33
    Aggregation Type: AVG                Decimal Precision: 4
    Difference Type: 0                   Magnitude: 0
    Data Type: INDEX                     Group: R03
    Primary Geography Code: 111          Secondary Geography Code:
    Source: FRB                          Source Description: Federal Reserv..


Summary
-------------------------------------------------------------------------------
    number of series described: 1
              series not found: 0

{pstd}
You can describe multiple Haver databases with one command:

	{cmd:. import haver haverd haverw, describe}
	<output omitted>

{pstd}
To restrict the output to the series that interest us for each database, you
could type

	{cmd:. import haver (FXTWB FXTWOTP)@haverd FARVSN@haverw, describe}
	<output omitted>


{marker remarks5}{...}
{title:Loading a Haver database}

{pstd}
{cmd:import haver} {it:seriesdblist} loads Haver databases.  If no series is
specified, then all series are loaded.
{p_end}

        {cmd:. import haver haverd, clear}

Summary
-------------------------------------------------------------------------------
       Haver data retrieval: 10 Dec 2012 11:41:18
      # of series requested: 3
      # of database(s) used: 1 (HAVERD)
       All series have been successfully retrieved

Frequency
-------------------------------------------------------------------------------
    highest Haver frequency: Daily
     lowest Haver frequency: Daily
 frequency of Stata dataset: Daily


{pstd}
The table produced by {cmd:import} {cmd:haver} {it:seriesdblist} displays a
summary of the loaded data, frequency information about the loaded data,
series that could not be loaded because of errors, and notes about the data.

{pstd}
The dataset now contains a time variable and three variables retrieved from
the HAVERD database:

        {cmd:. describe}

Contains data
  obs:         1,870
 vars:             4
 size:        59,840
-------------------------------------------------------------------------------
              storage  display     value
variable name   type   format      label      variable label
-------------------------------------------------------------------------------
time            double %td
fxtwb_haverd    double %10.0g                 Nominal Broad Trade-Weighted
                                                Exchange Value of the US$
                                                (1/97=100)
fxtwm_haverd    double %10.0g                 Nominal Trade-Weighted Exch Value
                                                of US$ vs Major Currencies
                                                (3/73=100)
fxtwotp_haverd  double %10.0g                 Nominal Trade-Weighted Exchange
                                                Value of US$ vs OITP (1/97=100)
-------------------------------------------------------------------------------
Sorted by: time
     Note: Dataset has changed since last saved.

{pstd}
Haver databases include the following meta-information about each variable:

{p2colset 9 30 32 2}{...}
{synopt:{cmd:HaverDB}}database name{p_end}
{synopt:{cmd:Series}}series name{p_end}
{synopt:{cmd:DateTimeMod}}date/time the series was last modified{p_end}
{synopt:{cmd:Frequency}}frequency of series (from daily to annual) as it
  is stored in the Haver database{p_end}
{synopt:{cmd:Magnitude}}magnitude of the data{p_end}
{synopt:{cmd:DecPrecision}}number of decimals to which the variable
  is recorded{p_end}
{synopt:{cmd:DifType}}relevant within Haver software only: if =1,
percentage calculations are not allowed{p_end}
{synopt:{cmd:AggType}}temporal aggregation type (one of AVG, SUM, EOP){p_end}
{synopt:{cmd:DataType}}type of data (e.g., ratio, index, US$, %){p_end}
{synopt:{cmd:Group}}Haver series group to which the variable belongs{p_end}
{synopt:{cmd:Geography1}}primary geography code{p_end}
{synopt:{cmd:Geography2}}secondary geography code{p_end}
{synopt:{cmd:StartDate}}data start date{p_end}
{synopt:{cmd:EndDate}}data end date{p_end}
{synopt:{cmd:Source}}Haver code associated with the source for the
  data{p_end}
{synopt:{cmd:SourceDescription}}description of Haver code associated
  with the source for the data{p_end}
{p2colreset}{...}

{pstd}
When a variable is loaded, this meta-information is stored in variable
characteristics (see {helpb char:[P] char}).  Those
characteristics can be viewed using {cmd:char list}:

	{cmd:. char list fxtwb_haverd[]}
          fxtwb_haverd[HaverDB]:      HAVERD
          fxtwb_haverd[Series]:       FXTWB
          fxtwb_haverd[DateTimeMod]:  26feb2012 14:56:36
          fxtwb_haverd[Frequency]:    Daily
          fxtwb_haverd[Magnitude]:    0
          fxtwb_haverd[DecPrecision]: 4
          fxtwb_haverd[DifType]:      0
          fxtwb_haverd[AggType]:      AVG
          fxtwb_haverd[DataType]:     INDEX
          fxtwb_haverd[Group]:        D01
          fxtwb_haverd[Geography1]:   0000000
          fxtwb_haverd[StartDate]:    03jan2005
          fxtwb_haverd[EndDate]:      17feb2012
          fxtwb_haverd[Source]:       FRB
          fxtwb_haverd[SourceDescription]:
	                              Federal Reserve Board

{pstd}
You can load multiple Haver databases/series with one command.  To load the
series FXTWB and FXTWOTP from the HAVERD database and all series that start
with V from the HAVERMQA database, you would type

	{cmd:. import haver (FXTWB FXTWOTP)@haverd V*@havermqa, clear}
	<output omitted>

{pstd}
{cmd:import haver} automatically {opt tsset}s the data for you.


{marker remarks6}{...}
{title:Loading a Haver database from a describe file}

{pstd}
You often need to search through the series information of a Haver database(s)
to see which series you would like to load.  You can do this by saving the
output of {cmd:import haver, describe} to a Stata dataset with
the {opt saving(filename)} option.  The dataset created can be used by
{cmd:import haver, frommemory} to load data from the described
Haver database(s).  For example, here we search through the series information
of database HAVERMQA.

	{cmd:. import haver havermqa, describe saving(my_desc_file)}
	<output omitted>

	{cmd:. use my_desc_file, clear}

	{cmd:. describe}

Contains data from my_desc_file.dta
  obs:           161
 vars:             8                          10 Dec 2012 11:41
 size:        19,642
-------------------------------------------------------------------------------
              storage  display     value
variable name   type   format      label      variable label
-------------------------------------------------------------------------------
path            str1   %9s                    Path to Haver file
file            str8   %9s                    Haver filename
series          str7   %9s                    Series name
description     str80  %80s                   Series description
startdate       str7   %9s                    Start date
enddate         str7   %9s                    End date
frequency       str9   %9s                    Frequency
source          str3   %9s                    Source
-------------------------------------------------------------------------------

{pstd}
The resulting dataset contains information on the 164 series in HAVERMQA.
Suppose that we want to retrieve all monthly series whose description
includes the word "Yield".  We need to keep only the observations from our
dataset where the frequency variable equals "Monthly" and where
the description variable contains "Yield".

	{cmd:. keep if frequency=="Monthly" & strpos(description,"Yield")}
	(152 observations deleted)

{pstd}
To load the selected series into Stata, we type

	{cmd:. import haver, frommemory clear}

{pstd}
Note: We must {cmd:clear} the described data in memory to load the selected
series.  If you do not want to lose the changes you made to the description
dataset, you must save it before using {cmd:import haver, frommemory}.


{marker remarks7}{...}
{title:Temporal aggregation}

{pstd}
If you request series with different frequencies, the higher frequency data
will be aggregated to the lowest frequency.  For example, if you request a
monthly and a quarterly series, the monthly series will be aggregated.  In
rare cases, a series cannot be aggregated to a lower frequency and so will
not be retrieved.  A list of these series will be stored in
{cmd:r(noaggtype)}.

{pstd}
The options {opt fin()} and {opt fwithin()} are useful for aggregating series
by hand.


{marker remarks8}{...}
{title:Daily data}

{pstd}
Haver's daily frequency corresponds to Stata's daily frequency.
Haver's daily data series are business series for which business calendars are
useful.  See
{helpb datetime business calendars:[D] Datetime business calendars} for more
information on business calendars.


{marker remarks9}{...}
{title:Weekly data}

{pstd}
Haver's weekly data are also retrieved to Stata's daily frequency.  See
{helpb datetime business calendars:[D] Datetime business calendars} for more
information on business calendars.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:import haver} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(k_requested)}}number of series requested{p_end}
{synopt:{cmd:r(k_noaggtype)}}number of series dropped because of
invalid aggregation type {p_end}
{synopt:{cmd:r(k_nodisagg)}}number of series dropped because their
frequency is lower than that of the output dataset{p_end}
{synopt:{cmd:r(k_notindata)}}number of series dropped because data
were out of the date range specified in {opt fwithin()} or {opt fin()}{p_end}
{synopt:{cmd:r(k_notfound)}}number of series not found in the
database{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(noaggtype)}}list of series dropped because of invalid
aggregation type{p_end}
{synopt:{cmd:r(nodisagg)}}list of series dropped because their
frequency is lower than that of the output dataset{p_end}
{synopt:{cmd:r(notindata)}}list of series dropped because data
were out of the date range specified in {opt fwithin()} or {opt fin()}{p_end}
{synopt:{cmd:r(notfound)}}list of series not found in the database{p_end}

{pstd}
{cmd:import haver}{cmd:, describe} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(k_described)}}number of series described{p_end}
{synopt:{cmd:r(k_notfound)}}number of series not found in the database{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(notfound)}}list of series not found in the database{p_end}
