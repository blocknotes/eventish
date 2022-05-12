# frozen_string_literal: true

module Logs
  class BalanceAroundCreateEvent < Eventish::SimpleEvent
    def call(balance, _options = {})
      puts '>>> Around create event - balance >>>'
      yield
      puts "<<< Around create event - balance ##{balance.id} <<<"
    end
  end
end
