# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
# ここで指定したパラメーターはログ上では[FILTERED]と出力される
Rails.application.config.filter_parameters += [:password]
