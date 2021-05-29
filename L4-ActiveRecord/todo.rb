require "active_record"

class Todo < ActiveRecord::Base
  def self.overdue
    where("due_date < ?", Date.today)
  end

  def self.due_today
    where("due_date = ?", Date.today)
  end

  def self.due_later
    where("due_date > ?", Date.today)
  end

  # this method adds a task
  def self.add_task(addtodo)
    Todo.create!(todo_text: addtodo[:todo_text], due_date: (Date.today + addtodo[:due_in_days]), completed: false)
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = (due_date == Date.today) ? nil : due_date
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

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list\n\n"

    #displays the todo which are overdue
    puts "Overdue\n"
    puts overdue.to_displayable_list
    puts "\n\n"

    #displays the todo which are due_today
    puts "Due Today\n"
    puts due_today.to_displayable_list
    puts "\n\n"

    #displays the todo which are due_later
    puts "Due Later\n"
    puts due_later.to_displayable_list
    puts "\n\n"
  end
end
