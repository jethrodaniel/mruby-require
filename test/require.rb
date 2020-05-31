#
# tests run using MRuby
#

def sandbox_load_env
  load_path = $:.dup
  loaded_features = $".dup
  yield
  $: = $LOAD_PATH       = load_path
  $" = $LOADED_FEATURES = loaded_features
end

assert 'Kernel#load' do
  sandbox_load_env do
    %i[A B C D].each do |const|
      assert_equal Object.const_defined?(const), false
    end

    begin
      load("test/examples/a")
    rescue LoadError => e
      assert_equal "failed to load 'test/examples/a.rb'", e.message
    end

    $: << File.expand_path(File.dirname(__FILE__))
    assert_equal load("test/examples/a.rb"), true
    assert_equal load("test/examples/b"), true
    assert_equal load("test/examples/c"), true
    assert_equal load("test/examples/d"), true

    begin
      load("test/examples/absent.rb")
    rescue LoadError => e
      assert_equal "failed to load 'test/examples/absent.rb'", e.message
    end

    %i[A B C D].each do |const|
      assert_equal Object.const_defined?(const), true
    end
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

    $: << File.expand_path(File.dirname(__FILE__))

    load "test/examples/e"

    assert_equal ["test/examples/e.rb"], $"
    assert_equal ["test/examples/e.rb"], $LOADED_FEATURES
  end
end
