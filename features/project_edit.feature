Feature: User should be able to edit project

  Scenario: Generates and saves new dates
    Given current date is "05.11.2016 11:00"
    And there is a project "Project name" with 5.0 progress and due dates:
    | name  | date             | progress |
    | Start | 03.11.2016 10:00 |    0.0   |
    | Week 1| 10.11.2016 10:00 |   33.33  |
    | Week 2| 17.11.2016 10:00 |   66.67  |
    | End   | 24.11.2016 10:00 |  100.0   |
    When I am on project edit page
    And I click "Generate due dates"
    And I fill in "start_date" with "10/29/2016 8:34 PM"
    And I fill in "end_date" with "11/26/2016 8:33 PM"
    And I click "Generate"
    When I click "Save"
    Then I should see "Project was successfully updated." on page
    When I click "Edit"
    And I should see "10/29/2016" on page
    And I should see "11/26/2016" on page
    And I should not see "11/03/2016 10:00 AM" on page
    And I should not see "11/10/2016 10:00 AM" on page
    And I should not see "11/17/2016 10:00 AM" on page
    And I should not see "11/24/2016 10:00 AM" on page

  Scenario: Generates new dates but does NOT save
    Given current date is "05.11.2016 11:00"
    And there is a project "Project name" with 5.0 progress and due dates:
    | name  | date             | progress |
    | Start | 03.11.2016 10:00 |    0.0   |
    | Week 1| 10.11.2016 10:00 |   33.33  |
    | Week 2| 17.11.2016 10:00 |   66.67  |
    | End   | 24.11.2016 10:00 |  100.0   |
    When I am on project edit page
    And I click "Generate due dates"
    And I fill in "start_date" with "10/29/2016 8:34 PM"
    And I fill in "end_date" with "11/26/2016 8:33 PM"
    And I click "Close"
    When I am on project edit page
    And I should not see "10/29/2016" on page
    And I should not see "11/26/2016" on page
    And I should see "11/03/2016 10:00 AM" on page
    And I should see "11/10/2016 10:00 AM" on page
    And I should see "11/17/2016 10:00 AM" on page
    And I should see "11/24/2016 10:00 AM" on page

  Scenario: User should be able to edit name, descriptions and progress
    Given current date is "05.11.2016 11:00"
    And there is a project "Project name" with 5.0 progress and due dates:
    | name  | date             | progress |
    | Start | 03.11.2016 10:00 |    0.0   |
    | Week 1| 10.11.2016 10:00 |   33.33  |
    | Week 2| 17.11.2016 10:00 |   66.67  |
    | End   | 24.11.2016 10:00 |  100.0   |
    When I am on project edit page
    Then I fill in "project[name]" with "Simple project"
    And I fill in "project[description]" with "Some description"
    And I fill in "project[progress]" with "0.0"
    When I click "Save"
    Then I should see "Project was successfully updated." on page
    When I click "Edit"
    And I should see "Simple project" on page
    And I should see "Some description" on page
    And I should see "0.0" on page
