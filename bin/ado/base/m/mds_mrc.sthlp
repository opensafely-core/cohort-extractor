{smcl}
{* *! version 1.0.3  11feb2011}{...}
{* Return codes reported by {cmd:mds}, {cmd:mdsmat}, and {cmd:mdslong} with {cmd:protect()}}{...}
{vieweralsosee "[MV] mds" "help mds"}{...}
{vieweralsosee "[MV] mdslong" "help mdslong"}{...}
{vieweralsosee "[MV] mdsmat" "help mdsmat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mds postestimation" "help mds_postestimation"}{...}
{title:Return codes reported in output for {cmd:protect()} runs}
 
{p2colset 2 15 18 2}{...}
{p2coldent:{cmd:mrc}{space 3}{cmd:r()}}Description{p_end}
{p2line}
{p2coldent:0{space 6}0}convergence achieved{p_end}
{p2col:+ 1{space 4}430}convergence not achieved; tolerance criterion failed{p_end}
{p2col:+ 2{space 4}430}convergence not achieved; ltolerance criterion failed{p_end}
{p2col:+ 3{space 4}430}convergence not achieved; both tolerance and ltolerance
	criteria failed{p_end}
{p2coldent:4{space 4}498}classical MDS failed: eigenvalues too close;
	could not compute initial values{p_end}
{p2coldent:5{space 4}498}classical MDS failed: all eigenvalues too close to 0;
	could not compute initial values{p_end}
{p2coldent:6{space 4}498}loss could not be computed or is missing{p_end}
{p2coldent:7{space 4}498}gradient of loss could not be computed or is
	missing{p_end}
{p2coldent:8{space 4}498}stepsize determination failed{p_end}
{p2coldent:9{space 4}498}transformation to disparities failed{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}{cmd:mrc} is the intermediate return code reported in the tabular output{p_end}
{p 4 6 2}
{cmd:r()} is the corresponding return code from
{cmd:mds}, {cmd:mdslong} or {cmd:mdsmat}{p_end}
{p 4 6 2}+ In the case where convergence is not achieved, an error message is
displayed with the output to the command, {cmd:r(0)} is returned and
{cmd:e(rc)} is set to 430.  This is the procedure used by commands that
use maximum likelihood estimation when convergence is not achieved.{p_end}
