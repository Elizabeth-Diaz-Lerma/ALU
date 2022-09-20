library ieee;
use ieee.std_logic_1164.all;

entity ALU is

port (A, B : in std_logic_vector(7 downto 0);
		Lower, Upper : out std_logic_vector(7 downto 0);
		Mode : in std_logic_vector(2 downto 0));
		
end Alu;

architecture Behavior of Alu is

component Restador8 is 
		PORT(A	: IN STD_LOGIC_Vector(7 DOWNTO 0);
		  B	: IN STD_LOGIC_Vector(7 DOWNTO 0);
		  F 	: OUT STD_LOGIC_Vector(8 DOWNTO 0));
end component;

component Sumador8 is 
		port(A, B : in std_logic_vector (7 downto 0);
			F : out std_logic_vector(8 downto 0));
		  
end component;

component Multiplicador8 is
	port(A	: IN STD_LOGIC_Vector(7 DOWNTO 0);
		  B	: IN STD_LOGIC_Vector(7 DOWNTO 0);
		  F 	: OUT STD_LOGIC_Vector(15 DOWNTO 0));
		  
end component;


component div is 

	port(numer, denom : in std_logic_vector(7 downto 0);
		  quotient, remain : out std_logic_vector(7 downto 0));
		  
end component;

signal RF, SF : std_logic_vector(8 downto 0);
signal MF : std_logic_vector(15 downto 0);
signal QuotF, RemF : std_logic_vector(7 downto 0);

begin

r1 : Restador8 port map(A => A, B => B, F => RF);

s1 : Sumador8 port map(A => A, B => B, F => SF);

m1 : Multiplicador8 port map(A => A, B => B, F => MF);

d1 : div port map(numer => A, denom => B, quotient => QuotF, remain => RemF);
							  
process(Mode) begin

	case Mode is
	
		when "000" =>
		
			Lower <= SF(7 downto 0);
			Upper <= "0000000"&SF(8);
		
		when "001" =>
		
			Lower <= RF(7 downto 0);
			Upper <= "0000000"&RF(8);
			
		when "010" =>
		
			Lower <= MF(7 downto 0);
			Upper <= MF(15 downto 8);
		
		when "011" =>
		
			Lower <= QuotF;
			Upper <= RemF;
			
		when "100" =>
		
			Lower <= A and B;
			Upper <= "00000000";
		
		when "101" =>
			
			Lower <= A or B;
			Upper <= "00000000";
		
		when "110" =>
		
			Lower <= A xor B;
			Upper <= "00000000";
		
		when "111" =>
		
			Lower <= not A;
			Upper <= not B;
	
	end case;
end process;

end Behavior;