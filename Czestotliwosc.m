classdef Czestotliwosc < handle
    %Klasa do symulacji uk³adu w dziedzinie czêstotliwoœci
    
    properties
        W = 0;          %wspó³czynniki filtru
        N = 0;          %rz¹d filtru
        Krok = 0;       %wspó³czynnik kroku adaptacji
        xTemp = 0;      %wejœcie tymczasowe
        xAdaptTemp = 0; %wejœcie tymczasowe algorytmu adaptacji
        X = 0;          %transformata sygna³u wejœciowego
        xAdapt = 0;     %transformata sygna³u wejœciowego algorytmu adaptacji
        E = 0;          %transformata sygna³u b³êdu
        Licznik = 0;    %licznik próbek transformaty
        S=0;            %wspó³czynniki filtru S do dzielenia przez wspó³czynnik mi
        %wKrok=0;
    end
    
    methods
        function obj = Czestotliwosc(N, mi)
        %Konstruktor
            obj.N = N;
            obj.Krok = mi;
            obj = obj.InicjalizacjaAlgorytmu;
        end
        
        function obj = InicjalizacjaAlgorytmu(obj)
        %Inicjalizacja algorytmu
            obj.W = zeros(1, obj.N+1);
            obj.xTemp = zeros(1, obj.N+1);
            obj.xAdaptTemp = zeros(1, obj.N+1);
            obj.X = zeros(1, obj.N+1);
            obj.xAdapt = zeros(1, obj.N+1);
            obj.E = zeros(1, obj.N+1);
            obj.Licznik = obj.N+1;
            %obj.wKrok = zeros(1, obj.N+1);           
        end
        
        function [y, paramW] = ObliczKrok(obj, x, xAdapt, e, modyf)
        
            %Obliczenie jednego kroku
            if obj.Licznik == 0
                %Aktualizacja transformaty sygna³u b³êdu
                obj.E = sdft(zeros(1, obj.N+1), e, 0, obj.N+1);
                
                %% Aktualizacja wag filtru - nale¿y wybraæ odpowiednie równanie
                
                if modyf==0
                obj.W = obj.W + obj.Krok * obj.E .* conj(obj.xAdapt);
                else
                obj.W = obj.W + (obj.Krok./modyf) .* obj.E .* conj(obj.xAdapt);
                end
                %% Aktualizacja transformaty X i tymczasowych
                obj.xAdapt = sdft(obj.xAdapt, xAdapt, obj.xAdaptTemp(end), obj.N+1);
                obj.xAdaptTemp = [xAdapt, obj.xAdaptTemp(1:end-1)];
                obj.X = sdft(obj.X, x, obj.xTemp(end), obj.N+1);
                obj.xTemp = [x, obj.xTemp(1:end-1)];
                
                %Obliczenie sygna³u wyjœciowego
                yIDFT = ifft(obj.W .* obj.X);
                y = -real(yIDFT(end));
                
            else
                %Jeœli zebrano mniej próbek ni¿ wymaga algorytm do pe³nej transformacji, wyjœcie=0
                obj.xAdapt = sdft(obj.xAdapt, xAdapt, obj.xAdaptTemp(end), obj.N+1);
                obj.xAdaptTemp = [xAdapt, obj.xAdaptTemp(1:end-1)];
                obj.X = sdft(obj.X, x, obj.xTemp(end), obj.N+1);
                obj.xTemp = [x, obj.xTemp(1:end-1)];
                obj.Licznik = obj.Licznik - 1;
                y = 0;
            end
            
            paramW=obj.W;
        end     
    end
end

