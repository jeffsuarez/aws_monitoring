require 'csv'

class BillSummary
  BILL_FILENAME = '%{account_number}-aws-billing-csv-%{year_month}.csv'

  def initialize(attributes = {})
    @s3_client = attributes[:s3_client]
    @s3_billing_bucket = attributes[:s3_billing_bucket]
    @account_number = attributes[:account_number]
  end

  def current_month_billed
    "$13,045.61"
  end

  def current_month_paid
  end

  def current_bill

  end

  def bill_csv
    begin
      file_stream = s3_client.get_object(bucket: @s3_billing_bucket, key: bill_filename).body.read
      return CSV.new(file_stream)
    rescue
      return nil
    end
  end

  def bill_filename
    BILL_FILENAME % { account_number: @account_number, year_month: Time.now.strftime("%Y-%m") }
  end
end