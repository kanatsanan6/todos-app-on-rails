# frozen_string_literal: true

module TasksHelper
  def progress(tasks)
    completed_task = tasks.count(&:status)
    all_task = tasks.length
    completed_task * 100 / (all_task.nonzero? || 1)
  end
end
