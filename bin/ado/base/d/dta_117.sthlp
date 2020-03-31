{smcl}
{* *! version 2.0.13  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{vieweralsosee "[D] use" "help use"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] sysuse" "help sysuse"}{...}
{vieweralsosee "[D] webuse" "help webuse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 1.2.2 Example datasets" "help dta_contents"}{...}
{viewerjumpto "Description" "dta_117##description"}{...}
{viewerjumpto "Remarks" "dta_117##remarks"}{...}
{title:Title}

{p2colset 5 30 32 2}{...}
{p2col :{hi:[P] File formats .dta} {hline 2}}Description of .dta file format 117{p_end}
{p2colreset}{...}


{pstd}
{bf:Warning:}
The entry below describes the contents of an old Stata {cmd:.dta} file format.
Newer version of Stata continue to read, and perhaps to write, this old
format.  What follows is the original help file for the {cmd:.dta} file format
when it was the current file format.


{marker description}{...}
{title:Description}

{pstd}
Described below is the format of Stata {cmd:.dta} datasets.
The description is highly technical and aimed at those needing to
write programs in C or other languages to read and
write them.

{pstd}
The format described here went into effect as of Stata 13. 
For documentation on earlier file formats, see {help dta_115}. 


{marker remarks}{...}
{title:Remarks}

{pstd}
The format of {cmd:.dta} files has changed over time.  Stata 13 writes
what are known as {cmd:.dta} format-117 files and can read all formats
of files that have ever been released.  The recent history of
{cmd:.dta} formats is

	Format        Current as of
	{hline 39}
	  117         Stata 13 
	  116         internal; never released
	  {help dta_115:115}         Stata 12
	  {help dta_114:114}         Stata 10
	  {help dta_113:113}         Stata  8
	{hline 39}

{marker f117}{...}
{pstd}
Format 117 is documented below.

{pstd}
Remarks are presented under the following headings:

	{help dta_117##intro:1.  Introduction}
	{help dta_117##versions:2.  Versions and flavors of Stata}
	{help dta_117##strings:3.  Representation of strings}
	{help dta_117##numbers:4.  Representation of numbers}
 	{help dta_117##definition:5.  Dataset format definition}
	    {help dta_117##header:5.1  Header}
                 {help dta_117##header_release:5.1.1  File format id}
                 {help dta_117##header_byteorder:5.1.2  Byteorder}
                 {help dta_117##header_K:5.1.3  K, # of variables}
                 {help dta_117##header_N:5.1.4  N, # of observations}
                 {help dta_117##header_label:5.1.5  Dataset label}
                 {help dta_117##header_timestamp:5.1.6  Datetime stamp}
	    {help dta_117##map:5.2  Map}
	    {help dta_117##variabletypes:5.3  Variable types}
	    {help dta_117##variablenames:5.4  Variable names}
	    {help dta_117##sortlist:5.5  Sort order of observations}
	    {help dta_117##formats:5.6  Display formats}
	    {help dta_117##labelnames:5.7  Value-label names}
	    {help dta_117##variablelabels:5.8  Variable labels}
	    {help dta_117##characteristics:5.9  Characteristics}
	    {help dta_117##data:5.10 Data}
            {help dta_117##strls:5.11 StrLs}
	         {help dta_117##strls_vo:5.11.1 (v,o) values}
	         {help dta_117##strls_gso:5.11.2 GSOs}
	         {help dta_117##strls_advw:5.11.3 Advice on writing strLs}
	         {help dta_117##strls_advr:5.11.4 Advice on reading strLs}
	    {help dta_117##value_labels:5.12 Value labels}


{marker intro}{...}
{title:1.  Introduction}

{pstd}
Stata-format datasets record data in a way generalized to work across computers
that do not agree on how data are recorded.  Thus the same dataset may be
used, without translation, on Windows, Unix, and
Mac computers.  Given a computer, datasets are
divided into two categories:  native-format and foreign-format datasets. Stata
uses the following two rules:

{p 8 13 2}
    R1.  On a given computer, Stata knows how to write native-format
	 datasets only.

{p 8 13 2}
    R2.  Even so, Stata can {it:read} all dataset formats, whether 
         foreign or native. 

{pstd}
Rules R1 and R2 ensure that Stata users need not be concerned with
dataset formats.  If you are writing a program to read and write Stata
datasets, you will have to determine whether you want to follow the same rules
or instead restrict your program to operate on only native-format datasets.
Because Stata follows rules R1 and R2, such a restriction would not be too
limiting.  If the user had a foreign-format dataset, he or she could enter
Stata, {helpb use} the data, and then {helpb save} it again.


{marker versions}{...}
{title:2.  Versions and flavors of Stata}

{pstd}
Stata is continually being updated, and these updates sometimes require changes
be made to how Stata records {cmd:.dta} datasets.  This document describes
what are known as {it:format-117} datasets, the most modern format.  Stata
itself can read older formats, but whenever it writes a dataset, it writes in
117 format.

{pstd}
There are currently three flavors of Stata available:
{help stataic:Stata/IC}, {help SpecialEdition:Stata/SE}, and
{help statamp:Stata/MP}.  The same 117 format is used by all flavors.
The difference is that datasets can be larger in some flavors.


{marker strings}{...}
{title:3.  Representation of strings}

{phang}
1.  Stata has two formats for strings, known to users as {cmd:str}{it:#} 
    and {cmd:strL}.  Most strings are recorded in {cmd:str}{it:#} format,
    but that is up to the user.
    The {cmd:strL} format allows for longer strings, and it allows for both 
    binary and ASCII strings.  {cmd:str}{it:#} strings can be ASCII only.

{p 8 8 2}
    By the way, StataCorp internal jargon is to refer to {cmd:str}{it:#} 
    strings as "strfs" (pronounced {it:sturfs}) and to {cmd:strLs}
    as "strLs" (pronounced {it:sturls}).  The {it:f} in strf stands 
    for fixed allocation length, which is how strfs are written in the 
    file.

{phang}
2.  We discuss {cmd:strL} format strings in section {help dta_117##strls:5.11}.

{phang}
3.  Strfs may be from 1 to 2,045 bytes long.

{phang}
4.  Strfs are recorded with a trailing binary zero ({cmd:\0}) delimiter if
    the length of the string is less than the maximum declared length.  The
    string is recorded without the delimiter if the string is of the maximum
    length.

{phang}
5.  Leading and trailing blanks are significant.

{phang}
6.  Strfs use ASCII encoding.


{marker numbers}{...}
{title:4.  Representation of numbers}

{phang}
1.  Numbers are represented as 1-, 2-, and 4-byte integers and 4- and 8-byte
    floats.  In the case of floats, ANSI/IEEE Standard 754-1985 format is 
    used, which in the case of the binary floating-point numbers considered
    here is equivalent to IEEE Standard 754-2008.

{phang}
2.  Byte ordering varies across machines for all numeric types.  Bytes are
    ordered either least significant to most significant, dubbed LSF, or
    most significant to least significant, dubbed MSF. Intel-based computers,
    for instance, mostly use LSF encoding.  Sun SPARC-based computers use MSF
    encoding.  Itanium-based computers are interesting in that they can be
    either LSF or MSF depending on the operating system.  Windows and Linux on
    Itanium use LSF encoding.  HP-UX on Itanium uses MSF encoding.

{phang}
3.  When reading an MSF number on an LSF machine or an LSF
    number on an MSF machine, perform the following before interpreting
    the number:

	    byte          no translation necessary
	    2-byte int    swap bytes 0 and 1
	    4-byte int    swap bytes 0 and 3, 1 and 2
	    4-byte float  swap bytes 0 and 3, 1 and 2
	    8-byte float  swap bytes 0 and 7, 1 and 6, 2 and 5, 3 and 4

{phang}
4.  For purposes of written documentation, numbers are written with the most
    significant byte listed first.  Thus {cmd:0x0001} refers to a
    2-byte integer taking on the logical value 1.

{phang}
5.  Stata has five numeric data types.  They are

	    {cmd:byte}          1-byte signed int
	    {cmd:int}           2-byte signed int
	    {cmd:long}          4-byte signed int
	    {cmd:float}         4-byte IEEE float
	    {cmd:double}        8-byte IEEE float

{phang}
6.  Each type allows for 27 {help missing:missing value codes}, known as
    {cmd:.}, {cmd:.a}, {cmd:.b}, ..., {cmd:.z}.
    For each type, the range allowed for nonmissing values and the missing
    value codes is

	    {cmd:byte}
		minimum nonmissing    -127   (0x80)
		maximum nonmissing    +100   (0x64)
		code for {cmd:.}            +101   (0x65)
		code for {cmd:.a}           +102   (0x66)
		code for {cmd:.b}           +103   (0x67)
		...
		code for {cmd:.z}           +127   (0x7f)

	    {cmd:int}
		minimum nonmissing    -32767 (0x8000)
		maximum nonmissing    +32740 (0x7fe4)
		code for {cmd:.}            +32741 (0x7fe5)
		code for {cmd:.a}           +32742 (0x7fe6)
		code for {cmd:.b}           +32743 (0x7fe7)
		...
		code for {cmd:.z}           +32767 (0x7fff)

	    {cmd:long}
		minimum nonmissing    -2,147,483,647  (0x80000000)
		maximum nonmissing    +2,147,483,620  (0x7fffffe4)
		code for {cmd:.}            +2,147,483,621  (0x7fffffe5)
		code for {cmd:.a}           +2,147,483,622  (0x7fffffe6)
		code for {cmd:.b}           +2,147,483,623  (0x7fffffe7)
		...
		code for {cmd:.z}           +2,147,483,647  (0x7fffffff)

	    {cmd:float}
		minimum nonmissing    -1.701e+38  (-1.fffffeX+7e)  {it:(sic)}
		maximum nonmissing    +1.701e+38  (+1.fffffeX+7e)
		code for {cmd:.}                        (+1.000000X+7f)
		code for {cmd:.a}                       (+1.001000X+7f)
		code for {cmd:.b}                       (+1.002000X+7f)
		...
		code for {cmd:.z}                       (+1.01a000X+7f)

	    {cmd:double}
		minimum nonmissing    -1.798e+308 (-1.fffffffffffffX+3ff)
		maximum nonmissing    +8.988e+307 (+1.fffffffffffffX+3fe)
		code for {cmd:.}                        (+1.0000000000000X+3ff)
		code for {cmd:.a}                       (+1.0010000000000X+3ff)
		code for {cmd:.b}                       (+1.0020000000000X+3ff)
		...
		code for {cmd:.z}                       (+1.01a0000000000X+3ff)

{pmore}
Note that for {cmd:float}, all {it:z}>1.fffffeX+7e, and for {cmd:double}, all
{it:z}>1.fffffffffffffX+3fe are considered to be missing values, and it is
merely a subset of the values that are labeled {cmd:.}, {cmd:.a}, {cmd:.b},
..., {cmd:.z}.  For example, a value between {cmd:.a} and {cmd:.b} is still
considered to be missing, and in particular, all the values between {cmd:.a}
and {cmd:.b} are known jointly as {cmd:.a_}.  Nevertheless, the recording of
those values should be avoided.

{pmore}
In the table above, we have used the
{c -(}{cmd:+}|{cmd:-}{c )-}{cmd:1.}{it:<digits>}{cmd:X}{c -(}{cmd:+}|{cmd:-}{c )-}{it:<digits>}
notation.  The number to the left of the {cmd:X} is to be interpreted as a
base-16 number (the period is thus the base-16 point) and the number to the
right (also recorded in base 16) is to be interpreted as the power of 2
{it:(sic)}.  For example,

	    1.01aX+3ff = (1.01a) * 2^(3ff)                        (base 16)
		       = (1 + 0/16 + 1/16^2 + 10/16^3) * 2^1023   (base 10)

{pmore}
The
{c -(}{cmd:+}|{cmd:-}{c )-}{cmd:1.}{it:<digits>}{cmd:X}{c -(}{cmd:+}|{cmd:-}{c )-}{it:<digits>}
notation easily converts to IEEE 8-byte double:
the {cmd:1} is the hidden bit, the digits to the right of the hexadecimal
point are the mantissa bits, and the exponent is the IEEE exponent in signed
(removal of offset) form.
For instance, pi = 3.1415927... is

					    8-byte IEEE, MSF
					 {hline 23}
	    pi = +1.921fb54442d18X+001 = 40 09 21 fb 54 44 2d 18

				       = 18 2d 44 54 fb 21 09 40
					 {hline 23}
					    8-byte IEEE, LSF

{pmore}
Converting
{c -(}{cmd:+}|{cmd:-}{c )-}{cmd:1.}{it:<digits>}{cmd:X}{c -(}{cmd:+}|{cmd:-}{c )-}{it:<digits>}
to IEEE 4-byte float is more difficult, but the same rule applies:  the
{cmd:1} is the hidden bit, the digits to the right of the hexadecimal point
are the mantissa bits, and the exponent is the IEEE exponent in signed
(removal of offset) form.  What makes it more difficult is that the
sign-and-exponent in the IEEE 4-byte format occupy 9 bits, which is not
divisible by four, and so everything is shifted one bit.  In float:

				      4-byte IEEE, MSF
					 {hline 11}
	    pi = +1.921fb60000000X+001 = 40 49 0f db

				       = db of 49 40
					 {hline 11}
				      4-byte IEEE, LSF

{pmore}
The easiest way to obtain the above result is to first convert
+1.921fb60000000X+001 to an 8-byte double and then convert the 8-byte double
to a 4-byte float.

{pmore}
In any case, the relevant numbers are

	    V            value                MSF              LSF
	    {hline 63}
	    m    -1.fffffffffffffX+3ff   ffefffffffffffff  ffffffffffffefff
	    M    +1.fffffffffffffX+3fe   7fdfffffffffffff  ffffffffffffdf7f
	    {cmd:.}    +1.0000000000000X+3ff   7fe0000000000000  000000000000e07f
	    {cmd:.a}   +1.0010000000000X+3ff   7fe0010000000000  000000000001e07f
	    {cmd:.b}   +1.0020000000000X+3ff   7fe0020000000000  000000000002e07f
	    {cmd:.z}   +1.01a0000000000X+3ff   7fe01a0000000000  00000000001ae07f

	    m    -1.fffffeX+7e           feffffff          fffffffe
	    M    +1.fffffeX+7e           7effffff          ffffff7e
	    {cmd:.}    +1.000000X+7f           7f000000          0000007f
	    {cmd:.a}   +1.001000X+7f           7f000800          0008007f
	    {cmd:.b}   +1.002000X+7f           7f001000          0010007f
	    {cmd:.z}   +1.01a000X+7f           7f00d000          00d0007f
	    {hline 63}


{marker definition}{...}
{title:5.  Dataset format definition}

{pstd}
A Stata dataset containing two variables named {cmd:myfloat} and 
{cmd:myint} -- {cmd:myfloat} a Stata 4-byte {cmd:float} and {cmd:myint}
a Stata 2-byte {cmd:int} -- and having one observation with 
{cmd:myfloat} = {cmd:myint} = 0 and written to disk on 
a dataset written on 10 July 2013 at 2:23 p.m. would look like this:

        {hline 40} {it:top of file} {hline 5}
	<stata_dta>

	    <header>
		<release>117</release>
		<byteorder>MSF</byteorder>
		<K>{rm:{it:0002}}</K>
		<N>{rm:{it:00000001}}</N>
		<label>{rm:{it:00}}</label>
		<timestamp>{rm:{it:11}}10 Jul 2013 14:23</timestamp>
	    </header>

	    <map>
		{it:0000000000000000}
		{it:0000000000000099}
		{it:0000000000000141}
		{it:0000000000000139}
		{it:0000000000000190}
		{it:00000000000001ab}
		{it:0000000000000220}
		{it:000000000000034e}
		{it:0000000000000371}
		{it:0000000000000384}
		{it:0000000000000393}
		{it:00000000000003b0}
		{it:00000000000003bc}
	    </map>

	    <variable_types>
            {rm:{it:fff7}}
	    {rm:{it:fff9}}
            </variable_types>

	    <varnames>
                 myfloat{rm:{it:00}}........................
                 myint{rm:{it:00}}..........................
            </varnames>

            <sortlist>
                {rm:{it:000000000000}}
            </sortlist>

            <formats>
                %9.0g{rm:{it:00}}...............................
                %8.0g{rm:{it:00}}............................... 
            </formats>

            <value_label_names>
		{rm:{it:00}}................................
		{rm:{it:00}}................................
            </value_label_names>

            <variable_labels>
		{rm:{it:00}}................................................
		{rm:{it:00}}................................................
            </variable_labels>

            <characteristics>
            </characteristics>

            <data>
		{rm:{it:000000000000}}
            </data>

	    <strls>
	    </strls>

	    <value_labels>
	    </value_labels>

	</stata_dta>{rm}
        {hline 40} {it:end of file} {hline 5}

{pstd}
We have taken liberties in the spacing of the presentation.  The file is
actually run together, so it looks more like this,

        {hline 40} {it:top of file} {hline 5}
        <stata_dta><header><release>117</release><byteorder>MSF</by
        teorder><K>{rm:{it:0002}}</K><N>{rm:{it:00000001}}</N><label>{rm:{it:00}}</label><timesta
        mp>{rm:{it:11}}10 Jul 2013 14:23</timestamp></header><map>{it:00000000000}
	{it:00000}{it:0000000000000099}{it:0000000000000141}{it:0000000000000139}{it:000000}
	{it:0000000190}{it:00000000000001ab}{it:0000000000000220}{it:000000000000034e}{it:0}
	{it:000000000000371}{it:0000000000000384}{it:0000000000000393}{it:000000000000}
	{it:03b0}{it:00000000000003bc}</map><variable_types>{rm:{it:fff7}}</variable_ty
	pes><varnames>myfloat{it:00}........................ myint{it:00}....
	......................</varnames><sortlist>{it:000000000000}</so
	rtlist><formats>%9.0g{it:00}...............................%8.0g
	{it:00}...............................</formats><value_label_nam
	es>{it:00}................................{it:00}....................
	.............</value_label_names><variable_labels>{it:00}.......
	...........................................................
	..............{it:00}...........................................
	.....................................</variable_labels><cha
	racteristics></characteristics><data>{rm:{it:000000000000}}</data><st
	rls></strls><value_labels></value_labels></stata_dta>
	{hline 40} {it:end of file} {hline 5}

{pstd}
We show binary content using hexadecimal values in italics.
{it:00}, for instance, means 1-byte binary zero.  The {it:11} following
<timestamp> means one byte recording hexadecimal 11, equivalent to 
decimal 17, and 17 is the 
length of the datestamp that follows it: "10 Jul 2013 14:23".
We show bytes that may contain random values -- that are and should be 
ignored -- using a period.

{pstd}
A 117-format {cmd:.dta} file begins with {cmd:<stata_dta>} and 
ends with {cmd:</stata_dta>}:

                         {cmd:<stata_dta>}..........{cmd:</stata_dta>}
                        /                                  \
                 {it:start of file                        end of file}

{pstd}
Between those markers appear

        header             {cmd:<header>}..............{cmd:</header>}
	file map	   {cmd:<map>}.................{cmd:</map>}
        variable types     {cmd:<variable_types>}......{cmd:</variable_types>}
        variable names     {cmd:<varnames>}............{cmd:</varnames>}
        sort order         {cmd:<sortlist>}............{cmd:</sortlist>}
        variable %fmts     {cmd:<formats>}.............{cmd:</formats>}
        value-label names  {cmd:<value_label_names>}...{cmd:</value_label_names>}
        variable labels    {cmd:<variable_labels>}.....{cmd:</variable_labels>}
        characteristics    {cmd:<characteristics>}.....{cmd:</characteristics>}
        data themselves    {cmd:<data>}................{cmd:</data>}
        strLs              {cmd:<strls>}...............{cmd:</strls>}
        value labels       {cmd:<value_labels>}........{cmd:</value_labels>}

{pstd}
Each marker pair must appear even if the content is empty, and the 
marker pairs must appear in the order shown.  



{marker header}{...}
{title:5.1  Header}

{pstd}
The Header is defined as

	{cmd:<header>}...{cmd:</header>}

{pstd}
Between those markers appear

        file format id     {cmd:<release>}...{cmd:</release>}
        byteorder          {cmd:<byteorder>}...{cmd:</byteorder>}
        # of variables     {cmd:<K>}...{cmd:</K>}
        # of observations  {cmd:<N>}...{cmd:</N>}
        dataset label      {cmd:<label>}...{cmd:</label>}
        datetime stamp     {cmd:<timestamp>}...{cmd:</timestamp>}

{pstd}
Each marker must appear, and it must appear in the order shown.


{marker header_release}{...}
{title:5.1.1  File format id}

{pstd}
The {it:file_format_id} is recorded as 

              {cmd:<release>}{cmd:117}{cmd:</release>}


{marker header_byteorder}{...}
{title:5.1.2  Byteorder}

{pstd}
The {it:byteorder} is recorded as 

              {cmd:<byteorder>}{it:byteorder}{cmd:</byteorder>}

{pstd}
where {it:byteorder} is either {cmd:MSF} or {cmd:LSF}. 

{pstd}
{cmd:MSF} stands for Most Significant byte First. 
In this encoding, the number 1 recorded as a 2-byte integer 
would be {it:00} followed by {it:01}:  {it:0001}.

{pstd}
{cmd:LSF} stands for Least Significant byte First. 
In this encoding, the number 1 recorded as a 2-byte integer 
would be {it:01} followed by {it:00}:  {it:0100}.


{marker header_K}{...}
{title:5.1.3  K, # of variables}

{pstd}
{it:K}, the number of variables stored in the dataset, is recorded as 

              {cmd:<K>}{it:bb}{cmd:</K>}

{pstd}
where {it:K} = {it:bb} is a 2-byte unsigned integer field
recorded according to {it:byteorder}.


{marker header_N}{...}
{title:5.1.4  N, # of observations}

{pstd}
{it:N}, the number of observations stored in the dataset, is recorded as 

              {cmd:<N>}{it:bbbb}{cmd:</N>}

{pstd}
Where {it:N} = {it:bbbb} is a 4-byte unsigned integer field recorded
according to {it:byteorder}.



{marker header_label}{...}
{title:5.1.5  Dataset label}

{pstd}
The dataset label is recorded as 
                             
              {cmd:<label>}{it:lccccc........c}{cmd:</label>}
                      |------------|
                       {it:l characters}

{pstd}
First recorded is the length {it:l} of the dataset label, excluding a
terminating binary 0.  {it:l} is a 1-byte unsigned integer field
required to be 0 <= {it:l} <= decimal 80 (hexadecimal 50).  The {it:l} ASCII
characters appear after that.


{marker header_timestamp}{...}
{title:5.1.6  Datetime stamp}

{pstd}
The datetime stamp records the date and time the file was written.
The datetime stamp is recorded as 

              {cmd:<timestamp>}{it:lccccc........c}{cmd:</timestamp>}
                          |------------|
                           {it:l characters}

{pstd}
First recorded is the length {it:l} of the datetime stamp, excluding the
terminating binary 0, if any.  {it:l} is a 1-byte unsigned integer field.
The {it:l} ASCII characters appear after that.

{pstd}
{it:l} is required to be 0 or decimal 17.  If {it:l}==0, then no datetime 
stamp is recorded.  If {it:l}==(decimal) 17, the datetime stamp is recorded 
in the format

                 ----+----1----+--
	         {it:dd Mon yyyy hh}{cmd::}{it:mm}
{pstd}
such as 
{p_end}
		 10 Jul 2013 14:23

{pstd}
If {it:dd}<10 or {it:hh}<10, the element is recorded with a 
leading blank or a leading zero:

		 04 Jul 2032 04:23
		  4 Jul 2013  4:23

{marker map}{...}
{title:5.2  Map}

{pstd}
The map has to do with the position in the file, not the Stata data themselves.
The map is recorded as 

              {cmd:<map>}{it:filepositions}{cmd:</map>}

{pstd}
where {it:filepositions} is a list (vector) of 14 8-byte 
offsets from the start of the file, written according to {it:byteorder}. 
The 14 positions to be recorded are

	         #        file position of the start of the
		{hline 47}
	         1.       {cmd:<stata_data>}, definitionally 0
	         2.       {cmd:<map>}
		 3.       {cmd:<variable_types>}
		 4.       {cmd:<varnames>}
		 5.       {cmd:<sortlist>}
		 6.       {cmd:<formats>}
		 7.       {cmd:<value_label_names>}
		 8.       {cmd:<variable_labels>}
		 9.       {cmd:<characteristics>}
		10.       {cmd:<data>}
		11.       {cmd:<strls>}
		12.       {cmd:<value_labels>}
		13.       {cmd:</stata_data>}
		14.       {it:end-of-file}
		{hline 47}

{pstd}
Notes:

{p 8 12 2}
1.  File positions are values that can be obtained from and set by 
    C function {cmd:lseek()}.  File positions are obtained by 
    {cmd:lseek(fd, 0, SEEK_CUR)} just before writing the marker 
    listed above or, in the case of {it:end-of-file}, just
    after writing {cmd:</stata_data>}. 

{p 8 12 2}
2.  If you are writing a file, we recommend writing 
    {cmd:<map>}...{cmd:</map>} with all file positions filled in 
    with zero as you are proceeding sequentially and 
    tracking the file positions in a structure such as 

                {cmd:struct mapdef {c -(}}
                        {cmd:off_t  hdr ;}
                        {cmd:off_t  map ;  }
                        {cmd:off_t  types ; }
                        {cmd:off_t  varnames ;}
                        {cmd:off_t  srtlist ;}
                        {cmd:off_t  fmts ;}
                        {cmd:off_t  vlblnames ;}
                        {cmd:off_t  varlabs ;}
                        {cmd:off_t  chars ;}
                        {cmd:off_t  data ;}
                        {cmd:off_t  strls ; }
                        {cmd:off_t  vallabs ;}
                        {cmd:off_t  tlr ;}
                        {cmd:off_t  bot ;}
                {cmd:{c )-} ;}

{p 12 12 2}
    Record file positions in the structure just before writing the
    corresponding marker.  Once you have written {cmd:</stata_data>}, 
    seek to {cmd:map+5} and rewrite the file positions.  Then 
    {cmd:close()} the file. 

{p 8 12 2}
3.  Note that file positions are 8 bytes long, as they would be on a 64-bit 
    computer.  If you are on a 32-bit 
    computer, you must set the most-significant 4 bytes to 0 and 
    record your 32-bit file positions in the least-significant 4 bytes. 
    If you are on a {cmd:MSF} computer, you write each file position 
    by first writing 4 bytes of 0 and then the 4-byte file position.
    If you are on a {cmd:LSF} computer, you write each file position 
    by writing the 4-byte file position and then writing 4 bytes of 0.


{marker variabletypes}{...}
{title:5.3  Variable types}

{pstd}
Variable types are recorded as 

              {cmd:<variable_types>}{it:typlist}{cmd:</variable_types>}

{pstd}
where {it:typlist} is a sequence (vector) of {it:K} 2-byte unsigned integer
fields written according to {it:byteorder} and recording the variable type 
of variable 1, 2, ..., {it:K}.

{pstd}
The types are encoded

                         Stata 
           typ          meaning      Description
	{hline 58}
             1          str1         1 character strf
             2          str2         2 or fewer characters strf
           ...          etc.
          2045          str2045      2,045 or fewer character strf

         32768          strL         strL of any length 

         65526          double       8-byte float
         65527          float        4-byte float
         65528          long         4-byte signed integer
         65529          int          2-byte signed integer
         65530          byte         1-byte signed integer
	{hline 58}


{marker variablenames}{...}
{title:5.4  Variable names}

{pstd}
Variable names are recorded as 

              {cmd:<varnames>}{it:varnamelist}{cmd:</varnames>}

{pstd}
where {it:varnamelist} is a sequence (vector) of {it:K} 
33-character, binary-zero terminated, ASCII variable names.

{pstd}
{it:varnamelist} contains the names of the Stata variables 1, ..., {it:K},
each up to 32 characters in length and each terminated by a binary zero (\0).
For instance, if {it:K}==4, {it:varnamelist} would be

	0       33        66          99
	|        |         |           |
	{cmd:vbl1\0...myvar\0...thisvar\0...lstvar\0...}


{pstd}
The above states 
that variable 1 is named {cmd:vbl1}, variable 2
{cmd:myvar}, variable 3 {cmd:thisvar}, and variable 4 {cmd:lstvar}.  The byte
positions indicated by periods will contain random values (and note that we
have omitted some of the periods).  If {it:varnamelist} is read into the
C-array {cmd:char} {cmd:varnamelist[]}, then {cmd:&varnamelist[(i-1)*33]}
points to the name of the {cmd:i}th variable, 1 <= {cmd:i} <= {it:K}. 


{marker sortlist}{...}
{title:5.5  Sort order of observations}

{pstd}
The sort order in which the observations will be subsequently 
recorded is recorded as

              {cmd:<sortlist>}{it:sortlist}{cmd:</sortlist>}

{pstd}
where {it:sortlist} is a sequence (array) of {it:K}+1 unsigned 2-byte 
integers recorded according to {it:byteorder}.  

{pstd}
{it:sortlist} specifies the sort-order of the dataset and is terminated by a
2-byte zero ({it:0000} in hex).  Each 2-byte element contains either a
variable number or zero.  The zero marks the end of the {it:sortlist}, and the
recorded positions after that contain random junk.  For instance, if the data
are not sorted, the first 2-byte integer will contain a zero, and the
2-byte integers thereafter will contain junk.  If {cmd:nvar}==4, the record
will appear as

	{cmd:0000................}

{pstd}
If the dataset is sorted by one variable, say {cmd:myvar}, and if that
variable is the second variable in the {it:varnamelist}, the record will
appear as

	{cmd:00020000............}  (if {cmd:byteorder}==MSF)
	{cmd:02000000............}  (if {cmd:byteorder}==LSF)

{pstd}
If the dataset is sorted by {cmd:myvar} and within {cmd:myvar} by {cmd:vbl1},
and if {cmd:vbl1} is the first variable in the dataset, the record will appear
as

	{cmd:000200010000........}  (if {cmd:byteorder}==MSF)
	{cmd:020001000000........}  (if {cmd:byteorder}==LSF)


{pstd}
If {it:sortlist} were read into the C-array {cmd:short} {cmd:int}
{cmd:srtlist[]}, then {cmd:srtlist[0]} would be the variable number of the
first sort variable or, if the data were not sorted, 0.  If the number is not
0, {cmd:srtlist[1]} would be the variable number of the second sort
variable or, if there is not a second sort variable, 0, and so on.


{marker formats}{...}
{title:5.6  Display formats}

{pstd}
The display formats associated with each variable are recorded as 

              {cmd:<formats>}{it:fmtlist}{cmd:</formats>}

{pstd}
{it:fmtlist} contains the formats of the variables 1, ..., {it:K}.  Each
format is 49 bytes long and includes a binary-zero end-of-string marker.  For
instance,

	{cmd:%9.0f\0..........................................%8.2f\0......}
	{cmd:....................................%20.0g\0..................}
	{cmd:.......................%td\0..................................}
	{cmd:..........%tcDDmonCCYY_HH:MM:SS.sss\0......................}

{pstd}
indicates that variable 1 has a {cmd:%9.0f} format, variable 2 a {cmd:%8.2f}
format, variable 3 a {cmd:%20.0g} format, and so on.  Note that these are
Stata formats, not C formats.

{phang2}
1.  Formats beginning with {cmd:%t} or {cmd:%-t} are Stata's date and time
    formats.

{phang2}
2.  Stata has an old {cmd:%}{cmd:d} format notation, and some datasets 
    still have them.  Format {cmd:%}{cmd:d}... is equivalent to 
    modern format {cmd:%td}... and {cmd:%}{cmd:-}{cmd:d}... is 
    equivalent to {cmd:%-td}... 

{phang2}
3.  Nondate formats ending in {cmd:gc} or {cmd:fc} are similar to C's {cmd:g}
    and {cmd:f} formats, but with commas.  Most translation routines would
    ignore the ending {cmd:c} (change it to {cmd:\0}).

{phang2}
4.  Formats may contain commas rather than periods, such as {cmd:%9,2f},
    indicating European format.

{pstd}
If {it:fmtlist} is read into the C-array {cmd:char} {cmd:fmtlist[]}, then
{cmd:&fmtlist[49*(i-1)]} refers to the starting address of the format for the
{cmd:i}th variable.


{marker labelnames}{...}
{title:5.7  Value-label names}

{pstd}
The value-label names associated with each variable are recorded as 

              {cmd:<value_label_names>}{it:lbllist}{cmd:</value_label_names>}

{pstd}
where {it:lbllist} is a sequence (array) of {it:K} 33-character, binary-zero
terminated strings.

{pstd}
{it:lbllist} contains the names of the value formats associated with the
variables 1, ..., {it:K}.  Each value-format name is 33 bytes long and
includes a binary-zero end-of-string marker.  For instance,

	0   33        66   99
	|    |         |    |
	{cmd:\0...yesno\0...\0...yesno\0...}

{pstd}
indicates that variables 1 and 3 have no value label associated with them,
whereas variables 2 and 4 are both associated with the value label named
{cmd:yesno}.  If {it:lbllist} is read into the C-array {cmd:char}
{cmd:lbllist[]}, then {cmd:&lbllist[33*(i-1)]} points to the start of the
label name associated with the {cmd:i}th variable.


{marker variablelabels}{...}
{title:5.8  Variable labels}

{pstd}
The variable labels associated with each variable are recorded as 

              {cmd:<variable_labels>}{it:varlbllist}{cmd:</variable_labels>}

{pstd}
where {it:varlbllist} is a sequence (array) of {it:K} 81-character, 
binary-zero terminated strings.  If a variable has no label, the first character
of its label is \0. 


{marker characteristics}{...}
{title:5.9  Characteristics}

{pstd}
Characteristics are used to record information that is unique to
Stata and has no equivalent in other data management packages.
When writing data, we recommend you write 
	
              {cmd:<characteristics>}{cmd:</characteristics>}

{pstd}
That leaves the problem of reading a dataset that might contain
characteristics.  Characteristics are recorded as

             {cmd:<characteristics>}...{cmd:</characteristics>}

{pstd}
We recommend you skip over the {it:...} part.
Do not, however, merely
scan ahead until you encounter the close marker, because the ... part 
itself might contain a characteristic
containing the string "{cmd:</characteristics>}".

{pstd}
The ... part contains zero or more individual characteristics, each appearing
as 

             {cmd:<ch>}{it:llll}...............{cmd:</ch>}
                     |-------------|
                         {it:llll} bytes

{pstd}
where {it:llll} is the length of what follows, recorded as a 4-byte
unsigned integer field to be interpreted according to {it:byteorder}.  Thus,
to skip an individual characteristic after reading {cmd:<ch>}, read
{it:llll} and then skip {it:llll} bytes in the file.  
Then verify that you next
read {cmd:/ch}.  The marker after that will then be either
{cmd:</characteristics>}, meaning you are done, or {cmd:<ch>},
meaning you have yet another individual characteristic to skip.

{pstd} 
For those who want to read and write characteristics, the ... part contains
the information on the individual characteristic being defined, recorded as

             0            33               66       {it:l}-1
             |             |                |        |
             {it:varname}{cmd:\0.....}{it:charname}{cmd:\0}.......{it:contents}{cmd:\0}
             |---------------------------------------|
                            {it:llll} bytes

{pstd}
Bytes 0-32 contain a binary-zero terminated variable name, bytes 33-65 
contain a binary-zero terminated characteristic name, and bytes 
60 through the end of the record contain the binary-zero terminated 
ASCII contents of characteristic {it:varname}{cmd:[}{it:charname}{cmd:]}.


{marker data}{...}
{title:5.10  Data}

{pstd}
The data are recorded as 

              {cmd:<data>}{it:data}{cmd:</data>}

{pstd}
where {it:data} is observation 1 followed by observation 2 followed by ...
followed by observation {it:N},

              {cmd:<data>}{it:obs1obs2obs3...obsN}{cmd:</data>}

{pstd} 
and where each observation is variable 1's value followed by 
variable 2's value ... followed by variable {it:K}'s value, 

              {cmd:<data>}{it:v11v12...v1Kv21v22...v2K......vN1vN2...VNK}{cmd:</data>}

{pstd}
Each {it:vIJ} is recorded in its own internal format, 
as given by {it:typlist} and defined in sections {help dta_117##strings:3} (strfs)
and
{help dta_117##numbers:4} (numeric values).
We have not yet explained how strLs are written; we will do that in 
section {help dta_117##strls:5.11}.  In the meantime, let us imagine a dataset without strLs.

{pstd}
All values are written per {it:byteorder}.  Strfs are binary-zero 
terminated if they are shorter than the allowed space, but they are 
not terminated if they are full width. 

{pstd}
For instance, consider a dataset in which {it:V1} is a {cmd:float}, {it:V2} a
{cmd:byte}, {it:V3} a {cmd:double}, and {it:V4} a {cmd:str6}:


        . {cmd:describe}

        Contains data
          obs:             2                          
         vars:             4                          
         size:            38                          
	{hline 64}
                      storage  display     value
        variable name   type   format      label      variable label
	{hline 64}
        V1              float  %9.0g                  
        V2              byte   %8.0g                  
        V3              double %10.0g                 
        V4              str6   %9s                    
	{hline 64}
        Sorted by:  

        . {cmd:}list

             {c TLC}{hline 23}{c TRC}
             {c |} V1   V2   V3       V4 {c |}
             {c LT}{hline 23}{c RT}
          1. {c |}  0    1    2    first {c |}
          2. {c |}  1    2    3   second {c |}
             {c BLC}{hline 23}{c BRC}

{pstd}
The corresponding {cmd:<data>}...{cmd:</data>} would read (assuming MSF
byteorder),

        <data>{it:00000000014000000000000000}first{it:00}{it:3f800000024008000000000000}
	second</data>

{pstd}
Values for variables and observations are run together, but 
we can more easily understand it if we add nonsignificant white space

	<data>
		 {it:00000000 01 4000000000000000} first{it:00}
		 {it:3f800000 02 4008000000000000} second
	</data>
		
{p 8 12 2}
1.  Each variable's value is written according to its variable type. 

{p 12 12 2}
    {cmd:V1}'s value is 4 bytes (8 hexadecimal digits) long
    because {cmd:V1} is of type {cmd:float}.  What is written 
    is interpreted as a 4-byte IEEE float. 

{p 12 12 2}
    {cmd:V2}'s value is 1 byte (2 hexadecimal digits) long
    because {cmd:V2} is of type {cmd:byte}.  What is written 
    is interpreted as 1-byte signed integer. 

{p 12 12 2}
    {cmd:V3}'s value is 8 bytes (16 hexadecimal digits) long
    because {cmd:V3} is of type {cmd:double}.  What is written 
    is interpreted as 8-byte IEEE float. 

{p 8 12 2}
2.  Look carefully at {cmd:V4}, a {cmd:str6} taking on 
    values "first" and "second".  The value "first" is written 
    as first\0 -- with trailing binary 0.  The value 
    "second" is written without a trailing binary 0 because 
    "second" is 6 characters long, which is to say, full length.
    If another observation contained "dog", it would be 
    written dog\0.. -- a binary 0 would be written, and then 
    two random bytes written so that the length of what was 
    written would be the required 6.

{p 12 12 2}
    The general rule is that {cmd:str#} is written in a field 
    of # bytes.  If the value is # bytes long, no binary 0 is 
    suffixed.  If the value is less than # bytes long, a binary 0 
    is suffixed at the end of the string. 

{p 12 12 2}
    An empty string is always written as \0 and then padded 
    with random bytes if necessary to fill out the required length.


{marker strls}{...}
{title:5.11  StrLs}

{pstd}
StrLs are long strings.  In the above section on
{cmd:<data>}...{cmd:</data>}, we saw that the value of each strf --
Stata types {cmd:str1}, {cmd:str2}, ..., {cmd:str2045} -- is recorded
as fixed-length strings.

{pstd}
StrLs can be up to 2,000,000,000 characters long, so they are recorded
differently.

{pstd}
If there are no strL variables in the data, {cmd:<strls>}...{cmd:</strls>} is
recorded as

		{cmd:<strls></strls>}

{pstd}
In section {help dta_117##data:5.10} we had an example showing the
contents of {cmd:<data>}...{cmd:</data>} for a dataset containing four
variables and two observations.  There were no strLs in that example, and
thus the entire {cmd:<data>}...{cmd:</data>} and
{cmd:<strls>}...{cmd:</strls>} would read

        <data>{it:00000000014000000000000000}first{it:00}{it:3f800000024008000000000000}
	second</data><strl><strls>

{pstd}
or, with more readable, nonsignificant spaces, 

	<data>
		 {it:00000000 01 4000000000000000} first{it:00}
		 {it:3f800000 02 4008000000000000} second
	</data>
	<strls>
	</strls>

{pstd}
Let's take that example's dataset and add a strL variable to it as 
variable {cmd:V5}:

        . {cmd:describe}

        Contains data
          obs:             2                          
         vars:             5                          
         size:            38                          
	{hline 64}
                      storage  display     value
        variable name   type   format      label      variable label
	{hline 64}
        V1              float  %9.0g                  
        V2              byte   %8.0g                  
        V3              double %10.0g                 
        V4              str6   %9s                    
        V5              strL   %9s                    
	{hline 64}
        Sorted by:  


        . {cmd:list}
             {c TLC}{hline 4}{c -}{hline 4}{c -}{hline 4}{c -}{hline 8}{c -}{hline 8}{c TRC}
             {c |} V1   V2   V3       V4       V5 {c |}
             {c LT}{hline 4}{c -}{hline 4}{c -}{hline 4}{c -}{hline 8}{c -}{hline 8}{c RT}
          1. {c |}  0    1    2    first    third {c |}
          2. {c |}  1    2    3   second   fourth {c |}
             {c BLC}{hline 4}{c -}{hline 4}{c -}{hline 4}{c -}{hline 8}{c -}{hline 8}{c BRC}

{pstd}
The data for the strL variable are divided between 
{cmd:<data>}...{cmd:</data>} and {cmd:<strls>}...{cmd:</strls>}.
Run together in the {cmd:.dta} file, it looks like this,

	<data>{it:00000000014000000000000000}first{it:00}{it:0000000500000001}
	{it:3f800000024008000000000000}second{it:0000000500000002}</data>
        <strls>GSO{it:00000005000000018200000006}third{it:00}GSO{it:000000050}
        {it:0000002 82 00000007}fourth{it:00}</strls>

{pstd}
or, with more readable, nonsignificant spaces, 

	<data>
		 {it:00000000 01 4000000000000000} first{it:00} {it:0000000500000001}
		 {it:3f800000 02 4008000000000000} second  {it:0000000500000002}
	</data>
	<strls>
                 GSO {it:0000000500000001 82 00000006}third{it:00}
                 GSO {it:0000000500000002 82 00000007}fourth{it:00}
	</strls>

{pstd}
StrLs are recorded in two parts:

{p 8 12 2}
1.  In {cmd:<data>}...{cmd:</data>}, each strL is recorded as an 8-byte
    (16 hex digit) value. These values are to be interpreted as 2 
    4-byte fields and are known as ({it:v},{it:o}) values.

{p 12 12 2}
    In the first observation, the strL is recorded as (hexadecimal)
    {it:0000000500000001}, which is the 2 4-byte values, namely,
    (hexadecimal) {it:00000005} and {it:00000001}, and which corresponds to
    ({it:v},{it:o}) = (5,1).

{p 12 12 2}
    In the second observation, the ({it:v},{it:o}) value is (5,2). 

{p 8 12 2}
2.  {cmd:<strls>}...{cmd:</strls>} records the mapping of 
    ({it:v},{it:o}) values to corresponding strings. 
    In the case of strLs, strings are known as 
    Generic String Objects (GSOs). 

{p 12 12 2}
    In this example, two GSOs are defined. 
    The first is the GSO for ({it:v},{it:o})=(5,1) and the second, 
    the GSO for (5,2). 

{p 12 12 2}
    ({it:v},{it:o})=(5,1) corresponds to "third".

{p 12 12 2}
    ({it:v},{it:o})=(5,2) correspond to "fourth". 

{pstd}
Obviously, there is more information recorded in the GSO than just 
the ({it:v},{it:o}) value and its corresponding string, and we will get 
to that, but let's focus first on the ({it:v},{it:o}) values. 


{marker strls_vo}{...}
{title:5.11.1  (v,o) values}

{pstd}
If our dataset contained variable V5 equaling "third" in both observations,


        . {cmd:list}
             {c TLC}{hline 4}{c -}{hline 4}{c -}{hline 4}{c -}{hline 8}{c -}{hline 8}{c TRC}
             {c |} V1   V2   V3       V4       V5 {c |}
             {c LT}{hline 4}{c -}{hline 4}{c -}{hline 4}{c -}{hline 8}{c -}{hline 8}{c RT}
          1. {c |}  0    1    2    first    third {c |}
          2. {c |}  1    2    3   second    third {c |}
             {c BLC}{hline 4}{c -}{hline 4}{c -}{hline 4}{c -}{hline 8}{c -}{hline 8}{c BRC}


{pstd}
they could be recorded like this, 
    
	<data>
		 00000000 01 4000000000000000 first{it:00} {it:0000000500000001}
		 3f800000 02 4008000000000000 second  {it:0000000500000002}
	</data>
	<strls>
                 GSO {it:0000000500000001 82 00000006}third{it:00}
                 GSO {it:0000000500000002 82 00000006}third{it:00}
	</strls>

{pstd}
or like this:

	<data>
		 00000000 01 4000000000000000 first{it:00} {it:0000000500000001}
		 3f800000 02 4008000000000000 second  {it:0000000500000001}
	</data>
	<strls>
                 GSO {it:0000000500000001 82 00000006}third{it:00}
	</strls>

{pstd}
Note that there is only one GSO and both observations refer to it by 
specifying ({it:v},{it:o}) as (5,1) in both observations.
This is called a shared or cross-linked GSO.  Lots of observations can 
link to the same GSO.  By the way, the data could not be
recorded like this:

	<data>
		 00000000 01 4000000000000000 first{it:00} {it:0000000500000002}
		 3f800000 02 4008000000000000 second  {it:0000000500000002}
	</data>
	<strls>
                 GSO {it:0000000500000002 82 00000006}third{it:00}
	</strls>

{pstd}
In this example of a mistake, ({it:v},{it:o}) is (5,2) rather than
(5,1).  This is called a forward reference and is not allowed.  
You might already suspect
that ({it:v},{it:o)} values are called that because they somehow refer to
variable and observation numbers.  In {cmd:<data>}...{cmd:</data>},
({it:v},{it:o}) values for variable {it:i}, observation {it:j} are
required to equal {it:i},{it:j} or be "before" {it:i},{it:j}, which is
to say, {it:o}<{it:j} or, if {it:o}=={it:j}, {it:v}<={it:i}.

{pstd}
(0,0) is a special ({it:v},{it:o}) value that refers to a GSO containing 
(ascii) "" and that you do not need to define (and that you may not 
define).  
If variable V5 in the first observation contained (ascii) "", 

        . {cmd:list}
             {c TLC}{hline 4}{c -}{hline 4}{c -}{hline 4}{c -}{hline 8}{c -}{hline 8}{c TRC}
             {c |} V1   V2   V3       V4       V5 {c |}
             {c LT}{hline 4}{c -}{hline 4}{c -}{hline 4}{c -}{hline 8}{c -}{hline 8}{c RT}
          1. {c |}  0    1    2    first          {c |}
          2. {c |}  1    2    3   second   fourth {c |}
             {c BLC}{hline 4}{c -}{hline 4}{c -}{hline 4}{c -}{hline 8}{c -}{hline 8}{c BRC}

{pstd}
the data could be recorded as


	<data>
		 00000000 01 4000000000000000 first{it:00} {it:0000000500000001}
		 3f800000 02 4008000000000000 second  {it:0000000500000002}
	</data>
	<strls>
                 GSO {it:0000000500000001 82 00000001}{it:00}
                 GSO {it:0000000500000002 82 00000007}fourth{it:00}
	</strls>

{pstd}
but that is considered bad style because it causes Stata to waste a little 
memory.  The right way to record the data is 

	<data>
		 00000000 01 4000000000000000 first{it:00} {it:0000000000000000}
		 3f800000 02 4008000000000000 second  {it:0000000500000002}
	</data>
	<strls>
                 GSO {it:0000000500000002 82 00000007}fourth{it:00}
	</strls>

{pstd}
In the above, note that ({it:v},{it:o}) = (0,0) in the first observation.  By
the way, if both observations of variable V5 contained (ascii) "", the data
would be recorded as

	<data>
		 00000000 01 4000000000000000 first{it:00} {it:0000000000000000}
		 3f800000 02 4008000000000000 second  {it:0000000000000000}
	</data>
	<strls>
	</strls>

{marker vo_rules}{...}
{pstd} 
The rules for specifying ({it:v},{it:o}) values are the following:

{p 8 12 2}
1.  In {cmd:<data>}...{cmd:</data>}, strLs are recorded as ({it:v},{it:o})
    values.  That means a ({it:v},{it:o}) value is specified for each strL
    variable in each observation.

{p 8 12 2}
2.  ({it:v},{it:o}) values are recorded in an 8-byte field and are 
    interpreted as 2 4-byte unsigned integer values per {it:byteorder}. 

{p 8 12 2}
3.  For variable {it:i}, observation {it:j}, ({it:v},{it:o}) = (0,0) 
    if {it:i},{it:j} contains (ascii) "". 

{p 8 12 2}
4.  For variable {it:i}, observation {it:j}, if ({it:v},{it:o}) != (0,0), 
    then {it:o}<{it:j} or, if {it:o}=={it:j}, {it:v}<={it:i}.  
    That is, variable {it:i}, observation {it:j} either links to 
    its own ({it:v},{it:o}) = ({it:i},{it:j}) or links to 
    the ({it:v},{it:o}) value of a variable and observation that appeared 
    before it in {cmd:<data>}...{cmd:</data>}.

{p 8 12 2}
5.  The usual case is ({it:v},{it:o}) = ({it:i},{it:j}).

{p 8 12 2}
6.  Programs that write {cmd:.dta} files are not required to produce 
    crosslinked ({it:v},{it:o}) values when contents of strings are equal. 

{p 8 12 2}
7.  Programs that read {cmd:.dta} files are required to be able to 
    process crosslinked ({it:v},{it:o}) values.


{marker strls_gso}{...}
{title:5.11.2  GSOs}

{pstd}
The markers {cmd:<strls>}....{cmd:</strls>} contain the definitions of 
zero or more GSOs:

		{cmd:<strls>}{it:GSOdef}{it:GSOdef}...{it:GSOdef}{cmd:</strls>}

{pstd}
Each GSO can contain 
either an ascii or a binary string.  We use the following definitions:

{p 12 12 8}
        A string is {it:ascii-like} if it contains no binary zeros and if it
        contains a binary zero following its last significant character.

{p 12 12 8}
        A string is {it:ascii} if it is ascii-like and it uses the ASCII
        character encoding

{p 12 12 8}
	A string that is not ascii is {it:binary}.

{pstd}
The format of a GSO record is 

		     o           len
                      \         /        contents
                       ---- ----         /
		{cmd:GSO}vvvvooootllllxxxxxxxxxxxxxxx...x
                   ----    -   (---- len bytes ----)
		  /        |
                 v       type


	    name    length          contents
	    {hline 59}
	                 3          {cmd:GSO} (fixed string)
            {it:v}            4          unsigned 4-byte integer, {...}
{it:v} of ({it:v},{it:o})
            {it:o}            4          unsigned 4-byte integer, {...}
{it:o} of ({it:v},{it:o})
            {it:t}            1          unsigned 1-byte integer
            {it:len}          4          unsigned 4-byte integer
            {it:contents   len}          contents of strL
            {hline 59}
	    {it:v}, {it:o}, and {it:len} are recorded per {it:byteorder}.

	    {it:t} is encoded:
	        129 (decimal)        binary
	        130 (decimal)        ascii
	    if {it:t}==129,
		{it:contents} contains the string AS-IS.
		{it:len} contains the length of {it:contents}.
	    if {it:t}==130, 
		{it:contents} must contain trailing \0.
		{it:len} contains the length of the string including \0.
		If using C, {it:len} = strlen(string) + 1.
	   

{pstd}
Notes:

{p 8 12 2}
1.  {it:v} and {it:o} are the ({it:v},{it:o}) values defined in 
    {cmd:<data>}...{cmd:</data>}.  {it:v} and {it:o} must follow
    the {help dta_117##vo_rules:rules} of specification previously given. 

{p 8 12 2}
2.  Variable {it:v} must be of type {cmd:strL}. 

{p 8 12 2}
3.  GSOs must appear in "ascending" order of ({it:v},{it:o}).
    Ascending order is defined as the same order as 
    they appeared in {cmd:<data>}...{cmd:</data>}: ascending {it:v} 
    for {it:o}==1, followed by ascending {it:v} for {it:o}==2, ....

{p 8 12 2}
4.  All ({it:v},{it:o}) values that appeared in {cmd:<data>}...{cmd:</data>}
    must be defined except ({it:v},{it:o}) = (0,0).  Each may be defined 
    only once.
    
{p 8 12 2}
5.  ({it:v},{it:o}) = (0,0) may not be defined.


{marker strls_advw}{...}
{title:5.11.3  Advice on writing strLs}

{pstd}
Writing {cmd:.dta} datasets containing strLs is easy if you do not 
attempt to link equal strLs.  Sometimes, crosslinking is easy, too, depending
on how your original data are stored.   

{pstd} 
Here is pseudocode for writing strLs without crosslinking:

	write "<data>"
	for (j=1; j<=N; j++) {c -(}
		for (i=1; i<=K; i++) {c -(}
			if (variable i is strL) {c -(}
				if (contents of i != (ascii) "") {c -(}
					write i as 4 bytes 
					write j as 4 bytes
				{c )-}
				else {c -(}
					write 0 as 8 bytes
				{c )-}
			{c )-}
			else ... /* the usual */
		{c )-}
	{c )-}
	write "</data>"

	write "<strls>"
	for (j=1; j<=N; j++) {c -(}
		for (i=1; i<=K; i++) {c -(}
			if (variable i is strL) {c -(}
				if (contents of i != (ascii) "") {c -(}
					write GSO for ({it:v},{it:o}) = (i,j)
				{c )-}
			{c )-}
		{c )-}
	{c )-}
	write "</strls>"


{marker strls_advr}{...}
{title:5.11.4  Advice on reading strLs}

{pstd}
Here is pseudocode for reading strLs (including crosslinking):

	read "<data>"
	for (j=1; j<=N; j++) {c -(}
		for (i=1; i<=K; i++) {c -(}
			read data the usual way 
			in the case of strLs, just store ({it:v},{it:o}) values
		{c )-}
	{c )-}
	read "</data>"

	read "<strls>"
	for (j=1; j<=N: j++) {c -(}
		for (i=1; i<=K; i++) {c -(}
			if (variable i is strL) {c -(}
				get {it:v} and {it:o} from data(i,j)
				if (v==i && o==j) {c -(}
					read GSO up to {it:contents}
					read {it:len} bytes of {it:contents}
					store contents in new_dataset(i,j)
				{c )-}
				else {c -(}
					if (v==0 && o==0) {c -(}
						store (ascii) "" in new_dataset
					{c )-}
					else if (o<j || (o==j && v<i) {c -(}
						retrieve string new_dataset(v,o)
						... that you previously stored.
						store string in new_dataset(i,j)
					{c )-}
					else {c -(}
						abort with error due to ...
						... forward reference 
					{c )-}
					
				{c )-}
			{c )-}
		{c )-}
	{c )-}
	read "</strls>"


{marker value_labels}{...}
{title:5.12  Value labels}

{pstd}
Numeric variables in Stata optionally have value labels associated with them.
Value labels map numeric values to strings, such as 1 to "male" and 2 to
"female".  Mappings are named.  The mapping of 1 to "male" and 2 to "female"
might be named {cmd:gender}.  The recording of the names of the mappings
optionally associated with variables was discussed in section 
{help dta_117##labelnames:5.7}.  Variable {cmd:sex} might be associated with 
value label {cmd:gender}. 

{pstd}
Here we discuss the recording of the value label definition itself, such as
{cmd:gender}.  Even if value label {cmd:gender} is used by a variable, it is
not required that the corresponding value-label definition be provided.

{pstd}
Value labels are defined by 

              {cmd:<value_labels>}{it:individual_definitions}{cmd:</value_labels>}

{pstd}
where an {it:individual_definitions} are each given by 

              {cmd:<lbl>}{it:def}{cmd:</lbl>}

{pstd}
If no individual definitions are provided, the above becomes

              {cmd:<value_labels>}{cmd:</value_labels>}

{pstd}
If individual definitions are provided, the above becomes 

              {cmd:<value_labels><lbl>}{it:def}{cmd:</lbl>}...{cmd:<lbl>}{it:def}{cmd:</lbl>}{cmd:</value_labels>}

{pstd}
where {it:def} is 

            {it:len   labelname                  padding  value_label_table}
              |   |                                |  |
              {it:llllcccccccccccccccccccccccccccccccccppp...................}
                  |-------- 33 characters --------|   |--- len bytes ---|


	{it:def}                    len   format     comment
	{hline 67}
	{it:len}                      4   int        length of {it:value_label_table}
	{it:labname}                 33   char       \0 terminated
	padding                  3
	{it:value_label_table}      {it:len}              see next table
	{hline 67}


	{it:value_label_table}      len   format     comment
	{hline 58}
	{it:n}                        4   int        number of entries
	{it:txtlen}                   4   int        length of {it:txt[]}
	{it:off}[]                  4*{it:n}   int array  {it:txt}[] offset table
	{it:val}[]                  4*{it:n}   int array  sorted value table
	{it:txt}[]               {cmd:txtlen}   char       text table
	{hline 58}

{pstd}
{it:len}, {it:n}, {it:txtlen}, {it:off[]}, and {it:val[]} are encoded per
{it:byteorder}.  The maximum length of a single label within {it:txt}[] is
32,000 characters, or 32,001 including the terminating binary 0.  Stata
ignores labels that exceed the limit.

{pstd}
For example, the {it:value_label_table} for 1<->yes and 2<->no, shown in MSF
format, would be

	byte position:  00 01 02 03   04 05 06 07   08 09 10 11   12 13 14 15
        {hline 69}
	     contents:  00 00 00 02   00 00 00 07   00 00 00 00   00 00 00 04
	      meaning:        {it:n} = 2    {it:txtlen} = 7    {it:off}[0] = 0    {it:off}[1] = 4
        {hline 69}

	byte position:  16 17 18 19   20 21 22 23   24 25 26 27 28 29 30
        {hline 69}
	     contents:  00 00 00 01   00 00 00 02    y  e  s 00  n  o 00
	      meaning:   {it:val}[0] = 1    {it:val}[1] = 2    {it:txt} --->
        {hline 69}

{pstd}
The interpretation is that there are {it:n}=2 values being mapped.
The values being mapped are {it:val}[0]=1 and {it:val}[1]=2.
The corresponding text for {it:val}[0] would be at {it:off}[0]=0
of {it:txt}[]
(and so be "{cmd:yes}") and for {it:val}[1] would be at
{it:off}[1]=4 of {it:txt}[] (and so be "{cmd:no}").

{pstd}
Interpreting this table in C is not as daunting as it appears.  Let
{cmd:(char *) p} refer to the memory area into which {cmd:value_label_table}
is read.  Assume your compiler uses 4-byte {cmd:int}s.  The following
manifests make interpreting the table easier:

	{cmd}#define SZInt               4
	#define Off_n               0
	#define Off_nxtoff          SZInt
	#define Off_off             (SZInt+SZInt)
	#define Off_val(n)          (SZInt+SZInt+n*SZInt)
	#define Off_txt(n)          (Off_val(n) + n*SZInt)
	#define Len_table(n,nxtoff) (Off_txt(n) + nxtoff)

	#define Ptr_n(p)            ( (int *) ( ((char *) p) + Off_n ) )
	#define Ptr_nxtoff(p)       ( (int *) ( ((char *) p) + Off_nxtoff ) )
	#define Ptr_off(p)          ( (int *) ( ((char *) p) + Off_off ) )
	#define Ptr_val(p,n)        ( (int *) ( ((char *) p) + Off_val(n) ) )
	#define Ptr_txt(p,n)        ( (char *) ( ((char *) p) + Off_txt(n) ) ){txt}

{pstd}
It is now the case that {cmd:for(i=0; i < *Ptr_n(p); i++)},
the value {cmd:*Ptr_val(p,i)} is mapped to the character string
{cmd:Ptr_txt(p,i)}.

{pstd}
Remember in allocating memory for {cmd:*p} that the table can be big.  The
limits are {it:n}=65,536 mapped values with each value being up to 32,001
characters long (including the null terminating byte).  There are
{it:n} offsets and {it:n} numeric values in the table, each 4 bytes long.
{it:n} itself is 4 bytes, and {it:txtlen} is 4 bytes.  Such a table would be
2,097,741,832 bytes long ((65536 * (32001 + 4 + 4)) + 4 + 4).
No user is likely to approach that limit, and in
any case, after reading the 8 bytes preceding the table ({it:n} and
{it:txtlen}), you can calculate the remaining length as 2*4*{it:n}+{it:txtlen}
and {cmd:malloc()} the exact amount.

{pstd}
Constructing the table is more difficult.  The easiest approach is to set
arbitrary limits equal to or smaller than Stata's as to the maximum number of
entries and total text length you will allow and simply declare the three
pieces {cmd:off[]}, {cmd:val[]}, and {cmd:txt[]} according to
those limits:

	{cmd}int off[MaxValueForN] ;
	int val[MaxValueForN] ;
	char txt[MaxValueForTxtlen] ;{txt}

{pstd}
Stata's internal code follows a more complicated strategy of always keeping
the table in compressed form and having a routine that will "add one position"
in the table.  This is slower but keeps memory requirements to be no more than
the actual size of the table.

{pstd}
In any case, when adding new entries to the table, remember that {it:val}[]
must be in ascending order:  {it:val}[0] < {it:val}[1] < ... <
{it:val}[{it:n}].

{pstd}
It is not required that {it:off}[] or
{it:txt}[] be kept in ascending order.  We previously offered the example of
the table that mapped 1<->yes and 2<->no:

	byte position:  00 01 02 03   04 05 06 07   08 09 10 11   12 13 14 15
        {hline 69}
	     contents:  00 00 00 02   00 00 00 07   00 00 00 00   00 00 00 04
	      meaning:        {it:n} = 2    {it:txtlen} = 7    {it:off}[0] = 0    {it:off}[1] = 4
        {hline 69}

	byte position:  16 17 18 19   20 21 22 23   24 25 26 27 28 29 30
        {hline 69}
	     contents:  00 00 00 01   00 00 00 02    y  e  s 00  n  o 00
	      meaning:   {it:val}[0] = 1    {it:val}[1] = 2    {it:txt} --->
        {hline 69}

{pstd}
This table could just as well be recorded as

	byte position:  00 01 02 03   04 05 06 07   08 09 10 11   12 13 14 15
        {hline 69}
	     contents:  00 00 00 02   00 00 00 07   00 00 00 03   00 00 00 00
	      meaning:        {it:n} = 2    {it:txtlen} = 7    {it:off}[0] = 3    {it:off}[1] = 0
        {hline 69}

	byte position:  16 17 18 19   20 21 22 23   24 25 26 27 28 29 30
        {hline 69}
	     contents:  00 00 00 01   00 00 00 02    n  o 00  y  e  s 00
	      meaning:   {it:val}[0] = 1    {it:val}[1] = 2    {it:txt} --->
        {hline 69}

{pstd}
but it could not be recorded as

	byte position:  00 01 02 03   04 05 06 07   08 09 10 11   12 13 14 15
        {hline 69}
	     contents:  00 00 00 02   00 00 00 07   00 00 00 04   00 00 00 00
	      meaning:        {it:n} = 2    {it:txtlen} = 7    {it:off}[0] = 4    {it:off}[1] = 0
        {hline 69}

	byte position:  16 17 18 19   20 21 22 23   24 25 26 27 28 29 30
        {hline 69}
	     contents:  00 00 00 02   00 00 00 01    y  e  s 00  n  o 00
	      meaning:   {it:val}[0] = 2    {it:val}[1] = 1    {it:txt} --->
        {hline 69}

{pstd}
It is not the out-of-order values of {it:off}[] that cause problems; it is
out-of-order values of {it:val}[].  In terms of table construction, we find
it easier to keep the table sorted as it grows.  This way one can use a binary
search routine to find the appropriate position in {it:val}[] quickly.

{pstd}
The following routine will find the appropriate slot.  It uses the manifests
we previously defined, and thus it assumes the table is in compressed form, but
that is not important.  Changing the definitions of the manifests to point to
separate areas would be easy enough.

	/*
	    slot = vlfindval(char *baseptr, int val)

	    Looks for value val in label at baseptr.
		If found:
			returns slot number:  0, 1, 2, ...
		If not found:
			returns k<0 such that val would go in slot -(k+1)
				k== -1        would go in slot 0.
				k== -2        would go in slot 1.
				k== -3        would go in slot 2.
	*/

	int vlfindval(char *baseptr, int myval)
	{c -(}
		int	n ;
		int	lb, ub, try ;
		int	*val ;
		char    *txt ;
		int	*off ;
		int	curval ;

		n   = *Ptr_n(baseptr) ;
		val =  Ptr_val(baseptr, n) ;

		if (n==0) return(-1) ;  /* not found, insert into 0 */

					/* in what follows,		   */
					/* we know result between [lb,ub   */
					/* or it is not in the table	   */
		lb = 0 ;
		ub = n - 1 ;
		while (1) {c -(}
			try = (lb + ub) / 2 ;
			curval = val[try] ;
			if (myval == curval) return(try) ;
			if (myval<curval) {c -(}
				ub = try - 1 ;
				if (ub<lb) return(-(try+1)) ;
				/* because want to insert before try, ergo,
			   	want to return try, and transform is -(W+1). */
			{c )-}
			else /* myval>curval */ {c -(}
				lb = try + 1 ;
				if (ub<lb) return(-(lb+1)) ;
				/* because want to insert after try, ergo,
			   	want to return try+1 and transform is -(W+1) */
			{c )-}
		{c )-}
		/*NOTREACHED*/
	{c )-}

