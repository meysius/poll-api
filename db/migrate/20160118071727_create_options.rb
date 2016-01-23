class CreateOptions < ActiveRecord::Migration
	def up
		create_table :options do |t|
			t.references(:poll)
			t.string('text')
			t.timestamps(:null => false)
		end
		add_index(:options, 'poll_id')
	end

	def down
		drop_table(:options)
	end
end
