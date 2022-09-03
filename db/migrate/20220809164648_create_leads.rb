class CreateLeads < ActiveRecord::Migration[6.1]
  def change
    create_table :leads do |t|
      t.string :api_key
      t.string :sourceurl
      t.integer :affiliate_id
      t.integer :campaign_id
      t.integer :sub_id
      t.string :quote_type
      t.string :bid_id
      t.string :ip
      t.string :useragent
      t.integer :zip
      t.string :trustedform
      t.string :leadid
      t.datetime :date
      t.string :firstname
      t.string :lastname
      t.string :address
      t.string :email
      t.string :phone
      t.string :project_type
      t.string :roof_material
      t.string :timeframe
      t.string :besttimecall
      t.string :homeowner
      t.string :property_type

      t.timestamps
    end

    add_reference :leads, :user, null: false, foreign_key: true
  end
end
