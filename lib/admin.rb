module FlexCP
  class Admin

    def initialize
      db = Mongo::Connection.new.db("flexcp")
      @projects = db['projects']
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
    end

    def new(project_name)
      project = @projects.find("name" => project_name).first
      if project
        puts "project '#{project_name}' already exists"
      else
        project = { "name" => project_name }
        @projects.insert(project)
        puts "project '#{project_name}' successfully created"
      end
    end
    
    def delete(project_name)
      project = @projects.find("name" => project_name).first
      if project
        @projects.remove("name" => project_name)
        puts "project '#{project_name}' successfully removed"
      else
        puts "project '#{project_name}' doesn't exist"
      end
    end
    
  end
end
