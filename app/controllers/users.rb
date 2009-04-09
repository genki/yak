class Users < Application
  before :ensure_authenticated, :exclude => [:index, :show, :new, :create]
  # provides :xml, :yaml, :js

  def index
    @users = User.desc.paginate(params.merge(:per_page => 20))
    display @users
  end

  def show(id)
    @user = User.get(id)
    raise NotFound unless @user
    display @user
  end

  def new
    only_provides :html
    @user = User.new
    display @user
  end

  def edit(id)
    only_provides :html
    @user = User.get(id)
    raise NotFound unless @user
    raise Forbidden unless @user == session.user
    display @user
  end

  def password(id)
    only_provides :html
    @user = User.get(id)
    raise NotFound unless @user
    raise Forbidden unless @user == session.user
    display @user
  end

  def create(user)
    @user = User.new(user)
    if @user.save
      redirect resource(@user), :message => {
        :notice => [t("User was successfully created."),
          t("We sent an email including activation code."),
          t("Please check it to activate your account.")].join(' ')
      }
    else
      message[:error] = t("User failed to be created.")
      render :new
    end
  end

  def update(id, user)
    @user = User.get(id)
    raise NotFound unless @user
    raise Forbidden unless @user == session.user
    if user[:email] && email_will_be_changed = @user.email != user[:email]
      @user.make_activation_code
    end
    if @user.update_attributes(user)
      if email_will_be_changed
        @user.send_signup_notification
        session.abandon!
        redirect resource(@user), :message => {
          :notice => [t("Your email address has been changed."), 
            t("Please reactivate by clicking URL in the email we " +
              "sent to your new email address.")].join(' ')}
      else
        redirect resource(@user)
      end
    else
      display @user, (params[:from] || "edit").intern
    end
  end

  def destroy(id)
    @user = User.get(id)
    raise NotFound unless @user
    raise Forbidden unless @user == session.user
    if @user.destroy
      redirect resource(:users)
    else
      raise InternalServerError
    end
  end
end # Users
