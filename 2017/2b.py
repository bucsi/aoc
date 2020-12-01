#!/bin/pypy3
import itertools

with open("be2.txt", "r") as f:		 #beolvasás
	seged=f.readlines()

be=[]
for sor in seged:			#mátrixba szétszedés
	asor = sor.split("\n")[0]
	be.append(asor.split("\t"))

sordiff=0

for i in range(len(be)):		
	for j in range(len(be[i])):
		be[i][j]=int(be[i][j])	#konvertálás intre
	
	for j in itertools.combinations(be[i], 2):
		if max(j)%min(j)==0:
			sordiff+=int(max(j)/min(j))	

print(sordiff)

