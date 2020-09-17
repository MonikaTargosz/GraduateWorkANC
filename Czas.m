classdef Czas < handle
    %Klasa do symualacji algorytmu w dziedzinie czasu
    
    properties
        W = 0;          %wspó³czynniki filtru
        N = 0;          %rz¹d filtru
        Krok = 0;       %wspó³czynnik kroku adaptacji
        xTemp = 0;      %zmienna pomocnicza
        xAdaptTemp = 0; %zmienna pomocnicza
    end
    
    methods
        function obj = Czas(N, Krok)
        %Konstruktor
            obj.N = N;
            obj.Krok = Krok;
            obj = obj.InicjalizacjaAlgorytmu;
        end
        
        function obj = InicjalizacjaAlgorytmu(obj)
        %Inicjalizacja algorytmu
            obj.W = zeros(1, obj.N+1);
            obj.xTemp = zeros(1, obj.N+1);
            obj.xAdaptTemp = zeros(1, obj.N+1);
        end
        
        function [output, paramW] = ObliczKrok(obj, x, xAdapt, e, flaga)
            %Obliczenie jednego kroku
        
            %Aktualizacja wag filtru
            obj.W = obj.W + obj.Krok * (e) .* obj.xAdaptTemp;
            %Aktualizacja poprzednich x
            obj.xAdaptTemp = [xAdapt, obj.xAdaptTemp(1:end-1)];
            obj.xTemp = [x, obj.xTemp(1:end-1)];
            %Obliczenie wyjœcia
            output = - obj.W * obj.xTemp';
            paramW=obj.W;
        end
    end
end

