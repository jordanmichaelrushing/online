class User < ActiveRecord::Base
  include Concerns::Users::OnlineStatus
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :generate_channel_key

  def self.online
    where(id: $redis.hgetall("online_users").keys ).select(:id,:email)
  end

  private

  def generate_channel_key
    begin
      key = SecureRandom.urlsafe_base64
    end while User.where(:channel_key => key).exists?
    self.channel_key = key
  end
end
