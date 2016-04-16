function diretorio_testes = obter_diretorio_testes()
  diretorio_testes = cat(2, pwd(), "/Testes/");
  if (exist(diretorio_testes) ~= 7)
    [STATUS, MSG, MSGID] = mkdir (diretorio_testes);
    if ~STATUS
      MSG
      MSGID
    endif
  endif
endfunction