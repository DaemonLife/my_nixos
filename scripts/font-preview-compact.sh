#!/usr/bin/env bash

cat >/tmp/fonts.html <<__HEADER
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sample of local fonts matching '$1'</title>
</head>
<body>
<table>
__HEADER

fc-list --format='%{family}\n' | sort -u | while IFS='' read -r fontfamily; do
  cat >>/tmp/fonts.html <<__BODY
                <tr>
        <td>${fontfamily}</td>
                <td  style="font-family: '${fontfamily}', 'sans'">$1</td>
                <td  style="font-family: '${fontfamily}', 'sans'">The quick brown fox jumped Проверка 0123456789,.:;?/<>'"[]{}|\-=\`~!@#$%^&*()-=\\</td>
                </tr>
__BODY

done

cat >>/tmp/fonts.html <<__FOOTER
</table>
</body>
</html>
__FOOTER

echo "fonts.html created"
$BROWSER /tmp/fonts.html
