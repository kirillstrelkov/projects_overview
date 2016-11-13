Feature: User should be able to view project with correct data
  Scenario: User creates future project
    Given current date is "10.11.2016 09:00"
    And there is a project "Project name" with 1.0 progress and due dates:
    | name  | date             | progress |
    | Start | 10.11.2016 10:00 |    0.0   |
    | Week 1| 17.11.2016 10:00 |   33.33  |
    | Week 2| 24.11.2016 10:00 |   66.67  |
    | End   | 01.12.2016 10:00 |  100.0   |
    When I am on project view page
    Then I should see "1.0" on page
    And I should see "11/10/2016 10:00 AM" on page
    And I should see "11/17/2016 10:00 AM" on page
    And I should see "11/24/2016 10:00 AM" on page
    And I should see "12/01/2016 10:00 AM" on page
    And positive progress bar should have width 1.0
    And negative progress bar should have width 0.0

  Scenario: User creates current projects with positive progress
    Given current date is "10.11.2016 08:00"
    And there is a project "Project name" with 29.0 progress and due dates:
    | name  | date             | progress |
    | Start | 03.11.2016 10:00 |    0.0   |
    | Week 1| 10.11.2016 10:00 |   33.33  |
    | Week 2| 17.11.2016 10:00 |   66.67  |
    | End   | 24.11.2016 10:00 |  100.0   |
    When I am on project view page
    Then I should see "29.0" on page
    And I should see "11/03/2016 10:00 AM" on page
    And I should see "11/10/2016 10:00 AM" on page
    And I should see "11/17/2016 10:00 AM" on page
    And I should see "11/24/2016 10:00 AM" on page
    And positive progress bar should have width 29.0
    And negative progress bar should have width 4.13

  Scenario: User creates current projects with negative progress
    Given current date is "10.11.2016 11:00"
    And there is a project "Project name" with 24.0 progress and due dates:
    | name  | date             | progress |
    | Start | 03.11.2016 10:00 |    0.0   |
    | Week 1| 10.11.2016 10:00 |   33.33  |
    | Week 2| 17.11.2016 10:00 |   66.67  |
    | End   | 24.11.2016 10:00 |  100.0   |
    When I am on project view page
    Then I should see "24.0" on page
    And I should see "11/03/2016 10:00 AM" on page
    And I should see "11/10/2016 10:00 AM" on page
    And I should see "11/17/2016 10:00 AM" on page
    And I should see "11/24/2016 10:00 AM" on page
    And positive progress bar should have width 24.0
    And negative progress bar should have width 9.73

  Scenario: User creates finished passed project
    Given current date is "25.12.2016 11:00"
    And there is a project "Project name" with 100.0 progress and due dates:
    | name  | date             | progress |
    | Start | 03.11.2016 10:00 |    0.0   |
    | Week 1| 10.11.2016 10:00 |   33.33  |
    | Week 2| 17.11.2016 10:00 |   66.67  |
    | End   | 24.11.2016 10:00 |  100.0   |
    When I am on project view page
    Then I should see "100.0" on page
    And I should see "11/03/2016 10:00 AM" on page
    And I should see "11/10/2016 10:00 AM" on page
    And I should see "11/17/2016 10:00 AM" on page
    And I should see "11/24/2016 10:00 AM" on page
    And positive progress bar should have width 100.0
    And negative progress bar should have width 0.0

  Scenario: User creates finished failed project
    Given current date is "25.12.2016 11:00"
    And there is a project "Project name" with 25.0 progress and due dates:
    | name  | date             | progress |
    | Start | 03.11.2016 10:00 |    0.0   |
    | Week 1| 10.11.2016 10:00 |   33.33  |
    | Week 2| 17.11.2016 10:00 |   66.67  |
    | End   | 24.11.2016 10:00 |  100.0   |
    When I am on project view page
    Then I should see "25.0" on page
    And I should see "11/03/2016 10:00 AM" on page
    And I should see "11/10/2016 10:00 AM" on page
    And I should see "11/17/2016 10:00 AM" on page
    And I should see "11/24/2016 10:00 AM" on page
    And positive progress bar should have width 25.0
    And negative progress bar should have width 75.0
