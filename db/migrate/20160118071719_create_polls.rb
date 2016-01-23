class CreatePolls < ActiveRecord::Migration
	def up
		create_table :polls do |t|
			t.references(:user)
			t.string('question')
			t.timestamps(:null => false)
		end
		add_index(:polls, 'user_id')
	end

	def down
		drop_table(:polls)
	end
end
