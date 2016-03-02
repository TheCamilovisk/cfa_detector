function gravar_dados_imagem(dados, str_imagem, str_pasta = "nulo")
  diretorio_img = "";
  switch (str_pasta)
  case "nulo"
    ind1 = find(str_imagem == ".");
	  ind2 = find(str_imagem == "/");
    str_imagem(ind1) = str_imagem(ind2) = "_";
    diretorio_img = cat(2, obter_diretorio_testes(), str_imagem);
  case {"Bilinear", "Bicubica", "Mediana", "Baseada_Gradiente", "Transicao_Saturacao", "Plano_cor"}
    diretorio_img = cat(2, obter_diretorio_testes(), str_pasta, "/", str_imagem);
  otherwise
    printf("Opcao de pasta invalida!\n");
  endswitch
  r = mkdir(diretorio_img);
  if r == 0
    printf("Não foi possivel criar o diretorio %s.\n", diretorio_img);
  endif
  save(cat(2, diretorio_img, "/dados.mat"), "dados");
endfunction