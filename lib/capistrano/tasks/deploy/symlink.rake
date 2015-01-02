namespace :deploy do
  namespace :symlink do

    desc 'Upload the linked files from local system'
    task :upload_linked_files do

      # Abort if no linked files found
      if fetch(:linked_files).nil?
        abort red "No linked files specified. Remove the upload_linked_files task or add linked_files."
      end

      # Loop through all linked files
      fetch(:linked_files).each do |file_name|

        # Initialize variable outsize run_locally block to make sure it can be
        # passed into the remote block
        local_cksum = nil
        local_file_name = ''

        # Get file information
        run_locally do

          # Try to find stage specific file, otherwice select default
          local_file_name = get_config_file(file_name, fetch(:stage).to_s)

          # Get local file info
          local_cksum = capture :cksum, local_file_name
        end

        # Getting local file information
        local_sum, local_size, local_path = local_cksum.split

        on roles :app do
          # Create directory
          dir_path = File.join shared_path, File.dirname(file_name)
          execute :mkdir, '-p', dir_path

          # Check if file already exists on remote
          remote_file_name = File.join shared_path, file_name
          if test("[ -f #{remote_file_name} ]")
            # File already exists
            # Get remote file info
            remote_cksum = capture :cksum, remote_file_name
            remote_sum, remote_size, remote_path = remote_cksum.split

            # Check if the file has changed
            if local_sum == remote_sum
              info "Remote #{remote_file_name} already up to date with local #{local_file_name}."
            else
              upload! local_file_name, remote_file_name
              info "Replaced #{local_file_name} -> #{remote_file_name}"
            end
          else
            # File does not exists
            upload! local_file_name, remote_file_name
            info "Uploaded #{local_file_name} -> #{remote_file_name}"
          end
        end

      end
    end

  end
end
