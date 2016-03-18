---
layout: post
title: Gentoo - aktualizace
lang: cz
categories: gentoo updates
---


Gentoo nabízí jeden z nejlepších systému pro správu balíčků - portage. K aktualizacím proto lze přistupovat docela individuálně. Zde bych (především pro sebe) chtěl sepsat můj postup.

<div class="warning">Upozornění: Autor zápisku není zodpovedný za škody vzniklé aplikací tohoto postupu.</div>

Nejdříve je samozřejmě nutná synchronizace repozitářů

<pre class="prettyprint">
emerge --sync
</pre>

Aktualizace by spadla při instalování balíčku virtualbox-modules, proto před samotnou aktualizací celého systému, provedu následující krok.

<pre class="prettyprint">
emerge gentoo-sources
cd /usr/src/linux
make oldconfig
make modules_prepare
</pre>

Teď všechny balíčky

<pre class="prettyprint">
emerge -uDNptv world
emerge -uDNtv world
emerge -1 $(qlist -IC x11-drivers)
emerge -pv --depclean
emerge -v --depclean
revdep-rebuild -pv
revdep-rebuild
etc-update
</pre>

Následuje kompilace nového jádra, nakopírování do /boot, přidání do grubu a reboot

<pre class="prettyprint">
cd /usr/src/linux
make && make modules_install
cp arch/x86/boot/bzImage /boot/gentoo-version
reboot
</pre>

Po rebootu je potřeba nainstalovat a zavést moduly pro virtualbox.

<pre class="prettyprint">
emerge virtualbox-modules
modprobe vboxdrv
</pre>

---

### Příkazy, které se mohou hodit

Překompiluje všechny balíčky, kterým se změnily USE flagy

<pre class="prettyprint">
emerge -pN world
</pre>

Nainstaluje balíček, ale nenapíše jej do world souboru

<pre class="prettyprint">
emerge --oneshot package
</pre>

---

### Problémy
Používám XMonad a čas od času se stane, že po aktualizaci nenaskočí. Řešení je následující.

<pre class="prettyprint">
# Vypíše seznam balíčků. Červeně vypsané jsou rozbité a je potřeba je přeinstalovat
ghc-pkg list

# Přeinstalování balíčku
emerge --oneshot balicek
</pre>

Někdy se zase stane, že nejde překompilovat a tím změnit konfigurace. Chybu ukazuje na include řádcích, které jsou ale v pořádku - nenechte se zmást.

<pre class="prettyprint">
emerge xmonad-contrib
</pre>

Měli bychom dostat chybu ve které jsou tyto neviné řádky (ani nejsou označené červeně)

<pre class="prettyprint">
setup: At least the following dependencies are missing:
X11 >=1.2.1
* ERROR: x11-wm/xmonad-contrib-0.10 failed (configure phase):
  setup configure failed
</pre>

Přeinstalujeme balíček který údajně chybí. Ten možná spadne na podobné chybě, tak nejdříve vyřešíme závislost pro něj.
