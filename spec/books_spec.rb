# require './lib/account.rb'
# require 'date'
# require './lib/data.yml'
require './lib/books.rb'
require 'pry'
require 'pry-byebug'
require 'yaml'

describe Books do
    let(:account) { instance_double('Account', pin_code: '1234', exp_date: '04/20', account_status: :active) }
        before do
            allow(Books).to receive(YAML.load_file('./lib/data.yml'))
        end

    it 'has books on library shelves' do
    expect(subject.books).to != true
    end 

    it 'number of available books are reduced at checkout' do
    subject.checkout(1, '1234', account)
    expect(subject.books).to eq -1 #changes book availability 
    end

    it 'rejects checkout if the book is already checked out' do
    expected_output = { status: false, message: 'book checked out', date: Date.today }
    expect(subject.checkout(1, '1234', account)).to eq expected_output
    end

    it 'allows checkout if the book is available' do
    expected_output = { status: true, message: 'success', date: Date.today}
    expect(subject.checkout(1, '1234', account)).to eq expected_output
    end

    it 'reject checkout if the pin is wrong' do
    expected_output = { status: false, message: 'wrong pin', date: Date.today }
    expect(subject.checkout(1, 1234, account)).to eq expected_output
    end

    it 'reject checkout if library account is expired' do
    allow(account).to receive(:exp_date).and_return('02/30')
    expected_output = { status: false, message: 'library account expired', date: Date.today }
    expect(subject.checkout(1, '1234', account)).to eq expected_output
    end

end
