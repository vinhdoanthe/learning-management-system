class AddAttachmentLinkToOpAdmissionClaim < ActiveRecord::Migration[6.0]
  def change
    add_column :op_admission_claim, :attachment_link, :string
  end
end
