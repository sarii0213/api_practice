# frozen_string_literal: true

class ItemsController < ApplicationController
  def index
    if params[:category_name]
      unless Category.find_by(name: params[:category_name])
        render json: { status: '404', message: 'requested category does not exist' }, status: :not_found
        return
      end
      items = Category.find_by(name: params[:category_name]).items.order(created_at: :desc)
    else
      items = Item.order(created_at: :desc)
    end
    render json: { status: '201', data: items }
  end

  def create
    category = Category.find_or_create_by(name: params[:category_name])
    item = Item.new(name: params[:name], category:)

    if item.save
      render json: { status: '201', data: item }
    else
      render json: { status: '422', data: item.errors }, status: :unprocessable_entity
    end
  end
end
