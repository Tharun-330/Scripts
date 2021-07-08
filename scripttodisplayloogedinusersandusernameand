#!/bin/bash
# Write a shell script called hello which output the following:
# + Your username
# + The time and date
# + Who is logged on
# + also output a line of asterices (*******) after each section
 
# function to display a line of asterices
function line(){
	echo "*************************************************"
}
 
echo "Your username : $(echo $USER)"
line # call function
 
echo "Current date and time : $(date)"
line
 
echo "Currently logged on users:"
who
line
