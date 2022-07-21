# frozen_string_literal: true

module TasksHelper
  def progress(tasks)
    completed_task = tasks.count { |task| task.status == 'done' }
    all_task = tasks.length
    completed_percent = completed_task * 100 / (all_task.nonzero? || 1)
    "<p>Completed: #{completed_percent}%</p>".html_safe
  end

  def checkbox_status(task)
    out = if task.done?
            '<input type="checkbox" disabled checked class="text-green-600" />'
          elsif task.in_progress?
            '<input type="checkbox" disabled checked class="text-gray-500" />'
          else
            '<input type="checkbox" disabled/>'
          end
    out.html_safe
  end

  def title_status(task)
    out = if task.done?
            "<p class='line-through text-gray-400 ml-2'>#{task.title}</p>"
          else
            "<p class='ml-2'>#{task.title}</p>"
          end
    out.html_safe
  end

  def task_status(task)
    out = 'Status: '
    out += if task.done?
             'Done'
           elsif task.in_progress?
             'In Progress'
           else
             'Pending'
           end
    out.html_safe
  end
end
