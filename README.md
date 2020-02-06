# ScriptZ
__*Usefull scripts box folder. Always in progress...*__

## del_repo
Bash script to delete a repository from the system

Option `-l` show the content of the system repositories directory
`./del_repo.sh -l`

Then you can delete it passing the name of repo and the name of OS (Debian or Centos)

`./del_repo.sh your-repo.list debian` or `./del_repo.sh your-repo.list centos`

## cleaner
Bash script to keep system free from garbage things

`./cleaner`

## pkts
Bash script for measurment the average packets number received (required `bc` https://linux.die.net/man/1/bc )

`./pkts -i wlan0` or `./pkts -i eth0 -s 10`

## resize_image_jpg_png.py
Python module to resize images from a directory without any distortion
