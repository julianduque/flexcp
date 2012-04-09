module FlexCP
  class Processor
    
    def initialize
      db = Mongo::Connection.new.db('flexcp')
      @projects = db['projects']
      @trajectories = db['trajectories'] 
    end
  
    def help
      puts 'Usage: flexcp process <project> <lt> <t1> ... <tn>'
    end
    
    def process(project_name, lt, trajectories)
      project = get_project(project_name)
      if project
        trajectories.each do |t|
          result = @trajectories.find({'_project_id' => project['_id'], '_height' => t})
          file = nil
          result.each do |row|
            # Create a new file if age_hour == 0
            if row['age_hour'] == '0.0'
              Dir::mkdir("out") unless File.exists?("out")
              Dir::mkdir("out/#{project_name}") unless File.exists?("out/#{project_name}")
              Dir::mkdir("out/#{project_name}/#{t}") unless File.exists?("out/#{project_name}/#{t}")
              
              file = File.open("out/#{project_name}/#{t}/n#{row['start_year']}#{row['start_month']}#{row['start_date']}#{row['start_hour']}", 'w')
            end
            if file
              file.puts "Hello"
            end            
          end          
        end
      else
        puts "project '#{project_name}' not found"
      end
    end
    
    private
    
    def get_project(project_name)
      @projects.find("name" => project_name).first
    end
    
  end
end
