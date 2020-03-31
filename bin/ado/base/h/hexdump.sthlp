{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[D] hexdump" "mansection D hexdump"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] filefilter" "help filefilter"}{...}
{vieweralsosee "[D] type" "help type"}{...}
{viewerjumpto "Syntax" "hexdump##syntax"}{...}
{viewerjumpto "Description" "hexdump##description"}{...}
{viewerjumpto "Links to PDF documentation" "hexdump##linkspdf"}{...}
{viewerjumpto "Options" "hexdump##options"}{...}
{viewerjumpto "The ASCII table" "hexdump##table"}{...}
{viewerjumpto "Examples" "hexdump##examples"}{...}
{viewerjumpto "Stored results" "hexdump##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] hexdump} {hline 2}}Display hexadecimal report on file{p_end}
{p2col:}({mansection D hexdump:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:hexdump}
{it:{help filename}}
[{cmd:,} {it:options}]

{synoptset 12}{...}
{synopthdr}
{synoptline}
{synopt :{opt a:nalyze}}display a report on the dump rather than the dump
itself{p_end}
{synopt :{opt tab:ulate}}display a full tabulation of the ASCII and extended
ASCII characters in the {opt analyze} report{p_end}
{synopt :{opt noex:tended}}do not display printable extended ASCII characters{p_end}
{synopt :{opt res:ults}}store results containing the frequency with which each
character code was observed; programmer's option{p_end}
{synopt :{opt f:rom(#)}}dump or analyze first byte of the file; default is to
start at first byte, {cmd:from(0)}{p_end}
{synopt :{opt t:o(#)}}dump or analyze last byte of the file; default is to
continue to the end of the file{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{opt hexdump} displays a hexadecimal dump of a file or, optionally, a
report analyzing the dump.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D hexdumpRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt analyze} specifies that a report on the dump, rather than the dump
itself, be presented.

{phang}
{opt tabulate} specifies in the {opt analyze} report that a full
tabulation of the ASCII and extended ASCII characters also be presented.

{phang}
{opt noextended} specifies that {opt hexdump} not display printable
extended ASCII characters, characters in the range 161-254 or, equivalently,
0xa1-0xfe.  ({opt hexdump} does not display characters 128-160 and 255.)

{phang}
{opt results} is for programmers.  It specifies that, in addition to
other stored results, {opt hexdump} store {cmd:r(c0)}, {cmd:r(c1)}, ...,
{cmd:r(c255)}, containing the frequency with which each character code was
observed.

{phang}
{opt from(#)} specifies the first byte of the file to be
dumped or analyzed.  The default is to start at the first byte of the file,
{cmd:from(0)}.

{phang}
{opt to(#)} specifies the last byte of the file to be
dumped or analyzed.  The default is to continue to the end of the file.


{marker table}{...}
{title:The ASCII table}

{center:{c TLC}{hline 11}{c TT}{hline 34}{c TT}{hline 24}{c TRC}}
{center:{c |}           {c |}                 we    also       {c |}                        {c |}}
{center:{c |}           {c |}               write  written     {c |}                        {c |}}
{center:{c |} Category  {c |} Decimal  Hex    as     as        {c |} Description            {c |}}
{center:{c LT}{hline 11}{c +}{hline 34}{c +}{hline 24}{c RT}}
{center:{c |} Control   {c |}   000     00    \0     NUL       {c |} null                   {c |}}
{center:{c |} Codes     {c |}   001     01    ^A     SOH       {c |} start of heading       {c |}}
{center:{c |}           {c |}   002     02    ^B     STX       {c |} start of text          {c |}}
{center:{c |}           {c |}   003     03    ^C     ETX       {c |} end of text            {c |}}
{center:{c |}           {c |}   004     04    ^D     EOT       {c |} end of transmission    {c |}}
{center:{c |}           {c |}   005     05    ^E     ENQ       {c |} enquiry                {c |}}
{center:{c |}           {c |}   006     06    ^F     ACK       {c |} acknowledge            {c |}}
{center:{c |}           {c |}   007     07    ^G     BEL       {c |} bell                   {c |}}
{center:{c |}           {c |}   008     08    ^H     BS        {c |} backspace              {c |}}
{center:{c |}           {c |}   009     09    \t     HT  ^I    {c |} horizontal tab         {c |}}
{center:{c |}           {c |}   010     0a    \n     LF  ^J    {c |} line feed, newline     {c |}}
{center:{c |}           {c |}   011     0b    ^K     VT        {c |} vertical tabulation    {c |}}
{center:{c |}           {c |}   012     0c    ^L     FF        {c |} form feed              {c |}}
{center:{c |}           {c |}   013     0d    \r     CR  ^M    {c |} carriage return        {c |}}
{center:{c |}           {c |}   014     0e    ^N     SO        {c |} shift out              {c |}}
{center:{c |}           {c |}   015     0f    ^O     SI        {c |} shift in               {c |}}
{center:{c |}           {c |}   016     10    ^P     DLE       {c |} data link escape       {c |}}
{center:{c |}           {c |}   017     11    ^Q     DC1  XON  {c |} device control 1       {c |}}
{center:{c |}           {c |}   018     12    ^R     DC2       {c |} device control 2       {c |}}
{center:{c |}           {c |}   019     13    ^S     DC3  XOFF {c |} device control 3       {c |}}
{center:{c |}           {c |}   020     14    ^T     DC4       {c |} device control 4       {c |}}
{center:{c |}           {c |}   021     15    ^U     NAK       {c |} negative acknowledge   {c |}}
{center:{c |}           {c |}   022     16    ^V     SYN       {c |} synchronous idle       {c |}}
{center:{c |}           {c |}   023     17    ^W     ETB       {c |} end transmission block {c |}}
{center:{c |}           {c |}   024     18    ^X     CAN       {c |} cancel                 {c |}}
{center:{c |}           {c |}   025     19    ^Y     EM        {c |} end of medium          {c |}}
{center:{c |}           {c |}   026     1a    ^Z     SUB       {c |} substitute             {c |}}
{center:{c |}           {c |}   027     1b    Esc    ESC  ^[   {c |} escape                 {c |}}
{center:{c |}           {c |}   028     1c    28     FS   ^\   {c |} file separator         {c |}}
{center:{c |}           {c |}   029     1d    29     GS   ^]   {c |} group separator        {c |}}
{center:{c |}           {c |}   030     1e    30     RS   ^^   {c |} record separator       {c |}}
{center:{c |}           {c |}   031     1f    31     US   ^_   {c |} unit separator         {c |}}
{center:{c LT}{hline 11}{c +}{hline 34}{c +}{hline 24}{c RT}}
{center:{c |} ASCII     {c |}   032     20    blank  SP        {c |} space                  {c |}}
{center:{c |} printable {c |}   033     21    !                {c |} exclamation point      {c |}}
{center:{c |}           {c |}   034     22    "                {c |} quotation mark         {c |}}
{center:{c |}           {c |}   035     23    #                {c |} number sign            {c |}}
{center:{c |}           {c |}   036     24    $                {c |} dollar sign            {c |}}
{center:{c |}           {c |}   037     25    %                {c |} percent sign           {c |}}
{center:{c |}           {c |}   038     26    &                {c |} ampersand              {c |}}
{center:{c |}           {c |}   039     27    '                {c |} apostrophe             {c |}}
{center:{c |}           {c |}   040     28    (                {c |} opening parenthesis    {c |}}
{center:{c |}           {c |}   041     29    )                {c |} closing parenthesis    {c |}}
{center:{c |}           {c |}   042     2a    )                {c |} closing parenthesis    {c |}}
{center:{c |}           {c |}   043     2b    +                {c |} plus                   {c |}}
{center:{c |}           {c |}   044     2c    ,                {c |} comma                  {c |}}
{center:{c |}           {c |}   045     2d    -                {c |} hyphen                 {c |}}
{center:{c BLC}{hline 11}{c BT}{hline 34}{c BT}{hline 24}{c BRC}}


{marker examples}{...}
{title:Examples}

{phang}{cmd:. hexdump myfile.raw}{p_end}

{phang}{cmd:. hexdump myfile.raw, analyze}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:hexdump, analyze} and {cmd:hexdump, results} store the following in
{cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(Windows)}}number of {cmd:\r\n}{p_end}
{synopt:{cmd:r(Mac)}}number of {cmd:\r} by itself{p_end}
{synopt:{cmd:r(Unix)}}number of {cmd:\n} by itself{p_end}
{synopt:{cmd:r(blank)}}number of blanks{p_end}
{synopt:{cmd:r(tab)}}number of tab characters{p_end}
{synopt:{cmd:r(comma)}}number of comma (,) characters{p_end}
{synopt:{cmd:r(ctl)}}number of binary 0s; A-Z, excluding {cmd:\r}, {cmd:\n},
{cmd:\t}; DELs; and 128-159, 255{p_end}
{synopt:{cmd:r(uc)}}number of A-Z{p_end}
{synopt:{cmd:r(lc)}}number of a-z{p_end}
{synopt:{cmd:r(digit)}}number of 0-9{p_end}
{synopt:{cmd:r(special)}}number of printable special characters (!@#, etc.){p_end}
{synopt:{cmd:r(extended)}}number of printable extended characters (160-254){p_end}
{synopt:{cmd:r(filesize)}}number of characters{p_end}
{synopt:{cmd:r(lmin)}}minimum line length{p_end}
{synopt:{cmd:r(lmax)}}maximum line length{p_end}
{synopt:{cmd:r(lnum)}}number of lines{p_end}
{synopt:{cmd:r(eoleof)}}1 if EOL at EOF, 0 otherwise{p_end}
{synopt:{cmd:r(l1)}}length of 1st line{p_end}
{synopt:{cmd:r(l2)}}length of 2nd line{p_end}
{synopt:{cmd:r(l3)}}length of 3rd line{p_end}
{synopt:{cmd:r(l4)}}length of 4th line{p_end}
{synopt:{cmd:r(l5)}}length of 5th line{p_end}
{synopt:{cmd:r(c0)}}number of binary 0s ({cmd:results} only){p_end}
{synopt:{cmd:r(c1)}}number of binary 1s ({cmd:^A}) ({cmd:results} only){p_end}
{synopt:{cmd:r(c2)}}number of binary 2s ({cmd:^B}) ({cmd:results} only){p_end}
{synopt:...}...{p_end}
{synopt:{cmd:r(c255)}}number of binary 255s ({cmd:results} only){p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(format)}}{cmd:ASCII}, {cmd:EXTENDED ASCII}, or {cmd:BINARY}{p_end}
{p2colreset}{...}
