---
layout: post
title: C - cmake - include math.h
lang: cz
tags: dev C
---


Pokud vytváříte projekt v C, který sestavujete a spouštíte pomocí
<pre class="prettyprint">
cmake .
make
../bin/my-bin
</pre>

Pravděpodobně máte soubor CMakeLists.txt ve kterém je asi něco takového

*build/CMakeLists.txt*
<pre class="prettyprint">
PROJECT(my-project)
ADD_EXECUTABLE(../bin/my-bin ../src/main.c)
</pre>

Problém nejspíš nastane, pokud budete chtít používat funkce ze souboru <math.h>. Řešení je naštěstí jednoduché. Do CMakeLists.txt stačí připsat řádek

*build/CMakeLists.txt*
<pre class="prettyprint">
TARGET_LINK_LIBRARIES(../bin/my-bin m)
</pre>

Ano, opravdu jen ''m''. Není to překlep.

Také není problém pokud chcete přeložit soubor jen pomocí příkazu gcc
<pre class="prettyprint">
gcc ../src/main.c -o ../bin/my-bin -lm
</pre>


### Odkazy
1. [http://www.cmake.org/cmake/help/cmake_tutorial.html](http://www.cmake.org/cmake/help/cmake_tutorial.html)
