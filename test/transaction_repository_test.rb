require_relative 'test_helper'

class TransactionRepositoryTest < Minitest::Test
  attr_reader :repository,
              :transactions,
              :transaction1,
              :transaction2,
              :transaction3,
              :expected_find_by_all_values,
              :expected_find_by_values,
              :search_terms,
              :engine

  def setup
    transaction_setup

    @engine     = Minitest::Mock.new
    @repository = TransactionRepository.new(engine, transactions)

    @search_terms = { id: "1",
                      invoice_id: "1",
                      credit_card_number: "4654405418249632",
                      credit_card_expiration_date: "",
                      result: "success",
                      created_at: "2012-03-27 14:53:59 utc",
                      updated_at: "2012-03-27 14:53:59 utc" }

    @expected_find_by_all_values = { id: [transaction1],
                                     invoice_id: [transaction1],
                                     credit_card_number: [transaction1],
                                     credit_card_expiration_date: [transaction1, transaction2, transaction3],
                                     result: [transaction1, transaction2, transaction3],
                                     created_at: [transaction1, transaction2],
                                     updated_at: [transaction1, transaction2] }

    @expected_find_by_values = { id: transaction1,
                                 invoice_id: transaction1,
                                 credit_card_number: transaction1,
                                 credit_card_expiration_date: transaction1,
                                 result: transaction1,
                                 created_at: transaction1,
                                 updated_at: transaction1 }
  end

  def transaction_setup
    transaction1_data = { id: "1",
                          invoice_id: "1",
                          credit_card_number: "4654405418249632",
                          credit_card_expiration_date: "",
                          result: "success",
                          created_at: "2012-03-27 14:53:59 utc",
                          updated_at: "2012-03-27 14:53:59 utc" }

    transaction2_data = { id: "2",
                          invoice_id: "2",
                          credit_card_number: "4580251236515201",
                          credit_card_expiration_date: "",
                          result: "success",
                          created_at: "2012-03-27 14:53:59 utc",
                          updated_at: "2012-03-27 14:53:59 utc" }

    transaction3_data = { id: "3",
                          invoice_id: "4",
                          credit_card_number: "4354495077693036",
                          credit_card_expiration_date: "",
                          result: "success",
                          created_at: "2012-03-27 14:54:00 utc",
                          updated_at: "2012-03-27 14:54:00 utc" }

    @transaction1 = Transaction.new(repository, transaction1_data)
    @transaction2 = Transaction.new(repository, transaction2_data)
    @transaction3 = Transaction.new(repository, transaction3_data)

    @transactions = [transaction1, transaction2, transaction3 ]
  end

  def test_it_is_empty_when_new
    other_repository = TransactionRepository.new(engine)
    assert_empty(other_repository.all)
  end

  def test_it_has_an_engine
    assert repository.engine
  end

  def test_find_by_can_return_empty
    assert_nil repository.find_by_invoice_id("5")
  end

  def test_find_by_all_can_return_empty
    assert_equal [], repository.find_all_by_invoice_id("5")
  end

  def test_it_can_return_all_transactions
    assert_equal transactions, repository.all
  end

  def test_it_has_a_random_method_which_returns_an_transaction
    assert_instance_of(Transaction, repository.random)
  end

  def test_it_can_find_by_any_attribute
    [:id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_values[attribute], repository.send("find_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_can_find_all_by_any_attribute
    [:id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_all_values[attribute], repository.send("find_all_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_delegates_find_invoice_to_engine
    engine.expect(:find_invoice_by_invoice_id, [], [transaction1.invoice_id])
    repository.find_invoice(transaction1.invoice_id)
    engine.verify
  end

  def test_inspect_method
    assert_includes(repository.inspect, "3")
  end
end
