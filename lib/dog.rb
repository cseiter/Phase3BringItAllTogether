class Dog

    attr_accessor :id, :name, :breed

    def initialize(id: nil, name:, breed:)
        @id=id
        @name=name
        @breed=breed
    end

    def self.create_table
        sql = <<-SQL
        create table if not exists dogs(
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        )
        SQL
        DB[:conn].execute(sql)
    end
    
    def self.drop_table
        DB[:conn].execute("drop table if exists dogs")
    end

    def save
        if self.id
            self.update
        else
            DB[:conn].execute("insert into dogs(name,breed) values (?,?)",self.name,self.breed)
            self.id=DB[:conn].execute("select last_insert_rowid() from dogs")[0][0]
        end
        self
    end

    def self.create(name:,breed:)
        new_dog=Dog.new(name: name,breed: breed)
        new_dog.save
        new_dog
    end

    def self.new_from_db(row)
        self.new(id: row[0],name: row[1],breed: row[2])
    end

    def self.all
        DB[:conn].execute("select * from dogs").map {|row| self.new_from_db(row)}
    end


end
