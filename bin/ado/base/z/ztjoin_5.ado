*! version 1.0.3  16feb2015
program define ztjoin_5
   version 5.0

   zt_is_5

   local varlist "opt exist"
   local options "noSHow Keep eps(real 0)"
   parse "`*'"
                     
 * interface with st key-variables
            
   local id : char _dta[st_id]
   local t  : char _dta[st_t]
   local t0 : char _dta[st_t0]
   local d  : char _dta[st_d]
   local wv : char _dta[st_wv]

   if "`t0'" == "" | "`id'" == "" | "`d'" == "" { 
      di in bl "stjoin requires that entry times (t0), case identifier (id), and" /*
         */ _n "a failure/censor indicator (dead) are specified"
      exit 
   }

   zt_sho_5 `show'
        
 quietly {        
    
   * scratch
      
   tempvar gap ival nrec0 nrec1 vpat

   * pattern in variables of -varlist-
   * here, missing values should be treated as "normal" values
        
   egen `vpat' = group(`varlist'), missing

   * count number of episodes per "subject"
        
   sort `id' `t'
   by `id' : gen `c(obs_t)' `nrec0' = _N 
   local Nrec0 = _N

   * check whether subsequent risk episodes have gaps
   *       t0(current) - t(prev) > eps
   *       died(prev) != 0
   *       varlist(current) != varlist(prev)
        
   by `id' : gen byte `gap' = cond(_n==1, 0, /*
      */  (`t'[_n-1]-`t0')>`eps' | `d'[_n-1]!=0 | `vpat'[_n-1]!=`vpat')

   capture by `id': assert `gap' == 1 if _n>1
   if !_rc {
      noi di in bl "No episodes can be joined, data unchanged"
      exit
   }
        
   * only keep relevant variables
   
   if "`keep'" != "" {
      keep `id' `t0' `t' `d' `wv' `varlist' `gap' `nrec0'             
   }                
        
   * (id,ival) identifies episodes-to-be-joined
      
   by `id' : gen int `ival' = sum(`gap')
        
   * join them!
      
   sort `id' `ival' `t'
   by `id' `ival' : replace `t' = `t'[_N] if _n==1
   by `id' `ival' : replace `d' = `d'[_N] if _n==1
   by `id' `ival' : drop if _n > 1

   * report number of cases/intervals affected
      
   by `id': gen `c(obs_t)' `nrec1' = _N if _n==1 
   local Nrec1 = _N
   if `Nrec0' > `Nrec1' {
      count if `nrec0' > `nrec1'
      noi di _n in ye =(`Nrec0'-`Nrec1') in gr /*
         */ " episodes joined in " in ye _result(1) in gr " cases"
   }                
   else noi di in gr "No episodes could be joined"
        
 } /* end quietly */
end

