print("Test") 
zeroToOneHundred = []
for x in range(0,101):
  zeroToOneHundred.append(x)
print(zeroToOneHundred)

prime = 2
strike = 2

while prime < 10:
  while strike < 101:
    zeroToOneHundred[strike] = 0
    strike = strike + prime
  prime = prime + 1
  strike = prime + prime

for x in zeroToOneHundred:
  if x != 0:
    print(str(x))