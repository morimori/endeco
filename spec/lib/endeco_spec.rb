require 'spec_helper'

describe Endeco do
  before do
    Endeco::Cache.clear
    Endeco::Config.path = "#{File.dirname(__FILE__)}/../../env"
    Endeco::Config.env  = 'test'
    FileUtils.mkdir_p File.expand_path(File.join(Endeco::Config.path, Endeco::Config.env))
  end

  after do
    FileUtils.rm_rf File.expand_path(File.join(Endeco::Config.path))
  end

  context 'file exists' do
    before do
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << 'hoge'
      end
    end

    after do
      File.unlink File.join(Endeco::Config.path, Endeco::Config.env, 'test_var')
    end

    it 'can read file contents through filename method' do
      Endeco.test_var.should == 'hoge'
    end

    it 'can read file contents through filename method with bang' do
      Endeco.test_var!.should == 'hoge'
    end

    it 'can read file contents through brace with filename key' do
      Endeco['test_var'].should == 'hoge'
    end

    it 'can read file contents through brace with filename key with bang' do
      Endeco['test_var!'].should == 'hoge'
    end
  end

  context 'file not exists' do
    it 'return nil through filename method' do
      Endeco.test_var.should be_nil
    end

    it 'raise Errno::ENOENT through filename method with bang' do
      expect{ Endeco.test_var! }.to raise_error(Errno::ENOENT)
    end

    it 'return nil through brace with filename key' do
      Endeco['test_var'].should be_nil
    end

    it 'raise Errno::ENOENT through brace with filename key with bang' do
      expect{ Endeco['test_var!'] }.to raise_error(Errno::ENOENT)
    end
  end

  context 'cache disable' do
    before do
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << 'hoge'
      end
    end

    after do
      File.unlink File.join(Endeco::Config.path, Endeco::Config.env, 'test_var')
    end

    it 'read variable is not cached' do
      Endeco.test_var!.should == 'hoge'
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << 'fuga'
      end
      Endeco.test_var!.should == 'fuga'
    end
  end

  context 'cache enable' do
    before do
      Endeco::Cache.enable = true
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << 'hoge'
      end
    end

    after do
      File.unlink File.join(Endeco::Config.path, Endeco::Config.env, 'test_var')
    end

    it 'read variable is cached' do
      Endeco.test_var!.should == 'hoge'
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << 'fuga'
      end
      Endeco.test_var!.should == 'hoge'
    end

    it 'force read cached variable with :force option' do
      Endeco.test_var!.should == 'hoge'
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << 'fuga'
      end
      Endeco.test_var!(:force => true).should == 'fuga'
    end
  end
end
