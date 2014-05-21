require "spec_helper"

describe "index", :type => :feature do
	let(:base_title_test) { full_title }
	let(:copyright_str_test) { copyright_str }
	before { visit "/" }
	subject { page }

	it { should have_title base_title_test }

	describe "has a footer" do
		it { should have_selector(:xpath, '//footer') }
		it { should have_selector(:xpath, '//footer', text: copyright_str_test) }
		#it { should have_selector(:xpath, '//foter/ul/li
	end
end
