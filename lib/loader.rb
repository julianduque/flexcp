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
      project = @projects.find('name' => project_name).first
      if project
        @trajectories.remove("_height" => height)
        file = File.new(filename, 'r')
        file.each_line do |row|
          if file.lineno > 1
            columns = row.split(',')
            content = {
              "_project_id" => project["_id"],
              "_height" => height,
              "start_year" => columns.shift.strip,
              "start_month" => columns.shift.strip,
              "start_date" => columns.shift.strip,
              "start_hour" => columns.shift.strip,
              "year" => columns.shift.strip,
              "month" => columns.shift.strip,
              "day" => columns.shift.strip,
              "hour" => columns.shift.strip,
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
  end
end
