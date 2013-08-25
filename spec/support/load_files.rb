module SpecPaths
  def tmp_path(*file)
    root_path('tmp', *file)
  end

  def fixtures_path(*file)
    root_path('spec', 'fixtures', *file)
  end

  def root_path(*file)
    File.expand_path(File.join('..', '..', '..', *file), __FILE__)
  end
end
