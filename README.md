# cfa_detector

Os scripts aqui apresentados implementam  a técnica exposta no paper "Classificador SLFN-ELM aplicado à verificação de adulteração de imagens baseada em padrão CFA", dos autores Camilo Lélis Assis Gonçalves e Ronaldo de Freitas Zampolo.

A técnica visa extender os conceitos apresentados no paper "Exposing digital forgeries in color filter array
interpolated images", por A. Popescu e H. Farid, afim de automatizar o processo de validação de imagens proposto.

Os códigos foram implementados utilizando o software de computação númerica Octave rodando em um sistema Linux. Portanto o suporte à outros sistemas, assim como a compatibilidade com o Matlab, ainda não foram implementados

# Pré-requisitos

Pacotes do Octave necessários:
* image;
* control;
* signal.

Antes de rodar os códigos é necessário rodar primeiro o script ***add_paths.m***, que irá incluir os diretórios de busca necessários para a execução correta dos programas.

# Parâmetros utilizados nos testes

Uma breve explicação sobre contexto de utilização e os valores inicias do parâmetros utilizados nos testes encontra-se no arquivo "[Algoritmo_EM.pdf!](docs/Algoritmo_EM.pdf)".

# Reproduzindo os resultados

* [classifica_imagem.m](classifica_imagem.m) - script de partida para a análise de uma imagem
* [cria_base_dados.m](cria_base_dados.m) - script de partida para a compilação das bases de dados utilizados no classificador SLFN.
