namespace :load do
  task :defaults do
    # Message displayed to users who attempt to deploy when deploys are blocked
    set :deploy_block_message, -> { "#{local_user} blocked deploys at #{Time.now}" }

    # File created on the deploy_block_host to signal that a deploy is blocked
    set :deploy_block_file, -> { File.join(shared_path, 'deploy-block') }
  end
end

namespace :deploy do
  desc 'Block deploys'
  task :block do
    on fetch(:deploy_block_host) do
      execute(:echo, "\"#{fetch(:deploy_block_message)}\"", "> #{fetch(:deploy_block_file)}")
    end
  end

  desc 'Check if deploys have been blocked'
  task :check_for_block do
    on fetch(:deploy_block_host) do
      block_file = fetch(:deploy_block_file)
      if test("[ -f #{block_file} ]")
        block_message = capture(:cat, block_file)
        error "[deploy:check_for_block] #{block_message}"
        exit 1
      end
    end
  end

  desc 'Unblock deploys'
  task :unblock do
    on fetch(:deploy_block_host) do
      execute(:rm, '-rf', fetch(:deploy_block_file))
      info '[deploy:unblock] Deploys have been unblocked'
    end
  end

  task :validate do
    run_locally do # Need `run_locally` in order to access `error` helper
      case fetch(:deploy_block_host)
      when nil
        error '[deploy:validate] deploy_block_host not specified'
        exit 1
      when Array
        error '[deploy:validate] deploy_block_host cannot be multiple hosts'
        exit 1
      end
    end
  end

  %w[block check_for_block unblock].each do |task|
    before task, :validate
  end

  before :starting, :check_for_block
end
