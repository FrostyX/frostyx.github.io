---
layout: post
title: Nahrávání obrazovky (včetně zvuku)
lang: cz
---


Screencasty jsou dnes hrozně cool a každý druhý jouda má svůj video tutoriál, jak v Photoshopu změnit barvu pozadí, jak být hacker a v novém Ubuntu změnit pozadí, nebo jak v html naprogramovat svůj vlastní web. Opravdu - někteří jsou až tak dobří, že umí programovat ve značkovacím jazyce!

Inu rozhodl jsem se, že si taky zkusím nějaký screencast udělat. Nikoliv proto, že jsem tak zdatný jako výše zmiňovaní a oplývám mimořádnými schopnostmi, ale spíš proto, abych si to také vyzkoušel. A možná trochu proto, abych si poslechl jak moc hloupě budu znít.

## recordMyDesktop
Prográmek [recordMyDesktop](http://recordmydesktop.sourceforge.net/about.php) zvládá základní požadavky docela obstojně.

1. Umí nahrávat i zvuk z mikrofonu
2. Lze jej ovládat klávesovými zkratkami
3. Nabízí konzolové, GTK i Qt rozhraní

Pro popis ovládání vás [odkážu](http://wiki.ubuntu.cz/programy/multimédia/recordmydesktop) na českou ubuntu wiki.

Použití je díky nepříliš obsáhlému a intuitivnímu rozhraní velmi jednoduché a s aplikací tak zvládne pracovat každý. Bohužel je to ale něco za něco. Lze nahrávat celou obrazovku, vybranou část, nebo jedno konkrétní okno. Pro velkou část návodů by se hodilo nahrávat konkrétní část obrazovky, ale její výběr je natolik nepříjemný, že jsem tuto možnost zavrhl. Nahrávání jednoho okna je moc pěkná funkce, ale ve chvíli, kdy člověk potřebuje přepínat mezí více aplikacemi, má problém. \r\n
Zbývá tedy poslední, nejjednodušší možnost - celá plocha. Jen mi přijde zbytečné a navíc trochu nepříjemné, aby mi ostatní koukali do systémových informací, které mám v panelech po krajích obrazovky. recordMyDesktop se nechce nechat snadno přemluvit, aby panely nenahrával, tak jsem to vzal z druhého konce. Nabindoval jsem si zobrazení a schování panelů (na úrovni správce oken Xmonad) na klávesovou zkratku.


<pre class="prettyprint">
-- Toggle dzen2 panels hidden/visible
, ((modm, xK_F11), sendMessage ToggleStruts)
</pre>

Se schovaným panelem pak těžko ovládat nahrávání, proto se výborně hodí globální klávesové zkratky. Globální znamená, že jsou k dispozici, ať už je aktivní libovolné okno.


<pre class="prettyprint">
// Klávesa Mod1 většinou představuje levý alt.
Control+Mod1+p // Přepínání pause/unpause
Control+Mod1+s // Stop
</pre>

## Odkazy
1. <http://wiki.ubuntu.cz/programy/multim%C3%A9dia/recordmydesktop>
2. <http://recordmydesktop.sourceforge.net/rug/app_a.php>
