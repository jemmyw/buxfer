require 'spec/spec_helper'

describe Buxfer do
  describe '::auth' do
    it 'should reset the connection'
  end

  describe '::connection' do
    it 'should create a new connection'
  end
end

describe Buxfer::Base do
  before do
    @base = Buxfer::Base.new('username', 'password')
    @base.stub!(:token).and_return('token')
    @base.class.stub!(:get)
  end

  describe '#tags' do
    it 'should return a collection of Buxfer::Tag objects'
  end

  describe '#accounts' do
    it 'should return a collection of Buxfer::Account objects'
  end

  %w(loans budgets reminders groups contacts).each do |type|
    describe "##{type}" do
      before do
        @response = {
            'response' => {
                type => {
                    type.singularize => [
                        {'id' => 1},
                        {'id' => 2}
                    ]
                }
            }
        }
        @base.class.stub!(:get).and_return(@response)
      end

      it "should call get on the path /#{type}.xml" do
        @base.class.should_receive(:get).with("/#{type}.xml", anything).and_return(@response)
        @base.send(type)
      end

      it "should pass the auth token with the get request" do
        @base.class.should_receive(:get).with(anything, :query => {:token => 'token'}).and_return(@response)
        @base.send(type)
      end

      it "should load the collection from response[#{type}][#{type.singularize}]" do
        @base.send(type).first.should be_a(Buxfer::Response)
        @base.send(type).first.id.should == 1
        @base.send(type).last.id.should == 2
      end
    end
  end
end