#!/bin/bash

mkdir -p ~/imagesDocker && cd ~/imagesDocker

wget --header='Host: drive.usercontent.google.com' --header='User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8' --header='Accept-Language: es-ES,es;q=0.9' --header='Cookie: NID=517=jS3rxCy4ZLFZZiFLfgX76sjAo4Tx7xqk4hB-fSI-x6XKIcdXtaO0KD7Yemw6bhNwIBki7__XzrWgneG_g_aqxTAcwLvqN10lA7CZ3ouwcd_dlGXCAsMqVnUpIuJyLwrbXmZw3V0c3UT0Z3pR1siJLL6CC3ObvGaPcXdG1K4RZiXURm7NDQ' --header='Connection: keep-alive' 'https://drive.usercontent.google.com/download?id=1O7QE__u3pTOyws1LoUoErK8f6dp7Gbg4&export=download&confirm=t&uuid=dda8edb7-2704-4005-8bfe-44bccdc6ddbc' -c -O 'idbi-images.zip'

unzip idbi-images.zip

rm idbi-images.zip

cd ..