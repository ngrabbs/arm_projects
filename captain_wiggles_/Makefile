blink1Hz: blink1Hz.sv
	yosys -p 'synth_ice40 -top blink1Hz -json blink1Hz.json' blink1Hz.sv
	nextpnr-ice40 --hx1k --package vq100 -v --freq 25 --json blink1Hz.json --pcf ./go-board.pcf --asc blink1Hz.asc
	icepack blink1Hz.asc blink1Hz.bin
	iceprog blink1Hz.bin

count1Hz: blink1Hz.sv
	yosys -p 'synth_ice40 -top count1Hz -json count1Hz.json' count1Hz.sv Binary_To_7Segment.sv
	nextpnr-ice40 --hx1k --package vq100 -v --freq 25 --json count1Hz.json --pcf ./go-board.pcf --asc count1Hz.asc
	icepack count1Hz.asc count1Hz.bin
	iceprog count1Hz.bin


clean:
	rm *.asc *.json *.bin
