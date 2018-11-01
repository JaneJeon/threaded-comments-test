class AddPaths < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :parent, foreign_key: { to_table: :comments }, index: true
    add_column :comments, :path, :integer, array: true, null: false
    add_column :comments, :htap, :integer, array: true, null: false
    add_index :comments, :path
    add_index :comments, :htap

    reversible do |dir|
      dir.up do
        change_column :comments, :id, :integer
        change_column :comments, :parent_id, :integer

        execute <<-SQL
          CREATE FUNCTION comment_build_path() RETURNS TRIGGER AS $$
            DECLARE
              parent_path INT[];
              parent_htap INT[];
            BEGIN
              IF NEW.parent_id IS NULL THEN
                NEW.path = ARRAY[NEW.id];
                NEW.htap = ARRAY[-NEW.id];
              ELSE
                SELECT path, htap INTO parent_path, parent_htap
                  FROM comments
                  WHERE id = NEW.parent_id;
                IF parent_path IS NULL THEN
                  RAISE EXCEPTION 'Invalid parent_id %', NEW.parent_id;
                END IF;
                  NEW.path = parent_path || NEW.id;
                  NEW.htap = parent_htap || -NEW.id;
              END IF;
              RETURN NEW;
            END;
          $$ LANGUAGE plpgsql;

          CREATE TRIGGER build_path BEFORE INSERT ON comments
            FOR EACH ROW EXECUTE PROCEDURE comment_build_path();
        SQL
      end

      dir.down do
        change_column :comments, :id, :bigint
        change_column :comments, :parent_id, :bigint

        execute <<-SQL
          DROP TRIGGER build_path ON comments;
          DROP FUNCTION comment_build_path();
        SQL
      end
    end
  end
end
