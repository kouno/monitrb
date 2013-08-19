def read_fixture(file)
  File.read(File.expand_path(File.join('..', '..', 'fixtures', file), __FILE__))
end

def load_fixture(file)
  load File.expand_path(File.join('..', '..', 'fixtures', file), __FILE__)
end

def read_tmp_file(file)
  File.read(File.expand_path(File.join('..', '..', '..', 'tmp', file), __FILE__))
end
