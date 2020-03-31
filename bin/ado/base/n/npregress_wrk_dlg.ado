*! version 1.0.2  02may2017
program define npregress_wrk_dlg, sclass
        syntax varlist(fv numeric)
        fvexpand `varlist'
        local newvars = r(varlist)
        local k: list sizeof newvars
        local finalvars ""
        forvalues i=1/`k' {
                local x: word `i' of `newvars'
                _ms_parse_parts `x'
                local name = r(name)
                local finalvars "`finalvars' `name'"
        }
        local finalvars: list uniq finalvars
        sreturn local finalvars `"`finalvars'"'
end
