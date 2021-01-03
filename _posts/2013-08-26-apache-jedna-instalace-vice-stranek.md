---
layout: post
title: Apache - jedna instalace, více stránek
lang: cz
tags: dev
---


Weby dnes vyvíjí hodně lidí a mnoho z nich nepracuje jen na jednom, ale hned na několika naráz. Nejedná se jen o profesionály, ale také o studenty, kteří během školního roku řeší řadu webových prezentací. Často jim nikdo neřekne, jak si nastavit webový server a jak k jednotlivým prezentacím přistupovat, aby to bylo alespoň trochu pohodlné. Proto bych rád ukázal, jak to řeším já.

Cílem bude přidělit každému webu jiný port a potom k němu přistupovat pomocí http://127.0.0.1:port. Není to nic složitého. Nejdříve potřebujete najít správný konfigurační soubor. V linuxových distribucích to nejspíš bude /etc/apache2/httpd.conf. Na windows můžete použít například software [EasyPHP](http://www.easyphp.org/). V tom případě vás bude zajímat konfigurační soubor C:\\Program Files\\EasyPHP-DevServer-13.1VC9\\binaries\\apache\\conf\\httpd.conf (můžete se k němu doklikat pomocí ikony EasyPHP v tray liště, nebo pomocí hlavního okna aplikace).

## Jdeme na to
Najděte řádku začínající slovem "Listen". Asi vám došlo, že toto klíčové slovo říká, na kterém portu apache naslouchá. Další port přidáme jednoduše tak, že napíšeme další řádku začínající "Listen" následovanou číslem portu. Pokud se v číslech portů nevyznáte, raději se koukněte jestli vámi zvolený nepoužívá nějaká [důležitá služba](http://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers).

*/etc/apache2/httpd.conf*
<pre class="prettyprint">
# Apache bude naslouchat na portech 80, 8001, 8002 a 8003
Listen 80   # Výchozí port pro http
Listen 8001 # První projekt
Listen 8002 # Druhý projekt
Listen 8003 # Třetí projekt
</pre>

Nyní jednotlivé weby nastavíme. Podívejte se, zda v konfiguračním souboru máte sekci týkající se VirtualHost. Pokud ne, pište na konec souboru. Teď  k samotnému kódu - ukážu jen základní možnosti, které využije asi každý, ale pokud potřebujete, zvolte konfiguraci, jaká vám bude sedět nejlépe.

*/etc/apache2/httpd.conf*
<pre class="prettyprint">
# Ukázka VirtualHostu pro linux
&lt;VirtualHost *:8001&gt;
ServerName prvni-projekt
DocumentRoot "/var/www/prvni-projekt"
&lt;Directory "/var/www/prvni-projekt"&gt;
Options Indexes FollowSymLinks
AllowOverride All

## V závislosti na verzi nainstalovaného apache ponechte jednu z možností:
# Apache 2.2
Order allow,deny
Allow from all

# Apache 2.4
Require all granted
&lt;/Directory&gt;
&lt;/VirtualHost>

# Ukázka VirtualHostu pro EasyPHP (verze 13.1)
&lt;VirtualHost *:8002&gt;
ServerName druhy-projekt
DocumentRoot "${path}/binaries/apache/htdocs/druhy-projekt"
&lt;Directory "${path}/binaries/apache/htdocs/druhy-projekt">
Options Indexes FollowSymLinks
AllowOverride All

## V závislosti na verzi nainstalovaného apache ponechte jednu z možností:
# Apache 2.2
Order allow,deny
Allow from all

# Apache 2.4
Require all granted
&lt;/Directory&gt;
&lt;/VirtualHost>

&lt;VirtualHost *:8003&gt;
# ...
&lt;/VirtualHost&gt;
</pre>

A je to! Náš první projekt si můžeme prohlédnout na <http://172.0.0.1:8001>, druhý na <http://172.0.0.1:8002>, ...

## Odkazy
1. <http://httpd.apache.org/docs/2.4/upgrading.html>
2. <http://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers>
3. <http://www.easyphp.org/>
