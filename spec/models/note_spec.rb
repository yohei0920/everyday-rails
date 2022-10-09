require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = User.create!(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'joetester@example.com',
      password: 'dottle-nouveau'
    )

    @project = @user.projects.create!(
      name: 'Test Project'
    )
  end

  it "is valid with a user, project, and message" do
    note = Note.new(
      message: 'This is a sample test',
      user: @user,
      project: @project,
    )
    expect(note).to be_valid
  end

  # 検索文字列に一致するメモを返すこと
  describe "search message for a term" do
    before do
      @note1 = @project.notes.create!(
        message: 'This is the first note',
        user: @user,
      )

      @note2 = @project.notes.create!(
        message: 'This is the second note',
        user: @user,
      )

      @note3 = @project.notes.create!(
        message: 'First, preheat the oven',
        user: @user,
      )
    end

    context 'when a match is found' do
      it 'returns notes that match the search term' do
        expect(Note.search('first')).to include @note1, @note3
        expect(Note.search('first')).to_not include(@note2)
      end
    end

    context 'when no match is found' do
      it 'returns notes that match the search term' do
        expect(Note.search('message')).to be_empty
      end
    end

  end
end
