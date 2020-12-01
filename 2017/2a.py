#!/bin/pypy3

with open("be2.txt", "r") as f:		 #beolvasás
	seged=f.readlines()

be=[]
for sor in seged:			#mátrixba szétszedés
	asor = sor.split("\n")[0]
	be.append(asor.split("\t"))

sordiff=[]

for i in range(len(be)):		
	for j in range(len(be[i])):
		be[i][j]=int(be[i][j])	#konvertálás intre
	min=be[i][0]
	max=be[i][0]
	for j in range(1, len(be[i])):	#minmax kiválasztás
		if be[i][j]<min:
			min=be[i][j]
		if be[i][j]>max:
			max=be[i][j]
	sordiff.append(max-min)

print("sordiff elemszáma:", len(sordiff))
print(sum(sordiff))

