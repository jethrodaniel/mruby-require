# wtf

$: = []
$: << ENV["MRBLIB"]       if ENV["MRBLIB"]
$: << ENV["MRBGEMS_ROOT"] if ENV["MRBGEMS_ROOT"]
$LOAD_PATH = $:

$" = []
$LOADED_FEATURES = $"

class LoadError < StandardError
end

module Kernel
  def load file
    $" << file unless $".include?(file)

    case __load__(file)
    when 0
      true
    when 1
      raise LoadError, "failed to load '#{file}'"
    else
      $stderr.puts "<<<< #{t}"
    end
  end
end
