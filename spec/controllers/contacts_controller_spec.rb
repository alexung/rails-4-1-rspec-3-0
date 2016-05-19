require 'rails_helper'

describe ContactsController do
  let(:contact) do
    create(:contact, firstname: "Lawrence", lastname: "Smith")
  end
  shared_examples_for 'public access to contacts' do
    describe 'GET #index' do
      context 'with params[:letter]' do
        it "populates an array of contacts starting with the letter" do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index, letter: 'S'
          expect(assigns(:contacts)).to match_array([smith])
        end

        it "renders the :index template" do
          get :index, letter: 'S'
          expect(response).to render_template :index
        end
      end

      context 'without params[:letter]' do
        it "populates an array of all contacts" do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index
          expect(assigns(:contacts)).to match_array([smith, jones])
        end

        it "renders the :index template" do
          get :index
          expect(response).to render_template :index
        end
      end
    end

    describe 'GET #show' do
      it "assigns the requested contact to contact" do
        contact = create(:contact)
        get :show, id: contact
        expect(assigns(:contact)).to eq contact
      end

      it "renders the :show template" do
        contact = create(:contact)
        get :show, id: contact
        expect(response).to render_template :show
      end
    end
  end

  shared_examples 'full access to contacts' do
    describe 'GET #new' do
      it "assigns a new Contact to contact" do
        get :new
        expect(assigns(:contact)).to be_a_new(Contact)
      end

      it "assigns a home, office, and mobile phone to the new contact" do
        get :new
        phones = assigns(:contact).phones.map do |p|
          p.phone_type
        end
        expect(phones).to match_array %w(home office mobile)
      end

      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      it "assigns the requested contact to contact" do
        contact = create(:contact)
        get :edit, id: contact
        expect(assigns(:contact)).to eq contact
      end

      it "renders the :edit template" do
        contact = create(:contact)
        get :edit, id: contact
        expect(response).to render_template :edit
      end
    end

    describe "POST #create" do
      before :each do
        @phones = [
          attributes_for(:phone),
          attributes_for(:phone),
          attributes_for(:phone)
        ]
      end

      context "with valid attributes" do
        it "saves the new contact in the database" do
          expect{
            post :create, contact: attributes_for(:contact,
              phones_attributes: @phones)
          }.to change(Contact, :count).by(1)
        end

        it "redirects to contacts#show" do
          post :create,
            contact: attributes_for(:contact,
              phones_attributes: @phones)
          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end

      context "with invalid attributes" do
        it "does not save the new contact in the database" do
          expect{
            post :create,
              contact: attributes_for(:invalid_contact)
          }.not_to change(Contact, :count)
        end

        it "re-renders the :new template" do
          post :create,
            contact: attributes_for(:invalid_contact)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do

      context "valid attributes" do
        it "locates the requested contact" do
          patch :update, id: contact,
            contact: attributes_for(:contact)
          expect(assigns(:contact)).to eq contact
        end

        it "changes the contact's attributes" do
          patch :update, id: contact,
            contact: attributes_for(:contact,
              firstname: 'Larry',
              lastname: 'Smith'
            )
          contact.reload
          expect(contact.firstname).to eq 'Larry'
          expect(contact.lastname).to eq 'Smith'
        end

        it "redirects to the updated contact" do
          patch :update, id: contact, contact: attributes_for(:contact)
          expect(response).to redirect_to contact
        end
      end

      context "invalid attributes" do
        it "locates the requested contact" do
          patch :update, id: contact, contact: attributes_for(:invalid_contact)
          expect(assigns(:contact)).to eq contact
        end

        it "does not change the contact's attributes" do
          patch :update, id: contact,
            contact: attributes_for(:contact,
              firstname: 'Larry',
              lastname: nil
            )
          contact.reload
          expect(contact.firstname).not_to eq('Larry')
          expect(contact.lastname).to eq('Smith')
        end

        it "re-renders the edit method" do
          patch :update, id: contact, contact: attributes_for(:invalid_contact)
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do

      it "deletes the contact" do
        contact
        expect{
          delete :destroy, id: contact
        }.to change(Contact,:count).by(-1)
      end

      it "redirects to contacts#index" do
        delete :destroy, id: contact
        expect(response).to redirect_to contacts_url
      end
    end
  end

  describe "administrator access" do
    before :each do
      set_user_session create(:admin)
    end

    it_behaves_like 'public access to contacts'
    it_behaves_like 'full access to contacts'
  end

  describe "user access" do
    before :each do
      set_user_session create(:user)
    end

    it_behaves_like 'public access to contacts'
    it_behaves_like 'full access to contacts'
  end

  describe "guest access" do
    it_behaves_like 'public access to contacts'

    describe 'GET #new' do
      it "requires login" do
        get :new
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      it "requires login" do
        contact = create(:contact)
        get :edit, id: contact
        expect(response).to require_login
      end
    end

    describe "POST #create" do
      it "requires login" do
        post :create, id: create(:contact),
          contact: attributes_for(:contact)
        expect(response).to require_login
      end
    end

    describe 'PUT #update' do
      it "requires login" do
        put :update, id: create(:contact),
          contact: attributes_for(:contact)
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      it "requires login" do
        delete :destroy, id: create(:contact)
        expect(response).to require_login
      end
    end
  end
end


    # ===fake method 1 that doesn't yet exist on our controller===
    # describe "PATCH hide_contact" do
    #   before :each do
    #     contact = create(:contact)
    #   end

    #   it "marks the contact as hidden" do
    #     patch :hide_contact, id: contact
    #     expect(contact.reload.hidden?).to be_true
    #   end

    #   it "redirects to contacts#index" do
    #     patch :hide_contact, id: contact
    #     expect(response).to redirect_to contacts_url
    #   end
    # end
    # === end fake method 1 ===

    # === fake method 2 that doesn't yet exist on our controller ===
    # for routes that look like /contacts/34/phones/22
    # describe 'GET #show' do
    #   it "renders the :show template for the phone" do
    #     contact = create(:contact)
    #     # this is how you connect a phone to a contact
    #     phone = create(:phone, contact: contact)
    #     # so you need to specify the phone id as id (its at the end of the route) and contact id as contact_id (it's in the middle of the route)
    #     get :show, id: phone, contact_id: contact.id
    #     expect(response).to render_template :show
    #   end
    # end
    # === end fake method 2 ===

    # # === fake method 3 to test CSV output ===
    # describe 'CSV output' do
    #   it "returns a CSV file" do
    #     get :index, format: :csv
    #     expect(response.headers['Content-Type']).to match 'text/csv'
    #   end

    #   it 'returns content' do
    #     create(:contact, firstname: 'Aaron', lastname: 'Sumner', email: 'aaron@sample.com')
    #     get :index, format: :csv
    #     expect(response.body).to match 'Aaron Sumner, aaron@sample.com'
    #   end

    #   it "returns comma separated values" do
    #     create(:contact, firstname: "Aaron", lastname: "Sumner", email: "aaron@sample.com")
    #     expect(Contact.to_csv).to match /Aaron Sumner,aaron@sample.com/
    #   end

    #   # can also test JSON or XML output with relative ease at the controller level
    #   it "returns JSON-formatted content" do
    #     contact = create(:contact)
    #     get :index, format: :json
    #     expect(response.body).to have_content contact.to_json
    #   end
    # end
    # # === end fake method 3 ===