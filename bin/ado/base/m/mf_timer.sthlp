{smcl}
{* *! version 1.1.3  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] timer" "help timer"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_timer##syntax"}{...}
{viewerjumpto "Description" "mf_timer##description"}{...}
{viewerjumpto "Remarks" "mf_timer##remarks"}{...}
{viewerjumpto "Conformability" "mf_timer##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_timer##diagnostics"}{...}
{viewerjumpto "Source code" "mf_timer##source"}{...}
{title:Title}

{p 4 8 2}
{bf:[M-5] timer()} {hline 2} Profile code


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:          }
{cmd:timer_clear()}

{p 8 12 2}
{it:void}{bind:          }
{cmd:timer_clear(}{it:real scalar t}{cmd:)}


{p 8 12 2}
{it:void}{bind:          }
{cmd:timer_on(}{it:real scalar t}{cmd:)}

{p 8 12 2}
{it:void}{bind:          }
{cmd:timer_off(}{it:real scalar t}{cmd:)}


{p 8 12 2}
{it:real rowvector}
{cmd:timer_value(}{it:real scalar t}{cmd:)}


{p 8 12 2}
{it:void}{bind:          }
{cmd:timer()}

{p 8 12 2}
{it:void}{bind:          }
{cmd:timer(}{it:real t}{cmd:)}

{p 8 12 2}
{it:void}{bind:          }
{cmd:timer(}{it:string scalar txt}{cmd:)}

{p 8 12 2}
{it:void}{bind:          }
{cmd:timer(}{it:real t}{cmd:,}
{it:string scalar txt}{cmd:)}

{p 8 12 2}
{it:void}{bind:          }
{cmd:timer(}{it:string scalar txt}{cmd:,}
{it:real t}{cmd:)}


{p 4 8 2}
where {it:t} is a timer number, 1 through 100.

{p 4 8 2}
For {cmd:timer()}, zero, one, or two arguments are allowed, and
    arguments may be specified in any order.  Argument {it:t} may be omitted,
    specified as a {it:scalar}, or specified as a {it:vector}:

{p 8 8 2}
    If {it:t} is omitted, all timers are reported.

{p 8 8 2}
    If {it:t} is a {it:scalar}, the specified timer is reported
    ({cmd:timer(.)} is the same as omitting {it:t}; all timers are reported).

{p 8 8 2}
    If {it:t} is a {it:rowvector}, the specified timers are reported.

{p 8 8 2}
    If {it:t} is a {it:colvector}, it must be 2 {it:x} 1, and the 
    timers in the range are reported.

{p 4 8 2}
For {cmd:timer_clear()}, {it:t} may be omitted or specified as a scalar:

{p 8 8 2}
    If {it:t} is omitted, all timers are cleared.

{p 8 8 2}
    If {it:t} is a {it:scalar}, the specified timer is cleared unless
    {it:t} is specified as missing, in which case the result is the 
    same as if {it:t} had been omitted; all timers are cleared.

{p 4 8 2}
In the other functions, {it:t} is a scalar and may not contain missing values.


{marker description}{...}
{title:Description}

{p 4 4 2}
Stata provides a set of 100 timers, numbered from 1 to 100, for profiling
code; see {helpb timer:[P] timer}.  These functions provide an interface into
those timers.

{p 4 4 2}
{cmd:timer_clear()} clears (resets to zero) all timers or the specified timer.

{p 4 4 2}
{cmd:timer_on(}{it:t}{cmd:)} turns on (restarts) timer {it:t}.  

{p 4 4 2}
{cmd:timer_off(}{it:t}{cmd:)} turns off (stops) timer {it:t}.  

{p 4 4 2}
{cmd:timer_value(}{it:t}{cmd:)} returns a 1 {it:x} 2 vector summarizing 
the contents of timer {it:t}.
The first element is the cumulative time in seconds
that the timer has been on, and the second element is the number of times 
the timer has been started and stopped.  

{p 4 4 2}
{cmd:timer()} displays a timer report showing cumulative time, 
the number of times the timer has been started and stopped, and the 
average time (first divided by second).
{cmd:timer()} allows two optional arguments:  {it:txt} and {it:t}, and 
they may be specified in either order.
{it:txt}, if specified, is used to title the report.
{it:t}, if specified, specifies the timers to be reported.
The default is to report all timers that have been turned on and off 
at least once.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
To obtain accurate timings, you must run whatever code you wish to profile
more than once.  In the example below, we run {cmd:subroutine_to_be_timed()}
100,000 times.

	{cmd}timer_clear()
	for (i=1; i<=100000; i++) {
		timer_on(1)
		subroutine_to_be_timed()
		timer_off(1)
	}
	timer(){txt}


{p 4 4 2}
{cmd:subroutine_to_be_timed()} might use other timers to profile parts of
itself:

	{cmd}function subroutine_to_be_timed()
	{
		...
		for ({txt...}) {
			...
			timer_on(2)
			...
			timer_off(2)
		}

		...

		timer_on(3)
		...
		timer_off(3)
	}{txt}

{p 4 4 2}
The result of running this experiment, as reported by {cmd:timer()}, might be

	{cmd}{hline 40}
	timer report
          1.     511.21 /   100000 =  .0051121
          2.       5.89 /   100000 =  .0000589
          3.     505.31 /   100000 =  .0050531
	{hline 40}{txt}

{p 4 4 2}
Each execution of {cmd:subroutine_to_be_timed()} requires 0.005 seconds, 
and the bulk of that time is spent in the second part of the code.
No matter how inefficient you thought the first part of the code was, 
improving it will make little difference in the overall execution time.


{marker conformability}{...}
{title:Conformability}

    {cmd:timer_clear(}{it:t}{cmd:)}:
		{it:t}:  1 {it:x} 1  (optional)
	   {it:result}:  {it:void}

    {cmd:timer_on(}{it:t}{cmd:)}, {cmd:timer_off(}{it:t}{cmd:)}:
		{it:t}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:timer_value(}{it:t}{cmd:)}:
		{it:t}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 2

    {cmd:timer(}{it:t}{cmd:,}{it:txt}{cmd:)}, {cmd:timer(}{it:txt}{cmd:,}{it:t}{cmd:)}: 
	      {it:txt}:  1 {it:x 1}                (optional)
		{it:t}:  1 {it:x} 1, 1 {it:x r}, 2 {it:x} 1  (optional)
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.

{p 4 4 2}
Timer resolution varies across computers but is at least .01 seconds.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view timer.mata, adopath asis:timer.mata}; other functions are built in.
{p_end}
