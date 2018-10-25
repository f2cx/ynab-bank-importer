class Dumper
  # Implements logic to fetch transactions via the Fints protocol
  # and implements methods that convert the response to meaningful data.
  class Csv < Dumper
    require 'digest/md5'

    def initialize(params = {})
      @ynab_id  = params.fetch('ynab_id')
      @file     = params.fetch('file')
    end

    def fetch_transactions

      #puts JSON.pretty_generate()
      lines = CSV.read(@file, headers: false, col_sep: ';', encoding:'iso-8859-1:utf-8')
      lines = lines.drop(8)

      lines.map{ |t| to_ynab_transaction(t) }

      #statement.map { |t| to_ynab_transaction(t) }
    end

    private

    def account_id
      @ynab_id
    end

    def date(transaction)
      return Date.parse(transaction[2])
    end

    def payee_name(transaction)
      transaction[3]
    end

    def payee_iban(transaction)
      transaction[3]
    end

    def memo(transaction)
      transaction[3]
    end

    def amount(transaction)
      amount = transaction[4].gsub(',', '.')
      (amount.to_f * 1000).to_i
    end

    def withdrawal?(transaction)
      memo = memo(transaction)
      return nil unless memo

      memo.include?('VOLKSBANK EGSTEISSLING') || memo.include?('Ausgleich Kreditkarte')
    end

    def import_id(transaction)
      #puts JSON.pretty_generate(transaction)
      data = [
              transaction[2],
              transaction[3],
              transaction[4]
              ].join
      Digest::MD5.hexdigest(data)
    end

  end
end
