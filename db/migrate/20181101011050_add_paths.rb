class AddPaths < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :parent_id, :integer
    add_index :comments, :parent_id
    add_column :comments, :path, :integer, array: true, null: false
    add_index :comments, :path
    add_column :comments, :htap, :integer, array: true, null: false
    add_index :comments, :htap
    change_column :comments, :id, :integer

    execute <<-SQL
      ALTER TABLE comments
        ADD CONSTRAINT parent_id_fk FOREIGN KEY (parent_id)
        REFERENCES comments (id)
        ON DELETE CASCADE;
      
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
end
