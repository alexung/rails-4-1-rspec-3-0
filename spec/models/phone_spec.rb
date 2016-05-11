require 'rails_helper'

describe Phone do
  it "does not allow duplicate phone numbers per contact" do
    # contact = Contact.create(
    #   firstname: "Joe",
    #   lastname: "Tester",
    #   email: "joetester@example.com")

    # contact.phones.create(
    #   phone_type: "home",
    #   phone: "785-555-1234")

    # mobile_phone = contact.phones.build(
    #   phone_type: "mobile",
    #   phone: "785-555-1234")
    # === CAN REPLACE ALL OF ABOVE WITH LINES BELOW ===

    contact = create(:contact)
    create(:home_phone,
           contact: contact,
           phone: '785-555-1234')
    mobile_phone = build(:mobile_phone,
                         contact: contact,
                         phone: '785-555-1234')

    mobile_phone.valid?
    expect(mobile_phone.errors[:phone]).to include("has already been taken")
  end

  it "allows two contacts to share a phone number" do
    # contact = Contact.create(
    #   firstname: "Joe",
    #   lastname: "Tester",
    #   email: "joetester@example.com")

    # contact.phones.create(
    #   phone_type: "home",
    #   phone: "785-555-1234")

    # other_contact = Contact.new
    # other_phone = other_contact.phones.build(
    #   phone_type: "home",
    #   phone: "785-555-1234")
    # === CAN REPLACE ALL OF ABOVE WITH 2 LINES BELOW ===

    create(:phone, phone_type: 'home', phone: '785-555-1234')

    expect(build(:phone, phone_type: 'home', phone: '785-555-1234')).to be_valid
  end
end
