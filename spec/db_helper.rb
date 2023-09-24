module DbHelper
  def setup_mysql
    around do |example|
      c = Mysql2::Client.new(
        host: "127.0.0.1",
        port: 3306,
        username: "root",
        password: 'password'
      )
      db = 'rack_analyzer_test'
      c.query("CREATE DATABASE IF NOT EXISTS #{db}")
      c.query("DROP TABLE IF EXISTS #{db}.users")
      c.query(<<-"SQL"
        CREATE TABLE #{db}.users (
          id INT AUTO_INCREMENT PRIMARY KEY, 
          name VARCHAR(255) NOT NULL, 
          email VARCHAR(255) NOT NULL
        )
      SQL
      )

      example.run

      c.query("DROP TABLE IF EXISTS #{db}.users")
      c.close
    end
  end

  def mysql_client
    Mysql2::Client.new(
      host: "127.0.0.1",
      port: 3306,
      username: "root",
      password: 'password',
      database: 'rack_analyzer_test'
    )
  end

  def setup_postgresql
    around do |example|
      conn = PG.connect(
        host: "127.0.0.1",
        port: 5432,
        user: "root",
        password: 'password'
      )
      db = 'rack_analyzer_test'
      if conn.exec("SELECT FROM pg_database WHERE datname = '#{db}'").count.zero?
        conn.exec("CREATE DATABASE #{db}")
      end
      conn.exec("DROP TABLE IF EXISTS users")
      conn.exec(<<-SQL
        CREATE TABLE users (
            id SERIAL PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            email VARCHAR(255) NOT NULL
        )
      SQL
      )

      example.run

      conn.exec("DROP TABLE IF EXISTS users")
      conn.close
    end
  end

  def postgres_client
    PG.connect(
      host: "127.0.0.1",
      port: 5432,
      user: "root",
      password: 'password',
      dbname: 'rack_analyzer_test'
    )
  end

  def setup_sqlite
    around do |example|
      db = SQLite3::Database.new 'rack_analyzer_test.db'
      db.execute("DROP TABLE IF EXISTS users")
      db.execute(<<-SQL
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT
        )
      SQL
      )

      example.run

      db.execute("DROP TABLE IF EXISTS users")
      db.close
    end
  end

  def sqlite_client
    SQLite3::Database.new 'rack_analyzer_test.db'
  end
end

include DbHelper
