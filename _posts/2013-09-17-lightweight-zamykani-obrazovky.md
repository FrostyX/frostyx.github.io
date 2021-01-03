---
layout: post
title: Lightweight zamykání obrazovky
lang: cz
tags: desktop
---


Situace ohledně zamykání obrazovky je na linuxu, řekl bych, spíše nedostatečná. Tedy alespoň donedávna byla. Narazíte na spoustu nástrojů, které slouží jako přihlašovací obrazovky pro hlavní desktopové prostředí. Jmenovitě jsou to KDM, [GDM](https://projects.gnome.org/gdm/). Jejich nevýhoda je zřejmá. Mají závislosti právě na těch prostředích. Další, poměrně novou aplikací je [LightDM](http://www.freedesktop.org/wiki/Software/LightDM/), které přestože nemá závilost na konkrétním grafickém prostředí, mi moc light nepřipadá. Ale hlavně, že je bez cukru.

Na druhou stranu najdeme několik až příliš jednoduchých nástrojů. Například [slock](http://tools.suckless.org/slock), který nenabízí žádný dialog pro zadání hesla, nebo XDM, které jednoduše řečeno, vypadá hrozně.

## Slim & Slimlock
Konečně, zlatá střední cesta. Jedná se o dva nástroje ve dvou balíčcích. Chtěl bych říci samostatné nástroje, ale nejsem si úplně jistý, nakolik se dají použít jeden bez druhého. [Slim](http://slim.berlios.de/) slouží pouze pro přihlašování do grafického prostředí. Ten můžete bez problému používat samostatně - spousta lidí to tak dělá. Osobně si moc nedovedu představit, k čemu je to dobré. Přihlásit se můžu i v TTY a napsat `startx` už není takový problém. Pokud člověk nerebootuje počítač stokrát denně, nebude v tom moc rozdíl. Jistě vám došlo, že [Slimlock](http://joelburget.com/slimlock/) je tedy nástroj pro zamykání obrazovky. Řekl bych, že jej do své distribuce nedostanete standardní cestou, aniž byste přitom nainstalovali SLim. Vypůjčuje si totiž z jeho konfiguračního souboru například nastavení tématu.

Téma obou nástrojů je totožné. Skládá se ze čtyř jednoduchých částí - wallpaper, logo, vstupní políčko a jednoduchý, textový, konfigurační soubor popisující rozmístění jednotlivých komponent po obrazovce. Pokud si nevyberete z [již vytvořených témat](http://slim.berlios.de/themes01.php), snadno si můžete některé z nich upravit k obrazu svému.

Nyní se spolu koukneme, jak jednoduchá je instalace a nastavení. Mimochodem, všechny důležité kroky vypíše emerge v poinstalační zprávě.

---

### Slim
Pokud jste uživatel binární distrubuce, budete muset vyjít s tím, jak je balíček sestavený. Na gentoo máme k dispozici USE flagy `branding`, který nainstaluje gentoo motiv, `consolekit`, který budete potřebovat například pro práci s disky v nautilu/thunaru/etc a `pam`.

Chtěl jsem vlastní motiv, takže mi bylo gentoo téma k ničemu.

*/etc/portage/package.use*
<pre class="prettyprint">
x11-misc/slim -branding
</pre>

Nezahálíme, instalujeme
<pre class="prettyprint">
emerge slim
</pre>

Témata najdete v `/usr/share/slim/themes/` a konfigurační soubor je `/etc/slim.conf`. Zde si můžete nastavit aktivní téma a mnoho dalších věcí. Všechny volby jsou řádně popsané.

Nastavíme výchozí login manager

*/etc/conf.d/xdm*
<pre class="prettyprint">
DISPLAYMANAGER="slim"
</pre>

Nastavíme výchozí prostředí. Dočasně je můžeme měnit pomocí klávesy F1
<pre class="prettyprint">
# V /etc/X11/Sessions máte skripty reprezentující prostředí, které máte v systému.
# Zvolte si, které chcete jako výchozí
ln -s /etc/X11/Sessions/xmonad ~/.xsession
</pre>

Nastavíme automatické spouštění slimu po startu počítače a spustíme jej i teď.
<pre class="prettyprint">
rc-update add xdm default

# Spustíme slim
## Ručně
/etc/init.d/xdm start

## Nebo rebootujeme a necháme jej spustit automaticky
reboot
</pre>

---

### Slimlock

Instalujeme

<pre class="prettyprint">
emerge slimlock
</pre>

Následně pomocí příkazu `slimlock` uzamknete obrazovku. Jak jednoduché.


## Problémy

### Prodleva při zadání špatného hesla.
První věc, které jsem si všiml byla nepříjemná dvousekundová prodleva, než mi bylo dovoleno opravit heslo. Způsobuje to:

*/etc/slimlock.conf*
<pre class="prettyprint">
wrong_passwd_timeout   2
</pre>

Stačí nastavit hodnotu 0 a je klid.

---

### XMonad a autostart skript.
Skript "po spuštění" volám v souboru .xinitrc, protože XMonad to sám neudělá. Musel jsem si tedy upravit soubor .xsession

*~/.xsession*
<pre class="prettyprint">
# Configure
wm="xmonad"
autostart=$HOME/.xmonad/autostart.sh

# Run
exec sh -c ". $autostart; exec $wm"
</pre>

---

### Nastavení proměnné $PATH
Vždy jsem si v .bashrc pomocí následujících řádků upravil proměnnou $PATH.

<pre class="prettyprint">
PATH=$HOME/.bin:$PATH
export PATH
</pre>

Není možno ji dále nastavovat v .bashrc, protože slim je spuštěn initem dávno před bashem. Řešení tomuto problému byl na foru gentoo věnován samostatný topic, takže vás pro více informací odkážu tam: <http://forums.gentoo.org/viewtopic-p-7396036.html>.

Řešením je nastavení $PATH v souboru `.xsession`. Pozor, je potřeba tak učinit před řádkem začínajícím příkazem `exec`.


## Odkazy
1. <http://wiki.gentoo.org/wiki/SLiM>
2. <http://slim.berlios.de/>
3. <http://slim.berlios.de/themes01.php>
4. <http://joelburget.com/slimlock/>
5. <http://darkshed.net/projects/alock>
