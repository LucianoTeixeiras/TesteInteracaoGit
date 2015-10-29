#!/bin/sh

#INDENTIFICAR O PEDIDO
sqlplus prod2/prod2@wdb @getidpedido.sql $1 | grep "PEDIDO=|" -i | cut -d"|" -f2

