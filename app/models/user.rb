require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :microposts, :dependent => :destroy
  has_many :groups, :dependent => :destroy

  #Relationships methods
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed

  has_many :reverse_relationships, :foreign_key => "followed_id",
    :class_name => "Relationship",
    :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  has_attached_file :avatar, :styles => { :thumb => "75x75>", :small => "150x150>", :smallest => "50x50>" }

  validates     :email, :name, :presence => true
  validates_length_of       :email, :within => 5..40
  validates_uniqueness_of   :email
  validates                 :email, :confirmation => true
  #validate                  :email_non_blank
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  attr_accessor             :password_confirmation
  attr_accessor             :email_confirmation

  #validates_format_of :picture, :with => /^[^\/\\\?\*:|"<>]+$/, :message => I18n.t(:invalid_characters, :scope => [:activerecord, :errors, :messages])


  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.forgot_password(self.email, self.name, new_pass).deliver
  end

  def refresh_remember_token
    self.remember_token = SecureRandom.base64(32)
    save(:validate => false)
  end


  private
  #custom validations
  def password_non_blank
    errors.add(:confirmation_password, "missing") if hashed_password.blank?
  end
  def validate_on_create
    errors.add(:confirmation_email, "missing") if email_confirmation.blank?
  end


  #password encryption methods
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  #generate a random password consisting of strings and digits
  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end