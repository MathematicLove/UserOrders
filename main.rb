# frozen_string_literal: true
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

loop do
  puts "1. Add user"
  puts "2. Add order"
  puts "3. Exit"
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
    puts "Bye"
    break
  else
    puts "Invalid choice"
  end
end

# class Main
#   def initialize(name)
#     @name = name
#   end
#
#   def circleArea(radius)
#     puts "Your area with radius = #{radius} = #{Math::PI * (radius ** 2)}"
#   end
#
#   def say_hi
#     puts "Hello #{@name}!"
#   end
#
#   def say_bye
#     puts "Bye #{@name}!"
#   end
#
#   def decToBin(x)
#     31.downto(0) do |i|
#       y = x >> i
#       print((y&1))
#     end
#     puts
#   end
#
#   def reverseStr(str)
#     reversed = ''
#     (str.length - 1).downto(0) do |i|
#       reversed += str[i]
#     end
#     return reversed
#   end
#
#   def isPalindrome(str)
#     if str == reverseStr(str)
#       puts "Is palindrome: #{reverseStr(str)} = #{str}"
#     else
#       puts "Is not palindrome: #{reverseStr(str)} != #{str}"
#       end
#   end
#
#   def inputMenu(x)
#     case x
#     when 1
#       reverseStr("HellO!")
#     when 2
#       isPalindrome("HELLO!")
#     when 3
#       decToBin(183)
#     when 4
#       say_hi
#     when 5
#       say_bye
#     when 6
#       circleArea(10)
#     end
#   end
# end
#
# puts "Enter your name:"
# user = gets.chomp
# sH = Main.new(user)
# inp = 0
# while (inp != -1)
#   puts "Input your menu num (1-6):"
#   inp = gets.chomp.to_i
#   sH.inputMenu(inp)
# end
