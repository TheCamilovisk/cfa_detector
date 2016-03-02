% Funçao para calcular os novos coeficientes do modelo estatistico estimado para um certo canal de cor de uma porçao de imagem, apos uma iteraçao do algoritmo EM.
% Retorno:                             Novos_coef -> novos coeficientes gerados para o novo modelo estimado.
% Parametros:                          F -> canal de cor escolhido da imagem.
%                                      W -> pesos estraidos das probabilidades geradas pelo algoritmo.
%                                      n -> indice limite para os limites inferior e superior de linhas e colunas da matriz de coeficientes.
function Novos_coefs = calcula_coeficientes(F, W, n)
  
%  Inicializaçao.
%----------------------------------------------------------------------------------------------------------
%  Obtem o tamanho da matriz 'F'.
  tamanho = size(F);
  
%  Determina o numero de deslocamentos que a matriz 'F' sofrera em cada dimensao - um para cada coeficiente.
  n_deslocamentos = 2*n + 1;
  
%  Determina o numero de coeficientes que serap calculados - tirando o coeficiente (0, 0).
  n_coeficientes = n_deslocamentos^2 - 1;
  
%  Matriz temporaria.
%  Guarda uma versao da matriz 'F' cercada por zeros.
  Fs_deslocados = zeros(tamanho + 2*n);
  Fs_deslocados(1+n : (1+n) + tamanho(1) - 1, 1+n : (1+n) + tamanho(2) - 1) = F;
  Fs_deslocados = repmat(Fs_deslocados, [1 1 n_coeficientes]);
  
%  Matriz de coeficientes 'A' do sistema linear a ser resolvido.
  A = zeros((2*n+1)^2-1);
  
%  Vetor de termos independentes do sistema linear a ser resolvido.
	b = zeros((2*n+1)^2-1, 1);
%----------------------------------------------------------------------------------------------------------
%  Fim da inicializaçao.

%  Calculo das versoes deslocadas de 'F'.
%----------------------------------------------------------------------------------------------------------
  d = 1;
  metade_deslocamentos = n_deslocamentos - n - 1;
  for i = 0: n_deslocamentos-1
    for j = 0: n_deslocamentos-1
      if(i != metade_deslocamentos || j != metade_deslocamentos)
        Fs_deslocados(:, :, d) = shift(shift(Fs_deslocados(:, :, d), -i, 1), -j, 2);
        d++;
      endif
    endfor
  endfor

  Fs_deslocados = Fs_deslocados(1: tamanho(1), 1: tamanho(2), :);
%----------------------------------------------------------------------------------------------------------
%  Fim do calculo das versoes deslocadas de 'F'.
  
%  Calculo das matriz 'A' de coeficientes e do vetor 'b' de termos independentes, ambos pertencentes ao sistema linear.
%----------------------------------------------------------------------------------------------------------
	for e1 = 1:(2*n+1)^2-1
    Termo_comum = W.*Fs_deslocados(:, :, e1);
		b(e1) = sum(sum(Termo_comum.*F));
		for e2 = e1:(2*n+1)^2-1
			A(e1, e2) = sum(sum(Termo_comum.*Fs_deslocados(:, :, e2)));
			if(e1 != e2)
				A(e2, e1) = A(e1, e2);
			end
		end
	end
%----------------------------------------------------------------------------------------------------------
%  Fim do calculo da matriz 'A' de do vetor 'b'.
%  Resolucao do sistema linear.
%----------------------------------------------------------------------------------------------------------
	Novos_coefs = A \ b;
  
%  Transforma o vetor solucao em uma matriz quadrada de ordem (2*n + 1) e adiciona o elemento (0,0).
  metade_dos_coeficientes = floor(rows(Novos_coefs)/2);
  Novos_coefs = [Novos_coefs(1:metade_dos_coeficientes)', 0, Novos_coefs(metade_dos_coeficientes+1:end)']';
  Novos_coefs = reshape(Novos_coefs, n_deslocamentos, n_deslocamentos)';
  
%----------------------------------------------------------------------------------------------------------
%  Fim da resolucao do sistema linear.
  
endfunction