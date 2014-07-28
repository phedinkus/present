class CreateGithubAccounts < ActiveRecord::Migration
  def change
    create_table :github_accounts do |t|
      t.references :user, :index => true
      t.integer :github_id
      t.string :login
      t.string :access_token
      t.text :scopes, :array => true
      t.timestamps
    end
  end
end
