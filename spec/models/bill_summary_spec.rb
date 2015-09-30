require 'spec_helper'

describe BillSummary do
  describe 'monthly_invoice_to_date' do
    it 'calls AWS properly to retrieve the bill' do
      s3_client = instance_double('Aws::S3::Client')
      expected_filename = '12345-aws-billing-csv-2015-09.csv'
      expect(s3_client).to receive(:get_object).with(bucket: 'billing-bucket', key: expected_filename)

      bill_summary = BillSummary.new(
        s3_client: s3_client,
        s3_billing_bucket: 'billing-bucket',
        account_number: '12345'
      )
      bill_summary.monthly_invoice_to_date
    end
    it 'returns the current estimate from the bill' do
      bill_file = IO.read(Rails.root.join('spec', 'fixtures', 'bill-sample.csv'))
      body = instance_double('StringIO', read: bill_file)
      response = double(body: body)
      s3_client = instance_double('Aws::S3::Client', get_object: response)

      bill_summary = BillSummary.new(
        s3_client: s3_client,
        s3_billing_bucket: 'billing-bucket',
        account_number: '12345'
      )
      expect(bill_summary.monthly_invoice_to_date).to eq(12245.29)
    end
    it 'gracefully handles the case where a bill is not found' do
      s3_client = instance_double('Aws::S3::Client', get_object: nil)

      bill_summary = BillSummary.new(
        s3_client: s3_client,
        s3_billing_bucket: 'billing-bucket',
        account_number: '12345'
      )
      expect(bill_summary.monthly_invoice_to_date).to eq(nil)
    end
    it 'gracefully handles the case where a bill is found, but there is no estimate' do
      bill_file = 'foobar,boo\n1,2'
      body = instance_double('StringIO', read: bill_file)
      response = double(body: body)
      s3_client = instance_double('Aws::S3::Client', get_object: response)

      bill_summary = BillSummary.new(
        s3_client: s3_client,
        s3_billing_bucket: 'billing-bucket',
        account_number: '12345'
      )
      expect(bill_summary.monthly_invoice_to_date).to eq(nil)
    end
  end
end