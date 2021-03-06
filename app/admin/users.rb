ActiveAdmin.register User do
  config.filters = false

  controller do
    defaults finder: :find_by_name
  end

  menu priority: 1
  scope :all, default: true
  scope :novices do |users|
    users.where(workflow_state: "novice")
  end

  scope :candidates do |users|
    users.where(workflow_state: "candidate")
  end

  scope :developers do |users|
    users.where(workflow_state: "developer")
  end

  scope :mentors do |users|
    users.where(workflow_state: "mentor")
  end

  scope :recruiters do |users|
    users.where(workflow_state: "recruiter")
  end

  scope :admins do |users|
    users.where(workflow_state: "admin")
  end

  index do
    column("Name", :name)
    column("Email", :email)
    column("Role") { |user| status_tag(user.current_state.to_s) }
    column("Action") { |user| link_to "Promote", "/admin/users/#{user.to_param}/promote", method: :put}
    actions
  end

  form do |f|
    f.inputs "user" do
      f.input :workflow_state, as: :select, collection: User.workflow_spec.states, label: "Role"
      f.input :name
      f.input :email
      f.input :biography
    end
    f.actions
  end

  member_action :promote, :method => :put do
    user = User.find_by(name: params[:id])
    user.promote!
    flash[:notice] = "#{user.name} promoted!"
    redirect_to action: :index
  end
end
