#! /bin/bash
# Script:    ImageNames.sh
# Purpose:   Transfer image and video files from any camera and rename them according to the date taken.
# Author:    Guillaume Dargaud - http://www.gdargaud.net/
# Copyright: (c) 2006 - Free use, distribution and modification
#
# Workflow:
#   The first time, put this script in an empty directory and start it from there.
#   Set the camera to [Usb Mass Storage] mode and connect it. Change the line below accordingly.
#   Run the present script from a bash window or from a bat file containing 
#     SET PATH="/usr/local/bin:/usr/bin:/bin"
#     c:\cygwin\bin\bash ImageNames.sh
#     PAUSE
#   It will move the files from the camera to the present directory 
#   and then move and rename them to YYYYMMDD\YYYYMMDD-HHMMSS.ext
#   You can then rename the directories and files to something more meaningful
#   For instance I use YYYYMMDD_PlaceOrEventName\YYYYMMDD-HHMMSS_SomeKeywords.ext
#   Next time you run it, new files are added.
#
# Make sure you have a backup of the whole directory the first few times you run this
# I take no responsability if you wipe out 2000 images or your camera catches fire.
#
# You need cygwin to run this on Windows: http://www.cygwin.com/
 
 
# This is the directory where the camera files are found 
# when you connect the USB cable OR use a card reader (faster)
# MAKE SURE THIS IS CORRECT.
## This is specific to a given camera
#PathCamera=$( cygpath "E:\DCIM\100RICOH" )
# This looks for any kind of card reader or USB-mounted camera drive
PathCamera=/media/dcam/*
 
 
# You shouldn't have anything to change below here
 
###############################################################################
# Function declarations
 
# Rename and move ./File.$2 to YYYYMMDD/YYYYMMDD-HHMMSS.$2
# With $1 as file name (jpg or avi or mp3 or anything that contains an embedded date such as an exif tag)
# This is quite slow !
function MoveWhatever {
	if [ $# -ne 1 ]; then exit; fi
 
	# Extract date from file. This may not work on some types of files
	DateStr=$( strings -14 "$1" | egrep -m 1 "^20[0-9][0-9][ :/]?[0-9][0-9][ :/]?[0-9][0-9][ :/]?[0-9][0-9][ :/]?[0-9][0-9][ :/]?[0-9][0-9]" ) &&
	Date=$( echo "$DateStr" | sed -e "s/\(20[0-9][0-9]\)[ :/]*\([0-9][0-9]\)[ :/]*\([0-9][0-9]\).*/\1\2\3/" ) &&
	Time=$( echo "$DateStr" | sed -e "s/20[0-9][0-9][ :/]*[0-9][0-9][ :/]*[0-9][0-9][ :/]*\([0-9][0-9]\)[ :/]*\([0-9][0-9]\)[ :/]*\([0-9][0-9]\).*/\1\2\3/" ) &&
	Ext=$( echo "$1" | sed -e "s/.*\.\([^.]\)/\1/" | tr "[:upper:]" "[:lower:]" ) &&
 
	# Create directory if necessary
	mkdir -vp $Date &&
	# Move and rename file only if all of the above succeeded
	mv -iv "$1" "$Date/${Date}_$Time.$Ext"
}
export -f MoveWhatever 
 
 
###############################################################################
# Optional: Find files without added keywords in their names, left over from previous runs
# This is just a reminder to move your sorry ass and rename those files
 
echo
echo "Files that you ough to rename to something more significant:"
find -iregex ".*/[0-9]*[-_][0-9]*\.[a-z]*"
 
 
###############################################################################
# Optional: Find empty files
echo
echo "Those files have size zero:"
find -type f -size 0
 
 
###############################################################################
# Copy files from digital camera (remember to reformat the card afterwards as files are not removed when using a cable)
# Note: camera should be in 'Mass Storage' USB mode and connected (d'oh!)
 
echo
# echo "Copying files from camera:"
# cp -v $PathCamera/* .
 
# Alternative method: move files from USB card (needs card reader)
echo "Moving files from camera:"
mv -v $PathCamera/* .
 
 
###############################################################################
# Rename according to exif date/time
# Original names are lost (but who cares)
 
echo
echo "Renaming and moving files to final destination:"
# Add other extensions as needed
find -maxdepth 1 -iregex ".*\.\(jpg\|tif\|wav\|mp3\|avi\|mpg\|raf\|raw\|dng\|nef\)" -exec bash -c "MoveWhatever '{}'" \;
 
 
# Sometimes there are hiccups
mv -iv /*.dng .
 
echo
echo "Verify that the files have been properly moved and reformat your memory card."
echo "If there are jpg or raw files left in the present directory, run this script again."
