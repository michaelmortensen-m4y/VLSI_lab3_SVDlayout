--------------------------------------------------------------------------------
-- Entity: tb_SVD
-- Date:2018-04-18  
-- Author: Michael Mortensen     
--
-- Description: Testbench for top SVD
--------------------------------------------------------------------------------
library IEEE;
     use IEEE.std_logic_1164.all;
     use IEEE.std_logic_signed.all;
     use IEEE.std_logic_textio.all;
     use STD.textio.all;

 ENTITY tb_SVD IS  
 END tb_SVD;  

 ARCHITECTURE behavior OF tb_SVD IS  
   -- Component Declaration for the Unit Under Test (UUT)  
   COMPONENT SVD  
   port  (
        x   : in std_logic_vector(19 downto 0); -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        y   : in std_logic_vector(19 downto 0); -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        w   : in std_logic_vector(19 downto 0); -- cos() -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        v   : in std_logic_vector(19 downto 0); -- sin() -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        s   : out std_logic_vector(19 downto 0); -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and range ]-2.0;2.0[
        d   : out std_logic_vector(19 downto 0)  -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and range ]-2.0;2.0[
    );
   END COMPONENT;  

   --Inputs  
    signal test_x : std_logic_vector(19 downto 0); 
    signal test_y : std_logic_vector(19 downto 0); 
    signal test_w : std_logic_vector(19 downto 0);
    signal test_v : std_logic_vector(19 downto 0); 
    signal test_s : std_logic_vector(19 downto 0);
    signal test_d : std_logic_vector(19 downto 0);
    
 BEGIN  
   -- Instantiate the Unit Under Test (UUT)  
   uut: SVD PORT MAP(  
     x => test_x,  
     y => test_y,  
     w => test_w,  
     v => test_v,  
     s => test_s,  
     d => test_d
   );  

   simulation : process
    
    procedure checkSVD(constant x : in std_logic_vector(19 downto 0); 
                       constant y : in std_logic_vector(19 downto 0); 
                       constant w : in std_logic_vector(19 downto 0);  
                       constant v : in std_logic_vector(19 downto 0); 
                       constant s_expected : in std_logic_vector(19 downto 0); 
                       constant d_expected : in std_logic_vector(19 downto 0)) is
        variable hasError : boolean := false;
    begin
        test_x <= x;
        test_y <= y;
        test_w <= w;
        test_v <= v;
        wait for 100 ns;
        
        for i in 0 to 19 loop
            if (test_s(i) /= s_expected(i) or test_d(i) /= d_expected(i)) then
                hasError := true;
            end if;
        end loop;
    
        assert not hasError -- If there is an error
            report "Fail."
            severity failure;
        assert hasError     -- If there is no error
            report "Success."
            severity note;
    end procedure checkSVD;
    
    begin
        
        checkSVD("00110000000000000000", --  0.75 = x
                 "00110000000000000000", --  0.75 = y
                 "01000000000000000000", --  1    = w
                 "01000000000000000000", --  1    = v
                 "01100000000000000000", --  1.5  = s_expected
                 "00000000000000000000");--  0    = d_expected
        
        checkSVD("00100000000000000000", --  0.5  = x
                 "00100000000000000000", --  0.5  = y
                 "01000000000000000000", --  1    = w
                 "01000000000000000000", --  1    = v
                 "01000000000000000000", --  1    = s_expected
                 "00000000000000000000");--  0    = d_expected
                
        checkSVD("11010000000000000000", -- -0.75 = x
                 "00110000000000000000", --  0.75 = y
                 "11000000000000000000", -- -1    = w
                 "11000000000000000000", -- -1    = v
                 "00000000000000000000", --  0    = s_expected
                 "10100000000000000000");-- -1.5  = d_expected        

        wait;
        
    end process simulation;
      
 END;  
