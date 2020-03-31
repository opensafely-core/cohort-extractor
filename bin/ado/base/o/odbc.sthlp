{smcl}
{* *! version 1.4.6  07mar2018}{...}
{viewerdialog "odbc load" "dialog odbc_load"}{...}
{viewerdialog "odbc insert" "dialog odbc_insert"}{...}
{vieweralsosee "[D] odbc" "mansection D odbc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "odbc##syntax"}{...}
{viewerjumpto "Menu" "odbc##menu"}{...}
{viewerjumpto "Description" "odbc##description"}{...}
{viewerjumpto "Links to PDF documentation" "odbc##linkspdf"}{...}
{viewerjumpto "Options" "odbc##options"}{...}
{viewerjumpto "Examples" "odbc##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] odbc} {hline 2}}Load, write, or view data from ODBC sources{p_end}
{p2col:}({mansection D odbc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}List ODBC sources to which Stata can connect

{p 8 13 2}
{cmd:odbc} {opt li:st}


{phang}Retrieve available names from specified data source

{p 8 13 2}
{cmd:odbc} {opt q:uery}
[{cmd:"}{it:DataSourceName}{cmd:"}
{cmd:,}
{opt verb:ose} {opt sche:ma} {it:{help odbc##connect_options:connect_options}}]


{phang}List column names and types associated with specified table

{p 8 13 2}
{cmd:odbc} {opt des:cribe}
[{cmd:"}{it:TableName}{cmd:"}
{cmd:,}
{it:{help odbc##connect_options:connect_options}}]


{phang}Import data from an ODBC data source

{p 8 13 2}
{cmd:odbc} {opt lo:ad}
[{it:extvarlist}]
{ifin}
{cmd:,}
{c -(}{cmdab:t:able:(}{cmd:"}{it:TableName}{cmd:"}{cmd:)}{c |}{cmdab:e:xec:(}{cmd:"}{it:SqlStmt}{cmd:"}{cmd:)}{c )-} {break}
[{it:{help odbc##load_options:load_options} {help odbc##connect_options:connect_options}}]


{phang}Export data to an ODBC data source

{p 8 13 2}
{cmd:odbc} {opt in:sert}
[{varlist}] {ifin} {cmd:,}
{cmdab:t:able:(}{cmd:"}{it:TableName}{cmd:"}{cmd:)}{break}
{c -(}{cmd:dsn(}{cmd:"}{it:DataSourceName}{cmd:"}{cmd:)}{c |}{cmdab:conn:ectionstring:(}{cmd:"}{it:ConnectStr}{cmd:"}{cmd:)}{c )-} {break}
[{it:{help odbc##insert_options:insert_options}} {it:{help odbc##connect_options:connect_options}}]


{phang}Allow SQL statements to be issued directly to ODBC data source

{p 8 13 2}
{cmd:odbc} {cmdab:exe:c(}{cmd:"}{it:SqlStmt}{cmd:"}{cmd:) ,}
{c -(}{cmd:dsn(}{cmd:"}{it:DataSourceName}{cmd:"}{cmd:)}{c |}{cmdab:conn:ectionstring:(}{cmd:"}{it:ConnectStr}{cmd:"}{cmd:)}{c )-} {break}
[{it:{help odbc##connect_options:connect_options}}]


{phang}Batch job alternative to odbc exec

{p 8 13 2}
{cmd:odbc} {cmdab:sql:file:(}{cmd:"}{it:{help filename}}{cmd:"}{cmd:) ,}
{c -(}{cmd:dsn(}{cmd:"}{it:DataSourceName}{cmd:"}{cmd:)}{c |}{cmdab:conn:ectionstring:(}{cmd:"}{it:ConnectStr}{cmd:"}{cmd:)}{c )-} {break}
[{opt loud} {it:{help odbc##connect_options:connect_options}}]


{phang}Specify ODBC driver type

{p 8 17 2}
{cmd:set}
{cmd:odbcdriver}
{c -(}{opt unicode}{c |}{opt ansi}{c )-} 
[{cmd:,} {opt perm:anently}]


{phang}Specify ODBC driver manager (Mac and Unix only)

{p 8 17 2}
{cmd:set}
{cmd:odbcmgr}
{c -(}{opt iodbc}{c |}{opt unixodbc}{c )-} 
[{cmd:,} {opt perm:anently}]


{phang}{it:DataSourceName} is the name of the ODBC source (database,
spreadsheet, etc.)

{phang}{it:ConnectStr} is a valid ODBC connection string

{phang}{it:TableName} is the name of a table within the ODBC data source

{phang}{it:SqlStmt} is an SQL SELECT statement

{phang}{it:filename} is pure SQL commands separated by semicolons

{phang}{it:extvarlist} contains

{phang3}{it:sqlvarname}{p_end}
{phang3}{varname}={it:sqlvarname}

{synoptset 35}{...}
{marker connect_options}{...}
{synopthdr :connect_options}
{synoptline}
{synopt :{opt u:ser(UserID)}}user ID of user establishing connection{p_end}
{synopt :{opt p:assword(Password)}}password of user establishing
connection{p_end}
{synopt :{cmdab:d:ialog(noprompt)}}do not display ODBC connection-information
dialog, and do not prompt user for connection information{p_end}
{synopt :{cmdab:d:ialog(prompt)}}display ODBC connection-information dialog
{p_end}
{synopt :{cmdab:d:ialog(complete)}}display ODBC connection-information dialog
only if there is not enough information{p_end}
{synopt :{cmdab:d:ialog(required)}}display ODBC connection-information dialog
only if there is not enough mandatory information provided{p_end}
{p2coldent:*{cmd:dsn("}{it:DataSourceName}{cmd:")}}name of data source{p_end}
{p2coldent:*{cmdab:conn:ectionstring("}{it:ConnectStr}{cmd:")}}ODBC
connection string{p_end}
{synoptline}
{p 4 6 2}* {cmd:dsn("}{it:DataSourceName}{cmd:")} is not allowed with
{cmd:odbc query}.  You may not specify both {it:DataSourceName} and
{cmd:connectionstring()} with {cmd:odbc query}.  Either {cmd:dsn()} or
{cmd:connectionstring()} is required with {cmd:odbc insert}, {cmd:odbc exec},
and {cmd:odbc sqlfile}.  

{synoptset 25 tabbed}{...}
{marker load_options}{...}
{synopthdr :load_options}
{synoptline}
{p2coldent :* {cmdab:t:able("}{it:TableName}{cmd:")}}name of table
stored in data source{p_end}
{p2coldent :* {cmdab:e:xec("}{it:SqlStmt}{cmd:")}}SQL SELECT
statement to generate a table to be read into Stata{p_end}
{synopt :{opt clear}}load dataset even if there is one in memory{p_end}
{synopt :{opt noq:uote}}alter Stata's internal use of SQL commands;
seldom used{p_end}
{synopt :{opt low:ercase}}read variable names as lowercase{p_end}
{synopt :{opt sql:show}}show all SQL commands issued{p_end}
{synopt :{opt allstr:ing}}read all variables as strings{p_end}
{synopt :{opt datestr:ing}}read date-formatted variables as strings{p_end}
{synopt :{opt multis:tatement}}allow multiple SQL statements delimited by
{cmd:;} when using {opt exec()}{p_end}
{synopt :{opt bigint:asdouble}}store BIGINT columns as Stata doubles on 64-bit operating systems{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* Either {cmd:table("}{it:TableName}{cmd:")} or
{cmd:exec("}{it:SqlStmt}{cmd:")} must be specified with {cmd:odbc}
{cmd:load}.{p_end}

{synoptset 25 tabbed}{...}
{marker insert_options}{...}
{synopthdr :insert_options}
{synoptline}
{p2coldent :* {cmdab:t:able("}{it:TableName}{cmd:")}}name of table
stored in data source{p_end}
{synopt :{opt over:write}}clear data in ODBC table before data in memory is
written to the table{p_end}
{synopt :{opt ins:ert}}default mode of operation for the {opt odbc insert}
command{p_end}
{synopt :{opt q:uoted}}quote all values with single quotes as they are inserted
in ODBC table{p_end}
{synopt :{opt sql:show}}show all SQL commands issued{p_end}
{synopt :{cmd:as("}{varlist}{cmd:")}}ODBC variables on the data source that correspond
to the variables in Stata's memory{p_end}
{synopt :{opt block}}use block inserts{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:table("}{it:TableName}{cmd:")} is required with {cmd:odbc}
{cmd:insert}.{p_end}


{marker menu}{...}
{title:Menu}

    {title:odbc load}

{phang2}
{bf:File > Import > ODBC data source}

    {title:odbc insert}

{phang2}
{bf:File > Export > ODBC data source}


{marker description}{...}
{title:Description}

{pstd}
{opt odbc} allows you to load, write, and view data from Open DataBase
Connectivity (ODBC) sources into Stata.  ODBC is a standardized set of function
calls for accessing data stored in both relational and nonrelational
database-management systems.  By default on Unix platforms, iODBC is the ODBC
driver manager Stata uses, but you can use unixODBC by using the command
{cmd:set odbcmgr unixodbc}.

{pstd}
ODBC's architecture
consists of four major components (or layers): the client interface, the
ODBC driver manager, the ODBC drivers, and the data sources.  Stata provides
{opt odbc} as the client interface.  The system is illustrated as following:

    {c TLC}{hline 19}{c TRC}{dup 37: }{c TLC}{hline 10}{c TRC}
    {c |}{dup 19: }{c |}{dup 5: }{c TLC}{hline 9}{c TRC}{dup 5: }{...}
{c TLC}{hline 9}{c TRC}{dup 5: }{c |}{dup 10: }{c |}
    {c |} {ul:Client interface}  {c |}{dup 5: }{c |}{dup 9: }{c |}{...}
{dup 5: }{c |}{dup 9: }{c |}{dup 5: }{c |}{dup 10: }{c |}
    {c |}       (Stata)     {c |}{dup 5: }{c |}{dup 9: }{c |}{...}
{dup 5: }{c |}{dup 9: }{c |}{dup 5: }{c |}{dup 10: }{c |}
    {c |}{dup 19: }{c |}{dup 5: }{c |} ODBC    {c |}{dup 5: }{...}
{c |} ODBC    {c |}{dup 5: }{c |}  ODBC    {c |}
    {c |} {cmd:odbc} {cmd:list}         {c |} {hline 3} {c |} driver  {c |} {...}
{hline 3} {c |} driver  {c |} {hline 3} {c |}  data    {c |}
    {c |} {cmd:odbc} {cmd:query}        {c |}{dup 5: }{c |} manager {c |}{dup 5: }{...}
{c |}{dup 9: }{c |}{dup 5: }{c |}  Source  {c |}
    {c |} {cmd:odbc} {cmd:describe}     {c |}{dup 5: }{c |}{dup 9: }{c |}{dup 5: }{...}
{c |}{dup 9: }{c |}{dup 5: }{c |}{dup 10: }{c |}
    {c |} {cmd:odbc} {cmd:load}         {c |}{dup 5: }{c BLC}{hline 9}{c BRC}{...}
{dup 5: }{c BLC}{hline 9}{c BRC}{dup 5: }{c |}{dup 10: }{c |}
    {c |} {cmd:odbc} {cmd:insert}       {c |}{dup 37: }{c |}{dup 10: }{c |}
    {c |} {cmd:odbc} {cmd:exec}         {c |}{dup 37: }{c |}{dup 10: }{c |}
    {c |} {cmd:odbc} {cmd:sqlfile}      {c |}{dup 37: }{c |}{dup 10: }{c |}
    {c BLC}{hline 19}{c BRC}{dup 37: }{c BLC}{hline 10}{c BRC}

{pstd}
{opt odbc list} produces a list of ODBC data source names to which Stata can
connect.

{pstd}
{opt odbc query} retrieves a list of table names available from a specified
data source's system catalog.

{pstd}
{opt odbc describe} lists column names and types associated with a specified
table.

{pstd}
{opt odbc load} reads an ODBC table into memory.  You can load
an ODBC table specified in the {opt table()} option or load an ODBC
table generated by an SQL SELECT statement specified in the {opt exec()}
option.  In both cases, you can choose which columns and rows of the
ODBC table to read by specifying {it:extvarlist} and {opt if} and {opt in}
conditions.  {it:extvarlist} specifies the
columns to be read and allows you to rename variables.  For
example,

{p 8 16 2}
{cmd:. odbc load id=ID name="Last Name", table(Employees) dsn(Northwind)}

{pstd}
reads two columns, {cmd:ID} and {cmd:Last Name}, from the
{cmd:Employees} table of the {cmd:Northwind} data source.  It will also rename
variable {cmd:ID} to {cmd:id} and variable {cmd:Last Name} to {cmd:name}.

{pstd}
{opt odbc insert} writes data from memory to an ODBC table.  The data can
be appended to an existing table or replace an existing table.

{pstd}
{opt odbc exec} allows for most SQL statements to be issued directly to any
ODBC data source.  Statements that produce output, such as SELECT, have their
output neatly displayed.  By using Stata's ado language, you can also generate
SQL commands on the fly to do positional updates or whatever the situation
requires.

{pstd}
{opt odbc sqlfile} provides a "batch job" alternative to the 
{opt odbc exec} command.  A file is specified that contains any number of any
length SQL commands.  Every SQL command in this file should be delimited by a 
semicolon and must be constructed as pure SQL.  Stata macros and ado-language 
syntax are not permitted.  The advantage in using this command, as opposed to
{opt odbc exec}, is that only one connection is established for multiple SQL
statements.  A similar sequence of SQL commands used via {opt odbc exec} would
require constructing an ado-file that issued a command and, thus, a connection
for every SQL command.  Another slight difference is that any output that might
be generated from an SQL command is suppressed by default.  A {opt loud} option
is provided to toggle output back on.

{pstd}
{opt set odbcdriver unicode} specifies that the ODBC driver is a Unicode
driver (the default).  {opt set odbcdriver ansi} specifies that the ODBC
driver is an ANSI driver.  You must restart Stata for the setting to take
effect.

{pstd}
{opt set odbcmgr iodbc} specifies that the ODBC driver manager is iODBC
(the default).  {opt set odbcmgr unixodbc} specifies that the ODBC driver
manager is unixODBC.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D odbcQuickstart:Quick start}

        {mansection D odbcRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt user(UserID)}
specifies that the user ID of the user attempting to establish the
connection to the data source.  By default, Stata assumes the user ID is the
same as the one specified in the previous {opt odbc} command
or is empty if {opt user()} has never been specified in the current
session of Stata.

{phang}
{opt password(Password)}
specifies the password of the user attempting to establish the
connection to the data source.  By default, Stata assumes the password is the
same as the one previously specified or is empty if the password has not been
used during the current session of Stata.
Typically, the {opt password()} option
will not be specified apart from the {opt user()} option.

{phang}
{cmd:dialog(noprompt}|{opt prompt}|{opt complete}|{cmd:required)}
specifies the mode the ODBC Driver Manager uses to display
the ODBC connection-information dialog to prompt for more 
connection information.

{pmore}
{opt noprompt} is the default value.  The ODBC connection-information
dialog is not displayed, and you are not prompted for connection
information.  If there is not enough information to establish a connection to
the specified data source, an error is returned.

{pmore}
{opt prompt} causes the ODBC connection-information dialog to be displayed.

{pmore}
{opt complete} causes the ODBC connection-information dialog to be displayed
only if there is not enough information, even if the information
is not mandatory.

{pmore}
{opt required} causes the ODBC connection-information dialog to be displayed
only if there is not enough mandatory information provided to establish a
connection to the specified data source.  You are prompted only for
mandatory information; controls for information that is not required to
connect to the specified data source are disabled.

{phang}
{cmd:dsn("}{it:DataSourceName}{cmd:")}
specifies the name of a data source, as listed by the
{opt odbc list} command.  If a name contains  spaces, it must be enclosed in
double quotes.  By default, Stata assumes that the data source name is the same
as the one specified in the previous {opt odbc} command.
This option is not allowed with {cmd:odbc query}.
Either the {cmd:dsn()} option or the {cmd:connectionstring()} option may be
specified with {cmd:odbc describe} and {cmd:odbc load}, and one of these
options must be specified with {cmd:odbc insert}, {cmd:odbc exec}, and
{cmd:odbc sqlfile}.

{phang}
{cmd:connectionstring("}{it:ConnectStr}{cmd:")}
specifies a connection string rather than the name of a data source.
Stata does not assume that the connection string is the same as the one
specified in the previous {opt odbc} command.
Either {it:DataSourceName} or the {cmd:connectionstring()} option may be
specified with {cmd:odbc query}; either the {cmd:dsn()} option or the
{cmd:connectionstring()} option can be specified with {cmd:odbc describe} and
{cmd:odbc load}, and one of these options must be specified with
{cmd:odbc insert}, {cmd:odbc exec}, and {cmd:odbc sqlfile}.

{phang}
{cmd:table("}{it:TableName}{cmd:")}
specifies the name of an ODBC table stored in a specified data
source's system catalog, as listed by the {opt odbc query} command.  If a
table name contains spaces, it must be enclosed in double quotes.  Either the
{opt table()} option or the {opt exec()} option -- but not 
both -- is required with the {opt odbc load} command.

{phang}
{cmd:exec("}{it:SqlStmt}{cmd:")}
allows you to issue an SQL SELECT statement to generate a
table to be read into Stata.  An error message is returned if the SELECT
statement is an invalid SQL statement.  The statement must be enclosed in
double quotes.  Either the {opt table()} option or the {opt exec()} 
option -- but not both -- is required with the {opt odbc load}
command.

{phang}
{opt clear} permits the data to be loaded, even if there is a dataset already
in memory, and even if that dataset has changed since the data were last saved.

{phang}
{opt noquote} alters Stata's internal use of SQL
commands, specifically those relating to quoted table names, to better
accommodate various drivers.  This option has been particularly helpful for
DB2 drivers.

{phang}
{opt lowercase} causes all the variable names to be read as lowercase.

{phang}
{opt sqlshow} is a useful option for showing all SQL commands issued to the
ODBC data source from the {opt odbc insert} or {opt odbc load} command.  This 
can help you debug any issues related to inserting or loading.

{phang}
{opt allstring} causes all variables to be read as string data types.

{phang}
{opt datestring} causes all date- and time-formatted variables to be read
as string data types.

{phang}
{opt multistatement} specifies that multiple SQL statements delimited by
{cmd:;} be allowed when using the {cmd:exec()} option.  Some drivers do not
support multiple SQL statements.

{phang}
{opt bigintasdouble} specifies that data stored in 64-bit integer (BIGINT)
database columns be converted to Stata doubles.  If any integer value is
larger than 9,007,199,254,740,965 or less than -9,007,199,254,740,992,
this conversion is not possible, and {cmd:odbc load} will issue an error
message.

{phang}
{opt overwrite} allows data to be cleared from an ODBC table before the data in
memory are written to the table.  All data from the ODBC table are erased, not
just the data from the variable columns that will be replaced.

{phang}
{opt insert} appends data to an existing ODBC table and is
the default mode of operation for the {opt odbc insert} command.

{phang}
{opt quoted} is useful for ODBC data sources that require all inserted values
to be quoted.  This option specifies that all values be quoted with single
quotes as they are inserted into an ODBC table.

{phang}
{cmd:as(}{cmd:"}{varlist}{cmd:")} allows you to specify the ODBC variables on
the data source that correspond to the variables in Stata's memory.  If this
option is specified, the number of variables must equal the number of variables
being inserted, even if some names are identical.

{phang}
{opt loud} specifies that output be displayed for SQL commands.

{phang}
{opt verbose} specifies that {cmd:odbc query} list any data source alias,
nickname, typed table, typed view, and view along with tables so that you can
load data from these table types.

{phang}
{opt schema} specifies that {cmd:odbc query} return schema names with the table
names from a data source.  NOTE: The schema names returned from
{cmd:odbc query} will also be used with the {cmd:odbc describe} and 
{cmd:odbc load} commands.  When using {cmd:odbc load} with a schema name, you 
might also need to specify the {opt noquote} option because some drivers
do not accept quotes around table or schema names.

{phang}
{opt block} specifies that {cmd:odbc insert} use block inserts to speed up
data-writing performance.  Some drivers do not support block inserts.

{phang}
{opt permanently} ({cmd:set odbcdriver} and {cmd:set odbcmgr} only) specifies
that, in addition to making the change right now, the setting be remembered
and become the default setting when you invoke Stata.


{marker examples}{...}
{title:Examples}

{pstd}
Some of the following examples are default samples that are available when
installing Microsoft Office.  Depending on the version of Microsoft Office,
your results may vary.

    {cmd}. odbc list

    {txt}Data Source Name                Driver
    {hline}
    dBase Files - Word              Microsoft Access dBASE Driver (*.dbf, *.ndx
    Excel Files                     Microsoft Excel Driver (*.xls, *.xlsx, *.xl
    MS Access Database              Microsoft Access Driver (*.mdb, *.accdb)
    Northwind                       Microsoft Access Driver (*.mdb, *.accdb)
    {hline}

    {cmd}. odbc query "Northwind"

    {txt}DataSource: {result:Northwind}
    Path      : C:\Program Files\Microsoft Office\Office\Samples\Northwind.accdb
    {hline}
    Customers
    Employee Privileges
    Employees
    Inventory Transaction Types
    Inventory Transactions
    Invoices
    Order Details
    Order Details Status
    Orders
    Orders Status
    Orders Tax Status
    Privileges
    Products
    Purchase Order Details
    Purchase Order Status
    Purchase Orders
    Sales Reports
    Shippers
    Strings
    Suppliers
    {hline}

    {cmd}. odbc describe "Employees", dsn("Northwind")

    {txt}DataSource: {result:Northwind} (query)
    Table:      {result:Employees} (load)
    {hline}
    Variable Name                               Variable Type
    {hline}
    {result:ID}                                 COUNTER
    {result:Company}                            VARCHAR
    {result:Last Name}                          VARCHAR
    {result:First Name}                         VARCHAR
    {result:E-mail Address}                     VARCHAR
    {result:Job Title}                          VARCHAR
    {result:Business Phone}                     VARCHAR
    {result:Home Phone}                         VARCHAR
    {result:Mobile Phone}                       VARCHAR
    {result:Fax Number}                         VARCHAR
    {result:Address}                            LONGCHAR
    {result:City}                               VARCHAR
    {result:State/Province}                     VARCHAR
    {result:ZIP/Postal Code}                    VARCHAR
    {result:Country/Region}                     VARCHAR
    {result:Web Page}                           LONGCHAR
    {result:Notes}                              LONGCHAR
    {result:Attachments}                        LONGCHAR
    {hline}

{p 4 12 2}
    {cmd}. odbc load id=ID name="Last Name" "Job Title" in 1/5, table("Employees") dsn("Northwind")

    {cmd}. list
{txt}
	 {c TLC}{hline 7}{c -}{hline 11}{c -}{hline 23}{c TRC}
	 {c |} {res}   id        name               Job Title {txt}{c |}
	 {c LT}{hline 7}{c -}{hline 11}{c -}{hline 23}{c RT}
      1. {c |} {res}    1   Freehafer    Sales Representative {txt}{c |}
      2. {c |} {res}    2     Cencini   Vice President, Sales {txt}{c |}
      3. {c |} {res}    3       Kotas    Sales Representative {txt}{c |}
      4. {c |} {res}    4   Sergienko    Sales Representative {txt}{c |}
      5. {c |} {res}    5      Thorpe           Sales Manager {txt}{c |}
	 {c BLC}{hline 7}{c -}{hline 11}{c -}{hline 23}{c BRC}

{p 4 12 2}
    {cmd}. odbc load, exec(`"SELECT ID, "Last Name", "Job Title" FROM Employees  WHERE ID <= 5"') dsn("Northwind") clear

    {cmd}. list
{txt}
	 {c TLC}{hline 7}{c -}{hline 11}{c -}{hline 23}{c TRC}
	 {c |} {res}   ID   Last_Name               Job_Title {txt}{c |}
	 {c LT}{hline 7}{c -}{hline 11}{c -}{hline 23}{c RT}
      1. {c |} {res}    1   Freehafer    Sales Representative {txt}{c |}
      2. {c |} {res}    2     Cencini   Vice President, Sales {txt}{c |}
      3. {c |} {res}    3       Kotas    Sales Representative {txt}{c |}
      4. {c |} {res}    4   Sergienko    Sales Representative {txt}{c |}
      5. {c |} {res}    5      Thorpe           Sales Manager {txt}{c |}
	 {c BLC}{hline 7}{c -}{hline 11}{c -}{hline 23}{c BRC}
{txt}{...}
