---
layout: post
title: Nastavení NTP na Gentoo
lang: cz
tags: gentoo
---


Protokol NTP (Network Time Protocol), jak jeho název říká, slouží k synchronizaci času po síti. To znamená - nainstalovat, nastavit a navždy mít přesný čas.

Nejdříve ze všeho nastavíme správné časové pásmo.

*/etc/timezone*
<pre class="prettyprint">
Europe/Prague
</pre>

Nainstalujeme daemona openntpd. Ten se postará, aby se v případě drobných výchylek, oproti nastaveným serverům, synchronizoval čas.

<pre class="prettyprint">
emerge openntpd
</pre>

V konfiguračním souboru zakomentujeme řádek obsahující "listen on". Ten je žádoucí nastavit pouze v případě, kdy sami chceme vytvářet NTP server. Dále nastavíme servery, ze kterých budeme získávat čas.

*/etc/ntpd.conf*
<pre class="prettyprint">
# listen on *
server 0.cz.pool.ntp.org
server 1.cz.pool.ntp.org
server 2.cz.pool.ntp.org
server 3.cz.pool.ntp.org
</pre>
Seznam serverů pro libovolné časové pásma naleznete na <http://www.pool.ntp.org/zone/@>

Daemona spustíme a nastavíme jeho automatické spoušení při startu systému.

<pre class="prettyprint">
/etc/init.d/ntpd start
rc-update add ntpd default
</pre>

Nainstalujeme utilitku, která seřídí čas v případě, že je oproti serveru hodně vychýlený.

<pre class="prettyprint">
emerge openrdate
</pre>

Nastavíme server, oproti kterému se bude čas synchronizovat. Stačí nastavit hodnotu proměnné "RDATE_SERVER".

*/etc/conf.d/openrdate*
<pre class="prettyprint">
RDATE_SERVER="0.cz.pool.ntp.org"
</pre>

Prográmek spustíme a nastavíme jeho automatické spoušení při startu systému.

<pre class="prettyprint">
/etc/init.d/openrdate start
rc-update add openrdate default
</pre>

V poslední řadě nastavíme synchronizaci hw času se systémovým. Pokud bychom tak neučinili, po rebootu by mohl být systémový čas opět rozhozený.

*/etc/conf.d/hwclock*
<pre class="prettyprint">
clock_systohc="YES"
</pre>

A je to! Odteď už bychom v systém měli mít vždy přesný a seřízený čas!

### Odkazy
1. <http://en.gentoo-wiki.com/wiki/Time_Synchronization>
2. <http://en.gentoo-wiki.com/wiki/Time_Synchronization#openntpd>
3. <http://en.gentoo-wiki.com/wiki/Time_Synchronization#openrdate>
