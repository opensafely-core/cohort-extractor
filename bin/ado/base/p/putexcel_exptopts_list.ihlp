{* *! version 1.0.1  30nov2015}{...}
{synopt :{opt overwr:itefmt}}overwrite existing cell formatting when
exporting new content{p_end}

{synopt :{opt asdate}}convert Stata date ({cmd:%td}-formatted) {it:exp} to an
Excel date{p_end}
{synopt :{opt asdatetime}}convert Stata datetime ({cmd:%tc}-formatted)
{it:exp} to an Excel datetime{p_end}
{synopt :{opt asdatenum}}convert Stata date
{it:exp} to an Excel date number, preserving the cell's format{p_end}
{synopt :{opt asdatetimenum}}convert Stata datetime
{it:exp} to an Excel datetime number, preserving the cell's format{p_end}

{synopt :{opt names}}also write row names and column names for matrix {it:name}; may 
not be combined with {cmd:rownames} or {cmd:colnames}{p_end}
{synopt :{opt rownames}}also write matrix row names for matrix {it:name}; 
may not be combined with {cmd:names} or {cmd:colnames}{p_end}
{synopt :{opt colnames}}also write matrix column names for matrix {it:name}; 
may not be combined with {cmd:names} or {cmd:rownames}{p_end}

{synopt :{opt colw:ise}}write results in {it:returnset} to consecutive columns
instead of rows{p_end}
