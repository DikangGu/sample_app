require 'spec_helper'

describe User do

  before(:each) do 
    @attr = {:name => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
      }
  end
  
  it "should create a new instance given valid attributes" do 
    User.create!(@attr)
  end
  
  describe "password validations" do 
    
    it "should require a password" do 
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    
    it "should require a matching password confirmation" do 
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short password" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long password" do 
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  
  
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
  end
  
  it "should require a name" do 
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
     no_email_user = User.new(@attr.merge(:email => ""))
     no_email_user.should_not be_valid
   end
   
   it "should reject duplicate email addresses " do
     User.create!(@attr)
     user_with_duplicate_email = User.new(@attr)
     user_with_duplicate_email.should_not be_valid
   end
   
   describe "password encryption" do
     
     before(:each) do
       @user = User.create!(@attr)
     end
     
     describe "has_password? method" do
       it "should be ture if the passwords match " do
         @user.has_password?(@attr[:password]).should be_true
       end
       
       it "should be false if the passwords don't match" do
         @user.has_password?("invalid").should be_false
       end
       
       it "should return the user on email/password match" do
         matching_user = User.authenticate(@attr[:email], @attr[:password])
         matching_user.should == @user
       end
     end
   end
   
   
end
