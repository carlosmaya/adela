require 'spec_helper'

describe Official do
  context "validations" do
    subject { FactoryGirl.create :official }

    it "should be valid with mandatory fields" do
      subject.should be_valid
    end

    it "should not be valid without a name" do
      subject.name = ""
      subject.should_not be_valid
    end

    it "should not be valid without a position" do
      subject.position = ""
      subject.should_not be_valid
    end

    it "should not be valid without an email" do
      subject.email = ""
      subject.should_not be_valid
    end

    it "should not be valid without a kind" do
      subject.kind = nil
      subject.should_not be_valid
    end
  end
end
