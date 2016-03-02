% Função de criaçao da matriz de coeficientes.
% Cria uma matriz quadrada aleatoria de coeficientes de ordem (2*n+1) com o elemento central igual a '0'.
% Retorno:                 Coef -> novos coeficientes recem-criados.
% Parametros:              n -> indice limite para os limites inferior e superior de linhas e colunas.
function Coef = cria_matriz_coef(n)
%  Adicionamos um valor aleatorio aos coeficientes para evitar valores nulos.
	Coef = abs(rand() + rand(2*n+1) - 1);
	Coef(n+1,n+1) = 0;
endfunction
