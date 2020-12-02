class AddEvaluationLogToOpSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :op_session, :evaluation_log, :text
  end
end
