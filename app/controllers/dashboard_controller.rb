class DashboardController < ApplicationController
  def show
    @bill_summary = BillSummary.new
  end
end