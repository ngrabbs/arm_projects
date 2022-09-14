// -------- BAD DOUBLE CLK (clk/slow_clk) -----
always_ff @(posedge clk) begin 
  if (counter == blah) begin 
    counter <= '0; 
    slow_clk <= !slow_clk; 
  end else begin 
    counter <= counter + 1'd1; 
  end 
end  

always_ff @(posedge slow_clk) begin // THIS CREATES ANOTHER CLOCK DOMAIN
    // do slow stuff end
  end

// ---------GOOD SINGLE CLK ---------------------
always_ff @(posedge clk) begin 
  en <= 1'b0; 
  if (counter == blah) begin 
    counter <= '0;
    en <= 1'b1; 
  end else begin 
    counter <= counter + 1'd1;
  end
end

always_ff @(posedge clk) begin // SINGLE CLOCK DOMAIN
  if (en) begin
    // do slow stuff end end
  end
end

/*
So one common thing that a lot of beginners do when they want to do stuff slowly is:
always_ff @(posedge clk) begin
  if (counter == blah) begin
    counter <= '0;
    slow_clk <= !slow_clk;
  end else begin
    counter <= counter + 1'd1;
  end
end

always_ff @(posedge slow_clk) begin
  // do slow stuff
end

The problem with this is two fold:

1) FPGAs have special clock routing networks that are low latency and low jitter. slow_clk was
created by logic and is now on the data routing network, which is not low latency nor is it low
jitter. Additionally to use it as a clock it has to be routed on to the clock routing network
which can only be done by special hardware blocks, so you a) use up resources, b) have to travel 
potentially a long way on the data routing network to get to one, just to then travel a long way 
on the clock routing network to get back. AKA it makes a terrible clock.

2) You've now got multiple clocks, so you have to add a new timing constraint for that clock,
and you quite likely have paths between those clocks, which means you need to consider CDC,
which is not a beginner topic.  Neither of these are deal breakers, and in fact I've worked
with Intel IP that does this. And you can totally do this if you know what you are doing.
The problem is beginners don't know what they are doing, and don't know to how to handle this
correctly.  For a 1Hz clock, this is not really an issue, but you don't want beginners to get
into the habit of doing this.  Also a 1Hz clock for blinking LEDs / counting on seven segment
displays is not a good use of finite resources (clock routing networks). A much better way to
do this that avoids all the above consequences and CDC issues is to use an enable generator.
Which is to say, you generate an enable signal at a certain frequency, and only do stuff when
that signal is enabled.

always_ff @(posedge clk) begin
  en <= 1'b0;
  if (counter == blah) begin
    counter <= '0; en <= 1'b1;
  end else begin
    counter <= counter + 1'd1;
  end
end

always_ff @(posedge clk) begin
  if (en) begin
    // do slow stuff
  end
end
    
Or if you don't plan to re-use the enable signal in multiple locations then:

always_ff @(posedge clk) begin
  if (counter == blah) begin
    counter <= '0; 
    // do slow stuff
   end else begin
    counter <= counter + 1'd1;
  end
end

The point is, you're doing it all on the same clock domain, but you only do stuff every X
ticks. Hence stuff happens slower.  The disadvantage here is you're still using a fast clock,
which means even if you only do stuff every 1 million ticks, you still have to meet timing
for your fast clock. And since you're clocking all your logic on that fast clock domain,
power usage increases too.  So in larger designs you do want to spilt things up into multiple
clock domains (not 1Hz, or even 100 KHz), stuff like, 48 MHz for USB, 125 MHz for RGMII,
50 MHz for control data, etc..  But in those cases you still don't want to create a clock
via logic, instead you want to use hardware components such as PLLs or clock dividers. And
by "hardware" here I mean not RTL, but physical hardware inside the FPGA that does this. 
And finally when you do this, you have to make sure you tell the timing tools about all your
clocks, you add the correct CDC logic in, and the correct constraints for your CDC too.
*/