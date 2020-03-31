*! version 1.0.0  08mar2000
program define bip0_lf
        version 6.0
        local ll    "`1'"  /* Log l */
        local xb1   "`2'"  /* x1*b1 */
        local xb2   "`3'"  /* x2*b2 */


        quietly {
                replace `ll' = binorm(`xb1',`xb2', 0)
                replace `ll' = 1-`ll' if $ML_y1 == 0
                replace `ll' = log(`ll')
        }

end
