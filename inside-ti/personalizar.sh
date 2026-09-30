#!/usr/bin/env bash
# Personalização "Suporte Remoto Inside-TI" sobre o RustDesk (AGPL-3.0). Aplicado na compilação (GitHub Actions),
# depois do checkout com submódulos. Tudo o que mudamos no RustDesk está neste script e na pasta inside-ti/.
#
# - Servidor e chave pública do Suporte Remoto Inside-TI embutidos (não precisa renomear o arquivo).
# - Nome do aplicativo "SuporteRemotoInsideTI" (sem espaços: o RustDesk monta comandos do Windows com ele) e
#   nome exibido "Suporte Remoto Inside-TI" nas propriedades do executável.
# - Ícone da Inside-TI.
# - Com nome próprio, o RustDesk se comporta como "cliente personalizado" e não oferece atualizar para o oficial.
set -euo pipefail
cd "$(dirname "$0")/.."

SERVIDOR="remoto.grupoinsideti.com.br"
CHAVE="hM3OMI3sUIJfVSvBSxNHbXBhfdu1oRJWYW3D3NKYnLM="
NOME="SuporteRemotoInsideTI"
EXIBIDO="Suporte Remoto Inside-TI"

CFG=libs/hbb_common/src/config.rs
sed -i -E "s|^pub const RENDEZVOUS_SERVERS: &\[&str\] = &\[\"[^\"]*\"\];|pub const RENDEZVOUS_SERVERS: \&[\&str] = \&[\"${SERVIDOR}\"];|" "$CFG"
sed -i -E "s|^pub const RS_PUB_KEY: &str = \"[^\"]*\";|pub const RS_PUB_KEY: \&str = \"${CHAVE}\";|" "$CFG"
sed -i -E "s|APP_NAME: RwLock<String> = RwLock::new\(\"RustDesk\".to_owned\(\)\);|APP_NAME: RwLock<String> = RwLock::new(\"${NOME}\".to_owned());|" "$CFG"
grep -q "\"${SERVIDOR}\"" "$CFG" && grep -q "\"${CHAVE}\"" "$CFG" && grep -q "\"${NOME}\".to_owned" "$CFG" \
  || { echo "Personalização do config.rs não aplicou (o RustDesk mudou?)." >&2; exit 1; }

RC=flutter/windows/runner/Runner.rc
sed -i -E "s|VALUE \"CompanyName\", \"[^\"]*\"|VALUE \"CompanyName\", \"INSIDE-TI LTDA\"|" "$RC"
sed -i -E "s|VALUE \"FileDescription\", \"[^\"]*\"|VALUE \"FileDescription\", \"${EXIBIDO}\"|" "$RC"
sed -i -E "s|VALUE \"ProductName\", \"[^\"]*\"|VALUE \"ProductName\", \"${EXIBIDO}\"|" "$RC"
sed -i -E "s|VALUE \"LegalCopyright\", \"[^\"]*\"|VALUE \"LegalCopyright\", \"Baseado no RustDesk (AGPL-3.0). Personalizacao: INSIDE-TI LTDA\"|" "$RC"
grep -q "${EXIBIDO}" "$RC" || { echo "Personalização do Runner.rc não aplicou." >&2; exit 1; }

ICONES=inside-ti/icones
cp "$ICONES/icone.ico" res/icon.ico
cp "$ICONES/icone.ico" res/tray-icon.ico
cp "$ICONES/icone.ico" flutter/windows/runner/resources/app_icon.ico
cp "$ICONES/icone-32.png" res/32x32.png
cp "$ICONES/icone-64.png" res/64x64.png
cp "$ICONES/icone-128.png" res/128x128.png
cp "$ICONES/icone-256.png" res/128x128@2x.png
cp "$ICONES/icone-512.png" res/icon.png
if [[ -f flutter/assets/icon.png ]]; then cp "$ICONES/icone-512.png" flutter/assets/icon.png; fi

echo "Personalização Inside-TI aplicada: ${EXIBIDO} → ${SERVIDOR}"
