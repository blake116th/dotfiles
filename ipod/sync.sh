
#!/bin/bash

# Mount and sync music to ipod :)

# the uuid of the ipod device to mount. can be found with
# lsblk -o NAME,UUID,MOUNTPOINT
IPOD_UUID="BB9C-B069"
SRC="/media/blake/1TB/torrents/music/"
DEST="/home/blake/ipod/music/"

# make sure this ipod is actually plugged in
if [ ! -e /dev/disk/by-uuid/$IPOD_UUID ]; then
    echo "ipod with uuid $IPOD_UUID isnt plugged in"
    exit 1
fi

mkdir -p ~/ipod

# check if ipod is already mounted. mount if not
if ! findmnt ~/ipod > /dev/null; then
    echo "mounting to ~/ipod"
    sudo mount -U $IPOD_UUID -o users,uid=$(id -u),gid=$(id -g) ~/ipod
    #defaults,user,gid=1000,uid=1000,dmask=027,fmask=137 ~/ipod
else
    echo "Device already mounted to ~/ipod"
fi

rsync -av --delete $SRC $DEST
