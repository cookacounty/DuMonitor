#!/usr/bin/ruby

## Disk Usage Monitor
#
# Aaron Cook Apr 2014
#
# Monitor a filesystem, when it approaches a limit, start notifiying users
# that are using more than a specified limit in a path

########## Configure here ##########

#Global configuration
$DUVERBOSE = true #See verbose log messages
#$DUNOEMAIL = true #Disable emails

#CC recepiants ( "user@one.com,user@two.com")
cc_list  = "a@example.com,b@exmaple.com" 

df_limit       = 80  #Percent disk full to start checking du
user_gb_limit  = 100 #Gb of storage after df limit is hit to start notifiying user's

#Filesystem to check
#Format is [filesystem,threshold, du_paths, cc_list]
#  filesystem is a string, the filesystem name in `df` output
#  threshold is an integer - the percent usage at which to start checking path usage and send notifications
#  du_paths is an array - The paths in the filesystem to check for usage (see Paths to check description)
#    Paths to check
#      Format is [path,threshold] 
#        path is a string
#        threshold is an integer, the notification limit in G
#  cc_list is the list of users to cc in notification emails
df_filesystems =[
      ["nhsim1:/native",     df_limit, [["/sim1",  user_gb_limit]], cc_list],
#      ["connery:/asim2",   df_limit, [["/asim2",  user_gb_limit]], analog_cc],
#      ["vandamme:/digsim", df_limit, [["/digsim", user_gb_limit]], digital_cc]
]

# The interval in hours to check the disk space
# Violating users will get an email at this interval until they comply
interval = 6

domain = "example.com"


####################################
########## Do not modifiy ##########

rel_path = File.dirname(__FILE__)
require rel_path + '/du_monitor.rb'

du_monitor(df_filesystems,interval,domain)
