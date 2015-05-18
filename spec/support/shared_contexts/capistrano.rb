require "capistrano/all"

shared_context "capistrano" do
  let(:app_root)   { File.expand_path('../../../../', __FILE__) }
  let(:rake)       { Rake::Application.new }
  let(:capistrano) { Capistrano::Application.new }
  let(:task_name)  { self.class.top_level_description }
  let(:task_path)  { "lib/capistrano/tasks/#{task_name.split(":").first}" }
  subject          { rake[task_name] }


  def loaded_files_excluding_current_rake_file
    $".reject {|file| file == "#{app_root}/#{task_path}.rake" }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [app_root], loaded_files_excluding_current_rake_file)

    Capistrano::Application = capistrano
    Capistrano::Application.rake_require(task_path, [app_root], loaded_files_excluding_current_rake_file)

    Rake::Task.define_task(:environment)
  end
end
