require 'spec_helper'
require 'account'

describe Account do
  let(:account) { subject }

  describe '#deposit' do
    context 'when a user puts some money on deposit' do
      it 'commits a new transaction' do
        old_transaction_count = account.transaction_count

        account.deposit(100)
        new_transaction_count = account.transaction_count

        expect(new_transaction_count).to eq(old_transaction_count + 1)
      end
      
      it 'increaces the account balance by the deposited amount' do
        first_deposit_amount  = rand(1..1000)
        account.deposit(first_deposit_amount)
        old_balance           = account.balance
        second_deposit_amount = rand(1..1000)

        account.deposit(second_deposit_amount)
        new_balance           = account.balance

        expect(new_balance).to eq(old_balance + second_deposit_amount)
      end

      it 'stores new records about transactions' do
        first_deposit_amount  = rand(1..1000)
        second_deposit_amount = rand(1..1000)
        current_date          = Date.today

        account.deposit(first_deposit_amount)
        account.deposit(second_deposit_amount)

        expected_records = [
          [current_date, first_deposit_amount, first_deposit_amount],
          [current_date, second_deposit_amount,
           first_deposit_amount + second_deposit_amount]
        ]

        expect(account.transaction_records[0]).to eq(expected_records[0])
        expect(account.transaction_records[1]).to eq(expected_records[1])
      end
    end

    context 'when a user tries to put 0 money on deposit' do
      it 'raises an exception and commits no new transactions' do
        expect { account.deposit(0) }.to raise_error(ZeroAmountError)
        expect(account.transaction_count).to eq(0)
      end
    end

    context 'when a user tries to put negative amount of money on deposit' do
      it 'raises an exception and commits no new transactions' do
        expect { account.deposit(-100) }.to raise_error(NegativeAmountError)
        expect(account.transaction_count).to eq(0)
      end
    end
  end

  describe '#withdraw' do
    context 'when a user withdraws some money from the account' do
      it 'commits a new transaction' do
        account.deposit(100)
        old_transaction_count = account.transaction_count

        account.withdraw(100)
        new_transaction_count = account.transaction_count

        expect(new_transaction_count).to eq(old_transaction_count + 1)
      end
      
      it 'decreaces the account balance by the withdrawed amount' do
        deposit_amount  = 200
        withdraw_amount = 100
        account.deposit(deposit_amount)

        account.withdraw(withdraw_amount)
        final_balance   = account.balance

        expect(final_balance).to eq(deposit_amount - withdraw_amount)
      end

      it 'stores new records about transactions' do
        deposit_amount  = rand(1..1000)
        withdraw_amount = rand(1..100)
        current_date    = Date.today

        account.deposit(deposit_amount)
        account.withdraw(withdraw_amount)

        expected_records = [
          [current_date, deposit_amount, deposit_amount],
          [current_date, -withdraw_amount, deposit_amount - withdraw_amount]
        ]

        expect(account.transaction_records[0]).to eq(expected_records[0])
        expect(account.transaction_records[1]).to eq(expected_records[1])
      end
    end

    context 'when a user tries to withdraw 0 money' do
      it 'raises an exception and commits no new transactions' do
        expect { account.withdraw(0) }.to raise_error(ZeroAmountError)
        expect(account.transaction_count).to eq(0)
      end
    end

    context 'when a user tries to withdraw negative amount of money' do
      it 'raises an exception and commits no new transactions' do
        expect { account.withdraw(-100) }.to raise_error(NegativeAmountError)
        expect(account.transaction_count).to eq(0)
      end
    end
 
    context 'when a user tries to withdraw amount of money\
     that exceeds the account balance' do
      it 'raises an exception and commits no new transactions' do
        account.deposit(50)
        old_transaction_count = account.transaction_count

        expect { account.withdraw(100) }
          .to raise_error(InsufficientBalanceError)
        expect(account.transaction_count).to eq(old_transaction_count)
      end
    end
  end

  describe '#print_statement' do
    context 'when a user tries to print statement' do
      let(:fake_stream) { double() }
      
      context 'no transaction records found' do
        let(:no_records_message) { described_class::NO_RECORDS_MESSAGE }

        it 'returns the no-records message' do
          allow(fake_stream).to receive(:write)
          expect(account.print_statement(fake_stream)).to eq(no_records_message)
        end

        it 'prints the no-records message' do
          expect{account.print_statement}
            .to output(no_records_message).to_stdout
        end
      end

      context 'some transaction records found' do
        let(:example_statement) {
          <<~STATEMENT
          Date        Amount  Balance
          31.10.2017    +500      500
          1.5.2018      -100      400
          2.5.2018    +24000    24400
          STATEMENT
        }

        before do
          allow(account).to receive(:current_date) { Date.new(2017, 10, 31) }
          account.deposit(500)
          allow(account).to receive(:current_date) { Date.new(2018, 5, 1) }
          account.withdraw(100)
          allow(account).to receive(:current_date) { Date.new(2018, 5, 2) }
          account.deposit(24000)
        end

        it 'returns a string representation of the statement' do
          allow(fake_stream).to receive(:write)
          expect(account.print_statement(fake_stream)).to eq(example_statement)
        end

        it 'prints the statement' do
          expect { account.print_statement }.to output(example_statement).to_stdout
        end
      end
    end
  end
end
