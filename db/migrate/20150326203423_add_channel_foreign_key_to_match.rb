class AddChannelForeignKeyToMatch < ActiveRecord::Migration
  def change
    add_reference :matches, :channel, index: true
    add_foreign_key :matches, :channels
  end
end
