# frozen_string_literal: true

module DbHelper
  DB_NAME = 'rack_analyzer_test'

  # create database and users table
  def setup_mysql
    around do |example|
      create_mysql_database_if_not_exists
      c = mysql_client
      c.query("DROP TABLE IF EXISTS #{DB_NAME}.users")
      c.query(<<-SQL)
        CREATE TABLE #{DB_NAME}.users (
          id INT AUTO_INCREMENT PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          email VARCHAR(255) NOT NULL
        )
      SQL

      example.run

      c.query("DROP TABLE IF EXISTS #{DB_NAME}.users")
      c.close
    end
  end

  def create_mysql_database_if_not_exists
    c = Mysql2::Client.new(host: ENV.fetch('MYSQL_HOST', nil), port: 3306, username: 'root', password: 'password')
    c.query("CREATE DATABASE IF NOT EXISTS #{DB_NAME}")
    c.close
  end

  def mysql_client
    Mysql2::Client.new(
      host: ENV.fetch('MYSQL_HOST', nil),
      port: 3306,
      username: 'root',
      password: 'password',
      database: DB_NAME,
    )
  end

  # create database and users table
  def setup_postgresql
    around do |example|
      create_postgresql_database_if_not_exists
      conn = postgres_client
      conn.exec('DROP TABLE IF EXISTS users')
      conn.exec(<<-SQL)
        CREATE TABLE users (
            id SERIAL PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            email VARCHAR(255) NOT NULL
        )
      SQL

      example.run

      conn.exec('DROP TABLE IF EXISTS users')
      conn.close
    end
  end

  def create_postgresql_database_if_not_exists
    conn = PG.connect(host: ENV.fetch('POSTGRESQL_HOST', nil), port: 5432, user: 'root', password: 'password')
    if conn.exec("SELECT FROM pg_database WHERE datname = '#{DB_NAME}'").count.zero?
      conn.exec("CREATE DATABASE #{DB_NAME}")
    end
    conn.close
  end

  def postgres_client
    PG.connect(host: ENV.fetch('POSTGRESQL_HOST', nil), port: 5432, user: 'root', password: 'password', dbname: DB_NAME)
  end

  # create database and users table
  def setup_sqlite
    around do |example|
      db = sqlite_client
      db.execute('DROP TABLE IF EXISTS users')
      db.execute(<<-SQL)
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT
        )
      SQL

      example.run

      db.execute('DROP TABLE IF EXISTS users')
      db.close
    end
  end

  def sqlite_client
    SQLite3::Database.new "tmp/#{DB_NAME}.db"
  end
end
