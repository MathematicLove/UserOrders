# frozen_string_literal: true

# ! Lib's used: !
# https://learn.javascript.ru/courses/vue
# https://learn.javascript.ru

require 'pg'
require 'time'
conn = PG.connect(:host => "localhost", :port => 5432, dbname: "pt", user: "ayzek", password: "123")

def next_user_id(conn)
  res = conn.exec("SELECT MAX(user_id) FROM users")
  max_id = res[0]["max"] ? res[0]["max"].to_i : 0
  max_id += 1
end

def next_order_id(conn)
  res = conn.exec("SELECT MAX(order_id) FROM orders")
  max_id = res[0]["max"] ? res[0]["max"].to_i : 0
  max_id += 1
end

def add_user(conn)
  print "Username: "
  username = gets.chomp
  print "Email: "
  email = gets.chomp

  user_id = next_user_id(conn)
  created_at = Time.now.utc
  conn.exec_params("INSERT INTO users (user_id, username, email, created_at) VALUES ($1, $2, $3, $4)", [user_id, username, email, created_at])

  puts "User added with id #{user_id}, username #{username}, email #{email}, created_at #{created_at}"
  user_id
end

def showTable(conn)
 result = conn.exec("SELECT users.username, orders.order_name, orders.amount, orders.order_date FROM users LEFT JOIN orders ON users.user_id = orders.user_id")

  puts "\nJoin results:"
  puts "Username\tOrder Name"
  puts "--------\t----------"

  result.each do |row|
    username = row['username']
    order_name = row['order_name'] || 'NULL'
    amount = row['amount'] || 'NULL'
    order_date = row['order_date'] || 'NULL'
    puts "#{username}\t#{order_name}\t#{amount}\t#{order_date}"
  end
  puts "\n"
end

def add_order(conn, user_id)
  puts "Add order: "
  print "Order name: "
  order_name = gets.chomp
  print "Order amount: "
  order_amount = gets.chomp.to_i

  order_id = next_order_id(conn)
  order_date = Time.now.utc

  conn.exec_params("INSERT INTO orders (order_id, user_id, amount, order_name, order_date) VALUES ($1, $2, $3, $4, $5)", [order_id, user_id, order_amount, order_name, order_date])

  puts "Order registered with id #{order_id}, order date #{order_date} for user #{user_id}"
end

loop do``
  puts "1. Add user"
  puts "2. Add order"
  puts "3. Show users and orders"
  puts "4. Exit"
  choice = gets.chomp
  case choice
  when '1'
    @last_user_id = add_user(conn)
  when '2'
    if @last_user_id
      add_order(conn, @last_user_id)
    else puts "First add user"
    end
  when '3'
    showTable(conn)
  when '4'
    puts "Bye"
    break
  else
    puts "Invalid choice"
  end
end
