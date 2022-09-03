require 'net/http'

ActiveAdmin.register Lead do
  scope_to :current_user
  permit_params :firstname, :lastname, :phone, :address, :zip, :email,
                :project_type, :roof_material, :timeframe, :besttimecall, :homeowner,
                :property_type, :ip, :useragent, :trustedform, :leadid, :date

  collection_action :ping, method: :put do

    @lead = Lead.find(params[:format])

    endpoint = "https://api.adventum.co/ping/"
    request = {
               "trustedform" => @lead.trustedform,
               "leadid" => @lead.leadid,
               "date" => @lead.date.strftime("%Y-%M-%d %H:%M:%S"),
               "useragent" => @lead.useragent,
               "ip" => @lead.ip,
               "zip" => @lead.zip,
                }
    attributes = {
                   "project_type" => @lead.project_type,
                   "roof_material" => @lead.roof_material,
                   "timeframe" => @lead.timeframe,
                   "besttimecall" => @lead.besttimecall,
                   "homeowner" => @lead.homeowner,
                   "property_type" => @lead.property_type,
                }
    params = {
              "test" => "1",
              "affiliate_id" => 821578,
              "api_key" => "EBE96F39-A0CD-F2B6-1201-475C85CBFB1C",
              "sourceurl" => "mywebsiteurl.com",
              "campaign_id" => "123456",
              "sub_id" => "123456",
              "quote_type" => "roofing",
              "request" => request,
              "attributes" => attributes,
                }

    url = URI(endpoint)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump(params)
    response = https.request(request)
    @data = JSON.parse(response.read_body)
    if @data["status"] != "success"
      return redirect_to({action: :index}, alert: "Ping failed with the following message: #{@data["message"]}!")
    end
    @lead.update(bid_id: @data["bid"]["bid_id"], price: @data["bid"]["price"])
    Request.create(status: @data["status"], category: 'Ping', message: @data["message"], bid: @data["bid"]["bid_id"], price: @data["bid"]["price"], lead_id: @lead.id)

    render 'admin/leads/ping.erb'
  end

  collection_action :post, method: :put do
    @lead = Lead.find(@_params[:format])

    endpoint = "https://api.adventum.co/post/"
    request = {
      "trustedform" => @lead.trustedform,
      "leadid" => @lead.leadid,
      "date" => @lead.date.strftime("%Y-%M-%d %H:%M:%S"),
      "useragent" => @lead.useragent,
      "ip" => @lead.ip,
      "zip" => @lead.zip,
      "firstname" => @lead.firstname,
      "lastname" => @lead.lastname,
      "address" => @lead.address,
      "email" => @lead.email,
      "phone" => @lead.phone,
    }
    params = {
      "quote_type" => "roofing",
      "bid_id" => @lead.bid_id,
      "request" => request,
    }

    url = URI(endpoint)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request.body = JSON.dump(params)
    response = https.request(request)
    @data = JSON.parse(response.read_body)
    if @data["status"] != "success"
      return redirect_to({action: :index}, alert: "Post failed with the following message: #{@data["message"]}!")
    end

    Request.create(status: @data["status"],category: 'Post', message: @data["message"], bid: @data["bid"]["bid_id"], price: @data["bid"]["price"], lead_id: @lead.id)

    return redirect_to({action: :index}, notice: "Successfully posted!!!")
  end

  index do
    selectable_column
    id_column
    column :firstname
    column :lastname
    column :phone
    column :bid_id
    column :price

    column  do |lead|
      link_to 'Ping', ping_admin_leads_path(lead), method: :put
      end
    actions
  end

  form do |f|
    f.inputs do
      f.input :firstname, label: "First Name"
      f.input :lastname, label: "Last Name"
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

