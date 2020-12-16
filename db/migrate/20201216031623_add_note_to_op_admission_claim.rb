class AddNoteToOpAdmissionClaim < ActiveRecord::Migration[6.0]
  def change
    add_column :op_admission_claim, :note, :string
  end
end
