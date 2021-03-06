require 'spec_helper'

describe Admin::BaseController do
  render_views

  let(:admin) { FactoryGirl.create(:admin) }
  let(:supervisor) { FactoryGirl.create(:supervisor) }
  let(:user) { FactoryGirl.create(:user) }

  describe "GET index" do

    def init_time
      @admin_login_time = Time.now
      @seconds_to_expire_session = 900.seconds
    end

    def freeze_time(time)
      Timecop.freeze(time)
    end
    
    shared_examples "an authorized user" do
      before :each do
        init_time
        freeze_time(@admin_login_time)
        sign_in user
        get :index
      end

      after :each do
        Timecop.return
      end

      it "has 200 status" do
        expect(response.status).to eq(200)
      end

      it "renders the index template" do
        expect(response).to render_template("index")
      end

      it "stores login time in session" do
        session[:admin_logs_in].should eql(@admin_login_time)
      end

      it "expires admin session" do
        Timecop.travel(@admin_login_time + @seconds_to_expire_session)
        get :index
        expect(response).to redirect_to(new_user_session_es_path)
      end
    end

    context "as an admin" do
      it_behaves_like "an authorized user" do
        let(:user) { FactoryGirl.create(:admin) }
      end
    end

    context "as a supervisor" do
      it_behaves_like "an authorized user" do
        let(:user) { FactoryGirl.create(:supervisor) }
      end
    end

    context "as an unpriviliged user" do
      before :each do
        sign_in user
        get :index
      end

      it "has 302 status" do
        expect(response.status).to eq(302)
      end

      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "as a visior" do
      before :each do
        get :index
      end

      it "has 302 status" do
        expect(response.status).to eq(302)
      end

      it "redirects to new_user_session_path" do
        expect(response).to redirect_to(new_user_session_es_path)
      end
    end
  end

  describe "GET acting_as" do
    context "as an admin" do
      before :each do
        sign_in admin
        get :acting_as, user_id: user.id
      end

      it "stores original_user_id in session" do
        session[:original_user_id].should eql(admin.id)
      end

      it "sets from_admin session value true" do
        session[:from_admin].should be_true
      end

      it "has 302 status" do
        expect(response.status).to eq(302)
      end

      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "as an supervisor" do
      before :each do
        sign_in supervisor
        get :acting_as, user_id: user.id
      end

      it "has 302 status" do
        expect(response.status).to eq(302)
      end

      it "shows access denied alert message" do
        expect(flash[:alert]).to eq(I18n.t("errors.messages.access_denied"))
      end

      it "redirects to root_path" do
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end

  describe "GET stop_acting_as" do
    context "as an admin" do
      before :each do
        sign_in admin
        get :acting_as, user_id: user.id
        get :stop_acting_as
      end

      it "sets from_admin session value false" do
        session[:from_admin].should be_false
      end

      it "destroys original_user_id from session" do
        session[:original_user_id].should be_nil
      end

      it "has 302 status" do
        expect(response.status).to eq(302)
      end

      it "redirects to admin_root_path" do
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end
end