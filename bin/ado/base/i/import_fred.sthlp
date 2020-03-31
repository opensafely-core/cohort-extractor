{smcl}
{* *! version 1.0.6  01mar2018}{...}
{viewerdialog "import fred" "dialog import_fred_dlg"}{...}
{vieweralsosee "[D] import fred" "mansection D importfred"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[D] import delimited" "help import delimited"}{...}
{vieweralsosee "[D] import haver" "help import haver"}{...}
{vieweralsosee "[D] odbc" "help odbc"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "import_fred##syntax"}{...}
{viewerjumpto "Menu" "import_fred##menu"}{...}
{viewerjumpto "Description" "import_fred##description"}{...}
{viewerjumpto "Links to PDF documentation" "import_fred##linkspdf"}{...}
{viewerjumpto "Options" "import_fred##options"}{...}
{viewerjumpto "Examples" "import_fred##examples"}{...}
{viewerjumpto "Stored results" "import_fred##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[D] import fred} {hline 2}}Import data from Federal Reserve Economic Data{p_end}
{p2col:}({mansection D importfred:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Set FRED key

{p 8 32 2}
{cmd:set} {cmd:fredkey}
{it:key}
   [{cmd:,} {opt perm:anently}]


{phang}
Import FRED data

{p 8 32 2}
{cmd:import} {cmd:fred}
{it:series_list}
[{cmd:,} {it:options}]

{phang}
or 

{p 8 32 2}
{cmd:import} {cmd:fred}{cmd:,}
{opth series:list(filename)}
[{it:options}]


{phang}
Describe series

{p 8 32 2}
{cmd:freddescribe}
{it:series_list}
[{cmd:,} {opt det:ail} {opt real:time(start end)}]


{phang}
Search series

{p 8 32 2}
{cmd:fredsearch}
{it:keyword_list}
[{cmd:,}  {help import fred##searchopts:{it:search_options}}]


{phang}
{it:key} is a valid API key, which is provided by the St. Louis Federal
Reserve and may be obtained from
{browse "https://research.stlouisfed.org/docs/api/api_key.html"}.

{phang}
{it:series_list} is a list of FRED codes, for example, {cmd:FEDFUNDS}.

{phang}
{it:keyword_list} is a list of keywords.

{synoptset 33 tabbed}{...}
{marker options_table}{...}
{synopthdr :options}
{synoptline}
{p2coldent:* {opth series:list(filename)}}specify series IDs using a file{p_end}
{synopt :{opt dater:ange(start end)}}restrict to only observations within
specified date range{p_end}
{synopt :{cmdab:aggr:egate(}{help import_fred##freq:{it:frequency}} [{cmd:,} {help import_fred##method:{it:method}}]{cmd:)}}specify the aggregation level and
aggregation type{p_end}
{synopt :{opt real:time(start end)}}import historical vintages between
specified dates{p_end}
{synopt :{opt vint:age(datespec)}}import historical data by vintage
dates{p_end}
{synopt :{opt nrobs}}import only new and revised observations{p_end}
{synopt :{opt initial}}import only first value for each observation in a
series{p_end}
{synopt :{opt long}}import data in long format{p_end}
{synopt :{opt nosumm:ary}}suppress summary table{p_end}

{synopt :{opt clear}}clear data in memory before importing FRED series{p_end}
{synoptline}
{p 4 6 2}* {opt serieslist()} is required if {it:series_list} is not
specified.{p_end}
{p 4 6 2}{opt clear} does not appear in the dialog box.{p_end}
{p2colreset}{...}

{phang}
If {it:start} and {it:end} are  provided as dates, they must be daily dates
using notation of the form {cmd:31Jan2016}, {cmd:2016-01-31},
{cmd:2016/01/31}, or {cmd:01/31/2016}.

{marker datespec}{...}
{phang}
{it:datespec} may be

            {it:date}                        a daily date
            {it:date_1} {it:date_2} ... {it:date_n}    a list of daily dates
	    {cmd:_all}                        all available dates

{synoptset 33}{...}
{marker searchopts}{...}
{synopthdr :search_options}
{synoptline}
{synopt :{opt id:only}}require {it:keywords} to appear in series IDs
only{p_end}
{synopt :{opt tags(tag_list)}}search by {it:tag_list}{p_end}
{synopt :{opt tagl:ist}}list tags present in current search results{p_end}
{synopt :{cmd:sort(}{help import_fred##sortby:{it:sortby}}[{cmd:,} {help import_fred##sortorder:{it:sortorder}}])}list matched series in order
specified by {it:sortby}{p_end}
{synopt :{opt det:ail}}list full metainformation for each search result{p_end}

{synopt :{cmdab:sav:ing(}{it:{help filename}} [{cmd:, replace}]{cmd:)}}save series information to {it:filename}{cmd:.dta}{p_end}
{synoptline}
{p 4 6 2}{opt saving()} does not appear in the dialog box.{p_end}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Import > Federal Reserve Economic Data (FRED)}

{pstd}
For information and examples on using the FRED interface, see
{mansection D importfredRemarksandexamplesTheFREDinterface:{it:The FRED interface}} in {bf:[D] import fred}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:import fred} imports data from the Federal Reserve Economic Data (FRED)
into Stata.  {cmd:import fred} supports data on FRED as well as historical
vintage data on Archival FRED (ALFRED).  {cmd:freddescribe} and
{cmd:fredsearch} provide tools to describe series in the database and to
search FRED for data based on keywords and tags.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importfredQuickstart:Quick start}

        {mansection D importfredRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Options are presented under the following headings:

        {help import fred##option_setfredkey:Option for set fredkey}
	{help import fred##option_importfred:Options for import fred}
	{help import fred##option_freddescribe:Options for freddescribe}
	{help import fred##option_fredsearch:Options for fredsearch}


{marker option_setfredkey}{...}
    {title:Option for set fredkey}

{phang}
{cmd:permanently} 
specifies that, in addition to setting the key for the current Stata session,
the key be remembered and become the default key when you invoke Stata.


{marker option_importfred}{...}
    {title:Options for import fred}

{phang}
{opth serieslist(filename)} allows you to import 
	the series specified in {it:filename}.  The series file must
	contain a variable called {cmd:seriesid} that contains the
	IDs of the series you wish to import.  {opt serieslist()}
	is required if {it:series_list} is not specified.

{phang}
{opt daterange(start end)} specifies that only
	observations between the {it:start} date and {it:end} date should be
	imported.  {it:start} and {it:end} must be specified as either a daily
	date or a missing value ({cmd:.}).  Use
	{bind:{cmd:daterange(.} {it:end}{cmd:)}} to import all observations
	from the first available through {it:end}.  Use
	{bind:{cmd:daterange(}{it:start} {cmd:.)}} to import from
	{it:start} through the most recently available date.

{phang}
{cmd:aggregate(}{it:frequency}[{cmd:,} {it:method}{cmd:)} specifies
	that the data should be imported at a lower frequency than the series'
	native frequency along with an optional method of aggregation.

{marker freq}{...}
{phang2}
	{it:frequency} may be {cmdab:d:aily},
	{cmdab:w:eekly}, {cmdab:biw:eekly},
	{cmdab:m:onthly}, {cmdab:q:uarterly},
	{cmdab:semia:nnual}, {cmdab:a:nnual},
	{cmd:weekly ending friday},
	{cmd:weekly ending thursday},
	{cmd:weekly ending wednesday},
	{cmd:weekly ending tuesday},
	{cmd:weekly ending monday},
	{cmd:weekly ending sunday},
	{cmd:weekly ending saturday},
	{cmd:biweekly ending wednesday}, or
	{cmd:biweekly ending monday}.

{marker method}{...}
{phang2}
	{it:method} may be {cmd:avg} (the within-period average), {cmd:sum}
	(the within-period sum), or {cmd:eop} (the end-of-period value).
	The default is {cmd:avg}.

{phang}
{opt realtime(start end)} specifies a real-time period between which
    all vintages for each series are imported.  The vintage available on
    {it:start} is imported, as are all vintages released between {it:start}
    and {it:end}.  Either of {it:start} or {it:end} may be replaced by a
    missing value ({cmd:.}).  If {it:start} is a missing value, then all
    vintages from the first available up through {it:end} are imported.  If
    {it:end} is a missing value, then all vintages from {it:start} up
    through the most recent available are imported.  {cmd:realtime()} may not
    be combined with {cmd:vintage()}.

{phang}
{opth vintage:(import_fred##datespec:datespec)}
    imports historical vintage data according to {it:datespec}.  {it:datespec}
    may either be a list of daily dates or {cmd:_all}.  When {it:datespec} is
    a list of dates, the specified series are imported as they were available on
    the dates in {it:datespec}.  When {it:datespec} is {cmd:_all}, all
    vintages of the  specified series are imported.  {cmd:vintage()} may not be
    combined with {cmd:realtime()}.

{phang}
{cmd:nrobs} specifies that only observations that are new or revised in each
    vintage be imported.  Old and unrevised observations are imported as the
    missing value {cmd:.u}.

{phang}
{cmd:initial} specifies that only the first value for each observation
    of the series be imported.  This option may not be combined with
    {cmd:nrobs}.

{phang}
{cmd:long} specifies that each series be imported in long format.

{phang}
{cmd:nosummary} suppresses the summary table.

{pstd}
The following option is available with {cmd:import fred} but is not shown in
the dialog box:

{phang}
{cmd:clear} specifies that the data in memory should be replaced with the 
imported FRED data.


{marker option_freddescribe}{...}
    {title:Options for freddescribe}

{phang}
{cmd:detail} displays full metainformation available about {it:series_list}.

{phang}
{opt realtime(start end)} provides historical vintage information
    about {it:series_list} during the real-time period specified by {it:start}
    and {it:end}.  Either {it:start} or {it:end} may be replaced by a
    missing value ({cmd:.}).  If {it:start} is a missing value, then all
    vintages from the first available up through {it:end} are described.  If
    {it:end} is a missing value, then all vintages from {it:start} up
    through the most recent available are described.


{marker option_fredsearch}{...}
    {title:Options for fredsearch}

{phang}
{opt idonly} specifies that the keywords in
    {it:keyword_list} be found in series IDs rather than
    elsewhere in the metadata.

{phang}
{opt tags(tag_list)} searches for series that have all the tags
    specified in {it:tag_list}.  The complete list of available tags is
    provided by FRED.  Tags form a space-separated list.  Tags are
    case-sensitive and all FRED tags are in lowercase.

{phang}
{opt taglist} lists all the tags present in the current search results.

{phang}
{cmd:sort(}{it:sortby}[{cmd:,} {it:sortorder}]{cmd:)} lists the search results
    in the order specified by {it:sortby}.

{marker sortby}{...}
{pmore}
    When searching series, {it:sortby} may be
    {opt pop:ularity}, {opt id}, {opt title},
    {opt lastup:dated}, {opt freq:uency},
    {opt obss:tart}, {opt obse:nd},
    {opt units}, or {opt seas:onaladj}.  By default, {opt popularity}
    is used.

{pmore}
    When searching with the {opt taglist} option,
    {it:sortby} may be {opt name} or {opt series_count}.
    {opt name} means the tag name, and
    {opt series_count} is the count of series associated with the tag in the
    search results.  By default, {opt series_count} is used.

{marker sortorder}{...}
{pmore}
    You can optionally change the order of the search results from
    descending ({opt descend:ing}) to
    ascending ({opt ascend:ing}) order.
    The default order when searching by {cmd:popularity}, {cmd:lastupdated},
    or {cmd:series_count} is {cmd:descending}; otherwise, the default
    sort order is {cmd:ascending}.

{phang}
{opt detail} lists full metainformation for each series that appears in the
    search results.

{pstd}
The following option is available with {cmd:fredsearch} but is not shown in
the dialog box:

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:, replace)} saves the search results to
    a file.  The filename may then be specified in the {cmd:serieslist()}
    option of {cmd:import fred} to import the series located by the search.
    The optional {cmd:replace} specifies that {it:filename} be overwritten if
    it exists.


{marker examples}{...}
{title:Examples}

{pstd}
Whether you plan to use the FRED interface or the 
{cmd:import fred} command, you must first have a valid API key.  API
keys are provided by the St. Louis Federal Reserve and may be obtained from
{browse "https://research.stlouisfed.org/docs/api/api_key.html"}.
The key will be a 32-character alphanumeric string.  You will be prompted to
enter this key the first time you open the FRED interface.  Alternatively, you
can type

{phang2}
{cmd:. set fredkey} {it:key}{cmd:, permanently}
{p_end}

{pstd}
where {it:key} is your API key.  

{pstd}
Find monthly data on the exchange rate between the U.S. dollar and the
Japanese Yen{p_end}
{phang2}
{cmd:. fredsearch us dollar yen exchange rate monthly}

{pstd}
Import the series for the answer from the results produced above{p_end}
{phang2}
{cmd:. import fred EXJPUS}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:fredsearch} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(series_ids)}}list of series IDs contained in the search
results{p_end}
{p2colreset}{...}
