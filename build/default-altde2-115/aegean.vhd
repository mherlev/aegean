
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.config_types.all;
use work.config.all;
use work.ocp.all;
use work.noc_interface.all;

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

begin

	pat0 : patmosMasterPatmosCore port map(
		clk	=>	clk,
		reset	=>	reset,
		io_comConf_M_Cmd	=>	ocp_io_ms(0).MCmd,
		io_comConf_M_Addr	=>	ocp_io_ms(0).MAddr,
		io_comConf_M_Data	=>	ocp_io_ms(0).MData,
		io_comConf_M_ByteEn	=>	ocp_io_ms(0).MByteEn,
		io_comConf_M_RespAccept	=>	ocp_io_ms(0).MRespAccept,
		io_comConf_S_Resp	=>	ocp_io_ss(0).SResp,
		io_comConf_S_Data	=>	ocp_io_ss(0).SData,
		io_comConf_S_CmdAccept	=>	ocp_io_ss(0).SCmdAccept,
		io_comSpm_M_Cmd	=>	ocp_core_ms(0).MCmd,
		io_comSpm_M_Addr	=>	ocp_core_ms(0).MAddr,
		io_comSpm_M_Data	=>	ocp_core_ms(0).MData,
		io_comSpm_M_ByteEn	=>	ocp_core_ms(0).MByteEn,
		io_comSpm_S_Resp	=>	ocp_core_ss(0).SResp,
		io_comSpm_S_Data	=>	ocp_core_ss(0).SData,
		io_cpuInfoPins_id	=>	std_logic_vector(to_unsigned(0,32)),
		io_cpuInfoPins_cnt	=>	std_logic_vector(to_unsigned(4,32)),
		io_memPort_M_Cmd	=>	ocp_burst_ms(0).MCmd,
		io_memPort_M_Addr	=>	ocp_burst_ms(0).MAddr,
		io_memPort_M_Data	=>	ocp_burst_ms(0).MData,
		io_memPort_M_DataValid	=>	ocp_burst_ms(0).MDataValid,
		io_memPort_M_DataByteEn	=>	ocp_burst_ms(0).MDataByteEn,
		io_memPort_S_Resp	=>	ocp_burst_ss(0).SResp,
		io_memPort_S_Data	=>	ocp_burst_ss(0).SData,
		io_memPort_S_CmdAccept	=>	ocp_burst_ss(0).SCmdAccept,
		io_memPort_S_DataAccept	=>	ocp_burst_ss(0).SDataAccept,
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

    spms : for i in 0 to NODES-1 generate
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
