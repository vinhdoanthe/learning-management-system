class SocialCommunity::Discussion
  self.table_name = 'discussions'
  has_many :messages, as: :messageable
end
