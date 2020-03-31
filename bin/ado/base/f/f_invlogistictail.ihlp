{* *! version 1.0.1  02mar2015}{...}
    {cmd:invlogistictail(}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse reverse cumulative logistic distribution:
if {cmd:logistictail(}{it:x}{cmd:)} = {it:p}, then
{cmd:invlogistictail(}{it:p}{cmd:)} = {it:x}{p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}-8e+307 to 8e+307{p_end}
{p2colreset}{...}

    {cmd:invlogistictail(}{it:s}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse reverse cumulative logistic distribution:
if {cmd:logistictail(}{it:s}{cmd:,}{it:x}{cmd:)} = {it:p}, then
{cmd:invlogistictail(}{it:s}{cmd:,}{it:p}{cmd:)} = {it:x}{p_end}
{p2col: Domain {it:s}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}-8e+307 to 8e+307{p_end}
{p2colreset}{...}

    {cmd:invlogistictail(}{it:m}{cmd:,}{it:s}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse reverse cumulative logistic distribution:
if {cmd:logistictail(}{it:m}{cmd:,}{it:s}{cmd:,}{it:x}{cmd:)} = {it:p}, then
{cmd:invlogistictail(}{it:m}{cmd:,}{it:s}{cmd:,}{it:p}{cmd:)} = {it:x}{p_end}
{p2col: Domain {it:m}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:s}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}-8e+307 to 8e+307{p_end}
{p2colreset}{...}
