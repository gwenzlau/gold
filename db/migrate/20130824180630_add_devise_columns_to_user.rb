=begin
class AddDeviseColumnsToUser < ActiveRecord::Migration
  def self.up
  	change_table(:users) do |t|
  		t.token_authenticable
  	end
  end
  def self.down
  	t.remove :authentication_token
  end
end
=end
