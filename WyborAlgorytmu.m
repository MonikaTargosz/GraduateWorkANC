%% Klasa do wyboru algorytmu sterowania 

classdef (Sealed) WyborAlgorytmu
 
    properties (Constant)
        LMS = 1;
        FXLMS = 2;
    end
    
    methods (Access = private)
        function obj = WyborAlgorytmu
        end
    end
    
end

