require 'date'

class ZeroAmountError < StandardError
end

class NegativeAmountError < StandardError
end

class InsufficientBalanceError < StandardError
end

class Account
  NO_RECORDS_MESSAGE     = "No Records Found\n"
  STATEMENT_TABLE_HEADER = %w(Date Amount Balance)
  STATEMENT_FORMAT_RULES = [
    :format_date_column, :format_amount_column, :format_balance_column
  ]

  attr_reader :balance, :transaction_records

  def initialize
    @balance = 0
    @transaction_records = []
  end

  def deposit(amount)
    raise ZeroAmountError     if amount == 0
    raise NegativeAmountError if amount < 0

    commit_transaction(amount)
  end

  def withdraw(amount)
    raise ZeroAmountError          if amount == 0
    raise NegativeAmountError      if amount < 0
    raise InsufficientBalanceError if amount > balance

    commit_transaction(-amount)
  end

  def print_statement(stream = $stdout)
    statement = generate_statement
    stream.write(statement)
    statement
  end

  def transaction_count
    transaction_records.size
  end

  private
  ###########################################################################

  def current_date
    Date.today
  end

  def commit_transaction(amount)
    @balance += amount
    @transaction_records << [current_date, amount, balance]
    nil
  end

  def generate_statement(header=STATEMENT_TABLE_HEADER,
                         no_records=NO_RECORDS_MESSAGE)
    return no_records if transaction_count == 0

    generate_statement_table(header)
  end

  def generate_statement_table(header)
    table = [STATEMENT_TABLE_HEADER] + transaction_records
    table = process_columns(table) do |columns|
      format_columns(columns, STATEMENT_FORMAT_RULES)
    end
    table.map { |c| c.join('  ') }.join("\n") + "\n"
  end

  def process_columns(table)
    columns = table.transpose
    formatted_columns = yield columns
    formatted_columns.transpose
  end

  def format_columns(columns, rules)
    columns.each_with_index.map { |c, i| self.send(rules[i], c) }
  end

  def format_date_column(col)
    formatted_col = col.map do |c|
      c.respond_to?(:strftime) ? c.strftime('%-d.%-m.%Y') : c
    end

    align_column(formatted_col, :left)
  end

  def format_amount_column(col)
    formatted_col = col.map { |c| c.to_i != 0 ? format('%+d', c) : c.to_s }
    align_column(formatted_col)
  end

  def format_balance_column(col)
    formatted_col = col.map(&:to_s)
    align_column(formatted_col)
  end

  def align_column(col, alignment = :right)
    column_width = col.max_by(&:size).size
    align_method = get_align_method(alignment)
    col.map { |c| c.send(align_method, column_width) }
  end

  def get_align_method(alignment)
    case alignment
    when :right
      :rjust
    when :left
      :ljust
    else
      raise ArgumentError
    end
  end
end
