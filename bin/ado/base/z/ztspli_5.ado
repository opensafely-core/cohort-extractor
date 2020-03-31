*! version 2.0.4  16feb2015
program define ztspli_5
        version 5.0, missing
        zt_is_5

        capt parsoptp 
        if _rc ~= 199 {
                * use parsopt to match on parentheses
                local cmd "`*'"

                * parse at()
                parsoptp at `cmd' 
                local at  "$S_2"        /* at(str) */
                local cmd "$S_3"        /* cmd, with at() removed */

                * parse every()
                parsoptp every `cmd' 
                local every "$S_2"      /* every(str) */
                local cmd   "$S_3"      /* cmd, with every() removed */

                * parse the rest
                local varlist "new req max(1)" 
                local if "opt"
                local in "opt"
                local options "noSHow expr"
                parse "`cmd'"
        }
        else {
                di in bl "Install -parsoptp- if you need real expressions in at/every"
                * standard Stata high-level parsing
                local varlist "new req max(1)" 
                local if "opt"
                local in "opt"
                local options "at(str) every(str) noSHow expr"
                parse "`*'"
        }                                
        
      * verify input
      
        if "`at'`every'" == "" {
            di in re "option { at() | every() } required"
            exit 100
        }                  
      
    quietly {
      
      * scratch  

        tempvar touse tsp v xid it0 it nt
        rename `varlist' `v'
               
      * sample 
      
        mark `touse' `if' `in'
        local N0 = _N
     
      * interface to -st- characteristics

        _st_aux, `show'

        local id : char _dta[st_id]
        local t  : char _dta[st_t]
        local t0 : char _dta[st_t0]
        local d  : char _dta[st_d]

      * regular time splitting t0,t

        quietly compress
        if "`every'" ~= "" {  
                tempname e
                capt gen `e' = `every' if `touse'
                if _rc {
                    di in re "syntax error in `e'"
                    exit 198
                }                    
                capt assert `e' > 0 if `touse'
                if _rc {               
                        di in re "every() should be strictly positive"
                        exit 498
                }
                
                * in which intervals are t0 and t
                * 1 [0,e)  2 [e,2e)  3 [2e,3e) etc
                gen int `it0' = 1 + int(`t0' / `e')         if `touse'
                gen int `it'  = 1 + int((`t' / `e') -1E-10) if `touse'

                * number of intervals [t0,t)
                gen int `nt'  = `it' - `it0' + 1 if `touse'
                gen int `xid' = _n               if `touse'

                * expand
                expn `nt'

                * adapt key-variables
                sort `xid'
                by `xid' : replace `v'  = `it0' + _n - 1 if           `touse'    
                by `xid' : replace `t0' = `e' * (`v'-1)  if _n > 1  & `touse'
                by `xid' : replace `t'  = `e' * `v'      if _n < _N & `touse'
                by `xid' : replace `d'  = 0              if _n < _N & `touse'
        }

      * at() splitting

        else {  
                if "`expr'" == "" {     
                        * -at- should be a _numlist 
                        _numlist `at', real sort 
                        local at  "$S_1"
                }
                else {
                        * -at- is interpreted as a list of expressions
                        tempvar att
                        gen `att' = .  
                }                        

                local nat : word count `at'
                replace `v' = 1 if `touse'
                local i 1
                while `i' <= `nat' {
                        if "`expr'" == "" {
                                local att : word `i' of `at'
                        }
                        else {
                                di in bl "add: test that expressions are increasing"
                                local e : word `i' of `at'
                                capt replace `att' = `e' if `touse'
                                if _rc {
                                    di in re "syntax error in `e'"
                                    exit 198
                                }                                        
                        }                                

                        * which obs to split ?
                        gen byte `tsp' = (`att' > `t0') & (`att' < `t') & `touse'
                        
                        * split records
                        local N  = _N
                        local N1 = _N+1
                        expand =`tsp'+1
                        if _N > `N' {                        
                                replace `t'  = `att' in 1/`N' if `tsp'
                                replace `d'  =   0   in 1/`N' if `tsp'
                                replace `t0' = `att' in `N1'/l
                                replace `v'  = `i'+1 in `N1'/l
                        }                                
                        
                        * adopt TVC for unsplit records
                        replace `v' = `i'+1 if `att' <= `t0' & `touse' & ~`tsp'

                        drop `tsp'
                        local i = `i'+1        
                }
        }

        if `N0' ~= _N {
                noi di _n in gr "number of episodes generated : " in ye =_N-`N0'
        }
        else    noi di _n in bl "no new episode generated!"
        
        rename `v' `varlist' 
    /* end quietly */ }     
end

program define expn
        capt expand = `*'
        if _rc {
                di in re "impossible to expand to split episodes--probably too little memory"
                di in re "hint: drop variables if possible"
                exit 950
        }
end


*! 1.1.0 Jan 03, 1997  Jeroen Weesie/ICS  STB-35 ip14
*     -- added -sort-
*     -- added -format-
*  1.0.0 Apr 96,  Jeroen Weesie/ICS 

program define _numlist

    * ------------------------------------------------------------------------
    * parse off and check options
    * ------------------------------------------------------------------------
    
    parse "`*'", p(",")
    local terms "`1'"
    if "`2'" != "" & "`2'" != "," { 
        exit 198 
    }
    local options "Display MIn(str) MAx(str) Real Sort Format(str)"
    parse ",`3'"

    * type of numbers    
    if "`real'" == "" { 
        local nmbtype "integer" 
    }
    else local nmbtype 

    * restrictions on number of terms    
    if "`min'" != "" { confirm integer number `min' }
    if "`max'" != "" { confirm integer number `max' }
    if "`min'" != "" & "`max'" != "" {
        if `min' > `max' {
            di in re "numlist: invalid (min, max)"
            exit 198
        }
    }

    if "`format'" != "" {
        capture local f : display `format' 1
        if _rc {
            di in re "invalid format `format'"
            exit 120
        }
    }
    
    * ------------------------------------------------------------------------
    * parse the terms
    * ------------------------------------------------------------------------

    global nlist
    parse "`terms'", p(" ")
    while "`1'" != "" {
        local term `1'
        local inc
        local rng2

        * term = number
        *      = number-number
        *      = number-number/number

        * split [term] in [term / inc]
        local pinc = index("`term'","/")
        if `pinc' > 0 {
            local inc = bsubstr("`term'",`pinc'+1,.)
	    confirm `nmbtype' number `inc'
            if `inc' == 0 { 
                di in re "numlist: Increment is zero!"
                exit 198
            }
            local term = bsubstr("`term'", 1, `pinc'-1)
        }

        * check if range is specified
        * beware of trailing -
        local prng = index(bsubstr("`term'",2,.),"-")+1
        if `prng' > 1 {
            local rng1 = bsubstr("`term'",1,`prng'-1)
            local rng2 = bsubstr("`term'",`prng'+1,.)
	    confirm `nmbtype' number `rng1'
	    confirm `nmbtype' number `rng2'
            if "`inc'" == "" { local inc 1 }
            
            local nincr = 1 + /*
              */ int((float(`rng2')-float(`rng1')+1E-6) / float(`inc'))
            if `nincr' <= 0 {
                di in re "range n-m/incr should imply > 0 terms"
                exit 198 
            }

            * loop rng1-rng2/inc
	    while `nincr' > 0 {
                if "`format'" != "" {
                    local f : display `format' `rng1'    
                    local nlist "`nlist'`f' "
                }
                else {
                    local nlist "`nlist'`rng1' "
                }
                local rng1 = `rng1' + `inc'
                local nincr = `nincr' - 1
	    }
        }
        else {
            * no increment expected at this point
            if "`inc'" != "" { 
                di in re "numlist : invalid /" 
                exit 198
            }
	    confirm `nmbtype' number `term'
            local nlist "`nlist'`term' "
        }
        mac shift
    }

    * ------------------------------------------------------------------------
    * sort list in ascending order
    * ------------------------------------------------------------------------

    if "`sort'" != "" {
        capture sortlist "`nlist'", a 
        if _rc {
             di in re "error in sorting. Was -sortlist- installed?"
             exit 198
        }
        local nlist "$S_1"
    }
    
    * ------------------------------------------------------------------------
    * check  min <= #terms <= max
    * ------------------------------------------------------------------------

    local nnl : word count `nlist'

    if "`min'" != ""  {
        if `nnl' < `min' {
            di in re "numlist: at least `min' values required, `nnl' specified"
            exit 198
        }
    }
    if "`max'" != "" {
        if `nnl' > `max' { 
            di in re "numlist: at most `max' values allowed, `nnl' specified"
    	    exit 198
        }
    }

    if "`display'" != "" { di in gr "numlist: " in ye "`nlist'" }
    global S_1 "`nlist'"
    global S_2 "`nnl'"        
end

program define sortlist

    if "`*'" == "" { 
        global S_1
        global S_2    
        exit 
    }

    local key "`1'"   /* list to be sorted */
    local v   "`2'"   /* list to-be-permuted just like key */       
    if "`v'" == "," {
        local v 
        mac shift 1
    }
    else mac shift 2

    local options "Ascending Descending DIsplay"
    parse "`*'"

    local k : word count `key'
    if "`v'" != "" {    
        local nv : word count `v'
        if `nv' != `k' { exit 198 }
        * simulate array access
        local i 1
        while `i' <= `k' {
            local v`i'   : word `i' of `v'
            local key`i' : word `i' of `key'
            confirm number `key`i''
            local i = `i'+1
        }
    }
    else {
        * simulate array access with v = 1,2,3,4...
        local i 1
        while `i' <= `k' {
            local key`i' : word `i' of `key'
            confirm number `key`i''
            local v`i' `i' 
            local v "`v'`v`i'' "
            local i = `i'+1
        }
    }

  * insert-sort sorting order direct
        
    if "`descend'" != "" & "`ascendi'" == "" { 
          local direct ">" 
    }
    else  local direct "<"

    local i 1
    while `i' <= `k' {
        * search mj (index of maximum/minimum of key) among i..k
        local j `i'            
        local mj `j'
        local mkey `key`j''
        while `j' <= `k' {
           if `key`j''  `direct'  `mkey' {
               local mj   `j'
               local mkey `key`j'' 
           }
           local j = `j'+1
        }

        * swap i and mj
        if `i' != `mj' {
           local tmp     `key`i''  
           local key`i'  `key`mj''
           local key`mj' `tmp'

           local tmp     `v`i''  
           local v`i'    `v`mj''
           local v`mj'   `tmp'
        }
        local i = `i'+1
    }                 
    
    * re-assemble -key- into S_1 and -v- into S_2
    global S_1
    global S_2    
    local i 1
    while `i' <= `k' {
        global S_1 "$S_1`key`i'' "        
        global S_2 "$S_2`v`i'' "        
        local i = `i'+1
    }                 

    if "`display'" != "" {    
        di in gr "keys   " in ye "`key'" in gr " -> " in ye "$S_1"
        di in gr "values " in ye "`v'"   in gr " -> " in ye "$S_2"
    }    
end

program define parsoptp
        
        if "`*'" == "" { 
                global S_1
                global S_2
                global S_3
                global S_4
                global S_5
                exit 
        }
                
        local optname "`1'"  /* name of option */
        mac shift
        
        * replaces spaces by a char (space), to put spaces back in later
        if "$S_PCHAR" == "" {
                local space "@"
        }
        else    local space "$S_PCHAR"                
        while "`1'" != "" {
                local input "`input'`1'`space'"
                mac shift
        }
        
        local H 0            /* level of nesting (#opened parenthesis/brackets) */
        local Mode0   "None" /* None, p(arenthesis), b(racket) */        
        local OptFnd  0      /* set to 1 if optname found */
        local ProcOpt 0      /* set to 1 during processing options */
        local ProcArg 0      /* set to 1 during processing args of optname */
        local NonOpt         /* set to input that does not belong to options */
        local Arg            /* set to argument of optname */
        local RestOpt        /* set to options other than optname */
       
        parse "`input'", p("`space'()[],")
        while "`1'" != "" {
                if "`1'" == "," & `H' == 0 {
                        * toggle Options <--> NonOptions
                        local ProcOpt = 1-`ProcOpt'
                }
                else if `ProcOpt'==1 & "`1'" == "`optname'" & `H' == 0 {
                        if `OptFnd' > 0 {
                                di in re "option `optname' occurs more than once"
                                exit 198
                        }                                
                        local OptFnd 1               /* option found */ 
                        if "`2'" == "(" {            
                                mac shift            /* skip option name & "(" */
                               *awkward but necessary if option text exceeds 80 chars
                               *so we can't simply take off enclosing () later on
                                local H = `H'+1      /* push "parenthesis" */
                                local Mode`H' "p"
                                local ProcArg 1      /* options has argument */
                        }
                }
                else {
                        if "`1'" == "(" {
                                local H = `H'+1      /* push "parenthesis" */
                                local Mode`H' "p"
                        }
                        else if "`1'" == "[" {
                                local H = `H'+1      /* push "bracket" */
                                local Mode`H' "b"
                        }
                        else if "`1'" == ")" {
                                if "`Mode`H''" ~= "p" { ErrNest }
                                local H = `H'-1      /* pop previous mode */
                        }
                        else if "`1'" == "]" {
                                if "`Mode`H''" ~= "b" { ErrNest }
                                local H = `H'-1      /* pop previous mode */
                        }
                        else if "`1'" == "`space'" {
                                local 1 " "          /* restore space */
                        }
                                                        
                        * store text in -Arg-, -RestOpt-, or -NonOpt-
                        if `ProcArg' == 1 {
                                if `H' > 0 {
                                        local Arg  "`Arg'`1'" 
                                }
                        }                        
                        else if `ProcOpt' == 1 {
                                local RestOpt "`RestOpt'`1'"
                        }
                        else    local NonOpt  "`NonOpt'`1'"
                                                

                        * end-of-arg reached
                        if `H' == 0 { 
                                local ProcArg 0 
                        }                                
                }
                mac shift
        }                
        if `H' ~= 0 { 
                di in re "too few ')' or ']'" 
                exit 132
        }
        
      * save results
        
        if `OptFnd' > 0 {
                global S_1 "`optname'"
        }                
        else    global S_1
        global S_2 "`Arg'"
        if "`RestOpt'" ~= "" { local c ", " }
        global S_3 "`NonOpt'`c'`RestOpt'"
        global S_4 "`NonOpt'"
        global S_5 "`RestOpt'"
        * di "$S_1/$S_2/$S_3"
end

program define ErrNest
        di in re "too many or mismatching ')' or ']'"
        exit 132
end 
         

program define _st_aux

        local options "noSHow"
        parse "`*'"

        * interface to stset

        local id : char _dta[st_id]
        local t  : char _dta[st_t]
        local t0 : char _dta[st_t0]
        local d  : char _dta[st_d]
        local w  : char _dta[st_w]

        if "`id'" == "" {
                MakeVar "case identification (id)" id caseid CaseID st_id st_ID
                local id "$S_1"
                gen int `id' = _n
                label var `id' "st: case identifier"
                char _dta[st_id] `id'
                local newid 1
        }

        if "`d'" == "" {
                MakeVar "failure variable (died)" died st_d st_died failure status
                local d "$S_1"                
                gen byte `d' = 1
                label var `d' "st: failure/censor identifier"
                char _dta[st_d] `d'
                local newd 1
        }

        if "`t0'" == "" {
                MakeVar "entry times (t0)" t0 etime st_t0 
                local t0 "$S_1"
                gen byte `t0' = 0
                label var `t0' "st: entry times"
                char _dta[st_t0] `t0'
                local newt0 1
        }
        
      * if new variables are generated, display definitions
       
        if "`show'" == "" & "`newid'`newd'`newt0'" ~= "" { 

                di _n in gr "st key variables were created" _n
            
                if "$S_FN" ~= "" {
                        di in gr _col(4) "data set name:  " in ye "$S_FN"
                }
            
                di _col(15) in gr "id:  " in ye _c
                if "`newid'" ~= "" {
                        di "`id'" _col(18) in gr "defined to _n: each record a unique subject"
                }
                else    di "`id'" 
                
                di _col(7) in gr "entry time:  " in ye _c 
                if "`newt0'" ~= "" {
                        di in ye "`t0'" _col(18) in gr "defined to 0, meaning all entered at time 0"
                }
                else    di "`t0'"
            
                di _col(8) in gr "exit time:  " in ye "`t'"

                di _col(3) in gr "failure/censor:  " in ye _c
                if "`newd'" ~= "" {
                        di "`d'" _col(18) in gr "defined to 1, meaning all failed"
                }
                else    di "`d'"
            
                if "`w'" ~= "" {
                        di in gr _col(11) "weight:  " in ye "`w'"
                }
        }
        else {
                zt_sho_5 `show'
        }            
end

* copied from stset (StataCorp)
program define MakeVar /* opname <potential-name-list> */
        local option "`1'"
        mac shift
        local list "`*'"
        while "`1'" ~= "" {
                capture confirm new var `1'
                if _rc == 0 {
                        global S_1 "`1'"
                        exit
                }
                mac shift
        }
        di in red "could not find variable name for `option'"
        di in red "      tried:  `list'"
        di in red "      specify `option' explicitly"
        exit 110
end
