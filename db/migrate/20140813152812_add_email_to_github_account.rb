class AddEmailToGithubAccount < ActiveRecord::Migration
  def change
    change_table :github_accounts do |t|
      t.string :email
    end
  end
end
