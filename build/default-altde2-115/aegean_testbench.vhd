
library std;
use std.textio.all;

library modelsim_lib;
use modelsim_lib.util.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.test.all;
use work.ocp.all;

entity aegean_testbench is

end entity;

architecture struct of aegean_testbench is
	signal pat0_uart_tx_reg : std_logic_vector(7 downto 0);
	signal pat0_uart_tx_status_reg : std_logic;
	signal clk0 : std_logic;
	signal clk1	: std_logic;
	constant PERIOD_0	: time := 12.5 ns;
	constant RESET_TIME	: time := 40 ns;
	constant PERIOD_1	: time := 25 ns;
	signal oSRAM_A : std_logic_vector(19 downto 0);
	signal oSRAM_OE_N : std_logic;
	signal oSRAM_WE_N : std_logic;
	signal oSRAM_CE_N : std_logic;
	signal oSRAM_LB_N : std_logic;
	signal oSRAM_UB_N : std_logic;
	signal SRAM_DQ : std_logic_vector(15 downto 0);
	signal pull_down : std_logic;

    file OUTPUT: TEXT open WRITE_MODE is "STD_OUTPUT";

begin


    clock_gen(clk0,PERIOD_0);
	clock_gen(clk1,PERIOD_1);
	top : entity work.aegean_top port map(
		clk0	=>	clk0,
		clk1	=>	clk1,
		oSRAM_A	=>	oSRAM_A,
		oSRAM_OE_N	=>	oSRAM_OE_N,
		oSRAM_WE_N	=>	oSRAM_WE_N,
		oSRAM_CE_N	=>	oSRAM_CE_N,
		oSRAM_LB_N	=>	oSRAM_LB_N,
		oSRAM_UB_N	=>	oSRAM_UB_N,
		SRAM_DQ	=>	SRAM_DQ,
		iUart0Pins_rxd	=>	'0',
		oUart0Pins_txd	=>	open,
		oLed0Pins_led	=>	open,
		oLed1Pins_led	=>	open,
		oLed2Pins_led	=>	open,
		oLed3Pins_led	=>	open,
		oLed4Pins_led	=>	open,
		oLed5Pins_led	=>	open,
		oLed6Pins_led	=>	open,
		oLed7Pins_led	=>	open,
		oLed8Pins_led	=>	open	);

    pat0_uart_spy : process
        variable buf: LINE;
        constant CORE_ID : STRING (10 downto 1):="PAT0: at: ";
        variable i : integer := 0;
    begin
        init_signal_spy("/aegean_testbench/top/cmp/pat0/iocomp/patmosMasterUart/txQueue/io_enq_valid","/aegean_testbench/pat0_uart_tx_status_reg");
        init_signal_spy("/aegean_testbench/top/cmp/pat0/iocomp/patmosMasterUart/txQueue/io_enq_bits","/aegean_testbench/pat0_uart_tx_reg");
        write(buf,CORE_ID);
        loop
            wait until rising_edge(pat0_uart_tx_status_reg);
            if i = 0 then
                write(buf,time'image(NOW) & " : ");
                --write(buf,real'image(real(NOW/time'val(1000000))/1000.0) & " us : ");
            end if;
            write(buf,character'val(to_integer(unsigned(pat0_uart_tx_reg))));
            i := i + 1;
            --writeline(OUTPUT,buf);
            if to_integer(unsigned(pat0_uart_tx_reg)) = 10 then
                writeline(OUTPUT,buf);
                i := 0;
                write(buf,CORE_ID);
            end if;
        end loop;
    end process ; -- pat0_uart_spy


    -- Add uart ticker to increase the UART speed to reduce simulation time
    baud_inc : process
    begin
        loop
            wait until rising_edge(clk0);
            signal_force("/aegean_testbench/top/cmp/pat0/iocomp/patmosMasterUart/tx_baud_tick", "1", 0 ns, freeze, open, 0);
            wait until rising_edge(clk0);
            signal_force("/aegean_testbench/top/cmp/pat0/iocomp/patmosMasterUart/tx_baud_tick", "0", 0 ns, freeze, open, 0);
            wait for 3*PERIOD_0;
        end loop;
    end process ; -- baud_inc

    main_mem : entity work.cy7c10612dv33 port map(
        CE_b  => oSRAM_CE_N,
        WE_b  => oSRAM_WE_N,
        OE_b  => oSRAM_OE_N,
        BHE_b => oSRAM_UB_N,
        BLE_b => oSRAM_LB_N,
        A     => oSRAM_A,
        DQ    => SRAM_DQ);

end struct;
