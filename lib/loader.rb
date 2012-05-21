module FlexCP
  class Loader

    def initialize
      db = Mongo::Connection.new.db('flexcp')
      @projects = db['projects']
      @trajectories = db['trajectories'] 
    end
    
    def help
      puts 'Usage: flexcp load <project> <height> <file>'
    end
    
    def load(project_name, height, filename)
      project = get_project(project_name)
      
      if project
        if !project['trajectories'].include?(height)
          @projects.update({'_id' => project['_id']}, {'$push' => {"trajectories" => height}})
        end
    
        @trajectories.remove("_height" => height)
        file = File.new(filename, 'r')
        file.each_line do |row|
          if file.lineno > 1
            columns = row.split("\t")
            content = {
              "_project_id" => project["_id"],
              "_height" => height,
              "toid" => columns.shift.strip,
              "foid" => columns.shift.strip, 
              "start_year" => columns.shift.strip,
              "start_month" => columns.shift.strip,
              "start_date" => columns.shift.strip,
              "start_hour" => columns.shift.strip,
              "minute" => columns.shift.strip,
              "fhour" => columns.shift.strip,
              "age_hour" => columns.shift.strip,
              "latitude" => columns.shift.strip,
              "longitude" => columns.shift.strip,
              "height" => columns.shift.strip,
              "press" => columns.shift.strip
            }
            @trajectories.insert(content)
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
