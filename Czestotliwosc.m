classdef Czestotliwosc < handle
    %Klasa do symulacji uk�adu w dziedzinie cz�stotliwo�ci
    
    properties
        W = 0;          %wsp�czynniki filtru
        N = 0;          %rz�d filtru
        Krok = 0;       %wsp�czynnik kroku adaptacji
        xTemp = 0;      %wej�cie tymczasowe
        xAdaptTemp = 0; %wej�cie tymczasowe algorytmu adaptacji
        X = 0;          %transformata sygna�u wej�ciowego
        xAdapt = 0;     %transformata sygna�u wej�ciowego algorytmu adaptacji
        E = 0;          %transformata sygna�u b��du
        Licznik = 0;    %licznik pr�bek transformaty
        S=0;            %wsp�czynniki filtru S do dzielenia przez wsp�czynnik mi
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
                %Aktualizacja transformaty sygna�u b��du
                obj.E = sdft(zeros(1, obj.N+1), e, 0, obj.N+1);
                
                %% Aktualizacja wag filtru - nale�y wybra� odpowiednie r�wnanie
                
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
                
                %Obliczenie sygna�u wyj�ciowego
                yIDFT = ifft(obj.W .* obj.X);
                y = -real(yIDFT(end));
                
            else
                %Je�li zebrano mniej pr�bek ni� wymaga algorytm do pe�nej transformacji, wyj�cie=0
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

