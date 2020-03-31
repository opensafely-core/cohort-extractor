{smcl}
{* *! version 2.3.10  11oct2019}{...}
{viewerdialog query "dialog query"}{...}
{vieweralsosee "[R] query" "mansection R query"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[M-3] mata set" "help mata set"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "query##syntax"}{...}
{viewerjumpto "Description" "query##description"}{...}
{viewerjumpto "Links to PDF documentation" "query##linkspdf"}{...}
{viewerjumpto "Example" "query##example"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] query} {hline 2}}Display system parameters{p_end}
{p2col:}({mansection R query:View complete PDF manual entry}){p_end}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmdab:q:uery} [ {opt mem:ory} | {opt out:put} |
		{opt inter:face} | {opt graph:ics} |
		{opt net:work} | {opt up:date} |
		{opt trace} | {opt mata} | {opt java} | {opt putdocx} |
		{opt python} | {opt random} | {opt unicode} | {opt oth:er} ]


{col 16}For information on ...{col 47}See ...
               {hline 49}
{col 16}Memory settings
{center:{cmd:set maxvar}                   {help memory}              }
{center:{cmd:set niceness}                 {help memory}              }
{center:{cmd:set max_memory}               {help memory}              }
{center:{cmd:set min_memory}               {help memory}              }
{center:{cmd:set segmentsize}              {help memory}              }
{center:{cmd:set adosize}                  {help adosize}             }
{center:{cmd:set max_preservemem}          {help preserve}            }

{col 16}Output settings
{center:{cmd:set more}                     {help more}                }
{center:{cmd:set rmsg}                     {help rmsg}                }
{center:{cmd:set dp}                       {help format}              }
{center:{cmd:set linesize}                 {help log}                 }
{center:{cmd:set pagesize}                 {help more}                }
{center:{cmd:set iterlog}                  {help set iter}            }
{center:{cmd:set level}                    {help level}               }
{center:{cmd:set clevel}                   {help clevel}              }
{center:{cmd:set showbaselevels}           {help set showbaselevels}  }
{center:{cmd:set showemptycells}           {help set showbaselevels}  }
{center:{cmd:set showomitted}              {help set showbaselevels}  }
{center:{cmd:set fvlabel}                  {help set showbaselevels}  }
{center:{cmd:set fvwrap}                   {help set showbaselevels}  }
{center:{cmd:set fvwrapon}                 {help set showbaselevels}  }
{center:{cmd:set lstretch}                 {help lstretch}            }
{center:{cmd:set cformat}                  {help set cformat}         }
{center:{cmd:set pformat}                  {help set cformat}         }
{center:{cmd:set sformat}                  {help set cformat}         }
{center:{cmd:set coeftabresults}           {help set coeftabresults}  }
{center:{cmd:set dots}                     {help set dots}            }
{center:{cmd:set logtype}                  {help log}                 }
{center:{cmd:set notifyuser}               {help notifyuser}          }
{center:{cmd:set playsnd}                  {help playsnd}             }
{center:{cmd:set include_bitmap}           {help include_bitmap}      }

{col 16}Interface settings
{center:{cmd:set dockable}                 {help dockable}            }
{center:{cmd:set floatwindows}             {help floatwindows}        }
{center:{cmd:set locksplitters}            {help locksplitters}       }
{center:{cmd:set pinnable}                 {help pinnable}            }
{center:{cmd:set doublebuffer}             {help doublebuffer}        }
{center:{cmd:set revkeyboard}              {help varkeyboard}         }
{center:{cmd:set varkeyboard}              {help varkeyboard}         }
{center:{cmd:set smoothfonts}              {help smoothfonts}         }
{center:{cmd:set linegap}                  {help linegap}             }
{center:{cmd:set scrollbufsize}            {help scrollbufsize}       }
{center:{cmd:set fastscroll}               {help fastscroll}          }
{center:{cmd:set reventries}               {help reventries}          }
{center:{cmd:set maxdb}                    {help db}                  }

{col 16}Graphics settings
{center:{cmd:set graphics}                 {help set graphics}        }
{center:{cmd:set autotabgraphs}            {help autotabgraphs}       }
{center:{cmd:set scheme}                   {help set scheme}          }
{center:{cmd:set printcolor}               {help set printcolor}      }
{center:{cmd:set copycolor}                {help set printcolor}      }
{center:{cmd:set maxbezierpath}            {help maxbezierpath}       }

{col 16}Network settings
{center:{cmd:set checksum}                 {help checksum}            }
{center:{cmd:set timeout1}                 {help netio}               }
{center:{cmd:set timeout2}                 {help netio}               }
{center:{cmd:set httpproxy}                {help netio}               }
{center:{cmd:set httpproxyhost}            {help netio}               }
{center:{cmd:set httpproxyport}            {help netio}               }
{center:{cmd:set httpproxyauth}            {help netio}               }
{center:{cmd:set httpproxyuser}            {help netio}               }
{center:{cmd:set httpproxypw}              {help netio}               }

{col 16}Update settings
{center:{cmd:set update_query}             {help update}              }
{center:{cmd:set update_interval}          {help update}              }
{center:{cmd:set update_prompt}            {help update}              }

{col 16}Trace settings
{center:{cmd:set trace}                    {help trace}               }
{center:{cmd:set tracedepth}               {help trace}               }
{center:{cmd:set traceexpand}              {help trace}               }
{center:{cmd:set tracesep}                 {help trace}               }
{center:{cmd:set traceindent}              {help trace}               }
{center:{cmd:set tracenumber}              {help trace}               }
{center:{cmd:set tracehilite}              {help trace}               }

{col 16}Mata settings
{center:{cmd:set matastrict}               {help mata set}            }
{center:{cmd:set matalnum}                 {help mata set}            }
{center:{cmd:set mataoptimize}             {help mata set}            }
{center:{cmd:set matafavor}                {help mata set}            }
{center:{cmd:set matacache}                {help mata set}            }
{center:{cmd:set matalibs}                 {help mata set}            }
{center:{cmd:set matamofirst}              {help mata set}            }

{col 16}Java settings
{center:{cmd:set java_heapmax}             {help java_utilities}      }
{center:{cmd:set java_home}                {help java_utilities}      }

{col 16}putdocx settings
{center:{cmd:set docx_hardbreak}           {help set docx}            }
{center:{cmd:set docx_paramode}            {help set docx}            }

{col 16}Python settings
{center:{cmd:set python_exec}              {help python}              }
{center:{cmd:set python_userpath}          {help python}              }

{col 16}Random settings
{center:{cmd:set rng}                      {help set rng}             }
{center:{cmd:set rngstate}                 {help set rngstate}        }
{center:{cmd:set rngstream}		   {help set rngstream}       }

{col 16}Unicode settings
{center:{cmd:set locale_functions}         {help set locale_functions}}
{center:{cmd:set locale_ui}                {help set locale_ui}       }

{col 16}Other settings
{center:{cmd:set type}                     {help generate}            }
{center:{cmd:set maxiter}                  {help set iter}            }
{center:{cmd:set searchdefault}            {help search}              }
{center:{cmd:set varabbrev}                {help varabbrev}           }
{center:{cmd:set emptycells}               {help emptycells}          }
{center:{cmd:set fvtrack}                  {help set fvtrack}         }
{center:{cmd:set fvbase}                   {help set fvbase}          }
{center:{cmd:set processors}               {help processors}          }
{center:{cmd:set odbcmgr}                  {help odbc}                }
{center:{cmd:set odbcdriver}               {help odbc}                }
{center:{cmd:set haverdir}                 {help import haver}        }
{center:{cmd:set fredkey}                  {help import fred}         }
               {hline 49}


{marker description}{...}
{title:Description}

{pstd}
{cmd:query} displays the settings of various Stata parameters.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R queryRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{phang}
Show memory settings only
{p_end}
{phang2}{cmd:. query memory}{p_end}

{phang}
Show all settings
{p_end}
{phang2}{cmd:. query}{p_end}
