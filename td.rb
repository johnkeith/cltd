require 'rbconfig'

class Todo
	def clear_screen
		host_os = RbConfig::CONFIG['host_os']

		case host_os
			when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
				system "cls"
			when /darwin|mac os|linux|solaris|bsd/
				puts "\e[H\e[2J"
		end

	end

	def open_app
		view_all
	end

	def view_all
		clear_screen

		list_read = read_active_list
		
		puts "------INCOMPLETE------\n\n"
		list_read.each do |line|
			puts line
		end
		puts "\n----------------------"

		choose_action
	end

	def read_active_list
		list = File.open("activelist.txt","a+").readlines
	end

	def choose_action
		puts %/
		What would you like to do with your list?
		1. Add a todo
		2. Mark complete
		3. View incomplete
		4. View completed
		5. Exit/

		choice = gets.chomp.downcase

		case choice
			when "1" then input_todo
			when "1." then input_todo
			when "add" then input_todo
			when "add todo" then input_todo
		
			when "2" then mark_done
			when "2." then mark_done
			when "mark" then mark_done
			when "mark done" then mark_done

			when "3" then view_incomplete
			when "3." then view_incomplete
			when "view incomplete" then view_incomplete
			
			when "4" then view_complete
			when "4." then view_complete
			when "view completed" then view_complete

			when "5" then return
			when "5." then return
			when "exit" then return

			else
				p "Not a valid choice"
				choose_action
		end
	end

#ask for todo
	def input_todo
		puts "\nEnter your new todo:"
		todo = gets.chomp
		add_todo(todo)
		view_all
	end

#write method
	def add_todo(todo)
		File.open("activelist.txt", "a") { |f| f.write "#{todo}\n" }
	end

#mark done method
	def mark_done
		clear_screen

		list_read = File.open("activelist.txt","a+").readlines

		puts "------INCOMPLETE------\n\n"
		list_read.each_with_index do |line, index|
			puts "#{index + 1}. " + line
		end
		puts "\n----------------------"

		puts "\nWhich todo do you want to mark complete? (Type the number or zero to cancel)."
		
		choice = gets.chomp.to_i

		File.open("activelist.txt", "w") do |f|
			list_read.each_with_index do |line, index|
				if (index + 1) == choice 
					add_to_complete_list line
				else
					f.write "#{line}"
				end
			end
		end

		view_all
	end

	def add_to_complete_list line
		File.open("completelist.txt", "a").write "#{line}"
	end

	def view_complete
		clear_screen

		complete_list = File.open("completelist.txt", "a+").readlines

		puts "------COMPLETED------\n\n"
		complete_list.each do |line|
			puts line
		end
		puts "\n---------------------"

		choose_action
	end

	def view_incomplete
		view_all
	end
end

my_todo_list = Todo.new

my_todo_list.open_app