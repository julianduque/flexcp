module FlexCP
  class Admin

    def initialize
      db = Mongo::Connection.new.db("flexcp")
      @projects = db['projects']
      @trajectories = db['trajectories'] 
    end
    
    def help(command)
      case command
      when 'new'
        puts "usage new"
      when 'list'
        puts 'usage list'
      when 'delete'
        puts "usage delete"
      end
    end

    def list
      if @projects.count() > 0
        puts "Listing projects"
        @projects.find().each do |project|
          puts "*  #{project['name']}"
        end
      else
        puts "No projects found"
      end
    end
    
    def show(project_name)
      project = get_project(project_name)
      if project
        puts "*  #{project['name']}"
        project['trajectories'].each do |t|
          puts "    - #{t}"
        end
      else
        puts "No projects found"
      end
    end

    def new(project_name)
      project = get_project(project_name)
      if project
        puts "project '#{project_name}' already exists"
      else
        project = { "name" => project_name, "trajectories" => []}
        @projects.insert(project)
        puts "project '#{project_name}' successfully created"
      end
    end
    
    def delete(project_name)
      project = get_project(project_name)
      if project
        @trajectories.remove("_project_id" => project['_id'])
        @projects.remove("name" => project_name)
        puts "project '#{project_name}' successfully removed"
      else
        puts "project '#{project_name}' doesn't exist"
      end
    end
    
    private
    
    def get_project(project_name)
      @projects.find("name" => project_name).first
    end
    
  end
end
