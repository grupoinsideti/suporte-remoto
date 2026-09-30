# Suporte Remoto Inside-TI

Versão personalizada do [RustDesk](https://github.com/rustdesk/rustdesk) usada pela INSIDE-TI LTDA para suporte
remoto aos seus clientes, com servidor próprio (`remoto.grupoinsideti.com.br`).

## O que mudou em relação ao RustDesk
Tudo está em `inside-ti/personalizar.sh`, aplicado na compilação (`.github/workflows/inside-ti-windows.yml`):
- servidor de IDs/relay e chave pública do servidor da Inside-TI embutidos;
- nome do aplicativo `SuporteRemotoInsideTI` e nome exibido "Suporte Remoto Inside-TI";
- ícone da Inside-TI (`inside-ti/icones/`).

Workflows do RustDesk que não usamos foram retirados deste branch.

## Licença
O RustDesk é licenciado sob a **GNU AGPL-3.0**, e esta versão também. O código-fonte completo, com as
modificações, é este repositório (branch `inside-ti`). RustDesk é marca dos seus respectivos donos; esta versão
não é oficial nem mantida pela equipe do RustDesk.
