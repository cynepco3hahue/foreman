class NotificationRecipient < ActiveRecord::Base
  belongs_to :notification
  belongs_to :user
  has_one :notification_blueprint, :through => :notification

  validates :notification, :presence => true
  validates :user, :presence => true

  scope :unseen, -> { where(:seen => false) }

  def payload
    {
      :id         => id,
      :seen       => seen,
      :level      => notification_blueprint.level,
      :text       => notification.message,
      :created_at => notification.created_at,
      :group      => notification_blueprint.group,
      :actions    => notification.actions
    }
  end

  def current_user?
    return true unless SETTINGS[:login]
    User.current.id == user_id
  end
end
