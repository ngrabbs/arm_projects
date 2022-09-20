# Makefile
all: sum01 arm_test_example sieve100

sieve100: sieve100.o
	gcc -g -o $@ $+

sieve100.o: sieve100.s
	as -g -o $@ $<

arm_test_example: arm_test_example.o
	gcc -g -o $@ $+

arm_test_example.o: arm_test_example.s
	as -g -o $@ $<

sum01: sum01.o
	gcc -g -o $@ $+

sum01.o : sum01.s
	as -g -o $@ $<

clean:
	rm -vf sum01 sieve100 *.o
