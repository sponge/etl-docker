docker build . --tag etlegacy --build-arg REF_PASSWORD=ref --build-arg RCON_PASSWORD=rcon --build-arg ET_HOSTNAME=hostname
docker run -p 27960:27960/udp -d etlegacy