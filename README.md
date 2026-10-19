# Valor Mortis VR

Joga **Valor Mortis** em realidade virtual, em primeira pessoa, com os braços do personagem seguindo os seus controles. É um mod de fã, feito sobre o [UEVR](https://github.com/praydog/UEVR) (praydog, licença MIT). **Não é oficial e este repositório não contém o jogo.**

> Versão 0.1, em desenvolvimento. Há partes ainda não testadas a fundo (veja [Limitações](#limitações)).

## O que o mod faz

- **Espada na mão direita:** o golpe vale quando a lâmina encosta no inimigo, com a força do movimento da sua mão.
- **Defesa:** levante a espada na frente do rosto para bloquear.
- **Pistola na mão esquerda:** a mira sai do cano, na direção do controle, com a animação de tiro e de recarga do jogo.
- **Granada na cintura**, frasco de cura e trava de mira no inimigo.
- **Câmera:** ajustada nos golpes especiais e finalizações; nas cenas do jogo o mod sai da frente e mostra a câmera original.
- **Corpo e braços:** os dois braços acompanham os controles, e o empurrão do golpe vira reação do inimigo.

## Requisitos

| Item | Detalhe |
|---|---|
| Jogo | Valor Mortis (Steam), Windows |
| Headset | qualquer um com runtime **OpenXR** (SteamVR, Meta/Oculus, Virtual Desktop, etc.) |
| Placa de vídeo | o jogo é pesado; em VR use resolução moderada no seu runtime |
| Windows | PowerShell 5.1 (já vem no Windows 10 e 11) |

## Instalação

1. Em **[Releases](../../releases)** baixe o `ValorMortisVR-v0.1.zip` e **extraia a pasta inteira** (não rode de dentro do ZIP).
2. **Feche o Valor Mortis.**
3. Dê dois cliques em **`instalar.bat`**.
   - Ele procura o jogo sozinho nas suas bibliotecas da Steam.
   - Se não achar, ele pede a pasta `...\Valor Mortis\ValorMortis\Binaries\Win64`; cole o caminho e aperte Enter.
4. Ligue o headset e abra o jogo **pela Steam**. O VR liga sozinho junto com o jogo; não precisa de injetor.

Se ainda não usou o OpenXR com outro jogo, defina primeiro o seu runtime como o OpenXR ativo (no SteamVR, Meta ou Virtual Desktop).

### Instalar numa pasta específica

```bat
instalar.bat "D:\SteamLibrary\steamapps\common\Valor Mortis\ValorMortis\Binaries\Win64"
```

## Atualizar

Baixe a versão nova, extraia e rode o `instalar.bat` de novo. Os arquivos do mod são trocados, mas **os seus ajustes e calibrações são mantidos** (`opcoes-vr.txt`, pegadas da espada e da pistola, configuração do UEVR).

## Remover

Rode **`desinstalar.bat`**. Ele pede confirmação, apaga o `version.dll` e a pasta `ValorMortisVR` do jogo e devolve o `version.dll` que existia antes, se havia. O jogo em si não é alterado.

## Controles

Mapa atual (pode mudar entre versões):

| Controle | Ação |
|---|---|
| Mão direita | espada |
| Mão esquerda | pistola (gatilho esquerdo atira) |
| Grip esquerdo | mirar com a pistola |
| Grip direito | esquiva |
| Analógico direito para cima / baixo | pular / agachar |
| A direito | recarregar |
| B direito | interagir |
| X esquerdo | curar (frasco) |
| X + Y esquerdos | inventário |
| ☰ esquerdo | pausa; segurado por 0,5 s abre o inventário |
| Analógico direito para os lados | giro da vista em passos |

## Ajustes

Ficam em `ValorMortisVR\dados\UnrealVRMod\ValorMortis-Win64-Shipping\plugins\opcoes-vr.txt`:

| Linha | O que muda |
|---|---|
| `giro=40` | ângulo de cada passo do giro da vista (30, 40 ou 45 graus). No jogo: clique os **dois analógicos juntos** para trocar |
| `mira=2.5` | cone da assistência de mira da pistola, em graus (0 desliga). No teclado: tecla **8** troca 2,5, 4 e desligada |
| `imagem=0` | modo de imagem: 0 = original do jogo, 1 = VR limpo (sem desfoque, aberração e granulado), 2 = limpo e sem o brilho espalhado. No teclado: tecla **9** troca |
| `braco=63.0` | comprimento do braço em cm (o mod mede sozinho com o uso) |

O menu do UEVR abre com a tecla **Insert** (no teclado do PC).

## Se algo der errado

- **O antivírus reclama do `version.dll`:** ele é o carregador do mod (liga o VR junto com o jogo). Libere a pasta do jogo e rode o instalador de novo. Se a cópia falhar, o instalador avisa.
- **O jogo não abre ou fecha sozinho:** rode `desinstalar.bat`, confirme que o jogo abre normal e instale de novo. Se voltar a acontecer, mande o registro (abaixo).
- **Imagem preta ou nenhum VR:** confira se o runtime OpenXR está ligado e ativo antes de abrir o jogo.
- **Registro do mod:** `ValorMortisVR\dados\UnrealVRMod\ValorMortis-Win64-Shipping\plugins\vmvr.log`. Anexe esse arquivo ao abrir uma issue.

## Limitações

Ainda não foram bem testados no jogo: quebrar caixotes e barris com o movimento da espada, bater em chefes muito grandes pelo movimento (o golpe pelo grip funciona), e a posição do frasco de cura na mão. Nada disso trava o jogo; só pode não funcionar como esperado.

## O que é instalado

Dentro de `...\Valor Mortis\ValorMortis\Binaries\Win64`:

```
version.dll                      carregador (liga o VR com o jogo)
ValorMortisVR\
  UEVRBackend.dll                núcleo do UEVR
  openxr_loader.dll              OpenXR (Khronos)
  LuaVR.dll
  perfil\config.txt              perfil inicial do VR
  dados\...\plugins\             plugin do mod (ValorMortisVR.dll) e seus ajustes
```

## Créditos

- [UEVR](https://github.com/praydog/UEVR), por praydog e colaboradores (MIT).
- OpenXR loader, Khronos Group.
- Mod por MCassador.
