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
    case ext = File.extname(file)
    when ".rb", ""
      file = "#{file}.rb" if ext == ""
    when ".so"
      raise LoadError, "'.so' is unimplemented"
    else
      raise LoadError, "invalid extension '#{ext}' for '#{file}'"
    end

    $" << file unless $".include?(file)
    load_file file
  end

  def load_file file
    case __load_filename__(file)
    when 0
      true
    # when 1
    else
      raise LoadError, "failed to load '#{file}'"
    end
  end
end
