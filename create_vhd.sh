#!/bin/bash

# Check for root access
if [ "${UID}" -ne 0 ]; then
    echo 'Please run with sudo or root.'
    exit 1
fi

# List information about block devices with mount point
lsblk -fp

# Function to create VHD and mount
function VHD {
    read -p "Enter the Disk name (sdb): " DISKNAME
    read -p "Enter the mount point (/mnt/folder_name): " MPOINT

    # Mount point
    if mount "/dev/$DISKNAME" "$MPOINT"; then
        echo "Disk /dev/$DISKNAME mounted at $MPOINT"
        
        # Add entry to /etc/fstab
        echo "/dev/$DISKNAME $MPOINT ext4 defaults 0 0" | tee -a /etc/fstab
    else
        echo "Failed to mount /dev/$DISKNAME"
    fi
}

# Function to unmount
function unmount {
    read -p "Enter the umount point (/mnt/folder_name): " MPOINT

    # Unmount point
    if umount "$MPOINT"; then
        echo "Disk Successfully unmounted at $MPOINT"
    else
        echo "Failed to unmount $MPOINT"
    fi
}

# Function to format disk
function formatdisk {
    read -p "Enter the Disk name (sdb): " DISKNAME

    # Format disk
    if mkfs.ext4 "/dev/$DISKNAME"; then
        echo "Format complete"
    else
        echo "Failed to format"
    fi
}

# Main script
while true; do
    echo "Choose options: "
    echo "1) Create VHD & Mount Disk "
    echo "2) Unmount Disk "
    echo "3) Format Disk"
    echo "4) Exit"
    read -p "Enter your choice (1/2/3/4): " main_choice

    case $main_choice in
        1) VHD ;;
        2) unmount ;;
        3) formatdisk ;;
        4) echo "Exiting script.........."
            exit ;;
        *)
            echo "Invalid option. Please choose a valid option."
            ;;
    esac
done
