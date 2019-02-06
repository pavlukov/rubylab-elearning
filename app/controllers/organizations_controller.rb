class OrganizationsController < ApplicationController
  before_action :set_organization, except: %i[index create new]

  # GET /organizations
  def index
    @organizations = Organization.all
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)
    redirect_to @organization if @organization.save
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/:id/edit
  def edit; end

  # GET /organizations/:id
  def show; end

  # PATCH /organizations/:id
  def update
    redirect_to @organization if @organization.update(organization_params)
  end

  # DELETE /organizations/:id
  def destroy
    redirect_to organizations_path if @organization.destroy
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(%i[name description])
  end
end