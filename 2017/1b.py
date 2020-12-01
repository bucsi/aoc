#!/bin/pypy3

be = list(input("? "))
for i in range(len(be)):
	be[i]=int(be[i])

sum=0
limit=int(len(be)/2)

for i in range(len(be)):
	kov=i+limit
	if kov>limit:
		kov-=len(be)
	if be[i]==be[kov]:
		sum+=be[i]
print("A bemenet hossza:", len(be))
print()
print(sum)
