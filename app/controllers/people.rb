class People < Application
  before :verify_user, :exclude => [:index, :show]
  # provides :xml, :yaml, :js

  def index
    @people = Person.all(:limit => 20)
    display @people
  end

  def show(id)
    @person = Person.get(id)
    raise NotFound unless @person
    display @person
  end

  def edit(id)
    @person = Person.get(id)
    raise NotFound unless @person
    display @person
  end

  def update(id, person)
    @person = Person.get(id)
    raise Unauthorized if @person != @user.person
    if @person.update_attributes(person)
      redirect resource(@person)
    else
      render :edit
    end
  end
end
