# ScriptZ
__*Usefull scripts box folder. Always in progress...*__

## repo
Bash script to delete a repository from the system

Option `-l` show the content of the system repositories directory
`./del_repo.sh -l [distribution name]`

Then you can delete it passing the name of repo and the name of OS (Debian, Ubuntu or Centos)

`./del_repo.sh your-repo.list debian` or `./del_repo.sh your-repo.list centos`

## cleaner
Bash script to keep system free from garbage things

`./cleaner.sh`

## pkts
Bash script for measurment the average packets number received (required `bc` https://linux.die.net/man/1/bc )

`./pkts.sh -i wlan0` or `./pkts -i eth0 -s 10`

## converter
bash script to convert:
1. base of a number
2. multiple file extension

`./converter.sh 1 [base] [number]`

`./converter.sh 2 [old_ext] [new_ext]`

## tshark check
bash script using tshark to extract network layer informations
from the network packets on any interface (detection on 1000 pkts)

`./tshark_check.sh`

## resize_image_jpg_png.py
Python module to resize images from a directory without any distortion

---

# TODO list

1. Script to disalbe completely a service in linux system (https://superuser.com/a/936976)
2. Enable persistence journal (https://www.reddit.com/r/debian/comments/6jtbxx/debian_stretch_taking_too_long_to_shutdownreboot/)
3. Disable and mask a service (https://gist.github.com/noromanba/6e062d38fd7fd2cd609a6ef1c26ea7bc)
4. Filter from web page
