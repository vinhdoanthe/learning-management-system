module Learning
  module Material
    class LearningMaterial < ApplicationRecord
      extend Enumerize

      belongs_to :op_lession, class_name: 'Learning::Course::OpLession', inverse_of: :learning_materials

      enumerize :material_type, in: [Learning::Constant::Material::MATERIAL_TYPE_FILE, Learning::Constant::Material::MATERIAL_TYPE_VIDEO]
      enumerize :learning_type, in: [Learning::Constant::Material::MATERIAL_TYPE_TEACH, Learning::Constant::Material::MATERIAL_TYPE_REVIEW]

      has_one_attached :material_file
      has_one_attached :thumbnail_image

      def self.get_drive_files(lesson_id)
        files = Array.new
        last_uploaded_file = LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE).last
        queries = LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE,
            op_lession_id: lesson_id).to_a
        if queries.blank?
          files << last_uploaded_file
        else
          files = queries
        end
        files
      end

      def get_drive_object
        unless google_drive_file_id.nil?
          GoogleDrive::DriveApi.get_drive_api_instance.get_pretty_file(google_drive_file_id)
        else
          nil
        end
      end

      def self.ziggeo_list_video
        ziggeo_key = Settings.ziggeo['key']
        ziggeo_secret = Settings.ziggeo['secret']
        ziggeo_encrypt = Settings.ziggeo['encryption']
        ziggeo = ziggeo = Ziggeo.new(ziggeo_secret, ziggeo_key, ziggeo_encrypt)
        @videos = ziggeo.videos.index
      end
    end
  end
end

