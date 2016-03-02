% Funçao responsavel por realizar o algoritmo EM em um determinado canal de uma porçao de imagem.
% Retorno:        Coef -> coeficientes de interpolaçao do modelo estimado.
%                 W -> mapa de probabilidades obtido da execuçao do algoritmo EM sobre o o canal da imagem escolhido.
% Parametros:     F -> canal de uma certa porçao de imagem predefinida escolhido para estimar o modelo de interpolaçao CFA e obter o mapa de probabilidades.
%                 n -> representa o limite inferior e superior, antes e depois de 0, de linhas e colunas dos coeficientes do modelo estimado.
%                 variancia_0 -> variancia inicial da distribuiçao Gaussiana de Pr(f(x,y) | f(x,y) pertence M1).
%                 erro_alvo -> erro maximo desejado para o calculo dos coeficientes do modelo.

function [Coef W P erro_interpolacao variancias erros_max] = algoritmo_em (F, n, variancia_0, erro_alvo)
  
%  Inicializaçao.
%----------------------------------------------------------------------------------------------------------
%  Criaçao da matriz de coeficientes do modelo.
  Coef = cria_matriz_coef(n);
  
%  Coef = [  0 0.5 0; 0.5 0 0.5; 0 0.5 0 ]
%  Rotaciona a matriz de coeficientes para posteriores convoluçoes.
  Coef_rot = rot90(Coef, 2);
  
%  Probabilidade da geraçao de um pixel de qualquer valor.
  p_0 = 1/256;
  
%  Variancia corrente no algoritmo.
  variancias = variancia_0;
  
%  Erro maximo corrente no algoritmo.
  erros_max = 10.0;
  
%  Matriz de erros residuais.
  R = zeros(size(F));
  
%  Matriz de probabilidades da gaussiana;
  P = zeros(size(F));
  
%  Matriz de pesos (mapa de probabilidades);
  W = zeros(size(F));
  
%  Iteraçao corrente do algoritmo.
  iter = 1;
  
%  Numero maximo de iteraçoes permitidas.
  max_iter = 1000;
  
%  Indica se houve algo errado na execuçao do algoritmo
%  err = 0 -> tudo normal
%  err = 1 -> houve algum problema
  err = 0;
  
%  Verifica quantes vezes as matrizes foram reinicializadas.
  reinicializacoes = 0;
  
%  Ainda não houveram erros de interpolacao.
  erro_interpolacao = 0;
  
%----------------------------------------------------------------------------------------------------------
%  Fim da inicializaçao.
  
%  Looping principal do algoritmo.
%----------------------------------------------------------------------------------------------------------
  do
%    Passo da Esperança.
%##########################################################################################################
%    Calculo dos erros residuais.
    R = abs( F .- conv2(F, Coef_rot, 'same') );
    
%    Calculo da probabilidade Pr(f(x,y) | f(x,y) pertence M1).
    den = 1/(variancias(iter) * sqrt(2*pi));
    a1 = -(R.^2) / (2*(variancias(iter)^2));
    P = exp(a1) .* den;
    
%    Calcula a matriz de pesos.
    W = P ./ (P .+ p_0);
    
%    Fim do passo da esperança.
%##########################################################################################################

%    Passo da maximizaçao.
%##########################################################################################################
%    Armazena os coeficientes antigos.
    Coef_passados = Coef;
    
%    Obtem os novos coeficientes.
    Coef = calcula_coeficientes(F, W, n);
    
    if R == 0
      printf("%f\n", erros_max(iter));
    endif
    
%    Se houverem inconsistencias nos dados (NaN) a matriz e reinicializada!
		r = find(isnan(Coef));
		[nr nc] = size(r);
%    Testa se há NaNs.
		if(nr > 0)
			if(reinicializacoes > 20)
				break;
			elseif(reinicializacoes <= 20)
				new_coef = cria_matriz_coef(n);
				Coef_rot = rot90(new_coef, 2);
				R = abs( F .- conv2(F, Coef_rot, 'same') );
				variancias = [variancias variancia_0];
				den = 1/(variancias(iter) * sqrt(2*pi));
        a1 = -(R.^2) / (2*(variancias(iter)^2));
        P = exp(a1) .* den;
				W = P ./ (P .+ p_0);
				reinicializacoes++;
			endif
		endif
    
%    Rotaciona os novos coeficientes.
    Coef_rot = rot90(Coef, 2);
    
%    Calcula o erro maximo dessa iteraçao.
    erros_max = [erros_max max(max(abs(Coef .- Coef_passados)))];
    
%    Calcula a nova variancia do algoritmo.
    variancias = [variancias sqrt(( vec(W)' * vec(R.^2)) / sum( vec(W) ))];
    
%    Nova iteraçao.
    iter++;
    
%##########################################################################################################
%    Fim do passo da maximizacao.

%  Continua ate que o erro maximo seja minor que o erro desejado ou ate que o numero de iteraçoes permitidas seja atingido.
  until ((erros_max(iter) < erro_alvo) || (iter > max_iter))
%----------------------------------------------------------------------------------------------------------
%  Fim do looping principal do algoritmo.
  
%  Testa de o algoritmo convergiu
%----------------------------------------------------------------------------------------------------------
  if(iter < max_iter+1)
    if (reinicializacoes > 20)
			erro_interpolacao = 1;
		endif
  else
    erro_interpolacao = 1;
  endif
%----------------------------------------------------------------------------------------------------------
%  Fim do teste do algoritmo.

endfunction