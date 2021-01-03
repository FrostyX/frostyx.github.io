---
layout: post
title: Facebook API - Sdílení vaší stránky na facebooku
lang: cz
tags: facebook dev php
---


V poslední době jsem dělal na několika webech, které měli být přátelské k facebooku. Šlo především o tlačítka pro sdílení, lajkování a komentáře. Dále pak aby se při sdílení stránky na facebooku zobrazil správný náhled, popisek, etc. Problém je, že vždycky zapomenu, jak jsem to minule řešil a pak trávím zbytečně moc času pročítáním dokumentace.


## Meta tagy
Slouží ke specifikaci názvu stránky, náhledu, popisu, etc. Hodí se vyplnit následující.

<pre class="prettyprint">
&lt;meta property="og:title" content="Foobar" /&gt;
&lt;meta property="og:type" content="article" /&gt;
&lt;meta property="og:url" content="http://example.com/foobar" /&gt;
&lt;meta property="og:description" content="Some foobar description" /&gt;
&lt;meta property="og:site_name" content="example.com" /&gt;
&lt;meta property="og:image" content="http://example.com/image.png" /&gt;
&lt;link rel="image_src" href="http://example.com/image.png" /&gt;
</pre>

Názvy vlastností jsou vypovídající a není potřeba je blíže popisovat. Tedy až na `type`. Doporučuji jej jednoduše nastavit na article a dál neřešit. Díky tomu přestaly být nabízeny obrázky z celého webu jako náhled, ale pouze ze chtěné podstránky.

## Cache
Facebook si samozřejmě cachuje záznamy o vaší stránce a obnovuje je pouze v následujících situacích.


- Každých sedm dní
- Zadáním URL do [debuggeru](http://developers.facebook.com/tools/debug)
- Posláním specifického POST požadavku na <https://graph.facebook.com/>


Z toho plynou jisté důsledky. Například, pokud přidáte příspěvěk na stránku, potrvá týden, než jej bude možné na facebooku korektně sdílet. Nebo alespoň pokud jej nedonutíte, aby si načetl nové cache hned po přidání příspěvku.


Donutit facebook můžete pomocí [debuggeru](http://developers.facebook.com/tools/debug), což ale nejde programově, takže je to pro použití v aplikaci k ničemu. Pro tento účel jsem si vytvořil jednoduchou třídu FacebookDebugger obsahující metodu reload($url). Její použití je zřejmé. Vše naleznete na gitu - <https://gist.github.com/FrostyX/81d58222d1e835e24013>.
