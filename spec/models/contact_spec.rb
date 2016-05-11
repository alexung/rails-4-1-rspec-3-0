require 'rails_helper'

describe Contact do

  it "is valid with a firstname, lastname and email" do
    contact = Contact.new(firstname: 'Alex',
      lastname: 'Ung',
      email: 'tester@example.com')
    expect(contact).to be_valid
  end

  it "is invalid without a firstname" do
    contact = FactoryGirl.build(:contact, firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end

  it "is invalid without a lastname" do
    contact = FactoryGirl.build(:contact, lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end

  it "is invalid without an email address" do
    contact = FactoryGirl.build(:contact,
      email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include("can't be blank")
  end

  it "is invalid with a duplicate email address" do
    FactoryGirl.create(
      :contact,
      email: 'alexung@gmail.com')
    contact = FactoryGirl.build(
      :contact,
      email: 'alexung@gmail.com')
    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end

  it "returns a contact's full name as a string" do
    contact = FactoryGirl.build(:contact, firstname: 'Jane', lastname: 'Smith')

    expect(contact.name).to eq 'Jane Smith'
  end

  it "has three phone numbers" do
    expect(create(:contact).phones.count).to eq 3
  end

  describe "filter last name by letter" do
    before :each do
      @smith = Contact.create(firstname: 'John', lastname: 'Smith', email: 'jsmith@example.com')
      @jones = Contact.create(firstname: "Tim", lastname: "Jones", email: "tjones@example.com")
      @johnson = Contact.create(firstname: 'John', lastname: 'Johnson', email: 'jjohnson@example.com')
    end
    context "matching letters" do
      # this is testing both the results of the query and sort orer.  'jones' is retrieved first from the database, but since we're sorting by last name then johnson should be stored first in the query results
      it "returns a sorted array of results that match" do
        expect(Contact.by_letter('J')).to eq([@johnson, @jones])
      end
    end

    context "non-matching letters" do
      # this is to not simply just test for ideal results, but also for letters with no results
      it "omits results that do not match" do
        expect(Contact.by_letter("J")).to_not include @smith
      end
    end
  end

end
