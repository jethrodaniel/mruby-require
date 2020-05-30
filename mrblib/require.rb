# wtf

$: = []
$: << ENV["MRBLIB"]       if ENV["MRBLIB"]
$: << ENV["MRBGEMS_ROOT"] if ENV["MRBGEMS_ROOT"]
$LOAD_PATH = $:

$" = []
$LOADED_FEATURES = $"

module Kernel
  def load file
    $" << file unless $".include?(file)
    # file += ".rb" unless file[file.size - 4..file.size - 1] == ".rb"
    puts file
    __load__ file
  end
end
