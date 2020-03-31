*! version 1.0.1  06nov2017
version 9.1
mata:

/*
	A structure is its own eltype, but it is in fact implemented
	as a pointer(pointer colvector).  The pointer colevector
	points to the individual members.

	Below, we make use of that fact to list a structure's members 
	at run time
*/

void liststruct(transmorphic matrix S)
{
	if (eltype(S) != "struct") {
		_error(3259, eltype(S) + " found where struct required")
		/*NOTREACHED*/
	}

	displayas("result")
	liststruct_struct("1", (pointer) S)
}

/*static*/ void liststruct_struct(string scalar id, 
					pointer(pointer colvector) matrix p)
{
	real scalar		i, j, k, n
	real scalar		min, max
	real scalar		hashdr
	string scalar		newid
	pointer colvector	m

	pragma unset min
	pragma unset max

	liststruct_count(p, min, max)

	printf("{txt:%s  }", id) 
	if (rows(p)!=1 | cols(p)!=1) printf("%g x %g ", rows(p), cols(p))
	printf("structure") 
	if (rows(p)==0 | cols(p)==0) {
		printf("\n")
		return 
	}
	printf(" of %g", min)
	if (min!=max) printf(" to %g", max)
	printf(" elements\n")
	if (max==0) return

	hashdr = (rows(p)*cols(p)>1)
	for (i=1; i<=rows(p); i++) {
		for (j=1; j<=cols(p); j++) {
			if (hashdr) {
				printf("{txt:%s  [%g,%g]:}\n", 
					i==1 & j==1 ?  length(id)*" " : id,
					i, j)
			}
			if (n = liststruct_mbrs(p[i,j])) {
				m = *(p[i,j])
				for (k=1; k<=n; k++) {
					newid = sprintf("%s.%g", id, k)
					liststruct_list(newid, m[k])
				}
			}
		}
	}
}

/*static*/ void liststruct_list(string scalar id, pointer scalar m)
{
	string scalar		typ
	transmorphic matrix	M

	if (m==NULL) {
		printf("{txt:%s  <empty>}\n", id)
		return
	}

	if ((typ = eltype(*m)) == "struct") {
		M = *m
		liststruct_struct(id, (pointer) M)
		return 
	}

	printf("{txt:%s}  ", id)
	printf("%g x %g %s", rows(*m), cols(*m), typ)

	if (rows(*m)==1 & cols(*m)==1) {
		if (typ=="real") {
			printf(" = %g", *m)
		}
		else if (typ=="complex") {
			if (Re(*m)>=.) printf(" = %g", Re(*m))
			else printf(" = %g + %gi", Re(*m), Im(*m))
		}
		else if (typ=="pointer") {
			printf(*m==NULL ? " = NULL" : " != NULL")
		}
		else if (typ=="string") {
			printf(`" = "%s""', *m)
		}
	}
	printf("\n")
}

/*static*/ real scalar liststruct_mbrs(pointer(pointer colvector) scalar p)
{
	if (p==NULL) return(0)
	return(length(*p))
}


/*static*/ void liststruct_count(pointer(pointer colvector) matrix p, min, max)
{
	real scalar		i, j
	real scalar		n


	min = max = 0
	if (p != NULL) {
		if (length(p)) {
			min =  1e+20
			max = -1e+20
			for (i=1; i<=rows(p); i++) {
				for (j=1; j<=cols(p); j++) {
					n = liststruct_mbrs(p[i,j])
					if (n<min) min = n 
					if (n>max) max = n
				}
			}
		}
	}
}
end
