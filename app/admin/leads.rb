require 'net/http'

ActiveAdmin.register Lead do
  scope_to :current_user
  permit_params :firstname, :lastname, :phone, :address, :zip, :email,
                :project_type, :roof_material, :timeframe, :besttimecall, :homeowner,
                :property_type, :ip, :useragent, :trustedform, :leadid, :date

  collection_action :ping, method: :put do
    byebug
    @lead = Lead.find(params[:format])

    endpoint = "https://api.adventum.co/ping/"
    uri = URI(endpoint)
    params = @lead.attributes.merge({})
    #
    # uri.query = URI.encode_www_form(params)
    # res = Net::HTTP.get_response(uri)
    #
    # data = JSON.parse(res.body)

    render 'admin/leads/ping.erb'
  end

  index do
    selectable_column
    id_column
    column :firstname
    column :lastname
    column :address
    column :email
    column :phone

    column  do |lead|
      link_to 'Ping', ping_admin_leads_path(lead), method: :put
      end
    actions
  end

  form do |f|
    f.inputs do
      f.input :firstname, label: "First Name"
      f.input :lastname, label: "First Name"
      f.input :address
      f.input :zip
      f.input :email
      f.input :phone
      f.input :leadid, label: "Lead ID"
      f.input :trustedform, label: "Trusted Form"
      f.input :project_type, :as => :select, :collection => ["new", "replace", "repair"], label: "Project Type"
      f.input :roof_material, :as => :select, :collection => ["asphalt", "cedar", "metal", "tar", "tile", "natural"], label: "Roof Material"
      f.input :timeframe, :as => :select, :collection => ["immediately", "within 1 month", "1-3 months", "3-6 months", "within a year", "not sure"], label: "Time Frame"
      f.input :besttimecall, :as => :select, :collection => ["morning", "afternoon", "evening", "anytime"], label: "Best Time To Call"
      f.input :homeowner, :as => :select, :collection => ["yes", "no"]
      f.input :property_type, :as => :select, :collection => ["residential", "commercial"], label: "Property Type"
      f.input :date
      f.input :ip
      f.input :useragent

    end
    f.actions
  end
end