# Valor Mortis VR

Joga **Valor Mortis** em realidade virtual, em primeira pessoa, com os braços do personagem seguindo os seus controles. É um mod de fã, feito sobre o [UEVR](https://github.com/praydog/UEVR) (praydog, licença MIT). **Não é oficial e este repositório não contém o jogo.**

> Versão 0.4, em desenvolvimento. Há partes ainda não testadas a fundo (veja [Limitações](#limitações)). **English below** ([English](#english)).

## O que o mod faz

- **Espada na mão direita:** o golpe vale quando a lâmina encosta no inimigo, com a força do movimento da sua mão.
- **Defesa:** levante a espada na frente do rosto para bloquear.
- **Pistola na mão esquerda:** a mira sai do cano, na direção do controle, com a animação de tiro e de recarga do jogo.
- **Granada na cintura**, frasco de cura e trava de mira no inimigo.
- **Câmera:** ajustada nos golpes especiais e finalizações; nas cenas do jogo o mod sai da frente e mostra a câmera original.
- **Corpo e braços:** os dois braços acompanham os controles, e o empurrão do golpe vira reação do inimigo.
- **Aba VR no menu do jogo:** em *Opções* há uma aba **VR** para ligar/desligar vida e balas infinitas, trocar o giro do analógico, ajustar a ajuda da mira e soltar o personagem se ele ficar preso.

## Novidades da 0.4

- **Esquiva e granadas não morrem mais:** o jogo achava que você tinha passado para teclado/mouse (ao mexer o mouse ou trocar de janela) e desligava os botões do controle (esquiva no grip direito, vagas de item). O mod agora devolve o jogo ao controle.
- **Configuração testada aplicada na instalação:** gráficos do jogo (FSR, qualidade, brilho), configuração do UEVR e opções do mod iguais às do autor, uma vez por versão. A sua resolução e o modo da janela ficam; o que existia é guardado e o `desinstalar.bat` devolve os gráficos de antes. Para não aplicar: `instalar.bat -SemConfigDoAutor`.
- **Granada (BETA):** dá para pegar com a **pistola na mão esquerda** (a pistola some e volta depois do arremesso); a mão segura a bomba na pose certa, sem a animação de arremesso do jogo, e a granada é presa na mão na hora em que nasce.
- **Troca de arma:** a arma não voa mais das costas/coldre até a mão; aparece direto na mão.
- **Mosquete:** a mão esquerda encosta no cano (antes às vezes ia por cima ou ficava fora) e não solta à toa; menos rastro/borrão na mão que se move.
- **Espada grande (claymore):** a defesa liga com ela também (lâmina de 140 cm segurada mais longe).
- **Caixotes e objetos quebráveis** quebram só com a espada (antes só depois do gatilho); os pedaços voam menos.
- **Inimigos comuns** não colam mais no personagem (corpo do VR um pouco maior).
- **Trava no inimigo:** a vista acompanha mais suave, sem tranco ao trocar de alvo.
- **Imagem:** reflexos em níveis (`img_reflexos`: madeira e lama não brilham mais como molhadas, menos pontinhos e menos diferença entre os olhos); resolução do VR 0,9 e profundidade enviada ao óculos (mais FPS, menos distorção do quadro inventado). Efeitos de fogo colados no rosto (pegando fogo) escondidos.
- **Núcleo do UEVR do fork joeyhodge (opcional, desligado):** `ValorMortisVR\nucleo-fork-LIGAR.bat` liga um núcleo mais novo com **2D**, **AFR**, **Native Stereo Fix** e correção da faixa preta ao virar a cabeça; `nucleo-fork-DESLIGAR.bat` volta ao normal. Com ele: deixe a janela do jogo na frente até o VR ligar e não minimize o jogo.
- **Game Pass (experimental):** o mod passa a acompanhar os objetos do jogo mesmo quando o UEVR não consegue (era o que deixava o VR "solto" do corpo no Game Pass). `coletar-logs.bat` pega também os gráficos e o registro do jogo do Game Pass.

## Novidades da 0.3.1

- **Granada (BETA):** a mira sai da palma da mão esquerda, aparece em qualquer superfície (água, paredes, céu) e fica enquanto o grip estiver segurado, mesmo levantando a mão.
- **Pegar rápido** não cancela mais o arremesso (antes ficava só a bolinha branca na mão).
- **Bolsos da cintura** mostram o modelo de cada item (granada, frasco); a busca acontece na primeira pausa dentro da fase.
- Com a **pistola** na mão esquerda a cintura fica desligada (o grip é a mira da pistola).

## Novidades da 0.3

- **Funciona com a atualização do jogo de 21/10** (a 0.2 não liga o VR depois dela).
- **Detecção automática:** se o jogo atualizar de novo, o mod procura sozinho o que precisa, sem esperar uma versão nova.
- **Xbox Game Pass (experimental):** o instalador acha o jogo também na pasta do app Xbox.
- **`coletar-logs.bat`:** junta os registros num ZIP na Área de Trabalho para mandar se algo der errado; o instalador grava `relatorio-instalacao.txt`.
- **Mosquete (arma de duas mãos):** segure com as duas mãos (grip esquerdo no cano), mira pelo cano, gatilho direito atira sem virar coronhada, com uma mão fica inclinado para baixo; troca de arma sem a mão voar. O mesmo vale para outras armas longas.
- **Mira com ponto branco** no mosquete e na pistola, e marca no lugar do impacto do tiro.
- **Golpes com peso:** a mão para no inimigo, vibração dupla forte e uma micro-pausa no acerto. Armas longas não dão mais golpe de espada.
- **Itens na cintura:** 3 bolsos para as vagas de item 1, 2 e 3 (pegue com o grip esquerdo); X esquerdo segurado abre o inventário.
- **Granadas (BETA):** pegue na cintura, a bomba fica na palma, uma linha mostra o arco e onde vai cair (aponte com o controle esquerdo), solte o grip para jogar. Granadas infinitas na aba VR (BETA).
- **Cenas em primeira pessoa:** os olhos vão para o rosto do personagem.
- **Giro do analógico:** o corpo gira junto (braços não ficam tortos).
- **Parkour:** corrida na parede, poste e gancho pegam melhor; no ar, o analógico segue a direção do salto, não a cabeça.
- **Imagem:** sem bloom (o brilho espalhado), sem reflexos do Lumen (menos pontinhos brilhantes, mais FPS) e sem efeitos de câmera (desfoque, reflexo de lente, aberração de cor, granulado, borrão).
- **Correções:** fechamento do jogo ao pegar granada; teclas de teste do teclado (F2–F12) só com Ctrl (um esbarrão no F8 congelava os braços); aba VR com os textos certos.

## Novidades da 0.2

- Aba **VR** nas Opções do jogo.
- Espada acerta melhor inimigos grandes, chefes e criaturas; não dá mais golpe sozinha (só com o braço balançando).
- Espadas novas (florete) certas na mão.
- Poderes da mão esquerda (gelo e fogo) presos na mão e no braço.
- Pistola com o frasco vermelho de volta.
- Roleta de armas só pelo analógico e mais firme.
- Escadas não derrubam mais o personagem.
- Câmera mais estável (menos tremida quando o jogo fica pesado).
- Braços no tamanho certo (fixo).
- Vida e balas infinitas (ligadas por padrão; desligue na aba VR).
- Desprender o personagem preso ou embaixo do mapa (aba VR ou tecla **5**).

## Requisitos

| Item | Detalhe |
|---|---|
| Jogo | Valor Mortis (Steam; Xbox Game Pass em teste), Windows |
| Headset | qualquer um com runtime **OpenXR** (SteamVR, Meta/Oculus, Virtual Desktop, etc.) |
| Placa de vídeo | o jogo é pesado; em VR use resolução moderada no seu runtime |
| Windows | PowerShell 5.1 (já vem no Windows 10 e 11) |

## Instalação

1. Em **[Releases](../../releases)** baixe o `ValorMortisVR-v0.4.zip` e **extraia a pasta inteira** (não rode de dentro do ZIP).
2. **Feche o Valor Mortis.**
3. Dê dois cliques em **`instalar.bat`**.
   - Ele procura o jogo sozinho nas bibliotecas da Steam e na pasta do app Xbox (Game Pass).
   - Se não achar, ele pede a pasta do executável do jogo (`...\ValorMortis\Binaries\Win64` na Steam); cole o caminho e aperte Enter.
4. Ligue o headset e abra o jogo (pela Steam ou pelo app Xbox). O VR liga sozinho uns 40 segundos depois; não precisa de injetor.

### Xbox Game Pass (experimental)

No app Xbox, deixe a pasta do jogo acessível para mods (opções do Valor Mortis > gerenciar > gerenciamento avançado / permitir mods) e rode o `instalar.bat`. O executável do Game Pass é diferente do da Steam; o mod procura sozinho o que precisa ao abrir o jogo. Se não funcionar, rode `coletar-logs.bat` e mande o ZIP.

Se ainda não usou o OpenXR com outro jogo, defina primeiro o seu runtime como o OpenXR ativo (no SteamVR, Meta ou Virtual Desktop).

### Instalar numa pasta específica

```bat
instalar.bat "D:\SteamLibrary\steamapps\common\Valor Mortis\ValorMortis\Binaries\Win64"
```

## Atualizar

Baixe a versão nova, extraia e rode o `instalar.bat` de novo. Os arquivos do mod são trocados e os seus ajustes ficam, **exceto quando a versão traz uma configuração do autor nova**: aí ela é aplicada uma vez (gráficos, UEVR e opções do mod), com cópia do que havia. Para manter tudo como está: `instalar.bat -SemConfigDoAutor`.

## Remover

Rode **`desinstalar.bat`**. Ele pede confirmação, apaga o `version.dll` e a pasta `ValorMortisVR` do jogo e devolve o `version.dll` que existia antes, se havia. O jogo em si não é alterado.

## Controles

Mapa atual (pode mudar entre versões):

| Controle | Ação |
|---|---|
| Mão direita | espada (ou mosquete) |
| Mão esquerda | pistola (gatilho esquerdo atira) |
| Grip esquerdo | mirar com a pistola; com o mosquete, segurar o cano com as duas mãos |
| Gatilho direito (mosquete) | mirar e atirar |
| Grip esquerdo na cintura | pegar o item do bolso (granada: segure, aponte e solte para jogar; com a pistola, a mão bem embaixo, no cinto) |
| Grip direito | esquiva |
| Analógico direito para cima / baixo | pular / agachar |
| A direito | recarregar |
| B direito | interagir |
| X esquerdo | curar (frasco); segurado abre o inventário |
| X + Y esquerdos | inventário |
| ☰ esquerdo | pausa; segurado por 0,5 s abre o inventário |
| Analógico direito para os lados | giro da vista em passos |

## Ajustes

O jeito mais fácil é a aba **VR** em *Opções* (no menu de pausa). Os valores ficam salvos em `ValorMortisVR\dados\UnrealVRMod\ValorMortis-Win64-Shipping\plugins\opcoes-vr.txt`:

| Linha | O que muda |
|---|---|
| `giro=40` | ângulo de cada passo do giro da vista (30, 40 ou 45 graus). No jogo: clique os **dois analógicos juntos** para trocar |
| `mira=2.5` | cone da assistência de mira da pistola, em graus (0 desliga). No teclado: tecla **8** troca 2,5, 4 e desligada |
| `vida=0` | vida e balas infinitas (1 liga, 0 desliga). No teclado: tecla **0** |
| `granadas=0` | granadas infinitas (BETA; 1 liga). Também na aba VR |
| `img_reflexos=3` | reflexos do Lumen: 0 = desligados (mais leve, mas superfícies brilham como molhadas); 1 = como o jogo; 2 = só nas superfícies lisas; 3 = só no quase espelho, sem vidro e sem reflexo pela tela (padrão) |
| `img_maos2=1` | 1 = menos rastro/borrão do FSR nos braços e armas do VR; 0 = desliga |
| `img_posfx=1` | 1 = sem desfoque, reflexo de lente, aberração de cor, granulado e borrão (melhor no VR) |

No Game Pass a pasta `ValorMortis-Win64-Shipping` tem o nome do executável do Game Pass.

O menu do UEVR abre com a tecla **Insert** (no teclado do PC).

## Se algo der errado

- **O antivírus reclama do `version.dll`:** ele é o carregador do mod (liga o VR junto com o jogo). Libere a pasta do jogo e rode o instalador de novo. Se a cópia falhar, o instalador avisa.
- **O jogo não abre ou fecha sozinho:** rode `desinstalar.bat`, confirme que o jogo abre normal e instale de novo. Se voltar a acontecer, mande o registro (abaixo).
- **Imagem preta ou nenhum VR:** confira se o runtime OpenXR está ligado e ativo antes de abrir o jogo.
- **Registros:** feche o jogo e rode **`coletar-logs.bat`** (na pasta do instalador). Ele cria `ValorMortisVR-logs-....zip` na Área de Trabalho; anexe esse arquivo ao abrir uma issue.

## Limitações

Ainda em ajuste: **granadas (BETA)**, alguns obstáculos de parkour, ícones dos itens nos bolsos da cintura, golpes de espada em alguns chefes e criaturas novos, e o suporte ao **Game Pass** (experimental). Se o personagem ficar preso depois de uma viagem rápida, use *Desprender* na aba VR (ou a tecla **5**) e salve o jogo num lugar normal. Nada disso trava o jogo.

## O que é instalado

Dentro de `...\Valor Mortis\ValorMortis\Binaries\Win64`:

```
version.dll                      carregador (liga o VR com o jogo)
ValorMortisVR\
  UEVRBackend.dll                núcleo do UEVR
  nucleo-fork\                   núcleo do UEVR do fork joeyhodge (opcional; nucleo-fork-LIGAR.bat / -DESLIGAR.bat)
  openxr_loader.dll              OpenXR (Khronos)
  LuaVR.dll
  perfil\config.txt              perfil inicial do VR
  dados\...\plugins\             plugin do mod (ValorMortisVR.dll) e seus ajustes
```

## Créditos

- [UEVR](https://github.com/praydog/UEVR), por praydog e colaboradores (MIT).
- Núcleo opcional do fork [joeyhodge/UEVR](https://github.com/joeyhodge/UEVR) (branch ue57performance), usado sem alterações.
- OpenXR loader, Khronos Group.
- Mod por MCassador.

---

## English

**Valor Mortis VR** lets you play *Valor Mortis* in virtual reality, in first person, with the character's arms following your controllers. Fan-made mod built on [UEVR](https://github.com/praydog/UEVR) (praydog, MIT). Not official; this repository does not contain the game.

### What's new in 0.4

- **Dodge and grenades no longer stop working:** the game thought you had switched to mouse/keyboard (after moving the mouse or switching windows) and turned off the gamepad buttons (dodge on the right grip, item slots). The mod now switches the game back to the gamepad.
- **Tested settings applied on install:** the game's graphics (FSR, quality, brightness), UEVR settings and mod options match the author's, once per version. Your resolution and window mode are kept; previous files are backed up and `desinstalar.bat` restores your old graphics. To skip: `instalar.bat -SemConfigDoAutor`.
- **Grenade (BETA):** you can grab one with the **pistol in your left hand** (the pistol hides and comes back after the throw); the hand holds the bomb properly, without the game's throw animation, and the grenade is caught in your hand as soon as it spawns.
- **Weapon swap:** the weapon no longer flies from your back/holster to your hand; it just appears in your hand.
- **Musket:** the left hand stays on the barrel (it sometimes went on top or floated off) and doesn't let go by itself; less FSR smearing on the moving hand.
- **Big sword (claymore):** blocking works with it too.
- **Crates and breakables** break with the sword alone (before, only after pulling the trigger); debris flies less far.
- **Regular enemies** no longer press against you (slightly larger VR body).
- **Target lock:** the view follows more smoothly, no jolt when switching targets.
- **Image:** reflection levels (`img_reflexos`: wood and mud no longer look wet, fewer sparkles, less difference between eyes); VR resolution 0.9 and depth sent to the headset (more FPS, less reprojection warping). Fire effects stuck to your face (when burning) are hidden.
- **Optional joeyhodge UEVR fork core (off by default):** `ValorMortisVR\nucleo-fork-LIGAR.bat` enables a newer core with **2D**, **AFR**, **Native Stereo Fix** and a fix for black edges when turning your head; `nucleo-fork-DESLIGAR.bat` goes back. With it, keep the game window in front until VR starts and don't minimize the game.
- **Game Pass (experimental):** the mod now tracks game objects even when UEVR can't (the cause of the "controllers separate from the body" reports on Game Pass). `coletar-logs.bat` also collects the Game Pass game log and graphics settings.

### What's new in 0.3.1

- **Grenade (BETA):** the aim comes out of the left palm, shows on any surface (water, walls, sky) and stays while you hold the grip, even with your hand raised.
- **Quick grabs** no longer cancel the throw (before, only the white ball stayed in the hand).
- **Belt pouches** show each item's model (grenade, flask); they are looked up the first time you pause inside a level.
- With the **pistol** in the left hand the belt is disabled (the grip aims the pistol).

### What's new in 0.3

- **Works with the October 21 game update** (0.2 no longer starts VR after it).
- **Automatic detection:** if the game updates again, the mod looks up what it needs by itself.
- **Xbox Game Pass (experimental):** the installer also finds the game in the Xbox app folder.
- **`coletar-logs.bat`:** collects all logs into a ZIP on your Desktop to send if something goes wrong; the installer writes `relatorio-instalacao.txt`.
- **Musket (two-handed weapon):** hold it with both hands (left grip on the barrel), aim down the barrel, right trigger fires (no accidental bayonet bash), lowered when held with one hand; no flying hand on weapon swap. Same for other long guns.
- **White aim dot** on the musket and the pistol, plus a marker where the shot lands.
- **Weightier melee:** your hand stops on the enemy, strong double vibration and a short hit-pause. Long guns no longer count as blades.
- **Belt items:** 3 belt pouches for item slots 1, 2 and 3 (grab with the left grip); hold left X to open the inventory.
- **Grenades (BETA):** grab one from your belt, it sits in your palm, an arc shows the trajectory and landing spot (point with the left controller), release the grip to throw. Infinite grenades option in the VR tab (BETA).
- **First-person cutscenes:** your eyes go to the character's face.
- **Snap turn:** the body turns with it (arms no longer twisted).
- **Parkour:** wall run, poles and grappling hook catch better; in the air, the stick follows the jump direction, not your head.
- **Image:** no bloom, no Lumen reflections (fewer sparkles, more FPS) and no camera effects (depth of field, lens flare, chromatic aberration, film grain, motion blur).
- **Fixes:** crash when grabbing a grenade; keyboard test keys (F2–F12) now need Ctrl (an accidental F8 froze the arms); VR tab labels.

### Install

1. Download `ValorMortisVR-v0.4.zip` from **[Releases](../../releases)** and extract the whole folder.
2. Close Valor Mortis.
3. Double-click **`instalar.bat`**. It finds the game in your Steam libraries and in the Xbox app folder (Game Pass); if not, paste the folder that contains the game executable (Steam: `...\ValorMortis\Binaries\Win64`).
4. Start your OpenXR runtime (SteamVR, Meta/Oculus, Virtual Desktop…) and launch the game. VR turns on by itself about 40 seconds later.

**Game Pass (experimental):** in the Xbox app, make the game folder accessible for mods (advanced management / allow mods), then run `instalar.bat`.

**Update:** run the new `instalar.bat`; your settings are kept. **Uninstall:** run `desinstalar.bat`.

**Something wrong?** Close the game, run **`coletar-logs.bat`** and attach the ZIP it creates on your Desktop to an issue.

**Settings:** the **VR** tab in the game's *Options* menu (infinite health/ammo, infinite grenades (beta), snap turn angle, pistol aim assist, unstuck).

**Known limitations:** grenades (BETA), some parkour obstacles, item icons on the belt pouches, sword hits on some new bosses/creatures, and Game Pass support (experimental).
