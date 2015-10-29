#!/bin/bash

clear

#Tratamento dos arquivos

for i in $(find . | xargs grep -s -a -i ﻿ | uniq)
	do
		find . -iname '*.CSV' | xargs sed -i 's/﻿//g';
done

