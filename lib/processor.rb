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
              
              file = File.open("out/#{project_name}/#{t}/#{row['start_year']}#{complete_zeros(row['start_month'],2)}#{complete_zeros(row['start_date'],2)}#{complete_zeros(row['start_hour'],2)}", 'w')
              
              file.print "     1" + "\r\n"
              file.print "    FNL     #{two_digits(row['start_year'])}    #{complete_zeros(row['start_month'],2)}    #{complete_zeros(row['start_date'],2)}     0     0" + "\r\n"
              file.print "     1BACKWARDOMEGA" + "\r\n"
              file.print "    #{two_digits(row['start_year'])}    #{complete_zeros(row['start_month'],2)}     #{complete_zeros(row['start_date'],2)}    #{complete_zeros(row['start_hour'],2)}" + align_value("#{row['latitude']}", 12)+ align_value("#{row['longitude']}",12) + align_value("#{row['height']}",10) + "\r\n"
              file.print "     1PRESSURE" + "\r\n"
            end
            
            if file
              file.print "     1     1   #{two_digits(row['start_year'])}    #{complete_zeros(row['start_month'],2)}     #{complete_zeros(row['start_date'],2)}    #{complete_zeros(row['start_hour'],2)}     0     0  " + align_value("#{row['age_hour']}",6) + align_value("#{row['latitude']}", 12)+ align_value("#{row['longitude']}",12) + align_value("#{row['height']}",10) + align_value("#{row['press']}", 10) + "\r\n"
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
    
    def align_value(value, length)
      spaces = length - value.length
      ' ' * spaces + value
    end
    
    def complete_zeros(value, length)
      zeros = length - value.to_s.length
      '0' * zeros + value.to_s
    end
    
    def two_digits(value)
      value[2,4]
    end
    
  end
end
