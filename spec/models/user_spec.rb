require 'spec_helper'

describe User do
  describe "#ready?" do
    before :each do
      @user       = FactoryGirl.create :user
      @groups     = FactoryGirl.create_list :group, 2
      @questions  = @groups.collect { |group| FactoryGirl.create_list :question, 2, group: group }
    end

    it "should be false for user who didn't select any group yet" do
      @groups.each{|group| @user.should_not be_ready_for(group)}
    end

    it "should be false if there are left some questions unanaswered in each group" do
      @user.groups = @groups
      @user.save!
      @questions.collect(&:first).each { |q| FactoryGirl.create :answer, user: @user, question: q }
      @user.should_not be_ready_for(@groups.first)
    end

    it "should be false if someone else answered all questions" do
      user2 = FactoryGirl.create :user
      user2.groups = @user.groups = @groups
      user2.save!
      @user.save!
      @questions.flatten.each { |q| FactoryGirl.create :answer, user: user2, question: q }
      @user.should_not be_ready_for(@groups.first)
    end

    it "should be true if user answered all question in one of groups and all answers accepted" do
      @user.groups = @groups
      @user.save!
      @groups.first.questions.each do |q| 
        answer = FactoryGirl.create :answer, user: @user, question: q
        answer.accept!
      end
      @user.should be_ready_for(@groups.first)
    end

    it "should be false unless all answers are accepted" do
      @user.groups = @groups
      @user.save!
      @groups.first.questions[1..-1].each do |q| 
        answer = FactoryGirl.create :answer, user: @user, question: q
        answer.accept! 
      end
      @user.should_not be_ready_for(@groups.first)
    end

  end
end
