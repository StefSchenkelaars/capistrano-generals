namespace :deploy do
  namespace :symlink do

    desc 'Upload the linked files from local system'
    task :upload_linked_files do
      fetch(:linked_files).each do |filename|

        # Initialize variable outsize run_locally block to make sure it can be
        # passed into the remote block
        local_cksum = nil

        run_locally do
          # Check if file exists, else abort
          unless File.exist? filename
            abort red "Cannot find file #{filename} on local machine"
          end

          # Get local file info
          local_cksum = capture :cksum, filename
        end
        local_sum, local_size, local_path = local_cksum.split

        on roles :app do
          # Create directory
          dir_path = File.join shared_path, File.dirname(filename)
          execute :mkdir, '-p', dir_path

          # Check if file already exists on remote
          remote_file_path = File.join shared_path, filename
          if test("[ -f #{remote_file_path} ]")
            # File already exists
            # Get remote file info
            remote_cksum = capture :cksum, remote_file_path
            remote_sum, remote_size, remote_path = remote_cksum.split

            # Check if the file has changed
            if local_sum == remote_sum
              info "#{filename} Already up to date."
            else
              upload! local_path, remote_file_path
              info "Replaced #{filename} -> #{remote_file_path}"
            end

          else
            # File does not exists
            upload! local_path, remote_file_path
            info "Uploaded #{filename} -> #{remote_file_path}"
          end

        end

      end
    end

  end
end
