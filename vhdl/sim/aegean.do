set StdArithNoWarnings 1
set StdNumNoWarnings 1
set NumericStdNoWarnings 1
view *
#view wave
do ../../build/ddr3/simulation/vhdl/mentor/run.do
do wave.do
run 10100 ns
