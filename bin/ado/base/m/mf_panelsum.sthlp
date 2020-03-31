{smcl}
{* *! version 1.0.2  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_panelsum##syntax"}{...}
{viewerjumpto "Description" "mf_panelsum##description"}{...}
{viewerjumpto "Conformability" "mf_panelsum##conformability"}{...}
{viewerjumpto "Source code" "mf_panelsum##source"}{...}
{title:Title}

{p 4 8 2}
{bf:[M-5] panelsum()} {hline 2} Panel sums


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:real matrix} = 
{cmd:panelsum(}{it:X}{cmd:,}
[{it:weights}{cmd:,}]
{it:info}{cmd:)}

{p 4 4 2}
where

	    {it:X}:  {it:real} {it:matrix}, possibly a view
      {it:weights}:  {it:real colvector}
         {it:info}:  {it:real matrix}, from {helpb mf_panelsetup:panelsetup()}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:panelsum()} computes within-panel sums of the columns of {it:X}
according to the panel information in {it:info}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:panelsum(}{it:X}{cmd:,} 
{it:weights}{cmd:,} 
{it:info}{cmd:)}:
{p_end}
		{it:X}:  {it:r x c}
	  {it:weights}:  r {it:x} 1    (optional)
	     {it:info}:  {it:K x} 2, {it:K} = number of panels
	   {it:result}:  {it:K x c}


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
