*! version 1.0.2  20jan2015 
program parse_dissim, sclass
	version 8

* parse_dissim -- similarity/dissimilarity option parsing
*
*   { L1 | absolute | manhattan | cityblock | L2 | euclidean | L2squared |
*     Linfinity | maximum | L(#) | Lpower(#) | angle | angular | correlation |
*     Canberra | matching | Jaccard | Russell | Hamann | Dice | antiDice |
*     Rogers | Sneath | Yule | Ochiai | Anderberg | Kulczynski | Gower2 |
*     Pearson | Gower }
*
* Synonyms:  L1 = L(1) = absolute = manhattan = cityblock = Lpower(1)
*            L2 = L(2) = euclidean        (the usual default)
*            L2squared = Lpower(2)        (sometimes the default)
*            Linfinity = maximum
*	     angular = angle
*	     Hamann = Hamman      (Hamman is an allowed misspelling)
*
* Returns: s(dist)   = selected (dis)similarity (with synonyms resolved)
*          s(darg)   = numeric argument for L() option
*          s(unab)   = the (dis)similarity they specified unabbreviated (no
*                      synonym resolution)
*          s(dtype)  = the word "dissimilarity" or "similarity" to indicate if
*                      larger or smaller numbers indicate larger distance.
*          s(drange) = range of measure (from match to mismatch).  A dot means
*                      infinity.
*          s(binary) = the word "binary" if the measure is designed only for
*                      binary variables.
*
* Important note for StataCorp developers: if you add measures or add/change
* aliases you should also edit the prsedist() routine in C code.
*

	sreturn clear
	syntax [anything(name=distance id="(dis)similarity measure")] ///
							[, default(str) ]

	if `"`distance'"' == "" {  // determine default
		if "`default'" == "" { // default default is Euclidean == L2
			sreturn local dist L2
			sreturn local unab L2
			sreturn local dtype dissimilarity
			sreturn local drange 0 .
		}
		else { // recursively call using default() as main arg
			parse_dissim `default'
		}
		exit
	}

	gettoken dist stuff : distance , parse(" ()") match(parens)
	local dist = trim(lower(`"`dist'"'))
	local dlen = length(`"`dist'"')

/* L(#) */
	if `"`dist'"' == "l" {
		local 0 `", x`stuff'"'
		capture syntax , x(numlist max=1 >=1)
		if _rc {
			di as err "invalid (dis)similarity option"
			exit 198
		}
	/* L(1) --> L1 */
		if float(`x') == float(1) {
			sreturn local dist L1
			sreturn local unab "L(1)"
			sreturn local dtype dissimilarity
			sreturn local drange 0 .
			exit
		}
	/* L(2) --> L2 */
		if float(`x') == float(2) {
			sreturn local dist L2
			sreturn local unab "L(2)"
			sreturn local dtype dissimilarity
			sreturn local drange 0 .
			exit
		}
	/* L(#) */
		sreturn local dist L
		sreturn local darg `"(`x')"'
		sreturn local unab `"L(`x')"'
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}

/* Lpower(#) */
	if `"`dist'"' == bsubstr("lpower",1,max(4,`dlen')) {
		local 0 `", x`stuff'"'
		capture syntax , x(numlist max=1 >=1)
		if _rc {
			di as err "invalid (dis)similarity option"
			exit 198
		}
	/* Lpower(1) --> L1 */
		if float(`x') == float(1) {
			sreturn local dist L1
			sreturn local unab Lpower(1)
			sreturn local dtype dissimilarity
			sreturn local drange 0 .
			exit
		}
	/* Lpower(2) --> L2squared */
		if float(`x') == float(2) {
			sreturn local dist L2squared
			sreturn local unab Lpower(2)
			sreturn local dtype dissimilarity
			sreturn local drange 0 .
			exit
		}
	/* Lpower(#) */
		sreturn local dist Lpower
		sreturn local darg `"(`x')"'
		sreturn local unab `"Lpower(`x')"'
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}


	/* The remaining distance options do not take arguments */
	if `"`stuff'"' != "" {
		di as err "invalid (dis)similarity option"
		exit 198
	}

/* euclidean --> L2 */
	if `"`dist'"' == bsubstr("euclidean",1,max(3,`dlen')) {
		sreturn local dist L2
		sreturn local unab "Euclidean"
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}
/* L2 */
	if `"`dist'"' == "l2" {
		sreturn local dist L2
		sreturn local unab L2
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}
/* L2squared */
	if `"`dist'"' == "l2squared" {
		sreturn local dist L2squared
		sreturn local unab L2squared
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}
/* absolute --> L1 */
	if `"`dist'"' == bsubstr("absolute",1,max(3,`dlen')) {
		sreturn local dist L1
		sreturn local unab absolute
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}
/* manhattan --> L1 */
	if `"`dist'"' == bsubstr("manhattan",1,max(6,`dlen')) {
		sreturn local dist L1
		sreturn local unab Manhattan
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}
/* cityblock --> L1 */
	if `"`dist'"' == bsubstr("cityblock",1,max(5,`dlen')) {
		sreturn local dist L1
		sreturn local unab cityblock
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}
/* L1 */
	if `"`dist'"' == "l1" {
		sreturn local dist L1
		sreturn local unab L1
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}
/* maximum --> Linf */
	if `"`dist'"' == bsubstr("maximum",1,max(3,`dlen')) {
		sreturn local dist Linfinity
		sreturn local unab maximum
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}
/* Linfinity --> Linf */
	if `"`dist'"' == bsubstr("linfinity",1,max(4,`dlen')) {
		sreturn local dist Linfinity
		sreturn local unab Linfinity
		sreturn local dtype dissimilarity
		sreturn local drange 0 .
		exit
	}
/* Canberra */
	if `"`dist'"' == bsubstr("canberra",1,max(4,`dlen')) {
		sreturn local dist Canberra
		sreturn local unab Canberra
		sreturn local dtype dissimilarity
		/* We say . for upper range -- it really is # of variables */
		sreturn local drange 0 .
		exit
	}
/* Correlation */
	if `"`dist'"' == bsubstr("correlation",1,max(4,`dlen')) {
		sreturn local dist correlation
		sreturn local unab correlation
		sreturn local dtype similarity
		sreturn local drange 1 -1
		exit
	}
/* angular */
	if `"`dist'"' == bsubstr("angular",1,max(3,`dlen')) {
		sreturn local dist angular
		sreturn local unab angular
		sreturn local dtype similarity
		sreturn local drange 1 -1
		exit
	}
/* angle --> angular */
	if `"`dist'"' == bsubstr("angle",1,max(3,`dlen')) {
		sreturn local dist angular
		sreturn local unab angle
		sreturn local dtype similarity
		sreturn local drange 1 -1
		exit
	}
/* matching */
	if `"`dist'"' == bsubstr("matching",1,max(5,`dlen')) {
		sreturn local dist matching
		sreturn local unab matching
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Jaccard */
	if `"`dist'"' == bsubstr("jaccard",1,max(3,`dlen')) {
		sreturn local dist Jaccard
		sreturn local unab Jaccard
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Russell--Rao */
	if `"`dist'"' == bsubstr("russell",1,max(4,`dlen')) {
		sreturn local dist Russell
		sreturn local unab Russell
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Hamann (alias "Hamman", some references have it wrongly spelled this way) */
	if `"`dist'"' == "hamann" | `"`dist'"' == "hamman" {
		sreturn local dist Hamann
		sreturn local unab Hamann
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 -1
		exit
	}
/* Dice */
	if `"`dist'"' == "dice" {
		sreturn local dist Dice
		sreturn local unab Dice
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* anti Dice */
	if `"`dist'"' == "antidice" {
		sreturn local dist antiDice
		sreturn local unab antiDice
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Rogers--Tanimoto */
	if `"`dist'"' == "rogers" {
		sreturn local dist Rogers
		sreturn local unab Rogers
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Sneath--Sokal */
	if `"`dist'"' == "sneath" {
		sreturn local dist Sneath
		sreturn local unab Sneath
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Ochiai */
	if `"`dist'"' == "ochiai" {
		sreturn local dist Ochiai
		sreturn local unab Ochiai
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Yule */
	if `"`dist'"' == "yule" {
		sreturn local dist Yule
		sreturn local unab Yule
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 -1
		exit
	}
/* Anderberg */
	if `"`dist'"' == bsubstr("anderberg",1,max(5,`dlen')) {
		sreturn local dist Anderberg
		sreturn local unab Anderberg
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Kulczynski */
	if `"`dist'"' == bsubstr("kulczynski",1,max(4,`dlen')) {
		sreturn local dist Kulczynski
		sreturn local unab Kulczynski
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Gower2 */
	if `"`dist'"' == "gower2" {
		sreturn local dist Gower2
		sreturn local unab Gower2
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 0
		exit
	}
/* Pearson */
	if `"`dist'"' == "pearson" {
		sreturn local dist Pearson
		sreturn local unab Pearson
		sreturn local dtype similarity
		sreturn local binary binary
		sreturn local drange 1 -1
		exit
	}
/* Gower */
	if `"`dist'"' == "gower" {
		sreturn local dist Gower
		sreturn local unab Gower
		sreturn local dtype dissimilarity
		sreturn local drange 0 1
		exit
	}

	di as err `"`dist' unrecognized (dis)similarity option"'
	exit 198
end

