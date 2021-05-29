require "active_record"

class Todo < ActiveRecord::Base

  # this method check todays date or not
  def due_today?
    due_date == Date.today
  end

  # check the due_date is less than today date or not
  def self.overdue
    Todo.all.filter { |todo| todo.due_date < Date.today }
  end

  # check the due_date is same as today date or not
  def self.due_today
    Todo.all.filter { |todo| todo.due_today? }
  end

  # check the due_date is greater than today date or not
  def self.due_later
    Todo.all.filter { |todo| todo.due_date > Date.today }
  end

  # this method adds a task
  def self.add_task(addtodo)
    Todo.create!(todo_text: addtodo[:todo_text], due_date: (Date.today + addtodo[:due_in_days]), completed: false)
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  #given a todo id this method marks a todo as complete
  def self.mark_as_complete(todos_id)
    complete_todo = Todo.find_by_id(todos_id)
    if complete_todo == nil # checks if there is no todo id
      puts "SORRY THERE IS NO TODO ID"
      exit
    else
      complete_todo.completed = true
      complete_todo.save
      exit
    end
  end

  def self.to_displayable_list(todos)
    todos.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list\n\n"

    #displays the todo which are overdue
    puts "Overdue\n"
    puts to_displayable_list(Todo.overdue)
    puts "\n\n"

    #displays the todo which are due_today
    puts "Due Today\n"
    puts to_displayable_list(Todo.due_today)
    puts "\n\n"

    #displays the todo which are due_later
    puts "Due Later\n"
    puts to_displayable_list(Todo.due_later)
    puts "\n\n"
  end
end
