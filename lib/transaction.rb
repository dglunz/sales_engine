class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at,
              :repository

  def initialize(repository, data={})
    @repository                   = repository
    @id                           = data[:id]
    @invoice_id                   = data[:invoice_id].to_s.downcase
    @credit_card_number           = data[:credit_card_number].to_s.downcase
    @credit_card_expiration_date  = data[:credit_card_expiration_date]
    @result                       = data[:result]
    @created_at                   = data[:created_at].to_s.downcase
    @updated_at                   = data[:updated_at].to_s.downcase
  end

  def attributes
    [:id,
     :invoice_id,
     :credit_card_number,
     :credit_card_expiration_date,
     :result,
     :created_at,
     :updated_at]
  end

  def invoice
    repository.find_invoice(invoice_id)
  end
end
