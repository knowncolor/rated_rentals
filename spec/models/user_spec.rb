require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end

  subject { @user }

  it { should respond_to(:reviews) }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:reset_password_token) }
  it { should respond_to(:reset_password_sent_at) }
  it { should respond_to(:sign_in_count) }
  it { should respond_to(:current_sign_in_at) }
  it { should respond_to(:last_sign_in_at) }
  it { should respond_to(:current_sign_in_ip) }
  it { should respond_to(:last_sign_in_ip) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
  it { should respond_to(:provider) }
  it { should respond_to(:uid) }
  it { should respond_to(:name) }

  it { should be_valid }

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = " " }
    it { should_not be_valid }
  end

  describe "when username is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when email is already taken" do
    it "should fail to save another user with the same email" do
      user_with_same_email = @user.dup
      user_with_same_email.name = 'new name'
      user_with_same_email.save

      expect(user_with_same_email).to_not be_valid
    end
  end

  describe "when name is already taken" do
    it "should fail to save another user with the same name" do
      user_with_same_name = @user.dup
      user_with_same_name.email = 'new@email.com'
      user_with_same_name.save

      expect(user_with_same_name).to_not be_valid
    end
  end

  describe "create user from facebook auth" do
    let(:auth) { OmniAuth::AuthHash.new(JSON.parse('{"provider":"facebook","uid":"204502870","info":{"nickname":"james.o.adams","email":"facebook@knowncolor.com","name":"James Adams","first_name":"James","last_name":"Adams","image":"http://graph.facebook.com/204502870/picture?type=square","urls":{"Facebook":"https://www.facebook.com/james.o.adams"},"verified":true},"credentials":{"token":"CAAHZCfDZBZBPeIBAJTWmAE5pLsXpjjFZAcltIHZAhmfn1AQljHR7dHz0zCYKe1qNRO8g2J7MpahgT87zJd7r5geBZCK4pcq4YOsDK7HTJZAWaIOgLNZBVZAZADox3OwPuIycPdpCTKcGf47lnPC8poIcgzmK4fWrKKCF46xsmWwVMJyI1lUpZAaZCqhk","expires_at":1393940452,"expires":true},"extra":{"raw_info":{"id":"204502870","name":"James Adams","first_name":"James","last_name":"Adams","link":"https://www.facebook.com/james.o.adams","username":"james.o.adams","gender":"male","email":"facebook@knowncolor.com","timezone":0,"locale":"en_GB","verified":true,"updated_time":"2013-11-11T09:31:17+0000"}}}')) }
    let(:auth2) { OmniAuth::AuthHash.new(JSON.parse('{"provider":"facebook","uid":"204502871","info":{"nickname":"james.o.adams","email":"facebook2@knowncolor.com","name":"James Adams","first_name":"James","last_name":"Adams","image":"http://graph.facebook.com/204502871/picture?type=square","urls":{"Facebook":"https://www.facebook.com/james.o.adams"},"verified":true},"credentials":{"token":"CAAHZCfDZBZBPeIBAJTWmAE5pLsXpjjFZAcltIHZAhmfn1AQljHR7dHz0zCYKe1qNRO8g2J7MpahgT87zJd7r5geBZCK4pcq4YOsDK7HTJZAWaIOgLNZBVZAZADox3OwPuIycPdpCTKcGf47lnPC8poIcgzmK4fWrKKCF46xsmWwVMJyI1lUpZAaZCqhk","expires_at":1393940452,"expires":true},"extra":{"raw_info":{"id":"204502871","name":"James Adams","first_name":"James","last_name":"Adams","link":"https://www.facebook.com/james.o.adams","username":"james.o.adams","gender":"male","email":"facebook2@knowncolor.com","timezone":0,"locale":"en_GB","verified":true,"updated_time":"2013-11-11T09:31:17+0000"}}}')) }
    before do
      expect(User.where(:provider => auth.provider).count).to eq 0
    end

    describe "for a new user" do
      it "should create a new user if match not found" do
        user = User.find_for_facebook_oauth(auth, nil)

        expect(User.where(:provider => auth.provider).size).to eq 1
        expect(user.name).to eq auth.info.name
        expect(user.provider).to eq auth.provider
        expect(user.uid).to eq auth.uid
        expect(user.email).to eq auth.info.email
      end

      it "should append a random string to the name if already taken" do
        User.find_for_facebook_oauth(auth, nil)
        user = User.find_for_facebook_oauth(auth2, nil)

        expect(user.name).to_not eq auth2.info.name
        expect(User.where(:provider => auth.provider).size).to eq 2
      end
    end

    describe "for an existing user" do
      it "should not create a new user" do
        user = User.find_for_facebook_oauth(auth, nil)
        user = User.find_for_facebook_oauth(auth, nil)
        expect(User.where(:provider => auth.provider).size).to eq 1
      end

      it "should match different cased email" do
        user = User.find_for_facebook_oauth(auth, nil)
        auth.info.email = "FACEBOOK@KNOWNCOLOR.COM"
        user = User.find_for_facebook_oauth(auth, nil)
        expect(User.where(:provider => auth.provider).size).to eq 1
      end
    end
  end

  describe "create user from google auth" do
    let(:auth) { OmniAuth::AuthHash.new(JSON.parse('{"provider":"google_oauth2","uid":"106187773642897165704","info":{"name":"James Adams","email":"james.o.adams@gmail.com","first_name":"James","last_name":"Adams","image":"https://lh6.googleusercontent.com/-Jatld5DvHOU/AAAAAAAAAAI/AAAAAAAAALU/yimkXzY1fSQ/photo.jpg","urls":{"Google":"https://plus.google.com/106187773642897165704"}},"credentials":{"token":"ya29.1.AADtN_VSreI_LXsyO2hDpi9FxGRhZB6FhkWSDhzpMAvkaaPr6uFObwSFg7F4SmY","expires_at":1389026174,"expires":true},"extra":{"id_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjE2OTJjNWIxMDdhZWViODQ5NDI3NmM5MjdjODhlMWUwYzhiNmU4OGYifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiaWQiOiIxMDYxODc3NzM2NDI4OTcxNjU3MDQiLCJzdWIiOiIxMDYxODc3NzM2NDI4OTcxNjU3MDQiLCJ2ZXJpZmllZF9lbWFpbCI6InRydWUiLCJlbWFpbF92ZXJpZmllZCI6InRydWUiLCJ0b2tlbl9oYXNoIjoiSXM2RU9VQ04yMmRmdC1xUjl1bnkzdyIsImF0X2hhc2giOiJJczZFT1VDTjIyZGZ0LXFSOXVueTN3IiwiYXVkIjoiMzU2MjIyMDYyNDcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJlbWFpbCI6ImphbWVzLm8uYWRhbXNAZ21haWwuY29tIiwiY2lkIjoiMzU2MjIyMDYyNDcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhenAiOiIzNTYyMjIwNjI0Ny5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImlhdCI6MTM4OTAyMjI4NSwiZXhwIjoxMzg5MDI2MTg1fQ.do594I9oleuZcH73W3_ilzsSDedp-xFzo5BzkhHVnXlnouF9UG025Qwd9T4CXJEMV0L1nUK5SMxtNw_STWZBNEZv194yugA7Z3C1xH__BTukV4Lg1Cui9riF990Fmn7Vp3MynDHh1Sj-TJnMNNWoqJ8YU1Ikh_KL2sgbl-BdnxI","raw_info":{"id":"106187773642897165704","email":"james.o.adams@gmail.com","verified_email":true,"name":"James Adams","given_name":"James","family_name":"Adams","link":"https://plus.google.com/106187773642897165704","picture":"https://lh6.googleusercontent.com/-Jatld5DvHOU/AAAAAAAAAAI/AAAAAAAAALU/yimkXzY1fSQ/photo.jpg","gender":"male","locale":"en-GB"}}}')) }
    let(:auth2) { OmniAuth::AuthHash.new(JSON.parse('{"provider":"google_oauth2","uid":"106187773642897165705","info":{"name":"James Adams","email":"james.o.adams2@gmail.com","first_name":"James","last_name":"Adams","image":"https://lh6.googleusercontent.com/-Jatld5DvHOU/AAAAAAAAAAI/AAAAAAAAALU/yimkXzY1fSQ/photo.jpg","urls":{"Google":"https://plus.google.com/106187773642897165704"}},"credentials":{"token":"ya29.1.AADtN_VSreI_LXsyO2hDpi9FxGRhZB6FhkWSDhzpMAvkaaPr6uFObwSFg7F4SmY","expires_at":1389026174,"expires":true},"extra":{"id_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjE2OTJjNWIxMDdhZWViODQ5NDI3NmM5MjdjODhlMWUwYzhiNmU4OGYifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiaWQiOiIxMDYxODc3NzM2NDI4OTcxNjU3MDQiLCJzdWIiOiIxMDYxODc3NzM2NDI4OTcxNjU3MDQiLCJ2ZXJpZmllZF9lbWFpbCI6InRydWUiLCJlbWFpbF92ZXJpZmllZCI6InRydWUiLCJ0b2tlbl9oYXNoIjoiSXM2RU9VQ04yMmRmdC1xUjl1bnkzdyIsImF0X2hhc2giOiJJczZFT1VDTjIyZGZ0LXFSOXVueTN3IiwiYXVkIjoiMzU2MjIyMDYyNDcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJlbWFpbCI6ImphbWVzLm8uYWRhbXNAZ21haWwuY29tIiwiY2lkIjoiMzU2MjIyMDYyNDcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhenAiOiIzNTYyMjIwNjI0Ny5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImlhdCI6MTM4OTAyMjI4NSwiZXhwIjoxMzg5MDI2MTg1fQ.do594I9oleuZcH73W3_ilzsSDedp-xFzo5BzkhHVnXlnouF9UG025Qwd9T4CXJEMV0L1nUK5SMxtNw_STWZBNEZv194yugA7Z3C1xH__BTukV4Lg1Cui9riF990Fmn7Vp3MynDHh1Sj-TJnMNNWoqJ8YU1Ikh_KL2sgbl-BdnxI","raw_info":{"id":"106187773642897165704","email":"james.o.adams@gmail.com","verified_email":true,"name":"James Adams","given_name":"James","family_name":"Adams","link":"https://plus.google.com/106187773642897165704","picture":"https://lh6.googleusercontent.com/-Jatld5DvHOU/AAAAAAAAAAI/AAAAAAAAALU/yimkXzY1fSQ/photo.jpg","gender":"male","locale":"en-GB"}}}')) }
    before do
      expect(User.where(:provider => auth.provider).count).to eq 0
    end

    describe "for a new user" do
      it "should create a new user if match not found" do
        user = User.find_for_google_oauth2(auth, nil)

        expect(User.where(:provider => auth.provider).size).to eq 1
        expect(user.name).to eq auth.info.name
        expect(user.provider).to eq auth.provider
        expect(user.uid).to eq auth.uid
        expect(user.email).to eq auth.info.email
      end

      it "should append a random string to the name if already taken" do
        User.find_for_google_oauth2(auth, nil)
        user = User.find_for_google_oauth2(auth2, nil)

        expect(user.name).to_not eq auth2.info.name
        expect(User.where(:provider => auth.provider).size).to eq 2
      end
    end

    describe "for an existing user" do
      it "should not create a new user" do
        user = User.find_for_google_oauth2(auth, nil)
        user = User.find_for_google_oauth2(auth, nil)
        expect(User.where(:provider => auth.provider).size).to eq 1
      end

      it "should match different cased email" do
        user = User.find_for_google_oauth2(auth, nil)
        auth.info.email = "JAMES.O.ADAMS@GMAIL.COM"
        user = User.find_for_google_oauth2(auth, nil)
        expect(User.where(:provider => auth.provider).size).to eq 1
      end
    end
  end


  describe "reviews association" do
    let(:review1) { FactoryGirl.create(:review) }
    let(:review2) { FactoryGirl.create(:review) }

    it "should be settable and retrievable" do
      @user.reviews << review1
      @user.reviews << review2
      @user.save

      expect(@user.reload.reviews.count).to eq 2
    end
  end

end
