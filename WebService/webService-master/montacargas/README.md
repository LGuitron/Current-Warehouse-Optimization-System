# Lift Trucks Services #

### Parameters needed ###

<br>

* #### montacargas.php

Name | Value | Example
---|---|---
s | It is needed to be "mont" | mont

<br>
<hr>

* #### selectLT.php

  Name | Value | Example
  ---|---|---
  s | It is needed to be "delete" | delete
  ean | The EAN scanned | 7501234567893
  mnt | ID of lift truck who took the EAN | 7
  pid | A unique product ID | 123e4567-e89b-12d3-a456-426655440000

<br>
<hr>

* #### unselectLT.php

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

  ***PLEASE NOTE ALL PARAMETERS ARE REQUIRED**
