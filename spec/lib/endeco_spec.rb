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

  shared_context 'file prepared' do
    before do
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << "hoge\n"
      end
    end

    after do
      File.unlink File.join(Endeco::Config.path, Endeco::Config.env, 'test_var')
    end
  end

  context 'file exists' do
    include_context 'file prepared'

    it 'can read file contents through filename method' do
      Endeco.test_var.should == "hoge\n"
    end

    it 'can read file contents through filename method with bang' do
      Endeco.test_var!.should == "hoge\n"
    end

    it 'can read file contents through brace with filename key' do
      Endeco['test_var'].should == "hoge\n"
    end

    it 'can read file contents through brace with filename key with bang' do
      Endeco['test_var!'].should == "hoge\n"
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
    include_context 'file prepared'

    it 'read variable is not cached' do
      Endeco.test_var!.should == "hoge\n"
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << 'fuga'
      end
      Endeco.test_var!.should == 'fuga'
    end
  end

  context 'cache enable' do
    before do
      Endeco::Cache.enable = true
    end

    include_context 'file prepared'

    it 'read variable is cached' do
      Endeco.test_var!.should == "hoge\n"
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << 'fuga'
      end
      Endeco.test_var!.should == "hoge\n"
    end

    it 'force read cached variable with :force option' do
      Endeco.test_var!.should == "hoge\n"
      open File.join(Endeco::Config.path, Endeco::Config.env, 'test_var'), 'w' do |f|
        f << 'fuga'
      end
      Endeco.test_var!(:force => true).should == 'fuga'
    end
  end

  context 'enable default chomp' do
    include_context 'file prepared'

    before do
      Endeco::Config.default_chomp = true
    end

    it 'remove line feed' do
      Endeco.test_var.should eq 'hoge'
    end

    it 'disable chomp with option' do
      Endeco.test_var(:chomp => false).should eq "hoge\n"
    end
  end

  describe '? method' do
    subject { Endeco.test_var? }

    context 'file exists' do
      include_context 'file prepared'
      it { should be_true }
    end

    context 'file not exists' do
      it { should be_false }
    end
  end
end
