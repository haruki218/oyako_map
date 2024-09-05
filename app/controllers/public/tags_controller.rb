class Public::TagsController < ApplicationController
  def create
    @tag = Tag.find_or_create_by(name: params[:name])
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
  end
end
