function [Dados_treinamento Dados_teste] = prepara_conj_teste_treinamento(t_bloco, n_itens_selec, porcentagem_sel_treinamento);

  tipo_bloco = "512";
  switch t_bloco
    case {1}
      tipo_bloco = "512";
    case {2}
      tipo_bloco = "256";
    case {0}
      tipo_bloco = "128";
    otherwise
      printf("Tamanho de bloco invalido! Utilizando valor padrao: 512 x 512");
      tipo_bloco = "512";
  endswitch
  
  arquivo_dados = cat(2, tipo_bloco, ".mat");

  load(arquivo_dados);

  linhas_para_eliminacao = [];
  i = 0;
  r = isnan(Base_dados_em);
  for k = 1:size(Base_dados_em, 1)
    linha = r(k, :);
    s = sum(linha);
    if s > 0
      i++;
      linhas_para_eliminacao(i) = k;
    endif
  endfor
  Base_dados_em(linhas_para_eliminacao, :) = [];

  n_entradas = size(Base_dados_em, 1);

  n = randperm(n_entradas);
  Base_dados_em = Base_dados_em(n, :);

  [B_sorted ind_sorted] = sort(Base_dados_em);

  ind = 0;

  for ind = 1:n_entradas
    if B_sorted(ind, 1) > 0
      break;
    endif
  endfor

  inds_dados_alterados = ind_sorted(ind:n_entradas);
  inds_dados_n_alterados = ind_sorted(1:ind-1);

  n = 0;
  if size(inds_dados_alterados, 2) < size(inds_dados_n_alterados, 2)
    n = size(inds_dados_alterados, 2);
  else
    n = size(inds_dados_n_alterados, 2);
  endif
  %n_itens_alterados = n_itens_n_alterados = n;
  n_itens_alterados = n_itens_n_alterados = round(n_itens_selec * n);

  n_itens_treinamento_alterados = round(porcentagem_sel_treinamento * n_itens_alterados);
  n_itens_teste_alterados = n_itens_alterados - n_itens_treinamento_alterados;

  n_itens_treinamento_n_alterados = round(porcentagem_sel_treinamento * n_itens_n_alterados);
  n_itens_teste_n_alterados = n_itens_n_alterados - n_itens_treinamento_n_alterados;

  inds_dados_treinamento_alterados = inds_dados_alterados(1:n_itens_treinamento_alterados);
  inds_dados_treinamento_n_alterados = inds_dados_n_alterados(1:n_itens_treinamento_n_alterados);
  dados_treinamento = cat(1, Base_dados_em(inds_dados_treinamento_alterados, :), Base_dados_em(inds_dados_treinamento_n_alterados, :));
  n = randperm(n_itens_treinamento_alterados + n_itens_treinamento_n_alterados);
  Dados_treinamento = dados_treinamento(n, :);

  inds_dados_teste_alterados = inds_dados_alterados(1:n_itens_teste_alterados);
  inds_dados_teste_n_alterados = inds_dados_n_alterados(1:n_itens_teste_n_alterados);
  dados_teste = cat(1, Base_dados_em(inds_dados_teste_alterados, :), Base_dados_em(inds_dados_teste_n_alterados, :));
  n = randperm(n_itens_teste_alterados + n_itens_teste_n_alterados);
  Dados_teste = dados_teste(n, :);

  arquivo_dados_treinamento = cat(2, tipo_bloco, "_treinamento", ".mat");
  save(cat(2, arquivo_dados_treinamento), "Dados_treinamento");
  arquivo_dados_teste = cat(2, tipo_bloco, "_teste", ".mat");
  save(cat(2, arquivo_dados_teste), "Dados_teste");

endfunction
