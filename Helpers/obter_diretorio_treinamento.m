function diretorio = obter_diretorio_treinamento(tipo_do_bloco)
  str_tipo_bloco = "";
  switch tipo_do_bloco
    case {0}
      str_tipo_bloco = "512x512";
    case {1}
      str_tipo_bloco = "256x256";
    otherwise
      printf("Tamanho de bloco invalido! Utilizando valor padrao: 512 x 512");
      str_tipo_bloco = "512x512";
  endswitch
  diretorio = cat(2, pwd(), "/Conjunto_treinamento/", str_tipo_bloco, "/");
endfunction