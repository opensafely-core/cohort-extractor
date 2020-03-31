{smcl}
{* *! version 1.1.9  05sep2018}{...}
{vieweralsosee "[M-4] Programming" "mansection M-4 Programming"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-4] Programming} {hline 2}}Programming functions
{p_end}
{p2col:}({mansection M-4 Programming:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 24}Function{col 42}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 43}{c TRC}
{col 5}{hline 3}{c RT}{it: Argument and caller-preference processing }{c LT}{hline}
{col 5}   {c BLC}{hline 43}{c BRC}

{col 7}{bf:{help mf_args:args()}}{...}
{col 24}{cmd:args()}{...}
{col 42}number of arguments

{col 7}{bf:{help mf_isfleeting:isfleeting()}}{...}
{col 24}{cmd:isfleeting()}{...}
{col 42}whether argument is temporary

{col 7}{bf:{help mf_callersversion:callersversion()}}{...}
{col 24}{cmd:callersversion()}{...}
{col 42}obtain version number of caller

{col 7}{bf:{help mf_favorspeed:favorspeed()}}{...}
{col 24}{cmd:favorspeed()}{...}
{col 42}whether speed or space is to be favored

{col 5}   {c TLC}{hline 18}{c TRC}
{col 5}{hline 3}{c RT}{it: Advanced parsing }{c LT}{hline}
{col 5}   {c BLC}{hline 18}{c BRC}

{col 7}{bf:{help mf_tokenget:tokenget()}}{...}
{col 24}{cmd:tokeninit()}{...}
{col 42}initialize parsing environment
{col 24}{cmd:tokeninitstata()}{...}
{col 42}initialize environment as Stata would
{col 24}{cmd:tokenset()}{...}
{col 42}set/reset string to be parsed
{col 24}{cmd:tokengetall()}{...}
{col 42}parse entire string
{col 24}{cmd:tokenget()}{...}
{col 42}parse next element of string
{col 24}{cmd:tokenpeek()}{...}
{col 42}peek at next {cmd:tokenget()} result
{col 24}{cmd:tokenrest()}{...}
{col 42}return yet-to-be-parsed portion
{col 24}{cmd:tokenoffset()}{...}
{col 42}query/reset offset in string
{col 24}{cmd:tokenwchars()}{...}
{col 42}query/reset whitespace characters
{col 24}{cmd:tokenpchars()}{...}
{col 42}query/reset parsing characters
{col 24}{cmd:tokenqchars()}{...}
{col 42}query/reset quote characters
{col 24}{cmd:tokenallownum()}{...}
{col 42}query/reset number parsing
{col 24}{cmd:tokenallowhex()}{...}
{col 42}query/reset hex-number parsing

{col 5}   {c TLC}{hline 21}{c TRC}
{col 5}{hline 3}{c RT}{it: Accessing externals }{c LT}{hline}
{col 5}   {c BLC}{hline 21}{c BRC}

{col 7}{bf:{help mf_findexternal:findexternal()}}{...}
{col 24}{cmd:findexternal()}{...}
{col 42}find global
{col 24}{cmd:crexternal()}{...}
{col 42}create global
{col 24}{cmd:rmexternal()}{...}
{col 42}remove global
{col 24}{cmd:nameexternal()}{...}
{col 42}name of external

{col 7}{bf:{help mf_direxternal:direxternal()}}{...}
{col 24}{cmd:direxternal()}{...}
{col 42}obtain list of existing globals

{col 7}{bf:{help mf_valofexternal:valofexternal()}}{...}
{col 24}{cmd:valofexternal()}{...}
{col 42}obtain value of global

{col 5}   {c TLC}{hline 11}{c TRC}
{col 5}{hline 3}{c RT}{it: Break key }{c LT}{hline}
{col 5}   {c BLC}{hline 11}{c BRC}

{col 7}{bf:{help mf_setbreakintr:setbreakintr()}}{...}
{col 24}{cmd:setbreakintr()}{...}
{col 42}turn off/on break-key interrupt
{col 24}{cmd:querybreakintr()}{...}
{col 42}whether break-key interrupt is off/on
{col 24}{cmd:breakkey()}{...}
{col 42}whether break key has been pressed
{col 24}{cmd:breakkeyreset()}{...}
{col 42}reset break key

{col 5}   {c TLC}{hline 20}{c TRC}
{col 5}{hline 3}{c RT}{it: Associative arrays }{c LT}{hline}
{col 5}   {c BLC}{hline 20}{c BRC}

{col 7}{bf:{help mf_asarray:asarray()}}{...}
{col 24}{cmd:asarray()}{...}
{col 42}store or retrieve element in array
{col 24}{cmd:asarray_*()}{...}
{col 42}utility routines 

{col 7}{bf:{help mf_associativearray:AssociativeArray()}}{...}
{col 42}class interface into {cmd:asarray()}
{col 24}{it:A}{cmd:.put()}{...}
{col 42}store element
{col 24}{it:A}{cmd:.get()}{...}
{col 42}get element
{col 24}etc.

{col 7}{bf:{help mf_hash1:hash1()}}{...}
{col 24}{cmd:hash1()}{...}
{col 42}Jenkins's one-at-a-time hash

{col 5}   {c TLC}{hline 15}{c TRC}
{col 5}{hline 3}{c RT}{it: Miscellaneous }{c LT}{hline}
{col 5}   {c BLC}{hline 15}{c BRC}

{col 7}{bf:{help mf_assert:assert()}}{...}
{col 24}{cmd:assert()}{...}
{col 42}abort execution if not true
{col 24}{cmd:asserteq()}{...}
{col 42}abort execution if not equal

{col 7}{bf:{help mf_c_lc:c()}}{...}
{col 24}{cmd:c()}{...}
{col 42}access c() value

{col 7}{bf:{help mf_sizeof:sizeof()}}{...}
{col 24}{cmd:sizeof()}{...}
{col 42}number of bytes consumed by object

{col 7}{bf:{help mf_swap:swap()}}{...}
{col 24}{cmd:swap()}{...}
{col 42}interchange contents of variables

{* BEGIN timer() is NOT included in the manual; it is undocumented}{...}
{col 7}{bf:{help mf_timer:timer()}}{...}
{col 24}{cmd:timer_clear()}{...}
{col 42}code profiling; clear timers
{col 24}{cmd:timer_on()}{...}
{col 42}start timer
{col 24}{cmd:timer_off()}{...}
{col 42}stop timer
{col 24}{cmd:timer_value()}{...}
{col 42}obtain timer values
{col 24}{cmd:timer()}{...}
{col 42}display time profile report
{* END timer() is NOT included in the manual; it is undocumented}{...}

{col 5}   {c TLC}{hline 13}{c TRC}
{col 5}{hline 3}{c RT}{it: System info }{c LT}{hline}
{col 5}   {c BLC}{hline 13}{c BRC}

{col 7}{bf:{help mf_byteorder:byteorder()}}{...}
{col 24}{cmd:byteorder()}{...}
{col 42}byte order used by computer

{col 7}{bf:{help mf_stataversion:stataversion()}}{...}
{col 24}{cmd:stataversion()}{...}
{col 42}version of Stata being used
{col 24}{cmd:statasetversion()}{...}
{col 42}version of Stata set

{col 5}   {c TLC}{hline 9}{c TRC}
{col 5}{hline 3}{c RT}{it: Exiting }{c LT}{hline}
{col 5}   {c BLC}{hline 9}{c BRC}

{col 7}{bf:{help mf_exit:exit()}}{...}
{col 24}{cmd:exit()}{...}
{col 42}terminate execution

{col 7}{bf:{help mf_error:error()}}{...}
{col 24}{cmd:error()}{...}
{col 42}issue standard Stata error message
{col 24}{cmd:_error()}{...}
{col 42}issue error message with traceback log

{col 5}{hline}
