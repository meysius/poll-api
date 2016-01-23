class CreateVotedOptionsVoters < ActiveRecord::Migration
	def up
		create_table :voted_options_voters, :id => false do |t|
			t.references(:user)
			t.references(:option)
			t.timestamps(:null => false)
		end
		add_index(:voted_options_voters, ['user_id', 'option_id'])
	end

	def down
		drop_table(:voted_options_voters)
	end
end
