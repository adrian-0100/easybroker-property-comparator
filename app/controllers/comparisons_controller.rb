class ComparisonsController < ApplicationController
  def index
    @comparisons = Comparison.includes(:properties, :user).order(created_at: :desc)
  end

  def show
    @comparison = Comparison.find(params[:id])
  end
end
