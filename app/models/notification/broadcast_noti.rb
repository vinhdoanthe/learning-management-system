class Notification::BroadcastNoti < ApplicationRecord
  self.table_name = 'broadcast_noti'

  belongs_to :user, class_name: 'User::User', foreign_key: 'created_by'

  def created_by_username
    user.username
  end

  rails_admin do
    list do
      field :title
      field :created_by_username
      field :expiry_date
    end

    show do
      field :title
      field :content do
        pretty_value do
          value.html_safe
        end
      end
      field :created_by_username
      field :expiry_date
    end

    edit do
      field :title
      field :content, :ck_editor do
        config_js ActionController::Base.helpers.asset_path('ckeditor/config.js')
      end
      field :expiry_date
      field :created_by, :hidden do
        visible true
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end
  end
end
