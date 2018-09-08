namespace :heaven do
  desc "Processes jobs in background"
  task run_worker: :environment do
    Worker.run
  end
end
