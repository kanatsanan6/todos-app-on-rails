# frozen_string_literal: true

module TasksHelper
  def progress(tasks)
    completed_task = 0
    tasks.each do |task|
      completed_task += 1 if task.status
    end
    completed_task * 100 / tasks.length
  end
end
