module Learning
  module Homework
    module Report
      class StudentHomework
        attr_accessor :sessions
        attr_accessor :data

        def initialize(sessions=[], data=[])
          @sessions = sessions
          @data = data
        end
      end
    end
  end
end
