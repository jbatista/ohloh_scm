# frozen_string_literal: true

require 'spec_helper'

describe 'Activity' do
  describe 'log_filename' do
    it 'should return system tmp dir path' do
      ENV['OHLOH_SCM_TEMP_FOLDER_PATH'] = nil
      core = get_core(:git)
      scm = OhlohScm::Activity.new(core)
      scm.log_filename.must_equal "#{Dir.tmpdir}/foobar.log"
    end

    it 'should return temp folder path' do
      ENV['OHLOH_SCM_TEMP_FOLDER_PATH'] = '/test'
      core = get_core(:git)
      scm = OhlohScm::Activity.new(core)
      scm.log_filename.must_equal '/test/foobar.log'
      ENV['OHLOH_SCM_TEMP_FOLDER_PATH'] = ''
    end
  end
end
