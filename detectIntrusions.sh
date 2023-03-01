#!/bin/bash

# Verificar si hay conexiones sospechosas en el puerto 4444
netstat -an | grep :4444 | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn > /tmp/suspects.txt

# Bloquear las conexiones sospechosas
while read line; do
  count=`echo $line | awk '{print $1}'`
  ip=`echo $line | awk '{print $2}'`
  if [[ "$count" -gt 10 ]]; then
    echo "Bloqueando $ip por $count conexiones sospechosas"
    iptables -I INPUT -s $ip -j DROP
  fi
done < /tmp/suspects.txt

# Guardar las reglas de iptables
iptables-save > /etc/iptables/rules.v4


#netstat -an | grep "ESTABLISHED"  Monitoreo en tiempo real

#lsof -iTCP -sTCP:ESTABLISHED -P -n  

# En este output cuál sería el puerto de salida de la conexión ? firefox-e 23641 seba  111u  IPv4 151463      0t0  TCP 192.168.3.140:49150->52.41.124.48:443 (ESTABLISHED)

# En el output mostrado, el puerto de salida sería el número "49150" después de la dirección IP local "192.168.3.140" y antes del símbolo "->". Esta es la dirección y el puerto local de la conexión. En este caso, el proceso Firefox (con PID 23641) está conectado al servidor remoto en el puerto 443.
