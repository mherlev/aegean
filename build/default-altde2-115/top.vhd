
library work;
use work.config.all;
use work.ocp.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aegean_top is
	port(
		clk0	: in std_logic;
		clk1	: in std_logic;
		oSRAM_A	: out std_logic_vector(19 downto 0);
		oSRAM_OE_N	: out std_logic;
		oSRAM_WE_N	: out std_logic;
		oSRAM_CE_N	: out std_logic;
		oSRAM_LB_N	: out std_logic;
		oSRAM_UB_N	: out std_logic;
		SRAM_DQ	: inout std_logic_vector(15 downto 0);
		iUart0Pins_rxd	: in std_logic;
		oUart0Pins_txd	: out std_logic;
		oLed0Pins_led	: out std_logic;
		oLed1Pins_led	: out std_logic;
		oLed2Pins_led	: out std_logic;
		oLed3Pins_led	: out std_logic;
		oLed4Pins_led	: out std_logic;
		oLed5Pins_led	: out std_logic;
		oLed6Pins_led	: out std_logic;
		oLed7Pins_led	: out std_logic;
		oLed8Pins_led	: out std_logic
	);

end entity;

architecture struct of aegean_top is
	constant pll_mult	: natural := 8;
	constant pll_div	: natural := 10;
	constant pll_mult2	: natural := 8;
	constant pll_div2	: natural := 5;
	signal clk_int0 : std_logic;
	signal clk_int1 : std_logic;
	signal int_res	: std_logic;
	signal int_res0	: std_logic := '0';
	signal int_res1	: std_logic := '0';
	signal res0_reg1,res0_reg2 : std_logic := '0';
	signal res1_reg1,res1_reg2 : std_logic := '0';
	signal res_reg1,res_reg2 : std_logic;
	signal res_cnt : unsigned(2 downto 0) := "000";
	signal sram_burst_m : ocp_burst_m;
	signal sram_burst_s : ocp_burst_s;
	signal SRAM_out_dout_ena : std_logic;
	signal SRAM_out_dout : std_logic_vector(15 downto 0);
	signal SRAM_in_din : std_logic_vector(15 downto 0);
	signal SRAM_in_din_reg : std_logic_vector(15 downto 0);

    attribute altera_attribute : string;
    attribute altera_attribute of res_cnt : signal is "POWER_UP_LEVEL=LOW";

	component SRamCtrl is
	port(
		clk	: in std_logic;
--		clk1	: in std_logic;
		reset	: in std_logic;
		io_ocp_M_Cmd	: in std_logic_vector(2 downto 0);
		io_ocp_M_Addr	: in std_logic_vector(20 downto 0);
		io_ocp_M_Data	: in std_logic_vector(31 downto 0);
		io_ocp_M_DataValid	: in std_logic;
		io_ocp_M_DataByteEn	: in std_logic_vector(3 downto 0);
		io_ocp_S_Resp	: out std_logic_vector(1 downto 0);
		io_ocp_S_Data	: out std_logic_vector(31 downto 0);
		io_ocp_S_CmdAccept	: out std_logic;
		io_ocp_S_DataAccept	: out std_logic;
		io_sRamCtrlPins_ramOut_addr	: out std_logic_vector(19 downto 0);
		io_sRamCtrlPins_ramOut_dout	: out std_logic_vector(15 downto 0);
		io_sRamCtrlPins_ramIn_din	: in std_logic_vector(15 downto 0);
		io_sRamCtrlPins_ramOut_doutEna	: out std_logic;
		io_sRamCtrlPins_ramOut_nce	: out std_logic;
		io_sRamCtrlPins_ramOut_noe	: out std_logic;
		io_sRamCtrlPins_ramOut_nwe	: out std_logic;
		io_sRamCtrlPins_ramOut_nlb	: out std_logic;
		io_sRamCtrlPins_ramOut_nub	: out std_logic
	);

	end component;

begin

    --
    --  internal reset generation
    --  should include the PLL lock signal
    --
    process(clk_int0)
    begin
        if rising_edge(clk_int0) then
            if (res_cnt /= "111") then
                res_cnt <= res_cnt + 1;
            end if;
            res_reg1 <= not res_cnt(0) or not res_cnt(1) or not res_cnt(2);
            res_reg2 <= res_reg1;
            int_res  <= res_reg2;
        end if;
    end process;

	process(clk_int0)
	begin
		if rising_edge(clk_int0) then
			res0_reg1	<= int_res;
			res0_reg2	<= res0_reg1;
			int_res0	<= res0_reg2;
		end if;
	end process;

	process(clk_int1)
	begin
		if rising_edge(clk_int1) then
			res1_reg1	<= int_res;
			res1_reg2	<= res1_reg1;
			int_res1	<= res1_reg2;
		end if;
	end process;




    SRAM_in_din <= SRAM_DQ;

    -- tristate output to SRAM
    process(SRAM_out_dout_ena, SRAM_out_dout)
    begin
        if SRAM_out_dout_ena='1' then
            SRAM_DQ <= SRAM_out_dout;
        else
            SRAM_DQ <= (others => 'Z');
        end if;
    end process;

    pll_inst : entity work.pll generic map(
            multiply_by => pll_mult,
            divide_by   => pll_div
        )
        port map(
            inclk0 => clk0,
            c0     => clk_int0,
            c1     => open
        );
	pll_inst_2 : entity work.pll generic map(
            multiply_by => pll_mult2,
            divide_by   => pll_div2
        )
        port map(
            inclk0 => clk1,
            c0     => clk_int1,
            c1     => open
        );


	cmp : entity work.aegean port map(
		clk0	=>	clk_int0,
		clk1	=>	clk_int1,
		reset0	=>	int_res0,
		reset1	=>	int_res1,
		sram_burst_m	=>	sram_burst_m,
		sram_burst_s	=>	sram_burst_s,
		led	=>	open,
		txd0	=>	oUart0Pins_txd,
		rxd0	=>	iUart0Pins_rxd,
		led0	=>	oLed0Pins_led,
		led1	=>	oLed1Pins_led,
		led2	=>	oLed2Pins_led,
		led3	=>	oLed3Pins_led	);

	ssram : SRamCtrl port map(
		clk	=>	clk_int0,
		reset	=>	int_res0,
		io_ocp_M_Cmd	=>	sram_burst_m.MCmd,
		io_ocp_M_Addr	=>	sram_burst_m.MAddr,
		io_ocp_M_Data	=>	sram_burst_m.MData,
		io_ocp_M_DataValid	=>	sram_burst_m.MDataValid,
		io_ocp_M_DataByteEn	=>	sram_burst_m.MDataByteEn,
		io_ocp_S_Resp	=>	sram_burst_s.SResp,
		io_ocp_S_Data	=>	sram_burst_s.SData,
		io_ocp_S_CmdAccept	=>	sram_burst_s.SCmdAccept,
		io_ocp_S_DataAccept	=>	sram_burst_s.SDataAccept,
		io_sRamCtrlPins_ramOut_addr	=>	oSRAM_A,
		io_sRamCtrlPins_ramOut_dout	=>	sram_out_dout,
		io_sRamCtrlPins_ramIn_din	=>	sram_in_din,
		io_sRamCtrlPins_ramOut_doutEna	=>	sram_out_dout_ena,
		io_sRamCtrlPins_ramOut_nce	=>	oSRAM_CE_N,
		io_sRamCtrlPins_ramOut_noe	=>	oSRAM_OE_N,
		io_sRamCtrlPins_ramOut_nwe	=>	oSRAM_WE_N,
		io_sRamCtrlPins_ramOut_nlb	=>	oSRAM_LB_N,
		io_sRamCtrlPins_ramOut_nub	=>	oSRAM_UB_N	);

end struct;
