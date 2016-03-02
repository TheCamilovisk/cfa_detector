function nome = cria_nome(img_str, pasta_str, tipo_bloco)

  nome_base = "512";
  if tipo_bloco == 2;
    nome_base = "256";
  elseif tipo_bloco == 0;
    nome_base = "128";
  endif
  
  u_str = tmpnam("/", "t_");
  nome = cat(2, u_str(3:end), "_", img_str, "_", pasta_str, "_", nome_base);

endfunction