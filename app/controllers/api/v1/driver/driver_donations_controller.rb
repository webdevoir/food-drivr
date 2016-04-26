class Api::V1::Driver::DriverDonationsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    donations = current_user.donations.all
    respond_with donations
  end

  def update
    donation = current_user.donations.find(params[:id])
    if donation.update(donation_params)
      render json: donation, status: 200, location: [:api_v1, donation]
    else
      render json: { errors: donations.errors }, status: 422
    end
  end

  def pending
    donations = Donation.where(status_id: 0)
    respond_with donations
  end

  def accepted
    donations = Donation.where(status_id: 1)
    respond_with donations
  end

  def completed
    donations = Donation.where(status_id: 2)
  end

  def donation_params
    params.require(:donation).permit(:id, :description, :status_id)
  end

  def status_params
    params.require(:donation).permit(:status_id, :pickup_status_id, :dropoff_status_id)
  end
end
