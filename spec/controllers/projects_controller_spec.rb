# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe 'POST /projects' do
    it 'saves project' do
      post :create, { project:
                      { 'name' => 'Name',
                        'description' => '',
                        'progress' => '',
                        'due_dates_attributes' =>
                        { '0' =>
                          { 'name' => 'Start date',
                            'description' => '',
                            'date' => '2016-11-03T18:37:00+00:00',
                            'progress' => '0.00',
                            'project_id' => '' },
                          '1' =>
                          { 'name' => 'Week 2',
                            'description' => '',
                            'date' => '2016-11-10T18:37:00+00:00',
                            'progress' => '33.33',
                            'project_id' => '' },
                          '2' =>
                          { 'name' => 'Week 1',
                            'description' => '',
                            'date' => '2016-11-17T18:37:00+00:00',
                            'progress' => '66.67',
                            'project_id' => '' },
                          '3' =>
                          { 'name' => 'End date',
                            'description' => '',
                            'date' => '2016-11-24T18:37:00+00:00',
                            'progress' => '100.00',
                            'project_id' => '' } } } }
      project = assigns(:project)
      expect(project).to be_a(Project)
      project.due_dates.each do |date|
        expect(date.date).not_to be_nil
      end
      expect(project).to be_persisted
    end
  end
end
