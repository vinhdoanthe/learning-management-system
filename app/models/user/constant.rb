module User::Constant
  # User roles
  ADMIN = 'Admin'
  TEACHER = 'Teacher'
  PARENT = 'Parent'
  STUDENT = 'Student'
  CONTENT_ADMIN = 'Content Admin'
  OPERATION_ADMIN = 'Operation Admin'

  # User status
  ACTIVE = true
  IN_ACTIVE = false
end

module User::Constant::Gender
  MALE = 'm'
  FEMALE = 'f'
end

module User::Constant::TekyCoinStarActivitySetting
  REWARD_LVN = 'REWARD_LVN'
  REWARD_GB = 'REWARD_GB'
  REWARD_LBTL = 'REWARD_LBTL'
  REWARD_TCPB = 'REWARD_TCPB'
  HOMEWORK_CHOICE = 'HOMEWORK_CHOICE'
  HOMEWORK_TEXT = 'HOMEWORK_TEXT'
  ATTENDANCE_YES = 'ATTENDANCE_YES'
  UPLOAD_SPCK = 'UPLOAD_SPCK'
end

module User::Constant::Evaluate
  EVALUATE = {
    'KIẾN THỨC' => {
      'knowledge1' => { 
        'label' => "Khả năng tiếp thu kiến thức bài học mới", 
        'content' => {
          '1' => 'Cần cố gắng (Need Improve)',
          '2' => 'Khá (Good)',
          '3' => 'Tốt (Perfect)'
        }
      },
      'knowledge2' => {
        'label' => "Khả năng sáng tạo, phát triển ý tưởng bài học",
        'content' => {
          '1' => 'Đáp ứng yêu cầu cơ bản (Achieve basis requirement)',
          '2' => 'Có ý tưởng sáng tạo (Creative)',
          '3' => 'Rất sáng tạo (Very creative)'
        }
      },
      'knowledge3' => {
        'label' => "Khả năng áp dụng các kiến thức đã học vào bài học mới",
        'content' => {
          '1' => 'Còn quên kiến thức (Forget a little)',
          '2' => 'Nhớ kiến thức cũ (Well Remember)',
          '3' => 'Áp dụng rất tốt (Very good and applied perfectly)'
        }
      },
      'knowledge4' => {
        'label' => "Hoàn thành bài tập về nhà",
        'content' => {
          '1' => 'Chưa làm (Has not done)',
          '2' => 'Hoàn thành yêu cầu (Complete Basic requirement)',
          '3' => 'Hoàn thành rất tốt (Perfectly completed)'
        }
      }
    },
    'THÁI ĐỘ' => {
      'attitude1' => {
        'label' => "Ý thức học tập, khả năng tập trung và chú ý nghe giảng",
        'content' => {
          '1' => 'Thỉnh thoảng còn mất tập trung (Sometime Distracting)',
          '2' => 'Rất tập trung (Very focused)',
          '3' => 'Hoàn thành rất tốt (Completed very well)'
        }
      },
      'attitude2' => {
        'label' => "Tinh thần phát biểu xây dựng bài học và tham gia các hoạt động trong lớp",
        'content' => {
          '1' => 'Còn rụt rè (Little shy)',
          '2' => 'Thường xuyên phát biểu (Usually stated)',
          '3' => 'Nhiệt tình, hào hứng tham gia (Proactive)'
        }
      }
    },
    'KĨ NĂNG' => {
      'skill1' => {
        'label' => "Khả năng làm việc nhóm",
        'content' => {
          '1' => 'Chưa tốt (Need improve)',
          '2' => 'Hỗ trợ các thành viên (Actively helping other member)',
          '3' => 'Có khả năng lãnh đạo nhóm (Leader mindset)'
        }
      },
      'skill2' => {
        'label' => "Kỹ năng thuyết trình",
        'content' => {
          '1' => 'Chưa tự tin (Not so confident)',
          '2' => 'Trình bày tự tin, rõ ràng (Very Confident)',
        }
      }
    }
  }

  CATEGORY_EVALUATE = {
    'category_finish' => {
      'label' => "Tốc độ hoàn thành các hoạt động trong lớp",
      'content' => {
        '1' => 'Chưa nhanh (Need improve)',
        '2' => 'Đạt yêu cầu (Achieve basic requirement)',
        '3' => 'Rất nhanh (Very fast)'
      }
    },
    'category_old_ideas' => {
      'label' => "Mức độ học sinh vận dụng các kiến thức cũ trong bài học mới",
      'content' => {
        '1' => 'Thỉnh thoảng còn quên kiến thức (Sometime forget)',
        '2' => 'Biết vận dụng kiến thức cũ và tiến bộ qua từng bài học (Basicly apply old concept to new lesson and improve during study period)',
        '3' => 'Vận dụng rất tốt các kiến thức cũ (Well apply old concept to new lesson)'
      }
    },
    'category_skill' => {
      'label' => "Mức độ học sinh có thể áp dụng các kỹ năng từ các bài đã học trong bài học mới",
      'content' => {
        '1' => 'Còn cần cố gắng (Need to keep trying)',
        '2' => 'Còn cần cố gắng (Need to keep trying)',
        '3' => 'Kỹ năng rất tốt (Very good skills)'
      }
    },
    'category_creation' => {
      'label' => "Mức độ sáng tạo trong các buổi học",
      'content' => {
        '1' => 'Đạt yêu cầu tối thiểu (Achieve basic requirement)',
        '2' => 'Có các ý tưởng mới trong từng buổi học (Sometime show some good idea)',
        '3' => 'Rất sáng tạo, áp dụng nhiều chủ đề khác nhau vào bài học (Creatively and well apply various subject to the lesson)'
      }
    },
    'category_complete' => {
      'label' => "Mức độ học sinh hoàn thành các hoạt động trong lớp",
      'content' => {
        '1' => 'Chưa hoàn thành đầy đủ (Sometime incomplete)',
        '2' => 'Hoàn thành nhưng cần hỗ trợ (Complete activities but need assisting)',
        '3' => 'Hoàn thành không cần hỗ trợ (Complete without assisting)',
        '4' => 'Hoàn thành rất tốt (Perfectly complete)'
      }
    },
    'category_presentation' => {
      'label' => "Khả năng thuyết trình",
      'content' => {
        '1' => 'Còn rụt rè (Little shy)',
        '2' => 'Đã tự tin, tiến bộ hơn qua từng buổi học (Confident and improve during study period)',
        '3' => 'Có khả năng trình bày rõ ràng rành mạch (Ability to express clearly)',
        '4' => 'Có khả năng chuẩn bị nội dung chi tiết, các công cụ và trình bày bài thuyết trình rất tốt (Ability to prepare detailed content, tools and presentations very well)'
      }
    },
    'category_working_group' => {
      'label' => "Khả năng làm việc nhóm",
      'content' => {
        '1' => 'Không hợp tác với nhóm (Not well collaborative)',
        '2' => 'Chịu khó trao đổi, đưa ra ý kiến và hợp tác với thành viên trong nhóm (Ability to communicate, give opinions and cooperate with team members)',
        '3' => 'Có khả năng lãnh đạo nhóm, đưa ra các yêu cầu cho nhóm (Ability to lead the team, giving the team requirements)'
      }
    },
    'category_complete_project' => {
      'label' => "Độ hoàn thiện dự án cuối khóa",
      'content' => {
        '1' => 'Chưa hoàn thiện (Not so completed. Need improved)',
        '2' => 'Hoàn thiện ở mức cơ bản (Complete at basic level)',
        '3' => 'Rất tốt (Perfect final project)'
      }
    },
    'category_awareness' => {
      'label' => "Ý thức học tập, Khả năng tập trung, chú ý nghe giảng",
      'content' => {
        '1' => 'Thỉnh thoảng còn mất tập trung (Sometime Distracting)',
        '2' => 'Rất tập trung (Very focused)'
      }
    },
    'category_stated' => {
      'label' => "Tinh thần phát biểu, xây dựng bài học ",
      'content' => {
        '1' => 'Còn rụt rè (Little shy)',
        '2' => 'Thường xuyên phát biểu (Proactive)'
      }
    },
    'category_take_initiative' => {
      'label' => "Mức độ chủ động tham gia các hoạt động trong lớp",
      'content' => {
        '1' => 'Còn rụt rè (Little shy)',
        '2' => 'Nhiệt tình, hào hứng tham gia (Proactive)'
      }
    }
  }
end

module User::Constant::SessionEvaluation
  EVALUATION = {
    'KNOWLEDGE' => {
      'knowledge1' => { 
        'label' => "Khả năng tiếp thu kiến thức bài học mới", 
        'content' => {
          '1' => 'Cần cố gắng (Need Improve)',
          '2' => 'Khá (Good)',
          '3' => 'Tốt (Perfect)'
        }
      },
      'knowledge2' => {
        'label' => "Khả năng sáng tạo, phát triển ý tưởng bài học",
        'content' => {
          '1' => 'Đáp ứng yêu cầu cơ bản (Achieve basis requirement)',
          '2' => 'Có ý tưởng sáng tạo (Creative)',
          '3' => 'Rất sáng tạo (Very creative)'
        }
      },
      'knowledge3' => {
        'label' => "Khả năng áp dụng các kiến thức đã học vào bài học mới",
        'content' => {
          '1' => 'Còn quên kiến thức (Forget a little)',
          '2' => 'Nhớ kiến thức cũ (Well Remember)',
          '3' => 'Áp dụng rất tốt (Very good and applied perfectly)'
        }
      },
      'knowledge4' => {
        'label' => "Hoàn thành bài tập về nhà",
        'content' => {
          '1' => 'Chưa làm (Has not done)',
          '2' => 'Hoàn thành yêu cầu (Complete Basic requirement)',
          '3' => 'Hoàn thành rất tốt (Perfectly completed)'
        }
      }
    },
    'ATTITUDE' => {
      'attitude1' => {
        'label' => "Ý thức học tập, khả năng tập trung và chú ý nghe giảng",
        'content' => {
          '1' => 'Thỉnh thoảng còn mất tập trung (Sometime Distracting)',
          '2' => 'Rất tập trung (Very focused)',
          '3' => 'Hoàn thành rất tốt (Completed very well)'
        }
      },
      'attitude2' => {
        'label' => "Tinh thần phát biểu xây dựng bài học và tham gia các hoạt động trong lớp",
        'content' => {
          '1' => 'Còn rụt rè (Little shy)',
          '2' => 'Thường xuyên phát biểu (Usually stated)',
          '3' => 'Nhiệt tình, hào hứng tham gia (Proactive)'
        }
      }
    },
    'SKILL' => {
      'skill1' => {
        'label' => "Khả năng làm việc nhóm",
        'content' => {
          '1' => 'Chưa tốt (Need improve)',
          '2' => 'Hỗ trợ các thành viên (Actively helping other member)',
          '3' => 'Có khả năng lãnh đạo nhóm (Leader mindset)'
        }
      },
      'skill2' => {
        'label' => "Kỹ năng thuyết trình",
        'content' => {
          '1' => 'Chưa tự tin (Not so confident)',
          '2' => 'Trình bày tự tin, rõ ràng (Very Confident)',
        }
      }
    }
  }

  CATEGORY_EVALUATE = {
    'category_finish' => {
      'label' => "Tốc độ hoàn thành các hoạt động trong lớp",
      'content' => {
        '1' => 'Chưa nhanh (Need improve)',
        '2' => 'Đạt yêu cầu (Achieve basic requirement)',
        '3' => 'Rất nhanh (Very fast)'
      }
    },
    'category_old_ideas' => {
      'label' => "Mức độ học sinh vận dụng các kiến thức cũ trong bài học mới",
      'content' => {
        '1' => 'Thỉnh thoảng còn quên kiến thức (Sometime forget)',
        '2' => 'Biết vận dụng kiến thức cũ và tiến bộ qua từng bài học (Basicly apply old concept to new lesson and improve during study period)',
        '3' => 'Vận dụng rất tốt các kiến thức cũ (Well apply old concept to new lesson)'
      }
    },
    'category_skill' => {
      'label' => "Mức độ học sinh có thể áp dụng các kỹ năng từ các bài đã học trong bài học mới",
      'content' => {
        '1' => 'Còn cần cố gắng (Need to keep trying)',
        '2' => 'Còn cần cố gắng (Need to keep trying)',
        '3' => 'Kỹ năng rất tốt (Very good skills)'
      }
    },
    'category_creation' => {
      'label' => "Mức độ sáng tạo trong các buổi học",
      'content' => {
        '1' => 'Đạt yêu cầu tối thiểu (Achieve basic requirement)',
        '2' => 'Có các ý tưởng mới trong từng buổi học (Sometime show some good idea)',
        '3' => 'Rất sáng tạo, áp dụng nhiều chủ đề khác nhau vào bài học (Creatively and well apply various subject to the lesson)'
      }
    },
    'category_complete' => {
      'label' => "Mức độ học sinh hoàn thành các hoạt động trong lớp",
      'content' => {
        '1' => 'Chưa hoàn thành đầy đủ (Sometime incomplete)',
        '2' => 'Hoàn thành nhưng cần hỗ trợ (Complete activities but need assisting)',
        '3' => 'Hoàn thành không cần hỗ trợ (Complete without assisting)',
        '4' => 'Hoàn thành rất tốt (Perfectly complete)'
      }
    },
    'category_presentation' => {
      'label' => "Khả năng thuyết trình",
      'content' => {
        '1' => 'Còn rụt rè (Little shy)',
        '2' => 'Đã tự tin, tiến bộ hơn qua từng buổi học (Confident and improve during study period)',
        '3' => 'Có khả năng trình bày rõ ràng rành mạch (Ability to express clearly)',
        '4' => 'Có khả năng chuẩn bị nội dung chi tiết, các công cụ và trình bày bài thuyết trình rất tốt (Ability to prepare detailed content, tools and presentations very well)'
      }
    },
    'category_working_group' => {
      'label' => "Khả năng làm việc nhóm",
      'content' => {
        '1' => 'Không hợp tác với nhóm (Not well collaborative)',
        '2' => 'Chịu khó trao đổi, đưa ra ý kiến và hợp tác với thành viên trong nhóm (Ability to communicate, give opinions and cooperate with team members)',
        '3' => 'Có khả năng lãnh đạo nhóm, đưa ra các yêu cầu cho nhóm (Ability to lead the team, giving the team requirements)'
      }
    },
    'category_complete_project' => {
      'label' => "Độ hoàn thiện dự án cuối khóa",
      'content' => {
        '1' => 'Chưa hoàn thiện (Not so completed. Need improved)',
        '2' => 'Hoàn thiện ở mức cơ bản (Complete at basic level)',
        '3' => 'Rất tốt (Perfect final project)'
      }
    },
    'category_awareness' => {
      'label' => "Ý thức học tập, Khả năng tập trung, chú ý nghe giảng",
      'content' => {
        '1' => 'Thỉnh thoảng còn mất tập trung (Sometime Distracting)',
        '2' => 'Rất tập trung (Very focused)'
      }
    },
    'category_stated' => {
      'label' => "Tinh thần phát biểu, xây dựng bài học ",
      'content' => {
        '1' => 'Còn rụt rè (Little shy)',
        '2' => 'Thường xuyên phát biểu (Proactive)'
      }
    },
    'category_take_initiative' => {
      'label' => "Mức độ chủ động tham gia các hoạt động trong lớp",
      'content' => {
        '1' => 'Còn rụt rè (Little shy)',
        '2' => 'Nhiệt tình, hào hứng tham gia (Proactive)'
      }
    }
  }
end
