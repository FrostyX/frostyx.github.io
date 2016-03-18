---
layout: post
title: Vzhled notify-send
lang: cz
categories: desktop
---


Delší dobu jsem chtěl změnit vzhled notify-send, aby vypadal například jako v aweesome wm. Výchozí vzhled se mi totiž vůbec nelíbí, zabírá zbytečně moc místa a v kombinaci s častými změnami na Dropboxu mě příliš otravuje. Nikdy se mi nepodařilo najít návod, jak změny vzhledu jednoduše docílit.

Obrázek: Default notify
![Obrázek: Default notify](/files/img/default-notify-crop.png)

Obrázek: Awesome notify
![Obrázek: Default notify](/files/img/awesome-notify-crop.png)

Naštěstí se problém konečně podařilo vyřešit. Místo klasického notification-daemon jsem použil alternativní prográmek dunst.

Při spuštění grafického prostředí nechejte automaticky provádět následující příkazy:

*~/.xmonad/autostart.sh*
<pre class="prettyprint">
kill `pidof notification-daemon`
dunst -conf ~/.dunstrc &
</pre>

A pak už si jen upravte vzhled dle libosti (nezapomeňte, že aby se změny projevily,  je potřeba dunst restartovat ).

*~/.dunstrc* (jen ukázková část. Zbytek na gitu)
<pre class="prettyprint">
[global]
font = terminus-medium 7
format = "<b>%s</b>\\n%b"
geometry = "270x5-140+748"

[urgency_normal]
background = "#1B1D1E"
foreground = "grey"
timeout = 10
</pre>

Obrázek: Moje notify (detail)
![Obrázek: Moje notify (detail)](/files/img/my-notify-crop.png)

Obrázek: Moje notify (s prostředím)
[![Obrázek: Moje notify (detail)](/files/img/my-notify-thumb.png)](/files/img/my-notify-full.png)
