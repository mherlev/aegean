
library work;
use work.config_types.all;
use work.config.all;
use work.ocp.all;
use work.noc_interface.all;
use work.OCPInterface.all;
use work.OCPIOCCI_types.all;
use work.OCPBurstCCI_types.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aegean is
	port(
		clk	: in std_logic;
		reset	: in std_logic;
		sram_burst_m	: out ocp_burst_m;
		sram_burst_s	: in ocp_burst_s;
		led	: out std_logic_vector(8 downto 0);
		txd0	: out std_logic;
		rxd0	: in std_logic;
		led0	: out std_logic;
		led1	: out std_logic;
		led2	: out std_logic;
		led3	: out std_logic
	);

end entity;

architecture struct of aegean is

	component TdmArbiterWrapper is
	port(
		clk	: in std_logic;
		reset	: in std_logic;
		io_slave_M_Cmd	: out std_logic_vector(2 downto 0);
		io_slave_M_Addr	: out std_logic_vector(20 downto 0);
		io_slave_M_Data	: out std_logic_vector(31 downto 0);
		io_slave_M_DataValid	: out std_logic;
		io_slave_M_DataByteEn	: out std_logic_vector(3 downto 0);
		io_slave_S_Resp	: in std_logic_vector(1 downto 0);
		io_slave_S_Data	: in std_logic_vector(31 downto 0);
		io_slave_S_CmdAccept	: in std_logic;
		io_slave_S_DataAccept	: in std_logic;
		io_master_0_M_Cmd	: in std_logic_vector(2 downto 0);
		io_master_0_M_Addr	: in std_logic_vector(20 downto 0);
		io_master_0_M_Data	: in std_logic_vector(31 downto 0);
		io_master_0_M_DataValid	: in std_logic;
		io_master_0_M_DataByteEn	: in std_logic_vector(3 downto 0);
		io_master_0_S_Resp	: out std_logic_vector(1 downto 0);
		io_master_0_S_Data	: out std_logic_vector(31 downto 0);
		io_master_0_S_CmdAccept	: out std_logic;
		io_master_0_S_DataAccept	: out std_logic;
		io_master_1_M_Cmd	: in std_logic_vector(2 downto 0);
		io_master_1_M_Addr	: in std_logic_vector(20 downto 0);
		io_master_1_M_Data	: in std_logic_vector(31 downto 0);
		io_master_1_M_DataValid	: in std_logic;
		io_master_1_M_DataByteEn	: in std_logic_vector(3 downto 0);
		io_master_1_S_Resp	: out std_logic_vector(1 downto 0);
		io_master_1_S_Data	: out std_logic_vector(31 downto 0);
		io_master_1_S_CmdAccept	: out std_logic;
		io_master_1_S_DataAccept	: out std_logic;
		io_master_2_M_Cmd	: in std_logic_vector(2 downto 0);
		io_master_2_M_Addr	: in std_logic_vector(20 downto 0);
		io_master_2_M_Data	: in std_logic_vector(31 downto 0);
		io_master_2_M_DataValid	: in std_logic;
		io_master_2_M_DataByteEn	: in std_logic_vector(3 downto 0);
		io_master_2_S_Resp	: out std_logic_vector(1 downto 0);
		io_master_2_S_Data	: out std_logic_vector(31 downto 0);
		io_master_2_S_CmdAccept	: out std_logic;
		io_master_2_S_DataAccept	: out std_logic;
		io_master_3_M_Cmd	: in std_logic_vector(2 downto 0);
		io_master_3_M_Addr	: in std_logic_vector(20 downto 0);
		io_master_3_M_Data	: in std_logic_vector(31 downto 0);
		io_master_3_M_DataValid	: in std_logic;
		io_master_3_M_DataByteEn	: in std_logic_vector(3 downto 0);
		io_master_3_S_Resp	: out std_logic_vector(1 downto 0);
		io_master_3_S_Data	: out std_logic_vector(31 downto 0);
		io_master_3_S_CmdAccept	: out std_logic;
		io_master_3_S_DataAccept	: out std_logic
	);

	end component;

	component patmosMasterPatmosCore is
	port(
		clk	: in std_logic;
		reset	: in std_logic;
		io_comConf_M_Cmd	: out std_logic_vector(2 downto 0);
		io_comConf_M_Addr	: out std_logic_vector(31 downto 0);
		io_comConf_M_Data	: out std_logic_vector(31 downto 0);
		io_comConf_M_ByteEn	: out std_logic_vector(3 downto 0);
		io_comConf_M_RespAccept	: out std_logic;
		io_comConf_S_Resp	: in std_logic_vector(1 downto 0);
		io_comConf_S_Data	: in std_logic_vector(31 downto 0);
		io_comConf_S_CmdAccept	: in std_logic;
		io_comSpm_M_Cmd	: out std_logic_vector(2 downto 0);
		io_comSpm_M_Addr	: out std_logic_vector(31 downto 0);
		io_comSpm_M_Data	: out std_logic_vector(31 downto 0);
		io_comSpm_M_ByteEn	: out std_logic_vector(3 downto 0);
		io_comSpm_S_Resp	: in std_logic_vector(1 downto 0);
		io_comSpm_S_Data	: in std_logic_vector(31 downto 0);
		io_cpuInfoPins_id	: in std_logic_vector(31 downto 0);
		io_cpuInfoPins_cnt	: in std_logic_vector(31 downto 0);
		io_memPort_M_Cmd	: out std_logic_vector(2 downto 0);
		io_memPort_M_Addr	: out std_logic_vector(20 downto 0);
		io_memPort_M_Data	: out std_logic_vector(31 downto 0);
		io_memPort_M_DataValid	: out std_logic;
		io_memPort_M_DataByteEn	: out std_logic_vector(3 downto 0);
		io_memPort_S_Resp	: in std_logic_vector(1 downto 0);
		io_memPort_S_Data	: in std_logic_vector(31 downto 0);
		io_memPort_S_CmdAccept	: in std_logic;
		io_memPort_S_DataAccept	: in std_logic;
		io_ledsPins_led	: out std_logic;
		io_uartPins_tx	: out std_logic;
		io_uartPins_rx	: in std_logic
	);

	end component;

	component patmosSlavePatmosCore is
	port(
		clk	: in std_logic;
		reset	: in std_logic;
		io_comConf_M_Cmd	: out std_logic_vector(2 downto 0);
		io_comConf_M_Addr	: out std_logic_vector(31 downto 0);
		io_comConf_M_Data	: out std_logic_vector(31 downto 0);
		io_comConf_M_ByteEn	: out std_logic_vector(3 downto 0);
		io_comConf_M_RespAccept	: out std_logic;
		io_comConf_S_Resp	: in std_logic_vector(1 downto 0);
		io_comConf_S_Data	: in std_logic_vector(31 downto 0);
		io_comConf_S_CmdAccept	: in std_logic;
		io_comSpm_M_Cmd	: out std_logic_vector(2 downto 0);
		io_comSpm_M_Addr	: out std_logic_vector(31 downto 0);
		io_comSpm_M_Data	: out std_logic_vector(31 downto 0);
		io_comSpm_M_ByteEn	: out std_logic_vector(3 downto 0);
		io_comSpm_S_Resp	: in std_logic_vector(1 downto 0);
		io_comSpm_S_Data	: in std_logic_vector(31 downto 0);
		io_cpuInfoPins_id	: in std_logic_vector(31 downto 0);
		io_cpuInfoPins_cnt	: in std_logic_vector(31 downto 0);
		io_memPort_M_Cmd	: out std_logic_vector(2 downto 0);
		io_memPort_M_Addr	: out std_logic_vector(20 downto 0);
		io_memPort_M_Data	: out std_logic_vector(31 downto 0);
		io_memPort_M_DataValid	: out std_logic;
		io_memPort_M_DataByteEn	: out std_logic_vector(3 downto 0);
		io_memPort_S_Resp	: in std_logic_vector(1 downto 0);
		io_memPort_S_Data	: in std_logic_vector(31 downto 0);
		io_memPort_S_CmdAccept	: in std_logic;
		io_memPort_S_DataAccept	: in std_logic;
		io_ledsPins_led	: out std_logic
	);
	end component;



	component OCPIOCCI is
		port(	input	: in	OCPIOCCIIn_r;
				output	: out	OCPIOCCIOut_r
		);
	end component;

	component OCPBurstCCI is
		port(	input	: in	OCPBurstCCIIn_r;
				output	: out	OCPBurstCCIOut_r
		);
	end component;

	signal ocp_io_ms : ocp_io_m_a;
	signal ocp_io_ss : ocp_io_s_a;
	signal ocp_core_ms : ocp_core_m_a;
	signal ocp_core_ss : ocp_core_s_a;
	signal ocp_burst_ms : ocp_burst_m_a;
	signal ocp_burst_ss : ocp_burst_s_a;
	signal spm_ms : spm_masters;
	signal spm_ss : spm_slaves;

    type size_array is array(0 to NODES-1) of integer;
	constant SPM_WIDTH : size_array := (12, 12, 12, 12);


	signal cci_io_input	 : OCPIOCCIIn_r;
	signal cci_io_output : OCPIOCCIOut_r;

	signal cci_burst_input	: OCPBurstCCIIn_r;
	signal cci_burst_output	: OCPBurstCCIOut_r;	
	
	signal clk0			 : std_logic;

begin
	clk0 <= clk;
	pat0 : patmosMasterPatmosCore port map(
		clk	=>	clk0,
		reset	=>	reset,
		io_comConf_M_Cmd	=>	cci_io_input.ocpio_A.MCmd,
		io_comConf_M_Addr	=>	cci_io_input.ocpio_A.MAddr,
		io_comConf_M_Data	=>	cci_io_input.ocpio_A.MData,
		io_comConf_M_ByteEn	=>	cci_io_input.ocpio_A.MByteEn,
		io_comConf_M_RespAccept	=>	cci_io_input.ocpio_A.MRespAccept,
		io_comConf_S_Resp	=>	cci_io_output.ocpio_A.SResp,
		io_comConf_S_Data	=>	cci_io_output.ocpio_A.SData,
		io_comConf_S_CmdAccept	=>	cci_io_output.ocpio_A.SCmdAccept,
		io_comSpm_M_Cmd	=>	ocp_core_ms(0).MCmd,
		io_comSpm_M_Addr	=>	ocp_core_ms(0).MAddr,
		io_comSpm_M_Data	=>	ocp_core_ms(0).MData,
		io_comSpm_M_ByteEn	=>	ocp_core_ms(0).MByteEn,
		io_comSpm_S_Resp	=>	ocp_core_ss(0).SResp,
		io_comSpm_S_Data	=>	ocp_core_ss(0).SData,
		io_cpuInfoPins_id	=>	std_logic_vector(to_unsigned(0,32)),
		io_cpuInfoPins_cnt	=>	std_logic_vector(to_unsigned(4,32)),
	--	io_memPort_M_Cmd	=>	ocp_burst_ms(0).MCmd,
	--	io_memPort_M_Addr	=>	ocp_burst_ms(0).MAddr,
	--	io_memPort_M_Data	=>	ocp_burst_ms(0).MData,
	--	io_memPort_M_DataValid	=>	ocp_burst_ms(0).MDataValid,
	--	io_memPort_M_DataByteEn	=>	ocp_burst_ms(0).MDataByteEn,
	--	io_memPort_S_Resp	=>	ocp_burst_ss(0).SResp,
	--	io_memPort_S_Data	=>	ocp_burst_ss(0).SData,
	--	io_memPort_S_CmdAccept	=>	ocp_burst_ss(0).SCmdAccept,
	--	io_memPort_S_DataAccept	=>	ocp_burst_ss(0).SDataAccept,
		io_memPort_M_Cmd	=>	cci_burst_input.OCPB_master.MCmd,
		io_memPort_M_Addr	=>	cci_burst_input.OCPB_master.MAddr,
		io_memPort_M_Data	=>	cci_burst_input.OCPB_master.MData,
		io_memPort_M_DataValid	=>	cci_burst_input.OCPB_master.MDataValid,
		io_memPort_M_DataByteEn	=>	cci_burst_input.OCPB_master.MDataByteEn,
		io_memPort_S_Resp	=>	cci_burst_output.OCPB_A.SResp,
		io_memPort_S_Data	=>	cci_burst_output.OCPB_A.SData,
		io_memPort_S_CmdAccept	=>	cci_burst_output.OCPB_A.SCmdAccept,
		io_memPort_S_DataAccept	=>	cci_burst_output.OCPB_A.SDataAccept,
		io_ledsPins_led	=>	led0,
		io_uartPins_tx	=>	txd0,
		io_uartPins_rx	=>	rxd0	);

	pat1 : patmosSlavePatmosCore port map(
		clk	=>	clk,
		reset	=>	reset,
		io_comConf_M_Cmd	=>	ocp_io_ms(1).MCmd,
		io_comConf_M_Addr	=>	ocp_io_ms(1).MAddr,
		io_comConf_M_Data	=>	ocp_io_ms(1).MData,
		io_comConf_M_ByteEn	=>	ocp_io_ms(1).MByteEn,
		io_comConf_M_RespAccept	=>	ocp_io_ms(1).MRespAccept,
		io_comConf_S_Resp	=>	ocp_io_ss(1).SResp,
		io_comConf_S_Data	=>	ocp_io_ss(1).SData,
		io_comConf_S_CmdAccept	=>	ocp_io_ss(1).SCmdAccept,
		io_comSpm_M_Cmd	=>	ocp_core_ms(1).MCmd,
		io_comSpm_M_Addr	=>	ocp_core_ms(1).MAddr,
		io_comSpm_M_Data	=>	ocp_core_ms(1).MData,
		io_comSpm_M_ByteEn	=>	ocp_core_ms(1).MByteEn,
		io_comSpm_S_Resp	=>	ocp_core_ss(1).SResp,
		io_comSpm_S_Data	=>	ocp_core_ss(1).SData,
		io_cpuInfoPins_id	=>	std_logic_vector(to_unsigned(1,32)),
		io_cpuInfoPins_cnt	=>	std_logic_vector(to_unsigned(4,32)),
		io_memPort_M_Cmd	=>	ocp_burst_ms(1).MCmd,
		io_memPort_M_Addr	=>	ocp_burst_ms(1).MAddr,
		io_memPort_M_Data	=>	ocp_burst_ms(1).MData,
		io_memPort_M_DataValid	=>	ocp_burst_ms(1).MDataValid,
		io_memPort_M_DataByteEn	=>	ocp_burst_ms(1).MDataByteEn,
		io_memPort_S_Resp	=>	ocp_burst_ss(1).SResp,
		io_memPort_S_Data	=>	ocp_burst_ss(1).SData,
		io_memPort_S_CmdAccept	=>	ocp_burst_ss(1).SCmdAccept,
		io_memPort_S_DataAccept	=>	ocp_burst_ss(1).SDataAccept,
		io_ledsPins_led	=>	led1	);

	pat2 : patmosSlavePatmosCore port map(
		clk	=>	clk,
		reset	=>	reset,
		io_comConf_M_Cmd	=>	ocp_io_ms(2).MCmd,
		io_comConf_M_Addr	=>	ocp_io_ms(2).MAddr,
		io_comConf_M_Data	=>	ocp_io_ms(2).MData,
		io_comConf_M_ByteEn	=>	ocp_io_ms(2).MByteEn,
		io_comConf_M_RespAccept	=>	ocp_io_ms(2).MRespAccept,
		io_comConf_S_Resp	=>	ocp_io_ss(2).SResp,
		io_comConf_S_Data	=>	ocp_io_ss(2).SData,
		io_comConf_S_CmdAccept	=>	ocp_io_ss(2).SCmdAccept,
		io_comSpm_M_Cmd	=>	ocp_core_ms(2).MCmd,
		io_comSpm_M_Addr	=>	ocp_core_ms(2).MAddr,
		io_comSpm_M_Data	=>	ocp_core_ms(2).MData,
		io_comSpm_M_ByteEn	=>	ocp_core_ms(2).MByteEn,
		io_comSpm_S_Resp	=>	ocp_core_ss(2).SResp,
		io_comSpm_S_Data	=>	ocp_core_ss(2).SData,
		io_cpuInfoPins_id	=>	std_logic_vector(to_unsigned(2,32)),
		io_cpuInfoPins_cnt	=>	std_logic_vector(to_unsigned(4,32)),
		io_memPort_M_Cmd	=>	ocp_burst_ms(2).MCmd,
		io_memPort_M_Addr	=>	ocp_burst_ms(2).MAddr,
		io_memPort_M_Data	=>	ocp_burst_ms(2).MData,
		io_memPort_M_DataValid	=>	ocp_burst_ms(2).MDataValid,
		io_memPort_M_DataByteEn	=>	ocp_burst_ms(2).MDataByteEn,
		io_memPort_S_Resp	=>	ocp_burst_ss(2).SResp,
		io_memPort_S_Data	=>	ocp_burst_ss(2).SData,
		io_memPort_S_CmdAccept	=>	ocp_burst_ss(2).SCmdAccept,
		io_memPort_S_DataAccept	=>	ocp_burst_ss(2).SDataAccept,
		io_ledsPins_led	=>	led2	);

	pat3 : patmosSlavePatmosCore port map(
		clk	=>	clk,
		reset	=>	reset,
		io_comConf_M_Cmd	=>	ocp_io_ms(3).MCmd,
		io_comConf_M_Addr	=>	ocp_io_ms(3).MAddr,
		io_comConf_M_Data	=>	ocp_io_ms(3).MData,
		io_comConf_M_ByteEn	=>	ocp_io_ms(3).MByteEn,
		io_comConf_M_RespAccept	=>	ocp_io_ms(3).MRespAccept,
		io_comConf_S_Resp	=>	ocp_io_ss(3).SResp,
		io_comConf_S_Data	=>	ocp_io_ss(3).SData,
		io_comConf_S_CmdAccept	=>	ocp_io_ss(3).SCmdAccept,
		io_comSpm_M_Cmd	=>	ocp_core_ms(3).MCmd,
		io_comSpm_M_Addr	=>	ocp_core_ms(3).MAddr,
		io_comSpm_M_Data	=>	ocp_core_ms(3).MData,
		io_comSpm_M_ByteEn	=>	ocp_core_ms(3).MByteEn,
		io_comSpm_S_Resp	=>	ocp_core_ss(3).SResp,
		io_comSpm_S_Data	=>	ocp_core_ss(3).SData,
		io_cpuInfoPins_id	=>	std_logic_vector(to_unsigned(3,32)),
		io_cpuInfoPins_cnt	=>	std_logic_vector(to_unsigned(4,32)),
		io_memPort_M_Cmd	=>	ocp_burst_ms(3).MCmd,
		io_memPort_M_Addr	=>	ocp_burst_ms(3).MAddr,
		io_memPort_M_Data	=>	ocp_burst_ms(3).MData,
		io_memPort_M_DataValid	=>	ocp_burst_ms(3).MDataValid,
		io_memPort_M_DataByteEn	=>	ocp_burst_ms(3).MDataByteEn,
		io_memPort_S_Resp	=>	ocp_burst_ss(3).SResp,
		io_memPort_S_Data	=>	ocp_burst_ss(3).SData,
		io_memPort_S_CmdAccept	=>	ocp_burst_ss(3).SCmdAccept,
		io_memPort_S_DataAccept	=>	ocp_burst_ss(3).SDataAccept,
		io_ledsPins_led	=>	led3	);

	

    spms : for i in 1 to NODES-1 generate
        spm : entity work.com_spm
        generic map(
            SPM_IDX_SIZE => SPM_WIDTH(i)
            )
        port map(
            p_clk => clk,
            n_clk => clk,
            reset => reset,
            ocp_core_m => ocp_core_ms(i),
            ocp_core_s => ocp_core_ss(i),
            spm_m => spm_ms(i),
            spm_s => spm_ss(i)
            );
    end generate ; -- spms



	spm0 : entity work.com_spm              
	generic map(
		SPM_IDX_SIZE => SPM_WIDTH(0)
	)
    port map(
		p_clk => clk0,
		n_clk => clk,
		reset => reset,
		ocp_core_m => ocp_core_ms(0),
		ocp_core_s => ocp_core_ss(0),
		spm_m => spm_ms(0),
		spm_s => spm_ss(0)
	);

	cdc_io : entity work.OCPIOCCI
	port map(
		input => cci_io_input,
		output => cci_io_output
	);
	cci_io_input.clk_A <= clk0;
	cci_io_input.rst_A <= reset;
	cci_io_input.clk_B <= clk;
	cci_io_input.rst_B <= reset;
	--cci_io_input.ocpio_A <= cci_io_input.ocpio_A;
	cci_io_input.ocpio_B <= ocp_io_ss(0);
	ocp_io_ms(0) <= cci_io_output.ocpio_B;	


	cdc_burst : entity work.OCPBurstCCI
	port map(
		input => cci_burst_input,
		output => cci_burst_output
	);
	cci_burst_input.clk_A <= clk0;
	cci_burst_input.rst_A <= reset;
	cci_burst_input.clk_B <= clk;
	cci_burst_input.rst_B <= reset;
	cci_burst_input.OCPB_slave <= ocp_burst_ss(0);
--	cci_burst_input.OCPB_master <= ocp_burst_ms(0);
	ocp_burst_ms(0) <= cci_burst_output.OCPB_B;	




	noc : entity work.noc port map(
		clk	=>	clk,
		reset	=>	reset,
		ocp_io_ms	=>	ocp_io_ms,
		ocp_io_ss	=>	ocp_io_ss,
		spm_ports_m	=>	spm_ms,
		spm_ports_s	=>	spm_ss	);

	arbit : TdmArbiterWrapper port map(
		clk	=>	clk,
		reset	=>	reset,
		io_slave_M_Cmd	=>	sram_burst_m.MCmd,
		io_slave_M_Addr	=>	sram_burst_m.MAddr,
		io_slave_M_Data	=>	sram_burst_m.MData,
		io_slave_M_DataValid	=>	sram_burst_m.MDataValid,
		io_slave_M_DataByteEn	=>	sram_burst_m.MDataByteEn,
		io_slave_S_Resp	=>	sram_burst_s.SResp,
		io_slave_S_Data	=>	sram_burst_s.SData,
		io_slave_S_CmdAccept	=>	sram_burst_s.SCmdAccept,
		io_slave_S_DataAccept	=>	sram_burst_s.SDataAccept,
		io_master_0_M_Cmd	=>	ocp_burst_ms(0).MCmd,
		io_master_0_M_Addr	=>	ocp_burst_ms(0).MAddr,
		io_master_0_M_Data	=>	ocp_burst_ms(0).MData,
		io_master_0_M_DataValid	=>	ocp_burst_ms(0).MDataValid,
		io_master_0_M_DataByteEn	=>	ocp_burst_ms(0).MDataByteEn,
		io_master_0_S_Resp	=>	ocp_burst_ss(0).SResp,
		io_master_0_S_Data	=>	ocp_burst_ss(0).SData,
		io_master_0_S_CmdAccept	=>	ocp_burst_ss(0).SCmdAccept,
		io_master_0_S_DataAccept	=>	ocp_burst_ss(0).SDataAccept,
		io_master_1_M_Cmd	=>	ocp_burst_ms(1).MCmd,
		io_master_1_M_Addr	=>	ocp_burst_ms(1).MAddr,
		io_master_1_M_Data	=>	ocp_burst_ms(1).MData,
		io_master_1_M_DataValid	=>	ocp_burst_ms(1).MDataValid,
		io_master_1_M_DataByteEn	=>	ocp_burst_ms(1).MDataByteEn,
		io_master_1_S_Resp	=>	ocp_burst_ss(1).SResp,
		io_master_1_S_Data	=>	ocp_burst_ss(1).SData,
		io_master_1_S_CmdAccept	=>	ocp_burst_ss(1).SCmdAccept,
		io_master_1_S_DataAccept	=>	ocp_burst_ss(1).SDataAccept,
		io_master_2_M_Cmd	=>	ocp_burst_ms(2).MCmd,
		io_master_2_M_Addr	=>	ocp_burst_ms(2).MAddr,
		io_master_2_M_Data	=>	ocp_burst_ms(2).MData,
		io_master_2_M_DataValid	=>	ocp_burst_ms(2).MDataValid,
		io_master_2_M_DataByteEn	=>	ocp_burst_ms(2).MDataByteEn,
		io_master_2_S_Resp	=>	ocp_burst_ss(2).SResp,
		io_master_2_S_Data	=>	ocp_burst_ss(2).SData,
		io_master_2_S_CmdAccept	=>	ocp_burst_ss(2).SCmdAccept,
		io_master_2_S_DataAccept	=>	ocp_burst_ss(2).SDataAccept,
		io_master_3_M_Cmd	=>	ocp_burst_ms(3).MCmd,
		io_master_3_M_Addr	=>	ocp_burst_ms(3).MAddr,
		io_master_3_M_Data	=>	ocp_burst_ms(3).MData,
		io_master_3_M_DataValid	=>	ocp_burst_ms(3).MDataValid,
		io_master_3_M_DataByteEn	=>	ocp_burst_ms(3).MDataByteEn,
		io_master_3_S_Resp	=>	ocp_burst_ss(3).SResp,
		io_master_3_S_Data	=>	ocp_burst_ss(3).SData,
		io_master_3_S_CmdAccept	=>	ocp_burst_ss(3).SCmdAccept,
		io_master_3_S_DataAccept	=>	ocp_burst_ss(3).SDataAccept	);

end struct;
