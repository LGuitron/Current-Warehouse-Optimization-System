# Andorid APP Services #

### Parameters needed ###

<br>

* #### scanning.php

  Name | Value | Example
  ---|---|---
  s | It's going to be 1 for loading the lift truck / 0 for leaving the product in the new section
  ean | The EAN scanned | 7501234567893
  mnt | ID of lift truck who took the EAN | 7
  sec | Section sended by beacons | 16
  time | Timestamp with format (YYYY-mm-dd hh:mm:ss) | 2017-11-23 13:17:33
  pid | A unique product ID | 123e4567-e89b-12d3-a456-426655440000

<br>
<hr>

* #### delete.php

  Name | Value | Example
  ---|---|---
  s | It is needed to be "delete" | delete
  ean | The EAN scanned | 7501234567893
  mnt | ID of lift truck who took the EAN | 7
  pid | A unique product ID | 123e4567-e89b-12d3-a456-426655440000

<br>
<hr>

* #### offline.php
>On the 2 & 3 value (pending_data / deleted_products) it will receive only 1

  Name | Value | Example
  ---|---|---
  s | It is needed to be "offline" | offline
  pending_data | A json text with the pending data to be uploaded
  deleted_products | A json text with the deleted products on list
  ean | The EAN scanned | 7501234567893
  mnt | ID of lift truck who took the EAN | 7
  sec | Section sended by beacons | 17
  time | Timestamp with format (YYYY-mm-dd hh:mm:ss) | 2017-11-23 13:17:33
  pid | A unique product ID. | 123e4567-e89b-12d3-a456-426655440000

<br>
<hr>

* #### getIdLiftT.php

  Name | Value | Example
  ---|---|---
  s | It is needed to be "getIdLiftT" | getIdLiftT
  mnt | ID of lift truck | 7

<br>
<hr>

* #### listaProductos.php

  Name | Value | Example
  ---|---|---
  s | It is needed to be "listaProductos" | listaProductos

  ***PLEASE NOTE ALL PARAMETERS ARE REQUIRED**
