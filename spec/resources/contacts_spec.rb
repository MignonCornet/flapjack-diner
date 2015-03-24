require 'spec_helper'
require 'flapjack-diner'

describe Flapjack::Diner::Resources::Contacts, :pact => true do

  before(:each) do
    Flapjack::Diner.base_uri('localhost:19081')
    Flapjack::Diner.logger = nil
  end

  context 'create' do

    it "submits a POST request for a contact" do
      flapjack.given("no contact exists").
        upon_receiving("a POST request with one contact").
        with(:method => :post, :path => '/contacts',
             :headers => {'Content-Type' => 'application/vnd.api+json'},
             :body => {'data' => {'contacts' => contact_data.merge('type' => 'contact')}}).
        will_respond_with(
          :status => 201,
          :headers => {'Content-Type' => 'application/vnd.api+json; supported-ext=bulk; charset=utf-8'},
          :body => {'data' => {'contacts' => contact_data.merge('type' => 'contact')}})

      result = Flapjack::Diner.create_contacts(contact_data)
      expect(result).not_to be_nil
      expect(result).to eq(contact_data.merge(:type => 'contact'))
    end

    it "submits a POST request for several contacts" do
      contacts_data = [contact_data.merge(:type => 'contact'),
                       contact_2_data.merge(:type => 'contact')]

      flapjack.given("no contact exists").
        upon_receiving("a POST request with two contacts").
        with(:method => :post, :path => '/contacts',
             :headers => {'Content-Type' => 'application/vnd.api+json'},
             :body => {:data => {:contacts => contacts_data}}).
        will_respond_with(
          :status => 201,
          :headers => {'Content-Type' => 'application/vnd.api+json; supported-ext=bulk; charset=utf-8'},
          :body => {:data => {:contacts => contacts_data}})

      result = Flapjack::Diner.create_contacts(*contacts_data)
      expect(result).not_to be_nil
      expect(result).to eq(contacts_data)
    end

    it "submits a POST request but a contact with that id exists" do
      flapjack.given("a contact exists").
        upon_receiving("a POST request with one contact").
        with(:method => :post, :path => '/contacts',
             :headers => {'Content-Type' => 'application/vnd.api+json'},
             :body => {:data => {:contacts => contact_data.merge(:type => 'contact')}}).
        will_respond_with(
          :status => 403,
          :headers => {'Content-Type' => 'application/vnd.api+json; supported-ext=bulk; charset=utf-8'},
            :body => {:errors => [{
              :status => '403',
              :detail => "Contacts already exist with the following ids: #{contact_data[:id]}"
            }]}
          )

      result = Flapjack::Diner.create_contacts(contact_data)
      expect(result).to be_nil
      expect(Flapjack::Diner.last_error).to eq([{:status => '403',
        :detail => "Contacts already exist with the following ids: #{contact_data[:id]}"}])
    end

  end

  context 'read' do

    before do
      skip "broken"
    end

    context 'GET all contacts' do

      it "has some data" do
        flapjack.given("a contact exists").
          upon_receiving("a GET request for all contacts").
          with(:method => :get, :path => '/contacts').
          will_respond_with(
            :status => 200,
            :headers => {'Content-Type' => 'application/vnd.api+json; supported-ext=bulk; charset=utf-8'},
            :body => {:data => {:contacts => contact_data.merge('type' => 'contact')}}).

        result = Flapjack::Diner.contacts
        expect(result).not_to be_nil
        expect(result).to eq([contact_data])
      end

      it "has no data" do
        flapjack.given("no contact exists").
          upon_receiving("a GET request for all contacts").
          with(:method => :get, :path => '/contacts').
          will_respond_with(
            :status => 200,
            :headers => {'Content-Type' => 'application/vnd.api+json; supported-ext=bulk; charset=utf-8'},
            :body => {:data => {:contacts => []}})

        result = Flapjack::Diner.contacts
        expect(result).not_to be_nil
        expect(result).to be_an_instance_of(Array)
        expect(result).to be_empty
      end

    end

    context 'GET a single contact' do

      it "finds the contact" do
        flapjack.given("a contact exists").
          upon_receiving("a GET request for a single contact").
          with(:method => :get, :path => "/contacts/#{contact_data[:id]}").
          will_respond_with(
            :status => 200,
            :headers => {'Content-Type' => 'application/vnd.api+json; supported-ext=bulk; charset=utf-8'},
            :body => {:data => {:contacts => contact_data.merge('type' => 'contact')}})

        result = Flapjack::Diner.contacts(contact_data[:id])
        expect(result).not_to be_nil
        expect(result).to eq(contact_data)
      end

      it "can't find the contact" do
        flapjack.given("no contact exists").
          upon_receiving("a GET request for a single contact").
          with(:method => :get, :path => "/contacts/#{contact_data[:id]}").
          will_respond_with(
            :status => 404,
            :headers => {'Content-Type' => 'application/vnd.api+json; supported-ext=bulk; charset=utf-8'},
            :body => {:errors => [{
                :status => '404',
                :detail => "could not find Contact record, id: '#{contact_data[:id]}'"
              }]}
            )

        result = Flapjack::Diner.contacts(contact_data[:id])
        expect(result).to be_nil
        expect(Flapjack::Diner.last_error).to eq([{:status => '404',
          :detail => "could not find Contact record, id: '#{contact_data[:id]}'"}])
      end

    end

  end

  context 'update' do

    before do
      skip "broken"
    end

    it 'submits a PATCH request for a contact' do
      flapjack.given("a contact exists").
        upon_receiving("a PATCH request for a single contact").
        with(:method => :patch,
             :path => "/contacts/#{contact_data[:id]}",
             :body => {:contacts => {:id => contact_data[:id], :type => 'contact', :name => 'Hello There'}},
             :headers => {'Content-Type' => 'application/vnd.api+json'}).
        will_respond_with(
          :status => 204,
          :body => '' )

      result = Flapjack::Diner.update_contacts(:id => contact_data[:id], :name => 'Hello There')
      expect(result).to be_a(TrueClass)
    end

    it 'submits a PUT request for several contacts' do
      flapjack.given("two contacts exist").
        upon_receiving("a PATCH request for two contacts").
        with(:method => :patch,
             :path => "/contacts",
             :body => {:contacts => [{:id => contact_data[:id], :type => 'contact', :name => 'Hello There'},
                                     {:id => contact_2_data[:id], :type => 'contact', :name => 'Goodbye Now'}]},
             :headers => {'Content-Type' => 'application/vnd.api+json'}).
        will_respond_with(
          :status => 204,
          :body => '' )

      result = Flapjack::Diner.update_contacts(
        {:id => contact_data[:id], :name => 'Hello There'},
        {:id => contact_2_data[:id], :name => 'Goodbye Now'})
      expect(result).to be_a(TrueClass)
    end

    it "can't find the contact to update" do
      flapjack.given("no contact exists").
        upon_receiving("a PATCH request for a single contact").
        with(:method => :patch,
             :path => "/contacts/#{contact_data[:id]}",
             :body => {:contacts => {:id => contact_data[:id], :type => 'contact', :name => 'Hello There'}},
             :headers => {'Content-Type' => 'application/vnd.api+json'}).
        will_respond_with(
          :status => 404,
          :headers => {'Content-Type' => 'application/vnd.api+json; charset=utf-8'},
          :body => {:errors => [{
              :status => '404',
              :detail => "could not find Contact records, ids: '#{contact_data[:id]}'"
            }]}
          )

      result = Flapjack::Diner.update_contacts(:id => contact_data[:id], :name => 'Hello There')
      expect(result).to be_nil
      expect(Flapjack::Diner.last_error).to eq([{:status => '404',
        :detail => "could not find Contact records, ids: '#{contact_data[:id]}'"}])
    end
  end

  context 'delete' do
    it "submits a DELETE request for one contact" do
      flapjack.given("a contact exists").
        upon_receiving("a DELETE request for a single contact").
        with(:method => :delete,
             :path => "/contacts/#{contact_data[:id]}",
             :body => nil).
        will_respond_with(:status => 204,
                          :body => '')

      result = Flapjack::Diner.delete_contacts(contact_data[:id])
      expect(result).to be_a(TrueClass)
    end

    it "submits a DELETE request for several contacts" do
      flapjack.given("two contacts exist").
        upon_receiving("a DELETE request for two contacts").
        with(:method => :delete,
             :path => "/contacts/#{contact_data[:id]},#{contact_2_data[:id]}",
             :body => nil).
        will_respond_with(:status => 204,
                          :body => '')

      result = Flapjack::Diner.delete_contacts(contact_data[:id], contact_2_data[:id])
      expect(result).to be_a(TrueClass)
    end

    it "can't find the contact to delete" do
      flapjack.given("no contact exists").
        upon_receiving("a DELETE request for a single contact").
        with(:method => :delete,
             :path => "/contacts/#{contact_data[:id]}",
             :body => nil).
        will_respond_with(
          :status => 404,
          :headers => {'Content-Type' => 'application/vnd.api+json; charset=utf-8'},
          :body => {:errors => [{
              :status => '404',
              :detail => "could not find Contact records, ids: '#{contact_data[:id]}'"
            }]}
          )

      result = Flapjack::Diner.delete_contacts(contact_data[:id])
      expect(result).to be_nil
      expect(Flapjack::Diner.last_error).to eq([{:status => '404',
        :detail => "could not find Contact records, ids: '#{contact_data[:id]}'"}])
    end
  end

end
