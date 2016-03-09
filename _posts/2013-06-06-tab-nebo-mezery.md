---
layout: post
title: TAB nebo mezery?
lang: cz
---


O tom, že je potřeba zdrojové kódy řádně formátovat, k čemuž nedělitelně patří i jejich odsazování a zarovnávání, není potřeba vést žádné velké diskuse. Laskavý čtenář, nechť sám posoudí jak se mu líbí následující triviální kód.

*Zdrojový kód bez odsazování*
<pre class="prettyprint">
int main(int argc, char **argv)
{
int i;
for(i=0; i&lt;10; i++)
{
if(i%2==0)
printf("%i\\n", i);
}
return 0;
}
</pre>

*Řádně odsazovaný zdrojový kód*
<pre class="prettyprint">
int main(int argc, char **argv)
{
	int i;
	for(i=0; i&lt;10; i++)
	{
		if(i%2==0)
		printf("%i\\n", i);
	}
	return 0;
}
</pre>

Není pochyb, že řádně odsazovaný zdrojový kód je pro člověka čitelnější, přehlednější a nemá nutkání kvůli němu vyskočit z okna. Protože se v kódu rychleji zorientuje, může svou práci na něm dokončit dříve. (Nemluvě o tom, že existují jazyky např. [Haskell](http://www.haskell.org/haskellwiki/Haskell), které považují bílé znaky za syntaxi a ve kterých je tedy nutné striktně dodržovat jejich způsob odsazování.)


Dohady však nebývají na téma zda odsazovat, nýbrž na téma čím odsazovat. Programátoři na sebe navzájem křičí, že mezery jsou špatné, jiní že tabulátory jsou zlo a jiní zase, že mezery jsou jediná správná cesta a ještě by rádi diktovali jejich počet. Dle mě mají pravdu všichni, ale zároveň nikdo. Odsazování a zarovnávání jsou dva rozdílné pojmy, které je potřeba si ujasnit a podle toho k nim přistupovat.

## Odsazování
Nebavme se o situaci, kdy se připojujeme k rozběhlému projektu a kdy nezbývá než přijmout zvyklosti, které zavedla komunita kolem něj. Mluvme o situaci, kdy vytváříme něco nového. Pokud by chtěli všichni používat stejné vývojové prostředí, stejnou šířku odsazování, atd., je úplně jedno, zda se zvolí mezery, nebo TABy. Tak tomu ale často není. Jednoduše proto, že každému vyhovuje něco jiného.

Proč bychom měli někomu diktovat, jakou šířku odsazení má používat, když to není nezbytně nutné. K tomu se perfektně hodí tabulátor. Proč by taky neměl? Vždyť slouží k odsazení textu na určitou úroveň. Ta je jasně daná (*jeden tab = jedna logická úroveň*) a každý uživatel si může šířku odsazení upravit podle sebe. Tohle s použitím mezer tak lehce nedokážeme.

![odsazování pomocí TABů](/files/img/odsazovani.png)
Kód vlevo má šířku tabulátoru 8 mezer, kód vpravo 4 mezery. Přesto se formátování nerozbilo.

## Zarovnávání
Pod pojmem zarovnání si představme posunutí určité části řádku na určitou úroveň (tedy nikoliv celý řádek). Pro názornost se podívejme na následující kód ve kterém lze vidět zarovnání hodnot na jednu úroveň.

*Část konfiguračního souboru [config.def.h](http://git.suckless.org/dwm/plain/config.def.h) správce oken [dwm](http://dwm.suckless.org/)*
<pre class="prettyprint">
static const char font[]            = "-*-terminus-medium-r-*-*-16-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#444444";
static const char normbgcolor[]     = "#222222";
static const char normfgcolor[]     = "#bbbbbb";
static const char selbordercolor[]  = "#005577";
static const char selbgcolor[]      = "#005577";
static const char selfgcolor[]      = "#eeeeee";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */
</pre>

A jak na to? Nabízí se zarovnat TABem, když už jím i odsazujeme, ... Radši to ale promyslete. Tady už neposouváme začátek řádku, ale jen nějakou jeho část. Co se stane, když použijeme tabulátor, přenastavíme v editoru jeho šířku a otevřeme soubor znovu?

![odsazování pomocí TABů](/files/img/zarovnavani-tabstop-8.png)
Při původní šířce tabulátoru 8 mezer je kód v pořádku.

![odsazování pomocí TABů](/files/img/zarovnavani-tabstop-4.png)
Bohužel při poloviční šířce tabulátoru už se to říci nedá.

Z toho vyplývá jediné. Nezbývá nic jiného, než *zarovávat pomocí mezer*.

## Tip na závěr
Každý slušný textový editor podporuje zobrazení bílých znaků (tedy mezer, tabulátorů, konců řádku). Vždy doporučuji mít tuto možnost zapnutou, ať máme větší přehled o formátování kódu. Znaky bývají zobrazeny nevýraznou barvou, takže si je s kódem plést nebudete.

## Odkazy
1. <http://www.iovene.com/posts/2007/05/tabs-vs-spaces-the-end-of-the-debate/>
