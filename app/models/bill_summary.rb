class BillSummary
  def initialize(attributes = {})
    @region = attributes[:region]
    @credentials = attributes[:credentials]
  end

  def current_month_spend
    "$13,045.61"
  end

  def current_month_estimate
    "$23,045.61"
  end
end