#Class to parse the result of the `df` command
class Df
   
   attr_accessor :filesystem
   attr_accessor :df_line
   attr_accessor :used
   attr_accessor :limit
   attr_accessor :cc_list
   
   
   #Parse the df command to find the desired filesystem
   def initialize(filesystem,cc_list)
      
      @filesystem = filesystem
		@cc_list = cc_list
      
      sys_result = `df`
      
      sys_result.each_line do |line|
         if line.index(filesystem)
            
            split_line = line.split
            
            @used = split_line[4].chomp("%").to_i
            if $DUVERBOSE; puts "Filesystem: #{@filesystem} #{@used}% used"; end
            
         end         
      end
      
      
   end
   
   #Check if the usage is past a specfied limit
   def past_limit?(limit)
      @limit = limit
      if( @used > limit)
         return true
      else
         return false
      end
   end
   
   
   #Create fake attributes for testing
   def initialize_fake(filesystem,used)
      @filesystem = filesystem
      @used = used
   end
   
   
end