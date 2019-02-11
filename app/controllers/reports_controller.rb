# frozen_string_literal: true

class ReportsController < ApplicationController

  before_action :set_organization

  def index; end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
