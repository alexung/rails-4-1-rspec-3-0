require 'rails_helper'

describe ContactsController do
  describe "administrator access" do

    before :each do
      user = create(:admin)
      session[:user_id] = user.id
    end

    describe 'GET #index' do
      context 'with params[:letter]' do
        it "populates an array of contacts starting with the letter" do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index, letter: "S"
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
      it "assigns the requested contact to @contact" do
        contact = create(:contact)
        get :show, id: contact
        expect(assigns(:contact)).to eq contact
      end
      it "renders the :show template" do
        contact = create(:contact)
        get :show, id: contact
        expect(:response).to render_template :show
      end
    end

    describe 'GET #new' do
      it "assigns a new Contact to @contact"
      it "renders the :new template"
    end

    describe 'GET #edit' do
      it "assigns the requested contact to @contact"
      it "renders the :edit template"
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
          expect {
              post :create, contact: attributes_for(:contact, phones_attributes: @phones)
            }.to change(Contact, :count).by(1)
        end
        it "redirects to contacts#show" do
          post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end

      context "with invalid attributes" do
        it "does not save the new contact in the database" do
          expect {
            post :create, contact: attributes_for(:invalid_contact)
          }.not_to change(Contact, :count)
        end
        it "re-renders the :new template" do
          post :create, contact: attributes_for(:invalid_contact)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      # before each spec is run
      before :each do
        @contact = create(:contact, firstname: 'Lawrence', lastname: 'Smith')
      end

      context "with valid attributes" do
        it "locates the requested @contact" do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(assigns(:contact)).to eq(@contact)
        end

        it "changes @contact's attributes" do
          patch :update, id: @contact, contact: attributes_for(:contact, firstname: "Larry", lastname: "Smith")
          @contact.reload
          expect(@contact.firstname).to eq("Larry")
          expect(@contact.lastname).to eq("Smith")
        end

        it "redirects to the updated contact" do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(response).to redirect_to @contact
        end
      end

      context "with invalid attributes" do
        it "does not change the contact's attributes" do
          patch :update, id: @contact, contact: attributes_for(:contact, firstname: "Larry", lastname: nil)
          @contact.reload
          expect(@contact.firstname).not_to eq("Larry")
          expect(@contact.lastname).to eq("Smith")
        end

        it "re-renders the :edit template" do
          patch :update, id: @contact, contact: attributes_for(:invalid_contact)
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @contact = create(:contact)
      end

      it "deletes the contact from the database" do
        expect {
          delete :destroy, id: @contact
        }.to change(Contact, :count).by(-1)
      end
      it "redirects to contacts#index" do
        delete :destroy, id: @contact
        expect(response).to redirect_to contacts_url
      end
    end

    # ===fake method 1 that doesn't yet exist on our controller===
    # describe "PATCH hide_contact" do
    #   before :each do
    #     @contact = create(:contact)
    #   end

    #   it "marks the contact as hidden" do
    #     patch :hide_contact, id: @contact
    #     expect(@contact.reload.hidden?).to be_true
    #   end

    #   it "redirects to contacts#index" do
    #     patch :hide_contact, id: @contact
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
  end
end