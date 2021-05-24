Feature: User should be able to create project

  Scenario: User deletes simple project
    Given I am on main page
    When I click "New Project"
    Then I fill in "project[name]" with "Simple project"
    And I fill in "project[description]" with "Some description"
    And I fill in "project[progress]" with "0.0"
    And I click "Save"
    Then I should see "Project was successfully created." on page
    When I am on "/projects/"
    And I click "Destroy"
    And I accept alert
    Then I should not see "Simple project" on page

  Scenario: User deletes project with dates
    Given current date is "05.11.2016 11:00"
    And there is a project "Project name" with 5.0 progress and due dates:
      | name   | date             | progress |
      | Start  | 03.11.2016 10:00 | 0.0      |
      | Week 1 | 10.11.2016 10:00 | 33.33    |
      | Week 2 | 17.11.2016 10:00 | 66.67    |
      | End    | 24.11.2016 10:00 | 100.0    |
    When I am on "/projects/"
    And I click "Destroy"
    And I accept alert
    Then I should not see "Project name" on page
