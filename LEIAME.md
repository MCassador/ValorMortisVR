# Valor Mortis VR

Mod de fã que joga **Valor Mortis** em realidade virtual, em primeira pessoa, com os braços do personagem seguindo os seus controles. Feito sobre o [UEVR](https://github.com/praydog/UEVR) (praydog, licença MIT). **Não é oficial e este repositório não contém o jogo.**

## O que tem

- Espada na mão direita: o golpe vale quando a lâmina encosta no inimigo, com a força do movimento.
- Defesa levantando a espada na frente do rosto.
- Pistola na mão esquerda, mirando pelo cano (com a animação de recarga e de tiro do jogo).
- Granada na cintura, frasco de cura, travar a mira no inimigo.
- Câmera ajustada nos golpes especiais e finalizações.

Está em desenvolvimento. Algumas partes ainda não foram bem testadas (quebrar caixotes e barris com a espada, bater em chefes grandes pelo movimento), e pode haver defeitos.

## Como instalar

1. Baixe o ZIP em **Releases** (ou o botão verde *Code > Download ZIP*) e **extraia a pasta inteira**.
2. Feche o Valor Mortis.
3. Dê dois cliques em **`instalar.bat`**. Ele acha o jogo sozinho pela Steam; se não achar, pede a pasta `...\ValorMortis\Binaries\Win64`.
4. Ligue o headset (SteamVR, Meta/Oculus ou Virtual Desktop com OpenXR) e abra o jogo pela Steam. O VR liga sozinho junto com o jogo.

Para **atualizar**, baixe a versão nova e rode `instalar.bat` de novo. Os seus ajustes e calibrações não são apagados.
Para **remover**, rode `desinstalar.bat`.

## Requisitos

- Valor Mortis (Steam) para Windows.
- Um headset com runtime **OpenXR**.
- Uma placa de vídeo que rode o jogo em VR (o jogo é pesado; use resolução do OpenXR/headset moderada).

## Se algo der errado

- O antivírus pode reclamar do `version.dll` (é o carregador do mod, que liga o VR junto com o jogo). Libere a pasta do jogo se isso acontecer.
- O jogo não abre ou fecha sozinho: rode `desinstalar.bat`, confirme que o jogo abre normal e tente instalar de novo.
- Os registros do mod ficam em `ValorMortisVR\dados\UnrealVRMod\ValorMortis-Win64-Shipping\plugins\vmvr.log`. Anexe esse arquivo ao relatar um problema.

## O que é instalado

`version.dll` (carregador) e a pasta `ValorMortisVR` dentro de `...\Valor Mortis\ValorMortis\Binaries\Win64`: o núcleo do UEVR, `openxr_loader.dll`, `LuaVR.dll`, o perfil inicial e o plugin do mod (`ValorMortisVR.dll`).

## Créditos

- [UEVR](https://github.com/praydog/UEVR) por praydog e colaboradores (MIT).
- OpenXR loader da Khronos Group.
- Mod por MCassador.
