class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :update, :destroy]

  # GET /applications
  def index
    json_response(Application.all)
  end

  # POST /applications
  def create
    application = Application.create(application_params)
    if application.errors.full_messages.any?
      json_response({errors: application.errors.full_messages})
    else
      json_response(application, :created)
    end
  end

  # GET /applications/:token
  def show
    if @application.present?
      json_response(@application)
    else
      json_response({message: 'Not found'})
    end
  end

  # PUT /applications/:token
  def update
    @application.update!(application_params)
    json_response(@application, :updated)
  end

  # DELETE /applications/:token
  def destroy
    @application.destroy
    json_response({message: 'Application deleted successfully!'}, :deleted)
  end

  private

  def application_params
    params.permit(:name)
  end

  def set_application
    @application = Application.find_by_token(params[:id])
  end


end
