Feature: Mentoring
  As Gentoo developer
  I want to mentor recruits
  So they join can join us

  Background:
    Given I logged in as an "mentor"
    And sample recruits exist

  Scenario: Comment an answer
    When I follow "Answers to review"
    And I follow first link "Review"
    Then I should not see "Some remark"
    When I fill in "comment_comment" with "Some remark"
    And press "Comment"
    Then I should see "Some remark"

  @javascript
  Scenario: Accept an answer
    When I follow "Answers to review"
    And I follow first link "Review"
    Then I should not see "Accepted"
    And I follow "Accept"
    Then I should see "Accepted"

  @javascript
  Scenario: Reject an answer
    When I follow "Answers to review"
    And I follow first link "Review"
    Then I should not see "Rejected"
    And I follow "Reject"
    Then I should see "Rejected"

  @javascript
  Scenario: Start mentoring
    When I follow "Candidates"
    Then I should not mentor all other users
    When I follow "Mentor"
    Then I should not see link "Mentor"
    And I should mentor all other users
