if Merb.env == 'production'
  require 'beeu'
else
  require 'beeu_dev'
end 

class Application < Merb::Controller
  include BeeU

  before :assign_user
  before :assign_admin_status
  before :assign_person

private
  def assign_person
    if @user
      unless person = Person.first(:email => @user.email)
        person = Person.new
        person.email = @user.email
        person.name = (@user.nickname || @user.email).split('@').first
        person.created_at = Time.now
        person.save!
      end
      (class << @user; self end).class_eval do
        define_method(:person){person}
      end
    end
  end

  def verify_user
    throw :halt, redirect(url(:root)) if @user.nil?
  end
end
