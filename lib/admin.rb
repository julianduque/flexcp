module FlexCP
  class Admin

    def initialize
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
      puts 'list all projects'
    end

    def new(project)
      puts "new project"      
    end
    
    def delete(project)
      puts "delete project"
    end
    
  end
end
