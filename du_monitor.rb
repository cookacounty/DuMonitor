## Disk Usage Monitor
#
# Monitor a filesystem, when it approaches a limit, start notifiying users
# that are using more than a specified limit in a path




###################################################################
### DONT EDIT BELOW HERE ##########################################
###################################################################

#Load Required classes

rel_path = File.dirname(__FILE__)
require rel_path + '/Email.rb'
require rel_path + '/Du.rb'
require rel_path + '/Df.rb'

#Ignore system warnings
$VERBOSE = nil


def du_monitor(df_filesystems,interval,domain)
   
   while 1

      df_filesystems.each do |df_array|

         filesystem = df_array[0]
         threshold = df_array[1]
         du_paths = df_array[2]
			cc_list = df_array[3]
         
         df = Df.new(filesystem,cc_list)

         if df.past_limit?(threshold)
            
            if $DUVERBOSE; puts "du threshold hit"; end
     
            du_paths.each do | du_path |
               path = du_path[0]
               limit = du_path[1]
               du = Du.new(path,df,domain)
               du.status
               du.find_violators(limit)
               if $DUVERBOSE; du.show_violators(); end
                  
               du.notify_violators
            end
            
         end
         
      end
      
      sleep_delay = interval*60*60
      if $DUVERBOSE; puts "Sleeping "+sleep_delay.to_s; end;
      
      sleep sleep_delay
   
   end

end