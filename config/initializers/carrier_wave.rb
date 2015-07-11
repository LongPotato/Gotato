if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AKIAJYSJ4DQL5DQTJQWQ'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['longpotatopictures']
  end
end