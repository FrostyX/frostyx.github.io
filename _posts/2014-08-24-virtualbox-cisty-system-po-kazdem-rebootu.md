---
layout: post
title: Virtualbox - Čistý systém po každém rebootu
lang: cz
tags: virt
---

Z nějakých důvodů potřebujete použít windows? Pracujete na projektu, nebo využíváte technologii, která nemá podporu pro váš operační systém? Dost možná sáhnete po nějakém virtualizačním software. Já zvolil VirtualBox.


## Zásadní problém Windows
Znáte to. Ať děláte co děláte, ať použijete jakou verzi Windows chcete, po čase se stejně vždycky zabordelí, zaseká a zpomalí. Existuje řada nástrojů (jako [Protect-On](http://www.mastereye.cz/protecton-pro)), které uživateli dovolují dělat pouze dočasné změny (po rebootu je totiž systém obnoven z uloženého snapshotu), ale to taky není úplně ono - hlavně proto, že je potřeba instalovat nějaký pochybný nástroj třetí strany.

## VirtualBox má řešení
Řešení, kterým je změna typu virtuálního disku na takzvaný "immutable", zařídí chování přesně tak, jak jsem zmínil výše. A to navíc zdarma, jednoduše a bez instalace cizích nástrojů.

### Jak na to?
Nejdříve si vytvoříme virtuální systém, nainstalujeme a nastavíme jako obvykle. Mějme na paměti, že všechna data se po restartu počítače budou mazat, takže je potřebujeme ukládat mimo systém. [Jednoduše nasdílíme](http://www.youtube.com/watch?v=HzgL77r1AB8) adresáře z hostitelského systému a data budeme ukládat do nich. Ve virtuálním systému se nasdílené adresáře nacházejí zde:

<pre class="prettyprint">
\\vboxsrv\
</pre>

Předpokládejme, že máme systém ve stavu, který nám vyhovuje. Chceme jej tedy zachovat a příště už spouštět systém tak, jak vypadá nyní. Nejdříve jej vypneme a v nastavení odpojíme disk. Pokud tento krok přeskočíme, zbytek nejspíš nebude fungovat.

Poté co máme disk odpojený, změníme typ na immutable, opětovně jej připojíme a máme hotovo. Odteď už budeme mít pokaždé "čistý" systém.

<pre class="prettyprint">
VBoxManage modifyhd WinXP-Dev.vdi --type immutable
</pre>

### Dodatečné změny
Samozřejmě se může stát, že budeme potřebovat dodatečně něco doinstalovat, nebo změnit některá nastavení. Postup je podobný. Nejdříve vypneme virtuální stroj, odpojíme disk, změníme jeho typ na "normální", následně jej připojíme a je to. Nyní můžeme provádět trvalé změny.

<pre class="prettyprint">
VBoxManage modifyhd WinXP-Dev.vdi --type normal
</pre>

## Odkazy
1. <https://forums.virtualbox.org/viewtopic.php?f=6&t=38295>
2. <http://www.youtube.com/watch?v=HzgL77r1AB8>
