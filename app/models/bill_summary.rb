require 'csv'

class BillSummary
  BILL_FILENAME = '%{account_number}-aws-billing-csv-%{year_month}.csv'
  ESTIMATED_BILL_ID_FIELD = :recordid
  ESTIMATED_BILL_ID_VALUE = 'InvoiceTotal:Estimated'
  ESTIMATED_BILL_COST_FIELD = :totalcost

  def initialize(attributes = {})
    @s3_client = attributes[:s3_client]
    @s3_billing_bucket = attributes[:s3_billing_bucket]
    @account_number = attributes[:account_number]
  end

  def monthly_invoice_to_date
    if current_parsed_bill.present?
      invoice_line = current_parsed_bill.find do |r|
        r[ESTIMATED_BILL_ID_FIELD] == ESTIMATED_BILL_ID_VALUE
      end
      invoice_line[ESTIMATED_BILL_COST_FIELD]
    end
  end

  private

  def current_parsed_bill
    @current_parsed_bill ||= parse_csv(bill_text(filename: bill_filename))
  end

  def parse_csv(bill_text)
    if bill_text
      CSV::Converters[:blank_to_nil] = lambda do |field|
          field && field.empty? ? nil : field
      end
      csv = CSV.new(
        bill_text,
        headers: true,
        header_converters: :symbol,
        converters: [:all, :blank_to_nil]
      )
      csv.to_a.map { |row| row.to_hash }
    end
  end

  def bill_text(filename: bill_filename)
    begin
      return @s3_client.get_object(bucket: @s3_billing_bucket, key: filename).body.read
    rescue
      return nil
    end
  end

  def bill_filename
    BILL_FILENAME % { account_number: @account_number, year_month: Time.now.strftime("%Y-%m") }
  end
end
