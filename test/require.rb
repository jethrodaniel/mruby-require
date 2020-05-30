#
# tests run using MRuby
#

load_path = $:.dup
loaded_features = $".dup

def sandbox_load_env
  load_path = $:.dup
  loaded_features = $".dup
  yield
  $: = $LOAD_PATH       = load_path
  $" = $LOADED_FEATURES = loaded_features
end

assert 'Kernel#__load__  |  Kernel#load' do
  sandbox_load_env do
    assert_equal Object.const_defined?(:A), false
    assert_equal Object.const_defined?(:B), false
    assert_equal __load__("test/examples/a.rb"), true
    assert_equal __load__("test/examples/b.rb"), true
    # assert_equal load("test/examples/b"), true
    assert_equal Object.const_defined?(:A), true
    assert_equal Object.const_defined?(:B), true
  end
end

assert '$:  /  $LOAD_PATH' do
  sandbox_load_env do
    assert_equal ["foo", "bar"], $:
    assert_equal ["foo", "bar"], $LOAD_PATH
  end
end

assert '$"  /  $LOADED_FEATURES' do
  sandbox_load_env do
    assert_equal [], $"
    assert_equal [], $LOADED_FEATURES
    # __load__ "test/example.rb"
    load "test/example.rb"
    assert_equal ["test/example.rb"], $"
    assert_equal ["test/example.rb"], $LOADED_FEATURES
  end
end
