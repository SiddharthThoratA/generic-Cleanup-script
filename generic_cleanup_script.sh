#!/bin/bash

d=`date +%Y%m%d%H%M%S`
run_dt=`date +%Y%m%d`
#echo $d
log_dir=/home/ds/cleanup/logs
script_path=/home/d/cleanup

start_time=`date '+%F %T'`


echo "--------------------------------------------------------------------------------------------------------"
echo "-------------------------------- Start_time : ${start_time}---------------------------------------"
echo "--------------------------------------------------------------------------------------------------------"

#echo "start time : " `date '+%F %T'`

cd /home/dstdw/cleanup

# Specify the path to your text file
file_path="/home/dstdw/cleanup/cleanup_files_folders_path.txt"

#echo "*****************************************************************************"
#echo "deleting files and folders from the below path"
#echo "*****************************************************************************"

# Read each line from the text file
while IFS= read -r line; do
  # Split the line into path and days using space as the delimiter
  read -r name path days <<< "$line"
  
  # Check if the path exists
  if [ -e "$path" ]; then
  
	#Get process name from the path
	process_name=${name}
	echo "********************************** ${process_name} **********************************"
	
	# Calculate the date in days ago format
    date_to_delete=$(date -d "$days days ago" +%Y%m%d)
	echo "date to delete : ${date_to_delete}"
	
	# Use the find command to locate and delete files/folders older than $days
	echo "rm direcroty is : ${path}"
	echo "days_to_delete : ${days}"
	echo " " 
	
	echo "================================================================================================"
	echo "Below list of files and folders are deleted"
	
	find "$path" -type f ! -newermt "$date_to_delete" -exec ls -lrt {} \;
	find "$path" -type f ! -newermt "$date_to_delete" -exec rm {} \;
	echo "-----------------------------------------------------------------------------------------------"
	echo "Removing below list of empty directories"
	find "$path" -empty -type d
	#find "$path" -empty -type d -delete
	find "$path" -mindepth 1 -empty -type d -exec rmdir {} \;
	
	echo "================================================================================================"
	echo "-----------------------------------------------------------------------------------------------"
	#find "$path" -type f -mtime +"$days" -name "*.*" -exec rm -f {} \;
    #find "$path" -type d -empty -delete
  else
    echo "Path $path does not exist."
  fi
done < "$file_path"

#Rename log file name

cd /home/dstdw/cleanup/logs
echo "Changing log file name"
mv generic_cleanup_script.log  generic_cleanup_script_${run_dt}.log

echo "Cleanup script has been completed"
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"