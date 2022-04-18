#Du Class
# Used to call the du command and origanize the results into DuPaths
class Du

   attr_accessor :path          #The path du will run
   attr_accessor :du_paths      #An array of the path results
   attr_accessor :du_violators  #An array of violating DuPath's
   attr_accessor :limit         #The limit for a path size
   attr_accessor :df            #The filesystem (Df class)
   attr_accessor :domain        #The email domain example.com

   def initialize(path,df)
      @path = path            
      @df = df
   end
   
   #Get the staus from the du command and create DuPaths
   def status()
      du_result = `du -s --block-size=1G #{@path}/*`
      
      @du_paths = []
      
      du_result.each_line do | line |
         if !line.index("du: cannot read directory") && !line.index("du: cannot access") #Skip du errors
            newDuPath = DuPath.new(line)
            if $DUVERBOSE; newDuPath.display; end;
            
            @du_paths << newDuPath
         end
      end
      
   end
   
   #Find paths that violate the threshold
   def find_violators(limit)
      
      @limit = limit
      @du_violators = []
      
      du_paths.each do |du_path|
         if du_path.size >= limit
            @du_violators << du_path
         end         
      end
      
   end
   
   #Notifiy violating users using the Email class
   def notify_violators()
      @du_violators.each do |du_path|
         email = Email.new(self,du_path)
         email.send         
      end
   end
   
   #Report the violators (debug only)
   def show_violators()
      puts "="*20
      puts "Violating Paths"
      puts "="*20
      @du_violators.each do |du_path|
         du_path.display
      end
   end
   
   #Create fake attributes for testing
   def initialize_fake(path,df,limit)
      @path = path
      @df = df
      @limit = limit
   end

end

#DuPath
# Class for a single path that contains information about that path
class DuPath
   attr_accessor :owner
   attr_accessor :path
   attr_accessor :size
   
   def initialize(du_line)
      split_line = du_line.split
      
      @size = split_line[0].to_i
      @path = split_line[1..split_line.length].join("\\ ")
      @owner =  `stat -c "%U" #{@path}`.chomp!

   end   
   def display
      puts "#{@path} #{@size} #{@owner}"
   end
   
   #Create fake attributes for testing
   def initialize_fake(owner,path,size)
      @owner=owner
      @path=path
      @size=size
   end
   
end