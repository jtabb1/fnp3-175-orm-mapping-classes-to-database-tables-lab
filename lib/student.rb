class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
  attr_accessor :name, :grade
  attr_reader :id

  # def initialize(name:, grade:, id: nil)
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  # This original method passes the tests.  It may be preferable to the
  #  official solution if it is desired that the "id" be passed to the 
  #  INSERT INTO command.
  def save_0
    sql = <<-SQL
    INSERT INTO students (
      id, name, grade)
    VALUES (
      ?, ?, ?
    )
    SQL
    DB[:conn].execute(sql, 
      self.id, self.name, self.grade
    )

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    self
  end

  # This slightly modified method from the official solution passes
  #  the tests as well, but may be preferable if it is not desired to
  #  pass the "id" into the INSERT INTO command. 
  def save
    sql = <<-SQL
    INSERT INTO students (
      name, grade)
    VALUES (
      ?, ?
    )
    SQL
    DB[:conn].execute(sql, 
      self.name, self.grade
    )

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    self
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(name:, grade:, id: nil)
    student = Student.new(name, grade, id)
    student.save
  end
end
