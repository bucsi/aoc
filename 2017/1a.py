#!/bin/pypy3

be = list(input("? "))
for i in range(len(be)):
	be[i]=int(be[i])

sum=0
for i in range(len(be)):
	if i==len(be)-1:
		kov=0
	else:
		kov=i+1
	if be[i]==be[kov]:
		sum+=be[i]
print("A bemenet hossza:", len(be))
print()
print(sum)
