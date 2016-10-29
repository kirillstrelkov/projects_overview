Feature: User should be able to create project

  Scenario: User creates simple project
    Given I am on main page
    When I click "New Project"
    Then I fill in "project[name]" with "Simple project"
    And I fill in "project[description]" with "Some description"
    And I fill in "project[progress]" with "0.0"
    And I click "Save"
    Then I should see "Project was successfully created." on page

  Scenario: User creates projects with weekly dates
    Given I am on main page
    When I click "New Project"
    Then I fill in "project[name]" with "Simple project"
    And I fill in "project[description]" with "Some description"
    And I fill in "project[progress]" with "0.0"
    Then I click "Generate due dates"
    And I fill in "start_date" with "10/29/2016 8:34 PM"
    And I fill in "end_date" with "11/26/2016 8:33 PM"
    And I click "Generate"
    Then I should see "Start date" on page
    And I should see "0.0" on page
    And I should see "End date" on page
    And I should see "100.0" on page
    And I should see "Week" on page
    And I should see "10/29/2016 8:34 PM" on page
    And I should see "11/26/2016 8:33 PM" on page
    When I click "Save"
    Then I should see "Project was successfully created." on page

    Scenario: User should see calendar while generating
      Given I am on main page
      When I click "New Project"
      Then I click "Generate due dates"
      And I click css element "#start_date"
      Then I should see calendar
      And I click css element "#end_date"
      Then I should see calendar
  
# TODO: create invalid cases or create checks for model/controllers
